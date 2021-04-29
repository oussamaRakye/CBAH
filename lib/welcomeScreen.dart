import 'package:cbah/components/textField.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cbah/components/button.dart';
import 'registerScreen.dart';
import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {

  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // controller = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );
    //
    // animation = ColorTween(
    //   begin: background,
    //   end: Colors.white,
    // ).animate(controller);
    //
    // controller.forward();
    //
    // controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: animation.value,
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
            Button(
              text: 'Log in',
              tag: 'log_in',
              function: () =>{
                Navigator.pushNamed(context, LoginScreen.id)
              },
            ),
            Button(
              text: 'Register',
              tag: 'register',
              function: () =>{
                Navigator.pushNamed(context, RegisterScreen.id)
              },
            ),
          ],
        ),
      ),
    );
  }
}
