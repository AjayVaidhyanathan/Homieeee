import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/screens/authentication/signup_page.dart';
import 'package:homieeee/screens/authentication/widgets/primary_button.dart';
import 'package:homieeee/screens/authentication/widgets/text_field.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:homieeee/utils/validator/validator.dart';
import 'package:homieeee/widgets/navbar_new.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        autoHide: Duration(seconds: 3),
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'You have successfully logged in.',
      ).show();
      Get.to(() => const BottomNavigation());
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(40),
          physics: const BouncingScrollPhysics(),
          children: [
            //logo with container
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/logos/3.png', // Replace with your image URL
                      fit: BoxFit.cover, // Adjust the fit property as needed
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Let’s sign you in.',
              style: blackBold24,
            ),
            heightSpace10,
            Text(
              'Welcome Back. You’ve been missed!',
              style: color8ARegular15,
            ),
            heightSpace25,
            Text('Email', style: color8ARegular15),
            AuthTextFormField(
              controller: _emailcontroller,
              validator: (value) => validateEmail(value),
              prefixIcon: 'assets/icons/email.png',
              hintText: 'Enter your email address',
            ),
            heightSpace25,
            Text('Password', style: color8ARegular15),
            AuthTextFormField(
              controller: _passwordcontroller,
              validator: (value) => validatePassword(value),
              prefixIcon: 'assets/icons/password.png',
              suffixIcon: 'assets/icons/show_password.png',
              hintText: 'Enter your password',
              isPassSecure: true,
              textInputAction: TextInputAction.done,
              maxLines: 1,
            ),
            heightSpace15,
            Text(
              'Forget password?',
              style: forgetPassStyle,
              textAlign: TextAlign.end,
            ),
            heightSpace35,
            PrimaryButton(
              title: 'Login',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  login(context);
                }
              },
            ),
            heightSpace20,
            Text(
              'OR',
              style: color8ARegular15,
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                print('Works');
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(vertical: 15),
                height: 100,
                decoration: BoxDecoration(
                  color: colorF9,
                  borderRadius: borderRadius10,
                ),
                child: Image.asset(
                  'assets/icons/google.png',
                  //scale: 2.5,
                ),
              ),
            ),
            bottomBar(context)
          ],
        ),
      ),
    );
  }

  Padding bottomBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: 'Don’t have an account? ',
              style: color8ARegular15,
              children: [
                TextSpan(
                    text: 'Sign Up',
                    style: primaryMedium15,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage())))
              ]),
        ));
  }
}
