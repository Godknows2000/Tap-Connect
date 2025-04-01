import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tapconnect/firebase_options.dart';
import 'package:tapconnect/pages/splashscreen.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Untappd Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFD700), // Golden color
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700), // Golden buttons
            foregroundColor: Colors.black, // Text/icon color
          ),
        ),
      ),
      home: const SplashScreen(), // Start with splash screen
      debugShowCheckedModeBanner: false,
    );
  }
}
