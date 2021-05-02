import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  final Function onChanged;
  final String hintText;
  final bool passwordType;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final controller;

  TextInput({this.onChanged, this.hintText, this.passwordType=false, this.textInputType=TextInputType.text, this.textAlign=TextAlign.center, this.controller});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: passwordType,
        textAlign: textAlign,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hoverColor: Colors.green,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          contentPadding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
    );
  }
}
