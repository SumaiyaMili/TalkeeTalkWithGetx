import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talketalk/screens/user_list_screen.dart';
import '../component/rounded_button.dart';
import '../constants.dart';
import '../controller/login_controller.dart';


class LoginScreen extends StatelessWidget {
  static const String id = "Login_Screen";
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Obx(() => Column(
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
            SizedBox(height: 48.0),
            TextField(
              controller: _controller.emailController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              style: kInputTextStyle,
              decoration: KTextInputBoxDecoration.copyWith(hintText: "Email"),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _controller.passwordController,
              textAlign: TextAlign.center,
              obscureText: true,
              style: kInputTextStyle,
              decoration: KTextInputBoxDecoration.copyWith(hintText: "Password"),
            ),
            SizedBox(height: 24.0),
            SolidColuredButton(
              buttonColor: Colors.purpleAccent,
              lebelText: 'Log In',
              onPressed: () => _controller.login(context),
            ),
            if (_controller.showSpinner.value)
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
          ],
        )),
      ),
    );
  }
}
