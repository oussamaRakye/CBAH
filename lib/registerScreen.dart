import 'package:cbah/inScreen.dart';
import 'package:cbah/verificationEmail.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cbah/components/textField.dart';
import 'package:cbah/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String repeatPassword;
  String name;
  String surname;
  String phoneNumber;
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
          builder: (context) => ListView(
            children: [
              Padding(
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
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextInput(
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Email',
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
                    TextInput(
                      hintText: 'Confirm password',
                      passwordType: true,
                      onChanged: (value) {
                        repeatPassword = value;
                      },
                    ),
                    TextInput(
                      hintText: 'Name',
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    TextInput(
                      hintText: 'Surname',
                      onChanged: (value) {
                        surname = value;
                      },
                    ),
                    TextInput(
                      hintText: 'Phone number',
                      textInputType: TextInputType.phone,
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                    ),
                    Button(
                      text: 'Register',
                      tag: 'register',
                      function: () async {
                        // TODO: refactor setState, one would be enough
                        final progress = ProgressHUD.of(context);
                        setState(() {
                          progress.show();
                        });
                        if (password != password){
                          setState(() {
                            error = 'Passwords don\'t match';
                          });
                        }
                        else if(name == '' || surname == '' || phoneNumber == ''){
                          setState(() {
                            error = 'Fill all the gaps';
                          });
                        }
                        else {
                          try {
                            final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                            if (newUser != null) {
                              //newUser.user.linkWithPhoneNumber(phoneNumber);
                              //newUser.user.updateProfile(displayName: '$name $surname');
                              _firestore.collection('users').doc(email).set({
                                'name': name,
                                'surname': surname,
                                'phoneNumber': phoneNumber,
                                'email': email,
                              });

                              // var postsRef = _firestore.collection('users');
                              // postsRef.doc()
                              print('User created');
                              //Navigator.pushNamed(context, VerifyScreen.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyScreen(
                                              email: email,
                                              password: password)));
                            }
                          } catch (e) {
                            setState(() {
                              if (e.code == 'invalid-email') {
                                error = 'Invalid email';
                              } else if (e.code == 'weak-password') {
                                error = 'Password too short';
                              } else if (e.code == 'email-already-in-use') {
                                error = 'Email already registered';
                              } else {
                                print(e.code);
                              }
                            });
                          }
                        }
                        setState(() {
                          progress.dismiss();
                        });
                      },
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
            ],
          ),
        ),
      ),
    );
  }
}
