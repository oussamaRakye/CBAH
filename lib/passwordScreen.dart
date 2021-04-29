import 'package:cbah/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbah/components/textField.dart';
import 'package:cbah/components/button.dart';


class ForgotPassword extends StatefulWidget {

  static String id = 'password_screen';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _auth = FirebaseAuth.instance;
  String email;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Hero(
                  tag: 'logoSplash',

                  child: Container(
                    child: Image.asset('images/cbah.jpg'),
                    width:  MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextInput(
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
              ),
              Button(
                text: 'Send recovery email',
                tag: 'password_recovery',
                function: () async{
                  await _auth.sendPasswordResetEmail(email: email);
                  setState(() {
                    message = 'Email sent!';
                  });
                },
              ),
              Center(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
      ),
    );
  }
}
