import 'package:flutter/foundation.dart' show immutable;
import 'package:homieeee/new_chat/constants/constants.dart';

@immutable
class UserModel {
  final String fullName;
  final String email;
  final String profilePicUrl;
  final String uid;


  const UserModel({
    required this.fullName,
    required this.email,
    required this.profilePicUrl,
    required this.uid,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirebaseFieldNames.fullName: fullName,
      FirebaseFieldNames.email: email,
      FirebaseFieldNames.profilePicUrl: profilePicUrl,
      FirebaseFieldNames.uid: uid,

    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map[FirebaseFieldNames.fullName] as String,
      email: map[FirebaseFieldNames.email] as String,
      profilePicUrl: map[FirebaseFieldNames.profilePicUrl] as String,
      uid: map[FirebaseFieldNames.uid] as String,
    );
  }
}