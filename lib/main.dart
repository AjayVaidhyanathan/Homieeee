import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:homieeee/auth/auth_gate.dart';
import 'package:homieeee/firebase_options.dart';
import 'package:homieeee/screens/authentication/about_me.dart';
import 'package:homieeee/screens/authentication/login_page.dart';
import 'package:homieeee/screens/onboarding/onboarding_screen.dart';
import 'package:homieeee/utils/helper/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final sharedPreferences = SharedPreferencesManager();
  final hasSeenOnboarding = await sharedPreferences.hasSeenOnboarding();
  runApp(ProviderScope(child: App(hasSeenOnboarding: hasSeenOnboarding)));
}

class App extends StatelessWidget {
  const App({super.key, required this.hasSeenOnboarding});
  final bool hasSeenOnboarding;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
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
            'authgate': (context) => AuthGate(),
          },
        );
      },
    );
  }
}
