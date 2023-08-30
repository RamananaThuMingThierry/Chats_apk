import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget{
  final String message;
  final bool isMe;

  SingleMessage({
    required this.message,
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(5),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Text("${message}", style: TextStyle(color: Colors.white),),
          ),
        ],
    );
  }
}