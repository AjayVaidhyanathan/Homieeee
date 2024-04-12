import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homieeee/screens/authentication/login_screen.dart';
import 'package:homieeee/widgets/nav_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapsnop) {
            if (snapsnop.hasData) {
              return const AppBottomNavigationBar();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
