import 'dart:math';
import 'package:uuid/uuid.dart';
import '../mockData/mock-pet.dart';
import '../mockData/mock-user.dart';
import 'animal.dart';
import 'chat-user-model.dart';

final Uuid uuid = Uuid();
final Random random = Random();

class AdoptionRequest {
  String requestId;
  String petId;
  String userId;
  DateTime timestamp;
  int status; // 0 for pending; 1 for rejected and 2 for approve

  AdoptionRequest({
    required this.requestId,
    required this.petId,
    required this.userId,
    required this.timestamp,
    required this.status,
  });
}

List<AdoptionRequest> generateAdoptionRequests() {
  List<AdoptionRequest> requests = [];

  for (int i = 0; i < 10; i++) {
    // Generate random indices for animalList and chatUsers
    int animalIndex = random.nextInt(animalList.length);
    int userIndex = random.nextInt(chatUsers.length);

    String requestId = uuid.v4();
    String petId = animalList[animalIndex].id;
    String userId = chatUsers[userIndex].userId;
    DateTime requestDate = DateTime.now().subtract(Duration(days: random.nextInt(30)));
    int status = random.nextInt(3);

    AdoptionRequest request = AdoptionRequest(
      requestId: requestId,
      petId: petId,
      userId: userId,
      timestamp: requestDate,
      status: status,
    );

    requests.add(request);
  }

  return requests;
}
