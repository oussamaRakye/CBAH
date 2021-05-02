import 'package:cbah/constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text;
  final Function function;
  final String tag;
  bool enabled;
  ShapeBorder shapeBorder;
  final double height;
  final Widget child;

  Button({this.text='', this.function, this.tag, this.enabled=true, this.shapeBorder, this.height=42.0, this.child});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
        child: MaterialButton(
          shape: shapeBorder==null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)) : shapeBorder,
          elevation: 5.0,
          color: enabled ? Colors.white : Colors.grey,
          onPressed: enabled || function==null ? function : (){},
          minWidth: 200.0,
          height: height,
          child: child==null ? Text(
            text,
            style: TextStyle(color: background),
          ) : child,
        ),
      ),
    );
  }
}
