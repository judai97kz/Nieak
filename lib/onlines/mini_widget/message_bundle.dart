import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String senderId;
  final bool isCurrentUser;

  MessageBubble({required this.text, required this.senderId, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topLeft: isCurrentUser ? Radius.circular(30.0) : Radius.circular(0.0),
              topRight: isCurrentUser ? Radius.circular(0.0) : Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isCurrentUser ? Colors.lightBlueAccent : Colors.grey.shade300,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
