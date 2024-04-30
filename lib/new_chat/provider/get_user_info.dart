import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/new_chat/constants/constants.dart';
import 'package:homieeee/new_chat/models/user.dart';

final getUserInfoProvider = FutureProvider.autoDispose<UserModel>((ref) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((userData) {
    return UserModel.fromMap(userData.data()!);
  });
});