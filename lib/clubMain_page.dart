import 'package:flutter/material.dart';

class clubMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mo.meet'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 타이틀
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '금오공과대학교',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '불모지대',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Checkbox(value: true, onChanged: (bool? value) {}),
                  Text('예술'),
                ],
              ),
            ),

            // 메인 이미지
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage('assets/main_image.png'), // 이미지 경로 수정 필요
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 상태 메시지
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('환영띠 ~~( ˘ ³˘ )', style: TextStyle(fontSize: 16)),
            ),

            // 다가오는 일정
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('다가오는 일정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text('15', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('"김종욱 찾기" 연극 연습', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            // 공지사항
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('게시판', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📌 불모지대 필독 공지사항!!', style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('- 2024.11.17 연극 후기'),
                  Text('- 동방 개편~!!! 미쳤따리'),
                ],
              ),
            ),

            // 하단 네비게이션 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  _buildBottomButton(Icons.calendar_today, '캘린더'),
                  _buildBottomButton(Icons.calculate, '정산'),
                  _buildBottomButton(Icons.check, '투표'),
                  _buildBottomButton(Icons.assignment, '회의'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.green),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}