import 'package:flutter/material.dart';
import 'package:cbah/components/button.dart';
import 'package:cbah/components/textField.dart';
import 'package:cbah/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbah/user.dart';
import 'package:cbah/components/messageBubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //final _auth = FirebaseAuth.instance;
  //FirebaseUser loggedInUser;
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String messageText;


  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs){
      print(message.data());
    }
  }

  void messagesStream() async {
   await for(var snapshot in _firestore.collection('messages').snapshots()){
     for (var message in snapshot.docs){
       print(message.data());
     }
   }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
            builder: (context, snapshot){
              List<Widget> messagesWidgets = [];
              if (snapshot.hasData){
                final messages = snapshot.data.docs;
                String lastSender;
                for (var message in messages){
                  final messageText = message.data()['text'];
                  final messageSender = message.data()['sender'];
                  final senderEmail = message.data()['email'];

                  final messageWidget = MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    isMe: senderEmail == Usr.email,
                    noSender: senderEmail == lastSender,
                  );
                  messagesWidgets.add(messageWidget);
                  lastSender = senderEmail;
                }
              }

              return Expanded(
                child: ListView(
                  //padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                  reverse: true,
                  children: List.from(messagesWidgets.reversed),
                ),
              );
            },
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Expanded(
                 flex: 6,
                 child: TextInput(
                   controller: messageTextController,
                   textAlign: TextAlign.left,
                   onChanged: (value){
                      messageText = value;
                   },
                   hintText: 'Type a message',
                 ),
               ),
                Expanded(
                  flex: 1,
                  child: Button(
                    child: Icon(Icons.send, color: background,),
                    function: (){
                      if(messageText.trim() == '') return;
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': '${Usr.name} ${Usr.surname}',
                        'email': Usr.email,
                        'time': Timestamp.now(),
                      });
                      // var now = DateTime.now();
                      // _firestore.collection('messages').doc('Y${now.year}M${now.month}D${now.day}H${now.hour}M${now.minute}S${now.second}MS${now.microsecond}').set({
                      //     'text': messageText,
                      //     'sender': '${Usr.name} ${Usr.surname}',
                      //     'email': Usr.email,
                      // });
                      messageTextController.clear();
                      messageText = '';
                    },
                    tag: 'send',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
