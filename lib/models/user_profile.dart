class UserProfile {
  String? uid;
  String? username;
  String? pfpURL;
  String? phoneNumber;
  String? age;

  UserProfile({
    required this.uid,
    required this.username,
    required this.pfpURL,
    required this.phoneNumber,
    required this.age,
  });

  UserProfile copyWith({
    String? username,
    String? pfpURL,
    String? phoneNumber,
    String? age,
  }) {
    return UserProfile(
      uid: uid ?? uid,
      username: username ?? this.username,
      pfpURL: pfpURL ?? this.pfpURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
    );
  }

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    pfpURL = json['pfpURL'];
    phoneNumber = json['phoneNumber'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['pfpURL'] = pfpURL;
    data['phoneNumber'] = phoneNumber;
    data['age'] = age;
    return data;
  }
}
