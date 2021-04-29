import 'package:cbah/constants.dart';
import 'package:cbah/inScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class VerifyScreen extends StatefulWidget {

  final String email;
  final String password;
  static String id = 'verify_screen';

  VerifyScreen({this.email, this.password});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  Timer timer;

  void checkVerification() async{
    // TODO: improve this, it is ugly AF
    print(loggedInUser.emailVerified);
    await _auth.signOut();
    await _auth.signInWithEmailAndPassword(email: widget.email, password: widget.password);
    if(FirebaseAuth.instance.currentUser.emailVerified == true){
      Navigator.pushNamed(context, InScreen.id);
      timer.cancel();
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = _auth.currentUser;
    if (user != null){
      loggedInUser = user;
      loggedInUser.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        checkVerification();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

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
            Text(
              'Verify your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
            ),
            Text(
              'Click on the link sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
