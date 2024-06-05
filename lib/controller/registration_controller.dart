import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var email = ''.obs;
  var password = ''.obs;
  var showSpinner = false.obs;

  Future<void> registerUser() async {
    try {
      showSpinner.value = true;
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      if (newUser != null) {
        Get.offAllNamed('/userListScreen');
      }
    } catch (e) {
      showToast(e.toString());
      print(e);
    } finally {
      showSpinner.value = false;
    }
  }

  void showToast(String message) {
    // Implementation of showToast
  }
}
