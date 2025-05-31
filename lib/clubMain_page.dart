import 'package:flutter/material.dart';
import 'package:momeet/settlement_info_page.dart';

import 'buildSideMenu.dart';
import 'club_member_sidebar.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/vote_page.dart';

import 'meeting_page.dart';

class clubMainPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    final String university = "금오공과대학교";
    final String clubName = "불모지대";
    final String category = "예술";

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          'mo.meet',
          style: TextStyle(
            fontFamily: '런드리고딕',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: BuildSideMenu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(

            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 타이틀
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF69B36D)),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              clubName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF69B36D),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(category),
                            Checkbox(value: true, onChanged: (bool? value) {}),
                          ],
                        ),
                        SizedBox(width: 15),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(_createSlideTransition());
                          },
                          icon: Icon(Icons.person, color: Colors.grey),
                          label: Text(
                            '24',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 16),

                // 메인 이미지
                Container(
                  width: double.infinity,
                  height: isLandscape ? 200 : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/main_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // 상태 메시지
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('환영띠 ~~( ˘ ³˘ )',
                      style: TextStyle(fontSize: 16)),
                ),

                SizedBox(height: 16),

                // 다가오는 일정
                Text('다가오는 일정',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child:
                        Text('15', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('"김종욱 찾기" 연극 연습',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // 게시판
                Text('게시판',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📌 불모지대 필독 공지사항!!',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Divider(),
                      Text('- 2024.11.17 연극 후기'),
                      Text('- 동방 개편~!!! 미쳤따리'),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // 하단 네비게이션 버튼
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: isLandscape ? 6 : 4,
                  children: [
                    _buildBottomButton(Icons.calendar_today, '캘린더', () {
                      // 캘린더 페이지로 이동 등 향후 구현
                    }),
                    _buildBottomButton(Icons.calculate, '정산', () {
                      // 정산 페이지 이동 코드 넣기
                    }),
                    _buildBottomButton(Icons.check, '투표', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VotePage()),
                      );
                    }),
                    _buildBottomButton(Icons.assignment, '회의', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MeetingPage()),
                      );
                    }),

                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Route _createSlideTransition() {
    return PageRouteBuilder(
      opaque: false,  // 배경이 보이도록 false로 설정
      barrierColor: Colors.black.withOpacity(0.3),  // 전체 배경 어둡게 (optional)
      pageBuilder: (context, animation, secondaryAnimation) => ClubMemberSidebar(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return Stack(
          children: [
            // 배경 반투명 오버레이
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 배경 탭 시 닫히도록 처리 가능
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            // 슬라이드되는 사이드바
            SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          ],
        );
      },
    );
  }



  Widget _buildBottomButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.green),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

}
