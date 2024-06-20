class Animal {
  String? ownerId;
  String? id;
  String? imageUrl;
  String? name;
  String? gender;
  String? type;
  String? size;
  int? age;
  String? description;
  List<String>? personality;
  bool isAdopted = false;

  Animal({
    required this.ownerId,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.gender,
    required this.type,
    required this.size,
    required this.age,
    required this.description,
    required this.personality,
    required this.isAdopted,
  });

  Animal.fromJson(Map<String, dynamic> json) {
    ownerId = json['ownerId'];
    id = json['id'];
    imageUrl = json['imageUrl'] ?? '';
    name = json['name'];
    gender = json['gender'];
    type = json['type'];
    size = json['size'];
    age = json['age'];
    description = json['description'];
    personality = List<String>.from(json['personality']);
    isAdopted = json['isAdopted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl ?? '';
    data['name'] = name;
    data['gender'] = gender;
    data['type'] = type;
    data['size'] = size;
    data['age'] = age;
    data['description'] = description;
    data['personality'] = personality;
    data['isAdopted'] = isAdopted;
    return data;
  }
}
