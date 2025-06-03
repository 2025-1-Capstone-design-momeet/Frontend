import 'package:flutter/material.dart';
import 'package:momeet/meeting_page.dart';
import 'package:momeet/waiting_list_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Center(child: Text("메인 화면")),

            Container(
              color: Colors.black.withOpacity(0.2),
            ),

            // ✅ 사이드바
            ClubMemberSidebar(),
          ],
        ),
      ),
    );
  }
}

class ClubMemberSidebar extends StatelessWidget {
  final List<Member> members = List.generate(
    15,
        (index) => Member(
      name: ['전장혁', '강채희', '송채빈', '임나경', '허겸'][index % 5],
      department: [
        '기계시스템공학과',
        '컴퓨터소프트웨어공학과',
        '토목공학과',
        '경영학과'
      ][index % 4],
      role: [null, '부회장', '간부', '회장'][index % 4],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 8,
        child: Container(
          width: screenWidth * 0.8,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 프로필
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                        AssetImage('assets/mainImg_01.jpg'), // 프로필 이미지
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '불모지대',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 4),
                                Text(
                                  '예술',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),]
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WaitingListPage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green.shade800,
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2), // 패딩 줄임
                                minimumSize: Size(0, 0), // 최소 크기 제거
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역도 줄임
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14, // 글자 크기도 조절 가능
                                ),
                              ),
                              child: Text('가입 대기'),
                            ),

                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    '부원',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),

                  // 구성원 리스트
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return MemberTile(member: members[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Member {
  final String name;
  final String department;
  final String? role;

  Member({required this.name, required this.department, this.role});
}

class MemberTile extends StatelessWidget {
  final Member member;

  const MemberTile({required this.member});

  Color getBadgeColor(String role) {
    switch (role) {
      case '회장':
        return Colors.red.shade300;
      case '부회장':
        return Colors.blue.shade300;
      case '간부':
        return Colors.green.shade300;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.account_circle, size: 28, color: Colors.grey.shade800),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  member.department,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (member.role != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getBadgeColor(member.role!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                member.role!,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
