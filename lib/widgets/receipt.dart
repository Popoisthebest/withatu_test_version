import 'package:flutter/material.dart';

class Receipt extends StatelessWidget {
  String title, detail;
  Receipt({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              height: 17 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            detail,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
              height: 17 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
