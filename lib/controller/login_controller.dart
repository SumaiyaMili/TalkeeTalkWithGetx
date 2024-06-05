import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/user_list_screen.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool showSpinner = false.obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  void login(BuildContext context) async {
    showSpinner.value = true;
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (user != null) {
        Get.offAll(UserListScreen());
      }
    } catch (e) {
      showToast(e.toString());
      print(e);
    } finally {
      showSpinner.value = false;
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 12.0,
    );
  }
}
