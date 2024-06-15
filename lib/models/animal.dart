import 'package:flutter/cupertino.dart';

class Animal {
  String id;
  String name;
  String gender;
  String type;
  String size;
  int age;
  String description;
  List<String> personality;

  Animal({
    required this.id,
    required this.name,
    required this.gender,
    required this.type,
    required this.size,
    required this.age,
    required this.description,
    required this.personality,
  });
}
