import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/constants/constants.dart';
import 'package:homieeee/new_chat/models/user.dart';

final getUserInfoByIdProvider =
    FutureProvider.autoDispose.family<UserModel, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(userId)
      .get()
      .then((userData) {

    return UserModel.fromMap(userData.data()!);
  });
});