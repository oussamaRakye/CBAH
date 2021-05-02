import 'package:cbah/flashScreen.dart';
import 'package:cbah/inScreen.dart';
import 'package:cbah/registerScreen.dart';
import 'package:cbah/welcomeScreen.dart';
import 'user.dart';
import 'loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:cbah/inScreen.dart';
import 'package:cbah/verificationEmail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cbah/passwordScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cbah/notifications.dart';

void main() => runApp(CBAH());

// TODO: add flexible (as parent) to all heros
class CBAH extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

   Firebase.initializeApp();

    // final fbm = FirebaseMessaging.instance;
    // fbm.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      initialRoute: FlashScreen.id,
      routes: {
        FlashScreen.id: (context) => FlashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        InScreen.id: (context) => InScreen(),
        VerifyScreen.id: (context) => VerifyScreen(),
        ForgotPassword.id: (context) => ForgotPassword(),
      },
    );
  }
}


