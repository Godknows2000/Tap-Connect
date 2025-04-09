import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/pages/authentication/loginScreen.dart';
import 'package:tapconnect/pages/authentication/signupscreen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Grid of images
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(8.0),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: [
                  // Replace these with your actual images
                  _buildGridImage('assets/clite.jpg'),
                  _buildGridImage('assets/castle.jpg'),
                  _buildGridImage('assets/mag.jpg'),
                  _buildGridImage('assets/super.jpg'),
                  _buildGridImage('assets/nyathi.jpg'),
                  _buildGridImage('assets/savana.jpg'),
                  _buildGridImage('assets/sable.jpg'),
                  _buildGridImage('assets/goldenp.jpg'),
                  _buildGridImage('assets/sable.jpg'),
                ],
              ),
            ),
            // Logo and text section
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo (crossed bottles)
                  // Image.asset(
                  //   'assets/beer.jpg', // Replace with your logo path
                  //   width: 100,
                  //   height: 100,
                  //   color: const Color(0xFF8F2B08), // Beer color for the logo
                  // ),
                  // const SizedBox(height: 10),
                  // App name
                  const Text(
                    'TAP CONNECT',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tagline
                  const Text(
                    'Discover, drink, and share with friends.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Buttons section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(primaryColor), // Golden button
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
