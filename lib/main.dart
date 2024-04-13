import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homieeee/auth/auth_gate.dart';
import 'package:homieeee/firebase_options.dart';
import 'package:homieeee/screens/onboarding/onboarding_screen.dart';
import 'package:homieeee/utils/helper/shared_preferences.dart';

int onboarding = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // This is for the sharedPreference to make sure the onboarding is done for one time and then the user doesnt see it again.
  final sharedPreferencesManager = SharedPreferencesManager();
  bool hasSeenOnboarding = await sharedPreferencesManager.hasSeenOnboarding();
  await sharedPreferencesManager.setHasSeenOnboarding(true); // Set to true after showing onboarding

  runApp(App(hasSeenOnboarding: hasSeenOnboarding));
}

class App extends StatelessWidget {
  const App({super.key, required this.hasSeenOnboarding});
  final bool hasSeenOnboarding;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homieeee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: !hasSeenOnboarding ? 'onboard' : 'authgate',
      routes: {
        'onboard': (context) => const OnBoardingScreen(),
        'authgate' :(context) => const AuthGate()  
      },
    );
  }
}