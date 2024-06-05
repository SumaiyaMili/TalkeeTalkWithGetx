import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/rounded_button.dart';
import '../constants.dart';
import '../controller/registration_controller.dart';


class RegistrationScreen extends StatelessWidget {
  static const String id = "Registration_Screen";
  final RegistrationController _controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Obx(
              () => Column(
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
                  _controller.email.value = value;
                },
                decoration: KTextInputBoxDecoration.copyWith(
                  hintText: "Enter Your Email",
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                style: kInputTextStyle,
                obscureText: true,
                onChanged: (value) {
                  _controller.password.value = value;
                },
                decoration: KTextInputBoxDecoration.copyWith(
                  hintText: "Enter Your Password",
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              SolidColuredButton(
                buttonColor: Colors.deepPurple,
                lebelText: 'Register',
                onPressed: () async {
                  await _controller.registerUser();
                },
              ),
              _controller.showSpinner.value
                  ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
