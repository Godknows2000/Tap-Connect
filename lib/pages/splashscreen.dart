import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/pages/landingPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(primaryColor), // Beer color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap Connect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black26, // Faint color (semi-transparent black)
              ),
            ),
            const SizedBox(height: 20), // Space between text and logo
            Image.asset(
              'assets/beer.png', // Replace with your logo path
              width: 150, // Adjust size as needed
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
