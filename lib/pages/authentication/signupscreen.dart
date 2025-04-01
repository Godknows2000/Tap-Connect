import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/contollers/auth_controller.dart';
import 'package:tapconnect/pages/authentication/loginScreen.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final RxBool _obscureText =
      true.obs; // Reactive variable for password visibility

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Form(
                    key: _formKey,
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
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Join the beer community",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: authController.emailController,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Color(0xFF8F2B08),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: authController.passwordController,
                            decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFF8F2B08),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  _obscureText.value = !_obscureText.value;
                                },
                              ),
                            ),
                            obscureText: _obscureText.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
                                return 'Password must contain at least one lowercase letter';
                              }
                              if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
                                return 'Password must contain at least one number';
                              }
                              if (!RegExp(r'(?=.*?[!@#\$&*~])')
                                  .hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: authController.isAbove18.value,
                                onChanged: (bool? value) {
                                  authController.isAbove18.value =
                                      value ?? false;
                                },
                                activeColor: const Color(0xFF8F2B08),
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
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => authController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Color(primaryColor),
                                )
                              : ElevatedButton(
                                  onPressed: authController.isAbove18.value
                                      ? () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            authController.signup(context);
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(primaryColor),
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
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
                                      builder: (context) => LoginScreen()),
                                );
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
      ),
    );
  }
}
