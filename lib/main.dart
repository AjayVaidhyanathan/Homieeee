import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
//import 'package:homieeee/features/google_maps/google_maps.dart';
//import 'package:homieeee/features/pages/map_circles.dart';
import 'package:homieeee/features/pages/nearby_friends.dart';

void main() async{
  ///Initializing the FlutterConfig file to retrieve the API_KEY. Always the API_KEY should be hidden
  //WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  //await FlutterConfig.loadEnvVariables();
  ///End initializing FlutterConfig
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FindFriends(),
    );
  }
}

