import 'package:flutter/material.dart';

class ApprovalRequestPage extends StatelessWidget {
  final String name = "강채희";
  final String major = "소프트웨어전공";
  final String studentId = "20220031";
  final String grade = "4학년";
  final String reason = "너무 재밌을 것 같아서 신청합니다.\n저는 진짜 이런게 너무 맘에 들거든요?\n저 좀 붙여주세요;;";
  final String activities = "랩, 댄스, 노래, 기선제압하기";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("가입 요청", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            SizedBox(height: 8),
            Text(grade, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(major, style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(studentId, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 24),

            _buildSection("신청 사유", reason),
            SizedBox(height: 16),
            _buildSection("원하는 활동", activities),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("거절", Colors.grey),
                _buildButton("승인", Colors.green),
              ],
            ),
            SizedBox(height: 16),
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
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content, style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
