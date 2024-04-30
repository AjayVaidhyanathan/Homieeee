// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homieeee/auth/auth_gate.dart';
import 'package:homieeee/utils/helper/shared_preferences.dart';
import 'package:homieeee/widgets/navbar_new.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //save user info in a separate document

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  updateUserProfile(String imgURL, String displayName, String age,
      String aboutMe, String gender) async {
    _firestore.collection("Users").doc(getCurrentUser()!.uid).update({
      'displayName': displayName,
      'img': imgURL,
      'age': age,
      'aboutMe': aboutMe,
      'gender': gender
    });
  }

  signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        /*  _firestore.collection("Users").doc(user!.uid).set({
          'uid': user.uid,
          'email': user.email,
          'img': user.photoURL,
          'displayName': user.displayName
        }); */
        print('Google signin uid ${user!.uid}');
        SharedPreferencesManager.saveUid(user.uid);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthService.customSnackBar(
              content: 'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthService.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  signOut({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthGate()));
    } catch (e) {
      return Text(e.toString());
    }
  }

  Future<String?> getUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        return userData['email'] as String?;
      }
    }
    return null;
  }

  Future<String?> getPhotoURL() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        return userData['img'] as String?;
      }
    }
    return null;
  }

  Future<String?> getUserDisplayName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        return userData['displayName'] as String?;
      }
    }
    return null;
  }

  Future<String> getUserID() async {
    final uid = await SharedPreferencesManager.getUid();
    return uid as String;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      // Get a reference to the user document in Firestore
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      // Update the user document with the new data
      await userDocRef.update(userData);
    } catch (e) {
      // Handle any errors that occur during the update process
      throw e.toString();
    }
  }
}
