import 'package:flutter/material.dart';
import 'package:meu_flash/services/gpt_services/gpt_service.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final String imageUrl;
  final bool isMe;

  MessageBubble({
    required this.sender,
    required this.text,
    required this.imageUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        Material(
          borderRadius: isMe
              ? BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )
              : BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          elevation: 5.0,
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black54,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
