import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToolCard extends StatefulWidget {
  // 필드 선언
  String img;
  String toolName;
  bool isUsing;

  // 생성자에서 매개변수를 받아 필드에 할당
  ToolCard({
    super.key,
    required this.img,
    required this.toolName,
    required this.isUsing,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  void sendData(String toolName, bool isUsing) {
    // Create a new user with a first and last name
    final toolList = <String, dynamic>{
      "tool_name": toolName,
      "isUsing": isUsing,
    };

    // Add a new document with a generated ID
    db
        .collection("users")
        .doc(toolList['tool_name'])
        .set(toolList)
        .onError((e, _) => print("Error writing document: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isUsing = !widget.isUsing;
        });
        sendData(widget.toolName, widget.isUsing);
      },
      child: Container(
        color: widget.isUsing ? Colors.red : Colors.blue,
        height: 120,
        child: Row(
          children: [
            // Image.asset(img),
            Text(widget.toolName),
          ],
        ),
      ),
    );
  }
}
