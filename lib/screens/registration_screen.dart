import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talketalk/screens/chat_screen.dart';
import 'package:talketalk/screens/user_list_screen.dart';

import '../component/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "Registration_Screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              style: kInputTextStyle,
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: KTextInputBoxDecoration.copyWith(
                  hintText: "Enter Your Email"),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: kInputTextStyle,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: KTextInputBoxDecoration.copyWith(
                  hintText: "Enter Your Password"),
            ),
            SizedBox(
              height: 24.0,
            ),
            SolidColuredButton(
                buttonColor: Colors.deepPurple,
                lebelText: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  await registerUser(context);
                }),
            showSpinner
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> registerUser(BuildContext context) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if ((newUser != null)) {
        Navigator.pushNamed(context, UserListScreen.id);
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      showToast(e.toString());
      print(e);
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
