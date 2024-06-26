import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sse3401_adopter_project/models/animal-adoption-request.dart';
import 'package:sse3401_adopter_project/models/chat.dart';
import 'package:sse3401_adopter_project/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/animal.dart';
import '../models/message.dart';
import '../models/user_profile.dart';
import 'auth_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

  CollectionReference? _usersCollection;
  CollectionReference? _chatsCollection;
  CollectionReference? _animalsCollection;
  CollectionReference? _adoptionRequestsCollection;
  Uuid uuid = const Uuid();

  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );

    _chatsCollection =
        _firebaseFirestore.collection("chats").withConverter<Chat>(
              fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );

    _animalsCollection =
        _firebaseFirestore.collection("animals").withConverter<Animal>(
              fromFirestore: (snapshot, _) => Animal.fromJson(snapshot.data()!),
              toFirestore: (animal, _) => animal.toJson(),
            );

    _adoptionRequestsCollection = _firebaseFirestore
        .collection("adoptionReqs")
        .withConverter<AdoptionRequest>(
          fromFirestore: (snapshot, _) =>
              AdoptionRequest.fromJson(snapshot.data()!),
          toFirestore: (req, _) => req.toJson(),
        );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Future<void> createAnimalProfile({required Animal animal}) async {
    await _animalsCollection?.doc(animal.id).set(animal);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Stream<QuerySnapshot<Animal>> getAnimals() {
    return _animalsCollection
        ?.where("isAdopted", isEqualTo: false)
        .where("ownerId", isEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<Animal>>;
  }

  Stream<QuerySnapshot<Animal>> getAnimalsForSwipe() {
    return _animalsCollection
        ?.where("isAdopted", isEqualTo: false)
        .where("ownerId", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<Animal>>;
  }

  // for chat feature
  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participants: [uid1, uid2],
      messages: [],
    );
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    await docRef.update({
      "messages": FieldValue.arrayUnion(
        [
          message.toJson(),
        ],
      ),
    });
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }

  // get and update current user's profile
  getCurrentUserProfile() {
    return _usersCollection?.doc(_authService.user!.uid).get();
  }

  getCurrentAnimalProfile(String documentId) {
    return _animalsCollection?.doc(documentId).get();
  }

  Future<void> updateUserProfile(String userId, UserProfile userProfile) async {
    await _usersCollection?.doc(userId).update(userProfile.toJson());
  }

  Future<void> updateAnimalDetail(String animalId, Animal animalDetail) async {
    await _animalsCollection?.doc(animalId).update(animalDetail.toJson());
  }

  // for adoption request
  getAnimalById(String petId) {
    return _animalsCollection?.doc(petId).get();
  }

  getUserById(String id) {
    return _usersCollection?.doc(id).get();
  }

  Stream<QuerySnapshot<AdoptionRequest>> getReceivedAdoptionRequests() {
    return _adoptionRequestsCollection
        ?.where("receiverId", isEqualTo: _authService.user?.uid)
        .snapshots() as Stream<QuerySnapshot<AdoptionRequest>>;
  }

  Stream<QuerySnapshot<AdoptionRequest>> getSentAdoptionRequests() {
    return _adoptionRequestsCollection
        ?.where("senderId", isEqualTo: _authService.user?.uid)
        .snapshots() as Stream<QuerySnapshot<AdoptionRequest>>;
  }

  Future<void> updateAnimalAdoptedStatus(String animalId) async {
    final docRef = _animalsCollection!.doc(animalId);
    await docRef.update({
      "isAdopted": true,
    });
  }

  Future<void> updateAdoptionRequestStatus(String reqId, int newStatus) async {
    final docRef = _adoptionRequestsCollection!.doc(reqId);
    await docRef.update({
      "status": newStatus,
    });
  }

  Stream<QuerySnapshot<Animal>> getAvailableAnimalByOwnerId(String ownerId) {
    return _animalsCollection
        ?.where("ownerId", isEqualTo: ownerId)
        .where("isAdopted", isEqualTo: false)
        .snapshots() as Stream<QuerySnapshot<Animal>>;
  }

  Stream<QuerySnapshot<AdoptionRequest>> getAdoptionRequestsBetween2Users(
      String senderId, String receiverId) {
    return _adoptionRequestsCollection
        ?.where("senderId", isEqualTo: senderId)
        .where("receiverId", isEqualTo: receiverId)
        .snapshots() as Stream<QuerySnapshot<AdoptionRequest>>;
  }

  Future<void> createNewAdoptionReq(
      String animalId, String senderId, String receiverId) async {
    String reqId = uuid.v4();
    final docRef = _adoptionRequestsCollection!.doc(reqId);
    final chat = AdoptionRequest(
      id: reqId,
      petId: animalId,
      receiverId: receiverId,
      senderId: senderId,
      sentAt: Timestamp.fromDate(DateTime.now()),
      status: 0,
    );
    await docRef.set(chat);
  }
}
