import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:withatu_test_version/screens/result.dart';

class Seat extends StatefulWidget {
  final int seatNum;

  const Seat({
    super.key,
    required this.seatNum,
  });

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  void sendSeat(int seatNum, bool isUsing) {
    final seatData = <String, dynamic>{
      "seat_number": seatNum,
      "is_using": isUsing,
      "timestamp": FieldValue.serverTimestamp(), // 서버 시간을 timestamp로 추가
    };

    db.collection("seats").doc(seatNum.toString()).set(seatData).onError(
          (e, _) => print("Error writing document: $e"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection("seats").doc(widget.seatNum.toString()).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("데이터가 없습니다.");
        }

        bool isUsing = snapshot.data!['is_using'] ?? false;

        return GestureDetector(
          onTap: () {
            isUsing = !isUsing;
            sendSeat(widget.seatNum, isUsing);
            Navigator.push(
                context, MaterialPageRoute(builder: (builder) => Result()));
          },
          child: Container(
            height: 50,
            width: 50,
            color: isUsing ? Colors.red : Colors.green,
            child: Center(
              child: Text(
                widget.seatNum.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
