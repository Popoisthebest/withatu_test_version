import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 추가
import 'package:withatu_test_version/widgets/receipt.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  // `current states` 컬렉션에서 가장 최근에 업데이트된 도구 가져오기
  Future<Map<String, dynamic>?> getLatestTool() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("current states")
        .orderBy("timestamp", descending: true) // 최신순으로 정렬
        .limit(1) // 가장 최근 항목 하나만 가져옴
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null; // 데이터가 없을 경우 null 반환
  }

  // `seats` 컬렉션에서 가장 최근에 업데이트된 자리 가져오기
  Future<Map<String, dynamic>?> getLatestSeat() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("seats")
        .orderBy("timestamp", descending: true) // 최신순으로 정렬
        .limit(1) // 가장 최근 항목 하나만 가져옴
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null; // 데이터가 없을 경우 null 반환
  }

  // 현재 날짜와 시간을 'yyyy.MM.dd | HH:mm' 형식으로 반환하는 함수
  String getCurrentDateTime() {
    final now = DateTime.now();
    return DateFormat('yyyy.MM.dd | HH:mm').format(now);
  }

  // Firestore의 타임스탬프를 'yyyy-MM-dd HH:mm' 형식으로 변환하는 함수
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "시간 정보 없음"; // timestamp가 null일 때 표시할 텍스트
    }
    final dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "영수증",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([getLatestTool(), getLatestSeat()]),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("데이터가 없습니다."));
          }

          final latestTool = snapshot.data![0];
          final latestSeat = snapshot.data![1];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getCurrentDateTime(), // 현재 날짜와 시간을 표시
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        height: 17 / 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "(주)새로이나누리",
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000),
                        height: 24 / 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 15),
                    Container(color: Colors.grey, height: 1),
                    SizedBox(height: 20),
                    if (latestTool != null) ...[
                      Receipt(
                          title: '상품명', detail: "${latestTool['tool_name']}"),
                      Receipt(
                          title: '대여 시간',
                          detail: formatTimestamp(latestTool['timestamp'])),
                      Receipt(title: '재고', detail: "${latestTool['stock']}"),
                      Receipt(title: '거래유형', detail: "승인"),
                    ] else
                      Text("도구 데이터가 없습니다."),
                    SizedBox(height: 5),
                    Container(color: Colors.grey, height: 1),
                    SizedBox(height: 20),
                    if (latestSeat != null) ...[
                      Receipt(
                          title: '자리 번호',
                          detail: "${latestSeat['seat_number']}"),
                      Receipt(
                          title: '대여 시간',
                          detail: formatTimestamp(latestSeat['timestamp'])),
                      Receipt(title: '사용 가능 여부', detail: '사용 가능'),
                    ] else
                      Text("자리 데이터가 없습니다."),
                    SizedBox(height: 5),
                    Container(color: Colors.grey, height: 1),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff1080FF),
                      ),
                      child: Center(
                        child: Text(
                          '완료',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
