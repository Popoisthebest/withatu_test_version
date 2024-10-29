import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:withatu_test_version/firebase_options.dart';
import 'package:withatu_test_version/screens/seat_screen.dart';
import 'package:withatu_test_version/screens/tool_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToolScreen(),
    );
  }
}
