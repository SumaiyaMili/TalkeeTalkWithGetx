import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talketalk/screens/chat_screen.dart';
import 'package:talketalk/screens/login_screen.dart';
import 'package:talketalk/screens/registration_screen.dart';
import 'package:talketalk/screens/user_list_screen.dart';
import 'package:talketalk/screens/welcome_screen.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(

      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(chatSender: ''),
        UserListScreen.id: (context) => UserListScreen(),
      },
    );
  }
}
