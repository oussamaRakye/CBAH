import 'package:cbah/constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text;
  final Function function;
  final String tag;
  bool enabled;

  Button({this.text, this.function, this.tag, this.enabled=true});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          elevation: 5.0,
          color: enabled ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(

            onPressed: enabled ? function : null,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: TextStyle(color: background),
            ),
          ),
        ),
      ),
    );
  }
}
