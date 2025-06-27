import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/contollers/auth_controller.dart';
import 'package:tapconnect/pages/authentication/signupscreen.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/main_screen.dart';

class LoginScreen extends GetView<AuthController> {
  final TextEditingController resetEmailController = TextEditingController();
  final RxBool obscureText = true.obs;

  LoginScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/rated_breweries_2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Login form with scroll
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Welcome back to the beer community",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => TextField(
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  obscureText.value = !obscureText.value;
                                },
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            obscureText: obscureText.value,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showResetPasswordDialog(context);
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
                        const SizedBox(height: 10),
                        Obx(
                          () => controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Color(0x800B21B4),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    controller.signIn(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x800B21B4),
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
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
                                      builder: (context) => SignupScreen()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
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
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: resetEmailController,
          decoration: const InputDecoration(
            labelText: 'Enter your email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.resetPassword(resetEmailController.text);
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
