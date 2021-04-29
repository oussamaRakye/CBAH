import 'package:cbah/verificationEmail.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cbah/components/textField.dart';
import 'package:cbah/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cbah/inScreen.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cbah/passwordScreen.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: ProgressHUD(
        barrierEnabled: true,
        barrierColor: Color.fromARGB(150, 100, 100, 100),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        indicatorColor: Colors.white,
        borderColor: Color.fromARGB(0, 0, 0, 0),
        borderWidth: 4.0,
        padding: EdgeInsets.all(40),
        child: Builder(
          builder: (context) =>Padding(
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
                TextInput(
                  hintText: 'Password',
                  passwordType: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                Button(
                  text: 'Log in',
                  tag: 'log_in',
                  function: () async {
                    final progress = ProgressHUD.of(context);
                    setState(() {
                      progress.show();
                    });
                    try{
                      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);

                      if (user != null){
                        //Navigator.pushNamed(context, InScreen.id);
                        if(user.user.emailVerified){
                          Navigator.pushNamed(context, InScreen.id);
                        }
                        else{
                          //Navigator.pushNamed(context, VerifyScreen.id);
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyScreen(email: email, password: password)
                              )
                          );
                        }

                      }
                    } catch (e) {
                      setState(() {
                        if (e.code == 'unknown'){
                          error = 'Email or password incorrect';
                        }
                        else{
                          print(e.code);
                        }
                      });
                    }
                    setState(() {
                      progress.dismiss();
                    });
                  },
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, ForgotPassword.id);
                    },
                    child: Text(
                      'Forgot password',
                      style: TextStyle(color: Colors.white),
                    ),
                ),
                Center(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
           ),
          ),
        ),
      ),
    );
  }
}
