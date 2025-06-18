import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/recruiting_page.dart';
import 'package:momeet/create_club_page.dart';
import 'package:momeet/request_club_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'clubMain_page.dart';
import 'main_page.dart';

class BuildSideMenu extends StatefulWidget {
  late final List<dynamic> myClubs;

  @override
  _BuildSideMenuState createState() => _BuildSideMenuState();
}

class _BuildSideMenuState extends State<BuildSideMenu> {
  String? _userId;
  List<String> imageUrls = [];
  bool _showAllClubs = false;

  // 서버 데이터 저장 변수들
  String userId = '';
  String name = '';
  String univName = '';
  String grade = '';
  bool schoolCertification = false;
  bool gender = false;
  String department = '';
  List<dynamic> myClubs = [];
  String firstClubName = '';
  List<dynamic> posters = [];
  String firstPosterImg = '';
  List<dynamic> clubPromotions = [];
  List<String> promotionClubNames = [];
  List<String> promotionClubId = [];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _userId = user.userId ?? "";

    if (_userId != null && _userId!.isNotEmpty) {
      fetchMainPageData();
    } else {
      print("⚠️ 사용자 ID가 없습니다.");
    }
  }

  Future<void> fetchMainPageData() async {
    final url = Uri.parse('http://momeet.meowning.kr/api/user/main');
    final body = jsonEncode({"userId": _userId});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ 요청 성공: $decoded");

        final data = decoded['data'];

        setState(() {
          userId = data['userId'] ?? '';
          name = data['name'] ?? '';
          grade = data['grade'] ?? '';
          univName = data['univName'] ?? '';
          schoolCertification = data['schoolCertification'] ?? false;
          gender = data['gender'] ?? false;
          department = data['department'] ?? '';

          myClubs = data['myClubs'] ?? [];
          firstClubName =
          myClubs.isNotEmpty ? myClubs[0]['clubName'] ?? '' : '';

          posters = data['posters'] ?? [];
          imageUrls = posters
              .map<String>((poster) =>
          'http://momeet.meowning.kr/api/file/image?type=posts&filename=${poster['img']}')
              .toList();

          clubPromotions = data['clubPromotions'] ?? [];
          promotionClubNames = clubPromotions
              .map<String>((club) => club['clubName'] ?? '')
              .toList();
          promotionClubId = clubPromotions
              .map<String>((club) => club['clubId'] ?? '')
              .toList();
        });
      } else {
        print('❌ 서버 오류: ${response.statusCode}');
        print('응답 내용: ${response.body}');
      }
    } catch (e) {
      print('❗ 예외 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayClubs = _showAllClubs ? myClubs : myClubs.take(2).toList();

    return Drawer(
      backgroundColor: const Color(0xFFFFFFFF),
      width: 300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 상단 사용자 정보
          Container(
            height: 250, // 원하는 높이로 조절
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text("${grade}학년",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[400],
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    Text(name,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF585858))),
                    Icon(Icons.female, color: Colors.pink, size: 18),
                  ],
                ),
                Text(
                  univName,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(department, style: TextStyle(color: Color(0xFF7C7C7C))),
              ],
            ),
          ),

          // 내 동아리 / 소모임
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("내 동아리 : 소모임",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Column(
                children: displayClubs.map<Widget>((club) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => clubMainPage(clubId: club['clubId']),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 270,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFBFBFB),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  club['official'] == true
                                      ? 'https://example.com/default_logo.png'
                                      : 'https://example.com/another_default.png',
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    club['clubName'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 5),

              if (!_showAllClubs && myClubs.length > 2)
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllClubs = true;
                      });
                    },
                    child: Text(
                      '더보기',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Container(
                width: 300 * 0.8, // Drawer 너비 300 기준 80% (240px)
                child: Divider(thickness: 1),
              ),
            ),
          ),

          // 메뉴 목록
          buildSectionTitle("동아리"),
          buildMenuItem("모집 공고", () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RecruitingPage(promotionClubs: clubPromotions)));
          }),
          buildMenuItem("동아리 활동", () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainPage()));
          }),
          buildMenuItem("창설하기", () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CreateClubPage(univName: univName)));
          }),


          buildSectionTitle("기타"),
          buildMenuItem("문의하기", () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainPage()));
          }),

          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          decoration: TextDecoration.underline, // 밑줄 추가
          decorationThickness: 2, // 밑줄 두께 조절
          decorationColor: Color(0xFF69B36D), // 밑줄 색
        ),
      ),
    );
  }

  Widget buildMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 30, right: 16),
      visualDensity: VisualDensity(vertical: -2, horizontal: 0),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF636363),
          fontWeight: FontWeight.w500,
          wordSpacing: 4,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}
