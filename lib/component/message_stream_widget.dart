import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import 'msg_bubble_widget.dart';

class MessageStream extends StatelessWidget {
  final FirebaseFirestore fireStore;
  final String chatSender;

  MessageStream({required this.fireStore, required this.chatSender});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore
          .collection('messages')
          .where('receiver', whereIn: [chatSender, loggedInUser.email])
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {


          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purpleAccent,
            ),
          );
        }


        final messages = snapshot.data!.docs;

        List<MessageBubble> messageBubbles = [];
        if(messages.isEmpty){
          return Center(
              child: Text(
                "Let's say hi to TalkMate",
                style: TextStyle(fontSize: 18),
              ));
        }
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messageReceiver = message['receiver'];

          if ((messageSender == loggedInUser.email && messageReceiver == chatSender) ||
              (messageSender == chatSender && messageReceiver == loggedInUser.email)) {
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: loggedInUser.email == messageSender,
            );

            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}