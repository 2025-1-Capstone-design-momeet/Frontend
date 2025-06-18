import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 👉 실제 MainPage로 대체할 페이지를 import 해주세요
import 'main_page.dart'; // 예시

class ApprovalRequestPage extends StatefulWidget {
  final String clubId;
  final String userName;
  final String department;
  final String userId;
  final String grade;
  final String studentNum;
  final String why;
  final String what;

  const ApprovalRequestPage({
    super.key,
    required this.userName,
    required this.department,
    required this.userId,
    required this.clubId,
    required this.grade,
    required this.studentNum,
    required this.why,
    required this.what,
  });

  @override
  ApprovalRequestPageState createState() => ApprovalRequestPageState();
}

class ApprovalRequestPageState extends State<ApprovalRequestPage> {
  String action = '';

  Future<void> approve() async {
    final uri = Uri.parse("http://momeet.meowning.kr/api/club/application/decision");

    final body = jsonEncode({
      "userId": widget.userId,
      "clubId": widget.clubId,
      "action": action, // approve 또는 deny
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ 업로드 성공: $decoded");

        final message = action == "approve"
            ? "가입 승인되었습니다"
            : "가입 거절되었습니다";

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        }
      } else {
        final decoded = utf8.decode(response.bodyBytes);
        print("❌ 업로드 실패: ${response.statusCode} $decoded");
        print("보낸 데이터: $body");
      }
    } catch (e) {
      print("🚨 에러 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String whyText = widget.why.trim().isEmpty ? '입력되지 않음' : widget.why;
    final String whatText = widget.what.trim().isEmpty ? '입력되지 않음' : widget.what;

    return Scaffold(
      appBar: AppBar(
        title: const Text("가입 요청", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            const SizedBox(height: 8),
            Text('${widget.grade}학년', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.userName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.studentNum,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),

            // 신청 사유 & 원하는 활동
            _buildSection("신청 사유", whyText),
            const SizedBox(height: 16),
            _buildSection("원하는 활동", whatText),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("거절", Color(0xFFAEAEAE), "deny"),
                _buildButton("승인", Color(0xFF69B36D), "approve"),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, color: Colors.green),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, String actionValue) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          action = actionValue;
        });
        approve();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
      ),
    );
  }
}
