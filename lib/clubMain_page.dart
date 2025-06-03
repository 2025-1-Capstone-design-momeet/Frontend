import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/settlement_info_page.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/user_provider.dart';
import 'package:momeet/write_promotion_post_page.dart';
import 'package:provider/provider.dart';

import 'board_page.dart';
import 'buildSideMenu.dart';
import 'club_member_sidebar.dart';
import 'package:momeet/calendar_page.dart';
import 'package:momeet/vote_page.dart';
import 'meeting_page.dart';

class clubMainPage extends StatefulWidget {
  final String clubId;

  const clubMainPage({Key? key, required this.clubId}) : super(key: key);

  @override
  clubMainPageState createState() => clubMainPageState();
}

class Member {
  final String name;
  final String department;
  final String? role;
  final String userId; // 👈 추가
  final String clubId; // 👈 추가

  Member({
    required this.name,
    required this.department,
    required this.userId, // 👈 추가
    required this.clubId, // 👈 추가
    this.role,
  });
}

class clubMainPageState extends State<clubMainPage> {
  String _userId = '';  // 응답에 없으니 초기화만 해둠
  String _userName = '';  // 응답에 없으니 초기화만 해둠
  String _clubName = '';
  String _univName = '';
  String _category = '';
  String _memberCount = '';
  String _bannerImage = '';
  String _welcomeMessage = '';
  bool _official = false;

  bool isLoading = true;
  List<Map<String, dynamic>> postList = [];

  String _myDuty = ''; // ✅ 나의 직무 저장



  Future<bool> postToServer() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/create");

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubId": widget.clubId,
    });

    print('🌟 요청 바디: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print("✅ 동아리 생성 성공: $decodedBody");

        final Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {  // ← 여기!
          final data = jsonResponse['data'];
          print("🎉 서버에서 받은 데이터: $data");
          return true;
        } else {
          print("❌ 서버 응답 실패: ${jsonResponse['message']}");
          return false;
        }
      } else {
        print("❌ HTTP 오류: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🚨 요청 중 에러 발생: $e");
      return false;
    }
  }



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
    _userName = user.name ?? "";

    _loadPosts();

    if (_userId.isNotEmpty) {
      fetchMainPageData();
      fetchUsers().then((users) {
        findMyDutyFromUsers(users);
      });
    } else {
      print("⚠️ 사용자 ID가 없습니다.");
    }
  }


  Future<List<Member>> fetchUsers() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/members");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubId": widget.clubId ,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {
          final List<dynamic> data = jsonResponse['data'];
          // Map 데이터를 Member 객체 리스트로 변환
          return data.map<Member>((item) {
            return Member(
              name: item['userName'] ?? '이름 없음',
              department: item['department'] ?? '학과 없음',
              role: item['duty'],  // role은 nullable,
              userId: item['userId'], // 👈 추가
              clubId: widget.clubId,
            );
          }).toList();
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

  void findMyDutyFromUsers(List<Member> users) {
    try {
      final currentUser = users.firstWhere(
            (user) => user.userId.trim() == _userId.trim(),
      );

      setState(() {
        _myDuty = currentUser.role?.trim() ?? '';
      });

      print('🎯 내 역할: $_myDuty');
    } catch (e) {
      print('⚠️ 현재 사용자 ($_userId)의 역할을 찾을 수 없습니다.');
      setState(() {
        _myDuty = '';
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _univName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF69B36D),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_myDuty == '회장') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WritePromotionPostPage(clubId: widget.clubId),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('⚠️ 모집 게시글 작성은 회장만 가능합니다.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8BCF8E), // 버튼 배경색
                            foregroundColor: Colors.white, // 글자색
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          child: Text('모집 게시글 작성'),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
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
                        SizedBox(width: 15),
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

                SizedBox(height: 16),

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

                SizedBox(height: 16),

                // 상태 메시지
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_welcomeMessage, style: TextStyle(fontSize: 16)),
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

                SizedBox(height: 16),

                // 게시판
                Text('게시판',
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
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => VotePage(clubId: widget.clubId)),
                      // );
                    }),
                    _buildBottomButton(Icons.assignment, '회의', () {
                      if (_myDuty == '회장') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MeetingPage(clubId: widget.clubId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ 회의 기능은 회장만 사용할 수 있습니다.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
          ClubMemberSidebar(clubId: widget.clubId, myName: _userName),
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
