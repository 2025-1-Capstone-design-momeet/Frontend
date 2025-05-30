import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:momeet/board_page.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';




import 'Post.dart';
import 'fillrow.dart';
import 'meeting_page.dart';

void main() {
  runApp(const MaterialApp(home: ViewPostPage()));
}

class ViewPostPage extends StatefulWidget {
  const ViewPostPage({super.key});


  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  bool showScript = false; // 스크립트 박스 표시 여부
  String _postNum = "6a9578c2015a4a85b85b94064b987465";
  String? _title;
  String? _content;
  DateTime? _date;
  File? _file;
  String? fileName;
  String? downloadUrl;


  @override
  void initState() {
    super.initState();
    getPost();
  }

  void downloadFile(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("❌ URL 열기 실패");
    }
  }


  Future<Post?> fetchPostById(String postNum) async {
    final url = Uri.parse("http://momeet.meowning.kr/api/post/get");

    // final headers = {
    //   'Content-Type': 'application/json',
    // };

    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)', // 혹은 필요한 경우 토큰 등 추가
      // 'Authorization': 'Bearer YOUR_TOKEN_HERE',  // 인증 필요시 추가
    };

    final body = jsonEncode({
      "postNum": postNum,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);

        print("✅ 게시물 조회 성공: ${decodedBody}");
        final Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse['success'] == "true") {
          final data = jsonResponse['data'];
          return Post.fromJson(data);
        } else {
          print("❌ 서버 응답 실패: ${jsonResponse['message']}");
          return null;
        }
      } else {
        print("❌ HTTP 오류: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🚨 요청 중 에러 발생: $e");
      return null;
    }
  }



  void getPost() async {
    final post = await fetchPostById("6a9578c2015a4a85b85b94064b987465");
    if (post != null) {
      setState(() {
        _title = post.title;
        _content = post.content;
        _date = post.date;
        if (_file != null) {
          _file = post.file as File?;
          fileName =  p.basename(_file!.path);
          downloadUrl = _file!.path;
        }

      });
    }
  }

  void handleFileDownload(BuildContext context) {
    if (downloadUrl != null) {
      launchUrl(Uri.parse(downloadUrl!), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ 다운로드 URL이 없습니다")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(

        children: [
          // 상단 고정 헤더 (기존 코드 유지)
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
                              MaterialPageRoute(builder: (context) => BoardPage()),
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
                const Text(
                  '게시글',
                  style: TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),

          // 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 회의록 제목 (중앙 정렬)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: Text(
                      _title ?? '제목 없음',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // 날짜
                  Center(
                    child: Text(
                      '${_date?.year}.${_date?.month.toString().padLeft(2, '0')}.${_date?.day.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // AI 요약 결과 카드
                  Center(
                    child: SizedBox(
                      width: 350, // 원하는 고정 너비 (픽셀 단위)
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFFAEDFB1), // 테두리 색상 #69B36D
                            width: 1.5, // 테두리 두께
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                _content ?? '내용이 없습니다.',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _file != null
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        width: 3,
                        height: 20,
                        color: const Color(0xFF68B26C),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.attach_file, size: 24, color: Colors.grey),
                      GestureDetector(
                        onTap: () => handleFileDownload(context),
                        child: Text(
                          fileName ?? '파일 없음',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9E9E9E),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                      : const SizedBox.shrink(), // 파일이 없으면 아무것도 안 보이도록


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
