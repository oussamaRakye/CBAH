import 'package:cbah/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String sender, text;
  final bool isMe, noSender;

  MessageBubble({this.text,this.sender, this.isMe, this.noSender=false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        child: Padding(
          //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: noSender ? 2.0 : 2.0),
          padding: EdgeInsets.fromLTRB(20, noSender ? 3 : 10, 20, 3),
          child: Material(
            elevation: 6.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topLeft: isMe || noSender ? Radius.circular(30.0) : Radius.circular(0.0),
                  topRight: !isMe || noSender ? Radius.circular(30.0) : Radius.circular(0.0),
              ),
            ),
            // borderRadius: BorderRadius.only(
            //   bottomLeft: Radius.circular(30.0),
            //   bottomRight: Radius.circular(30.0),
            //   topLeft: Radius.circular(0.0),
            //   topRight: Radius.circular(30.0),
            // ),
            color: isMe ? background : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getTexts(),
                ),
              ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTexts() {
    List<Widget> list = [];

    if(!noSender){
      list.add(Text(
        '$sender',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: isMe ? Colors.white : background,
        ),
      ));
  }


    list.add(Text(
      '$text',
      style: TextStyle(
        fontSize: 15.0,
        color: isMe ? Colors.white : background,
      ),
    ));

    return list;
  }
}
