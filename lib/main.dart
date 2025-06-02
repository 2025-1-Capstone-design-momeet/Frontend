import 'package:flutter/material.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/meeting_page.dart';
import 'package:momeet/settlement_info_page.dart';
import 'package:momeet/settlement_personal_page.dart';
import 'package:momeet/settlement_president_page.dart';
import 'package:momeet/verification_page.dart';
import 'package:momeet/vote_page.dart';
import 'package:provider/provider.dart';
import 'package:momeet/login_page.dart';
import 'main_page.dart';
import 'meeting_detail_page.dart';
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
      // home:  MeetingDetailPage(clubId: 'c020fd825e4d4f67a87e8a233487e5e4'), // 메인 페이지 설정
      home: loginPage(),
    );
  }
}
