import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homieeee/screens/authentication/login_page.dart';
import 'package:homieeee/screens/authentication/login_screen.dart';
import 'package:homieeee/utils/helper/shared_preferences.dart';
import 'package:homieeee/widgets/navbar_new.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3), seenOnboarding),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: const CircularProgressIndicator());
          }
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : snapshot.hasData ? const BottomNavigation() :  LoginPage();
            },
          );
        },
      ),
    );
  }

  Future<void> seenOnboarding() async {
    await SharedPreferencesManager().setHasSeenOnboarding(true);
  }
}
