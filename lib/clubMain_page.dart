import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/settlement_info_page.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/settlement_personal_page.dart';
import 'package:momeet/settlement_president_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'board_page.dart';
import 'buildSideMenu.dart';
import 'club_member_sidebar.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/vote_page.dart';
import 'club_provider.dart';
import 'http_service.dart';
import 'meeting_page.dart';

class clubMainPage extends StatefulWidget {
  final String clubId;

  const clubMainPage({Key? key, required this.clubId}) : super(key: key);

  @override
  clubMainPageState createState() => clubMainPageState();
}

class clubMainPageState extends State<clubMainPage> {
  String? _userId;  // 응답에 없으니 초기화만 해둠
  String _clubName = '';
  String _univName = '';
  String _category = '';
  String _memberCount = '';
  String _bannerImage = '';
  String _welcomeMessage = '';
  bool _official = false;

  bool isLoading = true;
  List<Map<String, dynamic>> postList = [];



  Future<void> fetchMainPageData() async {
    final url = Uri.parse('http://momeet.meowning.kr/api/club/main');
    final body = jsonEncode({"clubId": widget.clubId});
    print("🧾❗❗${widget.clubId}");

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
          _userId = '';  // 응답에 없으므로 빈값 유지
          _clubName = data['clubName'] ?? '';
          _univName = data['univName'] ?? '';
          _category = data['category'] ?? '';
          _memberCount = data['memberCount']?.toString() ?? '';
          _bannerImage = data['bannerImage'] ?? '';
          if (_bannerImage == 'null' || _bannerImage == null) {
            _bannerImage = ''; // null일 경우 빈 문자열 처리
          }
          _welcomeMessage = data['welcomeMessage'] ?? '';
          _official = data['official'] ?? false;
        });

        context.read<ClubProvider>().setClub(widget.clubId, _clubName, _official);

      } else {
        print('❌ 서버 오류: ${response.statusCode}');
        print('응답 내용: ${response.body}');
      }
    } catch (e) {
      print('❗ 예외 발생: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/post/getClubPostList");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',  // User-Agent 추가
      // 필요한 경우 Authorization 헤더도 추가
      // 'Authorization': 'Bearer your_access_token',
    };

    final body = jsonEncode({
      "clubId": widget.clubId ?? "7163f660e44a4a398b28e4653fe35507",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {
          final List<dynamic> data = jsonResponse['data'];
          return data.cast<Map<String, dynamic>>();
        } else {
          print("❌ 서버 실패 fetchPosts: ${jsonResponse['message']}");
        }
      } else {
        print("❌ HTTP 오류 fetchPosts: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 에러 발생 fetchPosts: $e");
    }

    return [];
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
    });
    final posts = await fetchPosts();
    setState(() {
      postList = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _userId = user.userId ?? "";

    print(user.userId);

    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    void _showDialog(String title, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text("확인"),
              ),
            ],
          );
        },
      );
    }

    Future<void> getPage(BuildContext context) async {
      final pageData = {
        "userId": _userId,
        "clubId": widget.clubId
      };

      print(pageData);

      try {
        final response = await HttpService().postRequest("pay/getManagementPaymentList", pageData);

        if (response.statusCode == 200) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettlementPresidentPage()),
          );
        }
      } catch (e) {
        try {
          final response2 = await HttpService().postRequest("pay/getPaymentList", pageData);

          if (response2.statusCode == 200) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettlementPersonalPage(clubId: widget.clubId)),
            );
          }
        } catch (e) {
          _showDialog("네트워크 오류.", "네트워크 오류가 발생했습니다.");
          print("Error: $e");
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
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
            fontFamily: '런드리고딕',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
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
                      _univName,
                      
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF69B36D)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _clubName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF69B36D),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(_category),
                            Checkbox(
                              value: _official,
                              onChanged: (bool? value) {
                                setState(() {
                                  _official = value ?? false;
                                });
                              },
                              activeColor: Color(0xFF69B36D), // 초록색으로 변경
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(_createSlideTransition());
                          },
                          icon: Icon(Icons.person, color: Colors.grey),
                          label: Text(
                            _memberCount,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // 메인 이미지
                Container(
                  width: double.infinity,
                  height: isLandscape ? 200 : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: _bannerImage.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(_bannerImage),
                      fit: BoxFit.cover,
                    )
                        : null,
                    color: _bannerImage.isEmpty ? Colors.grey.shade300 : null,
                  ),
                ),

                const SizedBox(height: 16),

                // 상태 메시지
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_welcomeMessage, style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 16),

                // 다가오는 일정
                const Text('다가오는 일정',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text('15', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('"김종욱 찾기" 연극 연습',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 게시판
                const Text('게시판',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardPage(clubId: widget.clubId),
                    ),
                  );
                },
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      postList.isNotEmpty
                          ? Text(postList[0]['title'] ?? '제목 없음')
                          : Text('게시글이 없습니다'),
                    ],
                  ),
                ),
              ),

                const SizedBox(height: 16),

                // 하단 네비게이션 버튼
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isLandscape ? 6 : 4,
                  children: [
                    _buildBottomButton(Icons.calendar_today, '캘린더', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CalendarPage(),
                        ),
                      );
                    }),
                    _buildBottomButton(Icons.calculate, '정산', () async {
                      await getPage(context);
                    }),
                    _buildBottomButton(Icons.check, '투표', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const VotePage()),
                      );
                    }),
                    _buildBottomButton(Icons.assignment, '회의', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MeetingPage()),
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
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (context, animation, secondaryAnimation) =>
          ClubMemberSidebar(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
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
          Icon(icon, size: 28, color: Colors.green),
          SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.green,
              )),
        ],
      ),
    );
  }
}
