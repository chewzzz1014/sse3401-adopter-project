import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../mockData/mock-pet.dart';
import '../mockData/mock-user.dart';

final Uuid uuid = Uuid();
final Random random = Random();

class AdoptionRequest {
  String? id;
  String? petId;
  String? receiverId;
  String? senderId;
  Timestamp? sentAt ;
  int? status; // 0 for pending; 1 for rejected and 2 for approve

  AdoptionRequest({
    required this.id,
    required this.petId,
    required this.receiverId,
    required this.senderId,
    required this.sentAt,
    required this.status,
  });

  AdoptionRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['petId'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    sentAt = json['sentAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petId'] = petId;
    data['receiverId'] = receiverId;
    data['senderId'] = senderId;
    data['sentAt'] = sentAt;
    data['status'] = status;;
    return data;
  }
}

// TODO: delete this after done setup firebase
List<AdoptionRequest> generateAdoptionRequests() {
  List<AdoptionRequest> requests = [];

  for (int i = 0; i < 10; i++) {
    // Generate random indices for animalList and chatUsers
    int animalIndex = random.nextInt(animalList.length);
    int userIndex = random.nextInt(chatUsers.length);

    String requestId = uuid.v4();
    String petId = animalList[animalIndex].id!;
    String userId = chatUsers[userIndex].userId;
    Timestamp sentAt = Timestamp.fromDate(DateTime.now());
    int status = random.nextInt(3);

    AdoptionRequest request = AdoptionRequest(
      id: '',
      petId: petId,
      receiverId: userId,
      senderId: userId,
      sentAt: sentAt,
      status: status,
    );

    requests.add(request);
  }

  return requests;
}
