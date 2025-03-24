import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/pages/authentication/loginScreen.dart';
import 'package:tapconnect/pages/homeScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isAbove18 = false; // State for the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(secondaryColor), // Beer color background
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Welcome message
                      const Text(
                        "Join the beer community",
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
                          fillColor: Colors.grey,
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
                          fillColor: Colors.grey,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      // Age verification checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isAbove18,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAbove18 = value ?? false;
                              });
                            },
                            activeColor: const Color(
                                0xFF8F2B08), // Beer color for checkbox
                          ),
                          const Text(
                            'I am above 18 years old',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Sign Up button
                      ElevatedButton(
                        onPressed: _isAbove18
                            ? () {
                                // Simulate signup success
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            : null, // Disable button if checkbox is not checked
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(primaryColor), // Beer color button
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
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
                                    builder: (context) => const LoginScreen()),
                              );
                              // Navigate to login screen (you can add the route here)
                            },
                            child: const Text(
                              'Login',
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
