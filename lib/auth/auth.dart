
class UserModel {
  final String id;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? bio;
  final int? age;
  final String? gender;
  final String? country;
  final String? city;
  final String? language;

  UserModel({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.bio,
    this.age,
    this.gender,
    this.country,
    this.city,
    this.language,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      age: data['age'],
      gender: data['gender'],
      country: data['country'],
      city: data['city'],
      language: data['language'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'age': age,
      'gender': gender,
      'country': country,
      'city': city,
      'language': language,
    };
  }
}
