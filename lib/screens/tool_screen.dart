import 'package:flutter/material.dart';
import 'package:withatu_test_version/widgets/tool_card.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('뜰체 대여'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            ToolCard(
              img: 'assets/pink.jpg',
              toolName: '핑크핑크 슈퍼짱짱 뜰채',
            ),
          ],
        ),
      ),
    );
  }
}
