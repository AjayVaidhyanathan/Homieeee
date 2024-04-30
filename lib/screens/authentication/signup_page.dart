import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/screens/authentication/about_me.dart';
import 'package:homieeee/screens/authentication/widgets/primary_button.dart';
import 'package:homieeee/screens/authentication/widgets/text_field.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:homieeee/utils/validator/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final formKeySignUp = GlobalKey<FormState>();

  register(BuildContext context) async {
    final auth = AuthService();
    try {
      await auth.signUpWithEmailPassword(
        _emailcontroller.text,
        _passwordcontroller.text,
      );

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        autoHide: Duration(seconds: 3),
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'You have successfully Signed up.',
      ).show();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKeySignUp,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(30),
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Get Started!',
                  style: blackBold24,
                ),
                Text('1/2', style: blackBold18)
              ],
            ),
            heightSpace10,
            Text(
              'Create an account to continue.',
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
            heightSpace25,
            Text('Repeat Password', style: color8ARegular15),
            AuthTextFormField(
              controller: _confirmPasswordController,
              validator: (value) => validatePassword(value),
              prefixIcon: 'assets/icons/password.png',
              suffixIcon: 'assets/icons/show_password.png',
              hintText: 'Repeat your password',
              isPassSecure: true,
              textInputAction: TextInputAction.done,
              maxLines: 1,
            ),
            heightSpace35,
            PrimaryButton(
                title: 'Next',
                onTap: () async{
                  if (formKeySignUp.currentState!.validate()) {
                    if (_passwordcontroller.text ==
                        _confirmPasswordController.text) {
                      await register(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutMe()));
                    }
                  }
                }),
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
              text: 'Already have an account? ',
              style: color8ARegular15,
              children: [
                TextSpan(
                    text: 'Login',
                    style: primaryMedium15,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pop(context))
              ]),
        ));
  }
}
