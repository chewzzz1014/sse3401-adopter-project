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
  });

  Animal.fromJson(Map<String, dynamic> json) {
    ownerId = json['ownerId'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    gender = json['gender'];
    type = json['type'];
    size = json['size'];
    age = json['age'];
    description = json['description'];
    personality = json['personality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'];
    data['imageUrl'];
    data['name'];
    data['gender'];
    data['type'];
    data['size'];
    data['age'];
    data['description'];
    data['personality'];

    return data;
  }
}
