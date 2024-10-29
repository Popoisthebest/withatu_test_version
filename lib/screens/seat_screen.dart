import 'package:flutter/material.dart';
import 'package:withatu_test_version/widgets/seat.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자리 고르기'),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 300,
              width: 200,
              color: Colors.blueAccent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Seat(
                    seatNum: 6,
                  ),
                  SizedBox(height: 70),
                  Seat(
                    seatNum: 5,
                  ),
                ],
              ),
              SizedBox(width: 25),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Seat(
                    seatNum: 1,
                  ),
                  SizedBox(height: 350),
                  Seat(
                    seatNum: 4,
                  ),
                ],
              ),
              SizedBox(width: 25),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Seat(
                    seatNum: 2,
                  ),
                  SizedBox(height: 70),
                  Seat(
                    seatNum: 3,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
