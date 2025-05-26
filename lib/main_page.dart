import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen; // 사이드바 열기/닫기 상태 토글
            });
          },
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
            ],
          ),
        ),
      ),
    );
  }
}