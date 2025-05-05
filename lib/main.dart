import 'package:flutter/material.dart';
import 'package:momeet/login_page.dart';
import 'package:momeet/join_page.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/approvalRequest_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: clubMainPage(), // 메인 페이지 설정
    );
  }
}
