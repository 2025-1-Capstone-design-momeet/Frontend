import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'buildSideMenu.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  late final List<dynamic> myClubs;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _userId;
  List<String> imageUrls = [];
  bool _showAllClubs = false;

  // 서버 데이터 저장 변수들
  String userId = '';
  String name = '';
  String univName = '';
  bool schoolCertification = false;
  bool gender = false;
  List<dynamic> myClubs = [];
  String firstClubName = '';
  List<dynamic> posters = [];
  String firstPosterImg = '';
  List<dynamic> clubPromotions = [];
  List<String> promotionClubNames = [];

  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2)); // 새로고침 대기 시간
    setState(() {
      fetchMainPageData();
    });
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
        print("✅✅✅요청 성공: $decoded");

        final data = decoded['data'];

        setState(() {
          userId = data['userId'] ?? '';
          name = data['name'] ?? '';
          univName = data['univName'] ?? '';
          schoolCertification = data['schoolCertification'] ?? false;
          gender = data['gender'] ?? false;

          myClubs = data['myClubs'] ?? [];
          firstClubName = myClubs.isNotEmpty ? myClubs[0]['clubName'] ?? '' : '';

          posters = data['posters'] ?? [];
          imageUrls = posters
              .map<String>((posters) =>
          'http://momeet.meowning.kr/api/file/image?type=poster&filename=${posters['img']}')
              .toList();

          print("📷 이미지 URL 목록: $imageUrls");

          clubPromotions = data['clubPromotions'] ?? [];
          promotionClubNames =
              clubPromotions.map<String>((club) => club['clubName'] ?? '').toList();
        });
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

  final List<String> clubActivityImages = [
    'assets/main_post1.jpg',
    'assets/main_post2.jpg',
    'assets/main_post3.jpg',
    'assets/main_post4.jpg'
  ];

  int _currentIndex = 0; // 현재 슬라이드 인덱스

  bool _showSidebar = false;

  @override
  Widget build(BuildContext context) {
    final displayClubs = _showAllClubs ? myClubs : myClubs.take(2).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // 뒤로가기 막기: 아무것도 하지 않음
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: const Text(
            'mo.meet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
            ),
          ],
        ),
        drawer: BuildSideMenu(),
        body: RefreshIndicator(
          onRefresh: _handleRefresh, // 아래에서 정의됨
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    univName,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                        items: (imageUrls.isNotEmpty
                            ? imageUrls
                            : ['assets/main_nullpost.png'])
                            .map((url) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageUrls.isNotEmpty
                                ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.error));
                              },
                            )
                                : Image.asset(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),

                      if (imageUrls.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(imageUrls.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                    ],
                  ),

                  SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        '내 동아리',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      displayClubs.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            '현재 가입한 동아리가 없습니다',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                          : Column(
                        children: displayClubs.map<Widget>((club) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      clubMainPage(clubId: club['clubId']),
                                ),
                              );
                            },
                            child: Container(
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            club['category'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
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

                  SizedBox(height: 2),

                  Text(
                    '동아리 활동',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(clubActivityImages.length, (index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
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
        ),

      ),
    );
  }
}
