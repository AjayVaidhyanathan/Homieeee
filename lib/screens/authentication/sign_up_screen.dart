import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/screens/authentication/login_screen.dart';
import 'package:homieeee/widgets/auth_textfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoContainer(),
            const SizedBox(height: 30),
            const Text(
              'Create an Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            const Text(
              'Complete signup and get started today!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            const AuthTextField(
              prefixIcon: Icons.email,
              hintText: 'Enter your email',
            ),
            const SizedBox(height: 15),
            const AuthTextField(
              prefixIcon: Icons.password,
              suffixIcon: Icons.hide_image,
              hintText: 'Enter your password',
              isPassSecure: true,
              textInputAction: TextInputAction.done,
              maxLines: 1,
            ),
            textSpan(context),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 15),
            const Text(
              '---------- OR ----------',
              style: TextStyle(color: Color.fromARGB(255, 169, 169, 169)),
            ),
            const SizedBox(height: 15),
            SignInButton(
              Buttons.Google,
              elevation: 1,
              onPressed: () async {
                await AuthService().signInWithGoogle(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  textSpan(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: 'Don’t have an account? ',
              style: const TextStyle(
                color: Color(0xff8A9CBF),
                fontSize: 12,
              ),
              children: [
                TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(
                      color: Color(0xffF62354),
                      fontSize: 12,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          )))
              ]),
        ));
  }
}
