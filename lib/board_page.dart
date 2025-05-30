import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/write_post_page.dart';
import 'package:http/http.dart' as http;

import 'meeting_page.dart';

void main() {
  runApp(const MaterialApp(home: BoardPage()));
}

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showScript = false; // 스크립트 박스 표시 여부
  bool isLoading = true;



  List<Map<String, dynamic>> postList = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
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


  Future<List<Map<String, dynamic>>> fetchPosts({String? clubId}) async {
    final url = Uri.parse("http://momeet.meowning.kr/api/post/getClubPostList");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',  // User-Agent 추가
      // 필요한 경우 Authorization 헤더도 추가
      // 'Authorization': 'Bearer your_access_token',
    };

    final body = jsonEncode({
      "clubId": clubId ?? "7163f660e44a4a398b28e4653fe35507",
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




  // Future<void> fetchPostList(String clubId) async {
  //   final url = Uri.parse("http://momeet.meowning.kr/api/post/getClubPostList");
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'User-Agent': 'Mozilla/5.0 (Flutter App)',
  //   };
  //
  //   final body = jsonEncode({
  //     "clubId": "7163f660e44a4a398b28e4653fe35507",
  //   });
  //
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //
  //     if (response.statusCode == 200) {
  //       final decoded = utf8.decode(response.bodyBytes);
  //       final json = jsonDecode(decoded);
  //
  //       if (json["success"] == "true") {
  //         final List<dynamic> data = json["data"];
  //         print(body);
  //
  //         setState(() {
  //           postList = data.cast<Map<String, dynamic>>();
  //         });
  //       } else {
  //         print("❌ 서버 실패fetchPostList: ${json["message"]}");
  //       }
  //     } else {
  //       print("❌ HTTP 오류fetchPostList: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("🚨 오류 발생fetchPostList: $e");
  //   }
  // }






  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // 1. 고정 게시글 필터링
    final fixedPosts = postList.where((post) => post['fixation'] == 1).toList();

    // 2. 일반 게시글 필터링
    final normalPosts = postList.where((post) => post['fixation'] != 1).toList();

    // 3. 일반 게시글 날짜 최신순 정렬
    normalPosts.sort((a, b) {
      final aDate = a['date'] as List<dynamic>? ?? [];
      final bDate = b['date'] as List<dynamic>? ?? [];

      final aComparable = DateTime(
        aDate.length > 0 ? aDate[0] : 0,  // 년
        aDate.length > 1 ? aDate[1] : 1,  // 월
        aDate.length > 2 ? aDate[2] : 1,  // 일
      );
      final bComparable = DateTime(
        bDate.length > 0 ? bDate[0] : 0,
        bDate.length > 1 ? bDate[1] : 1,
        bDate.length > 2 ? bDate[2] : 1,
      );

      return bComparable.compareTo(aComparable); // 최신순 (내림차순)
    });

    // 4. 고정 게시글 + 정렬된 일반 게시글 합치기
    final sortedPosts = [...fixedPosts, ...normalPosts];

    // // 5. 게시글 리스트 뿌리기
    // return ListView.builder(
    //   itemCount: sortedPosts.length,
    //   itemBuilder: (context, index) {
    //     return _buildPostCard(sortedPosts[index]);
    //   },
    // );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: null,
      body: Column(
        children: [
          // 상단 고정 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WritePostPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 0),
                        Text(
                          'mo.meet',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 30 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'C.O.K',
                          style: TextStyle(fontSize: 18, color: Color(0xFF68B26C)),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check_box),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    SizedBox(width: 150),  // 왼쪽 공백 고정 (원하는 값으로 조절)
                    Center(
                      child: Text(
                        '게시판',
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()), // 오른쪽 공백은 유동적
                    OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        backgroundColor: const Color(0xFF8BCF8E),
                        side: BorderSide.none,
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white, size: 15),
                      label: const Text(
                        '게시글 작성',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          Container(height: 1, color: const Color(0xFFE0E0E0)),

          // 스크롤 영역
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedPosts.length + 2, // 게시글 수 + 상단 여백 + 마지막 글
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 12); // 상단 여백
                } else if (index == sortedPosts.length + 1) {
                  return const Center(
                    child: Text(
                      '마지막 글입니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                } else {
                  return _buildPostCard(sortedPosts[index - 1]);
                }
              },
            ),
          ),
          SizedBox(height: 50),


        ],
      ),
    );
  }
}


Widget _buildPostCard(Map<String, dynamic> post) {
  final date = post['date'] as List<dynamic>? ?? [];
  final year = date.length > 0 ? date[0] : 0;
  final month = date.length > 1 ? date[1] : 0;
  final day = date.length > 2 ? date[2] : 0;

  final isFixed = post['fixation'] == 1;

  return Card(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFF69B36D), width: 1.5),
    ),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 제목 + 날짜
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    if (isFixed)
                      const Icon(Icons.push_pin, size: 16, color: Colors.orange), // 고정 아이콘
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        post["title"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$year.$month.$day",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 본문
          Text(
            post["content"] ?? "",
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 12),

          // 하단 정보 (타입, 좋아요 등)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#${post["typeLabel"] ?? "기타"}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("${post["like"] ?? 0}"),
                ],
              ),
            ],
          ),
          SizedBox(height: 0),
        ],

      ),

    ),


  );
}

