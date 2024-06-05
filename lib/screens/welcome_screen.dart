import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talketalk/screens/login_screen.dart';
import 'package:talketalk/screens/registration_screen.dart';
import '../component/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
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
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        'Talkee Talk',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            SolidColuredButton(
              buttonColor: Colors.purpleAccent,
              lebelText: 'Log In',
              onPressed: () {
                Get.toNamed('/loginScreen');
              },
            ),
            SolidColuredButton(
              buttonColor: Colors.purple,
              lebelText: 'Register',
              onPressed: () {
                Get.toNamed('/registrationScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
