import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:homieeee/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoContainer(),
            const SizedBox(height: 30),
            Text('Share, Save, Sustain',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 30),
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () async {
                await AuthService().signInWithGoogle(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Example width constraint
      height: 200, // Example height constraint
      decoration: BoxDecoration(
        color: Colors.white, // Example background color
        borderRadius: BorderRadius.circular(20), // Example border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/logos/launch_icon.jpg', // Replace with your image URL
          fit: BoxFit.cover, // Adjust the fit property as needed
        ),
      ),
    );
  }
}
