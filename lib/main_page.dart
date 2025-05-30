import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


import 'buildSideMenu.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {
  String? _userId;

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
        final data = jsonDecode(response.body);
        print("✅✅✅요청 성공: ${utf8.decode(response.bodyBytes)}");
        print(data);
        print("이름: ${data['data']['name']}");
      } else {
        print('❌❌❌❌서버 오류: ${response.statusCode}');
        print('응답 내용: ${response.body}');
      }
    } catch (e) {
      print('⭐⭐⭐⭐예외 발생: $e');
    }
  }

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

  final List<String> imagePath = [
    'assets/mainImg_01.jpg',
    'assets/mainImg_01.jpg',
    'assets/mainImg_01.jpg',
  ];

  final List<String> clubActivityImages = [
    'assets/clubAct_01.jpg',
    'assets/mainImg_01.jpg',
    'assets/mainImg_01.jpg',
    'assets/mainImg_01.jpg',
    'assets/mainImg_01.jpg',
  ];

  final List<Map<String, String>> clubs = [
    {'category': '예술', 'name': '불모지대', 'image': 'https://via.placeholder.com/50'},
    {'category': '음악', 'name': '하모니', 'image': 'https://via.placeholder.com/50'},
  ];

  int _currentIndex = 0; // 현재 슬라이드 인덱스
  bool _isSidebarOpen = false; // 사이드바 열림/닫힘 상태 변수

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // 이제 제대로 작동!
            },
          ),
        ),
        title: Text(
          'mo.meet',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: buildSideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '금오공과대학교',
                style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: imagePath.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(url, fit: BoxFit.cover, width: double.infinity),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imagePath.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index ? Colors.green : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                '내 동아리',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                children: clubs.map((club) {
                  return Container(
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
                              backgroundImage: NetworkImage(club['image']!),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(club['category']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text(club['name']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 5),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text('더보기', style: TextStyle(color: Colors.green, fontSize: 16)),
                ),
              ),
              SizedBox(height: 2),
              Text(
                '동아리 활동',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(clubActivityImages.length, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 120,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(clubActivityImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),

        ),

      ),
    );
  }
}