import 'package:flutter/material.dart';
import 'package:withatu_test_version/widgets/tool_card.dart';

class SeatScreen extends StatelessWidget {
  const SeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('뜰체 대여'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            ToolCard(
              img: '',
              toolName: '뜰채 1',
              isUsing: true,
            ),
          ],
        ),
      ),
    );
  }
}
