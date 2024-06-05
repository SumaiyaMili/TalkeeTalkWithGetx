import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talketalk/screens/chat_screen.dart';
import 'package:talketalk/screens/login_screen.dart';
import 'package:talketalk/screens/registration_screen.dart';
import 'package:talketalk/screens/user_list_screen.dart';
import 'package:talketalk/screens/welcome_screen.dart';
import 'package:talketalk/service/notification_service.dart';
import 'controller/login_controller.dart';
import 'firebase_options.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  // You can call your notification service to display the notification here
  NotificationService().showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(FirebaseFirestore.instance); // Inject Firestore instance
  Get.put(LoginController()); // Inject AuthController

  await NotificationService().init(); // Initialize Notification Service

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light().copyWith(),
      initialRoute: '/welcomeScreen',
      getPages: [
        GetPage(name: '/welcomeScreen', page: () => WelcomeScreen()),
        GetPage(name: '/loginScreen', page: () => LoginScreen()),
        GetPage(name: '/registrationScreen', page: () => RegistrationScreen()),
        GetPage(name: '/chatScreen', page: () => ChatScreen(chatSender: '')),
        GetPage(name: '/userListScreen', page: () => UserListScreen()),
      ],
    );
  }
}
