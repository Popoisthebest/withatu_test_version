import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToolCard extends StatefulWidget {
  // 필드 선언
  final String img;
  final String toolName;

  // 생성자에서 매개변수를 받아 필드에 할당
  const ToolCard({
    super.key,
    required this.img,
    required this.toolName,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // 상태를 데이터베이스에 저장
  void sendData(String toolName, bool isUsing) {
    final toolList = <String, dynamic>{
      "tool_name": toolName,
      "isUsing": isUsing,
    };

    db.collection("current states").doc(toolName).set(toolList).onError(
          (e, _) => print("Error writing document: $e"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection("current states").doc(widget.toolName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("데이터가 없습니다.");
        }

        // Firestore의 현재 상태를 가져와 isUsing 변수를 설정
        bool isUsing = snapshot.data!['isUsing'] ?? false;

        return GestureDetector(
          onTap: () {
            setState(() {
              isUsing = !isUsing;
            });
            sendData(widget.toolName, isUsing);
          },
          child: SizedBox(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(widget.img),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.toolName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 120,
                    color: isUsing ? Colors.red : Colors.green,
                    child: Center(
                      child: Text(
                        isUsing ? '사용중' : '사용\n가능',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
