import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/pages/authentication/signupscreen.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/main_screen.dart';
import 'package:tapconnect/pages/homeScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(secondaryColor), // Golden background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Card(
                elevation: 8.0, // Slight elevation for shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white, // White background for the card
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize:
                        MainAxisSize.min, // Card takes only the space it needs
                    children: [
                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF8F2B08), // Beer color for the icon
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Title
                      const Text(
                        'Login Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Welcome message
                      const Text(
                        "We'll welcome to app",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Email field
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'EMAIL ADDRESS',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password field
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          filled: true,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      // Forgot Password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Add forgot password functionality here
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login button
                      ElevatedButton(
                        onPressed: () {
                          // Simulate login success
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(primaryColor), // Golden button
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add Google login functionality
                            },
                            icon: Image.asset(
                              'assets/google.png', // Replace with your Google icon
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              // Add Facebook login functionality
                            },
                            icon: Image.asset(
                              'assets/fb.jpg', // Replace with your Facebook icon
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Create account link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Not yet? ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                              // Navigate to signup screen (you can add the route here)
                            },
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
