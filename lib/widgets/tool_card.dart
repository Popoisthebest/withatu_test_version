import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:withatu_test_version/screens/seat_screen.dart';

class ToolCard extends StatefulWidget {
  final String img;
  final String toolName;

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

  void sendTool(String toolName, int stock) {
    final toolData = <String, dynamic>{
      "tool_name": toolName,
      "stock": stock,
      "timestamp": FieldValue.serverTimestamp(), // 서버 시간을 timestamp로 추가
    };

    db.collection("current states").doc(toolName).set(toolData).onError(
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

        int stock = snapshot.data!['stock'] ?? 0;

        return GestureDetector(
          onTap: stock == 0
              ? null
              : () {
                  setState(() {
                    stock = stock > 0 ? stock - 1 : 0;
                  });
                  sendTool(widget.toolName, stock);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => SeatScreen()),
                  );
                },
          child: SizedBox(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(widget.img),
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.toolName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              stock > 0 ? '재고: $stock' : '품절',
                              style: TextStyle(
                                fontSize: 16,
                                color: stock > 0 ? Colors.black : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 120,
                    color: stock > 0 ? Colors.green : Colors.red,
                    child: Center(
                      child: Text(
                        stock > 0 ? '대여\n하기' : '대여\n불가',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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
