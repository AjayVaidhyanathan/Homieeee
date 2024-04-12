import 'package:flutter/material.dart';
import 'package:homieeee/auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.email});

  final String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $email'),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut(context: context);
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}