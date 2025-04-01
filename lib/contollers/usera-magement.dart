import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tapconnect/pages/bottom_navigations_pages.dart/main_screen.dart';

class UserManagement {
  storeNewUser(user, context) async {
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentFirebaseUser?.uid)
        .set({
      'usAccount': [],
      'email': user.email,
      'uid': user.uid,
    }).then((value) => Get.offAll(() => MainScreen()));

    //.catchError((e) {});
  }
}
