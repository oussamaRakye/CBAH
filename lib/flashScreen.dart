import 'package:cbah/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashScreen extends StatefulWidget {

  static String id = 'splash_screen';

  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      final _authe
      Navigator.pushNamed(context, WelcomeScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Hero(
          tag: 'logoSplash',
          child: Container(
            child: Image.asset('images/cbah.jpg'),
          ),
        ),
      ),
    );
  }
}
