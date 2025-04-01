import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tapconnect/config/configuration.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/contollers/usera-magement.dart';
import 'package:tapconnect/models/user_model.dart';
import 'package:tapconnect/pages/authentication/loginScreen.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/main_screen.dart';

class AuthController extends GetxController {
  GetStorage getStorage = GetStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isAbove18 = false.obs;
  RxBool isLoading = false.obs;
  RxBool stringResponse = false.obs;
  TextEditingController authorNameController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  Map<String, dynamic> data = {};

  // Signup method
  void signup(BuildContext context) async {
    isLoading.value = true;
    try {
      UserCredential signedInUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      data = {
        "email": signedInUser.user!.email,
        "uid": signedInUser.user!.uid,
      };
      await getStorage.write("user", data);
      kUser.value = UserModel.fromJson(data);

      UserManagement().storeNewUser(signedInUser.user, context);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Email or password error, try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign-in method
  void signIn(BuildContext context) async {
    isLoading.value = true;
    try {
      UserCredential signedInUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      data = {
        "email": signedInUser.user!.email,
        "uid": signedInUser.user!.uid,
      };
      await getStorage.write("user", data);
      kUser.value = UserModel.fromJson(data);

      Get.offAll(() => MainScreen());
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid email or password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      isLoading.value = false;
    }
  }

  signOut() {
    isLoading.value = true;
    getStorage.erase();
    FirebaseAuth.instance
        .signOut()
        .then((value) => Get.to(() => LoginScreen()));
    isLoading.value = false;
  }
  // New Sign-out method
  // void signOut(BuildContext context) async {
  //   isLoading.value = true;
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     await getStorage.remove("user");
  //     data.clear();
  //     kUser.value = UserModel(); // Reset user model

  //     // Navigate back to login screen
  //     Navigator.pushReplacementNamed(context, '/login');

  //     Fluttertoast.showToast(
  //         msg: "Successfully signed out",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //         msg: "Error signing out",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.orange,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // New Reset Password method
  void resetPassword(String email) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter an email address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(primaryColor),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Fluttertoast.showToast(
          msg: "Password reset email sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error sending reset email: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(primaryColor),
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      isLoading.value = false;
    }
  }
}
