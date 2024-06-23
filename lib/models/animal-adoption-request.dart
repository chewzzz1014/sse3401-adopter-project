import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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
    data['status'] = status;

    return data;
  }
}