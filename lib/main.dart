import 'package:flutter/material.dart';
import 'package:momeet/settlement_personal_page.dart';
import 'package:momeet/settlement_president_page.dart';
import 'package:provider/provider.dart';
import 'package:momeet/login_page.dart';
import 'package:momeet/join_page.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/approvalRequest_page.dart';
import 'package:momeet/verification_page.dart';
import 'package:momeet/vote_page.dart';
import 'package:momeet/vote_create_page.dart';
import 'package:momeet/calculate_member_page.dart';
import 'user_provider.dart';


void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child: const MyApp()
    ),
  );
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
      home: SettlementPresidentPage(), // 메인 페이지 설정
    );
  }
}
