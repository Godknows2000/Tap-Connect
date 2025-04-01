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
  Widget build(BuildContext context) {
    Get.put(
        AuthController()); // Consider moving this to a higher level if already initialized elsewhere
    return Scaffold(
      backgroundColor: const Color(secondaryColor),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          color: Color(0xFF8F2B08),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome back to the beer community",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
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
                            fillColor: Colors.grey,
                          ),
                          obscureText:
                              obscureText.value, // Use reactive value here
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
                      const SizedBox(height: 20),
                      Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Color(primaryColor),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  controller.signIn(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(primaryColor),
                                  foregroundColor: Colors.white,
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
                      ),
                      const SizedBox(height: 20),
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
