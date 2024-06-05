import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/message_stream_widget.dart';
import '../constants.dart';
import 'login_screen.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "Chat_Screen";
  final String chatSender;

  ChatScreen({required this.chatSender});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final msgTextController = TextEditingController();
  late String text;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[

        ],
        title: Text('${widget.chatSender.split('@').first}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(fireStore: _fireStore, chatSender: widget.chatSender),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: msgTextController,
                        maxLines: 2,
                        style: kInputTextStyle,
                        onChanged: (value) {
                          text = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        msgTextController.clear();
                        sendFunction();
                      },
                      child: Icon(Icons.send),
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

  void sendFunction() {
    _fireStore.collection("messages").add({
      'sender': loggedInUser.email,
      'receiver': widget.chatSender,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
