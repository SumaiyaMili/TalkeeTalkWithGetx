import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final count = 0.obs;

  increment() => count.value++;
}
