import 'package:flutter/material.dart';
import 'package:tapconnect/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
