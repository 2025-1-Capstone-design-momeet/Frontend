import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';


import 'board_page.dart';

class MeetingDetailPage extends StatefulWidget {
  final String clubId; // 전달받은 clubId 저장

  const MeetingDetailPage({Key? key, required this.clubId}) : super(key: key);

  @override
  MeetingDetailPageState createState() => MeetingDetailPageState();
}

class MeetingDetailPageState extends State<MeetingDetailPage> {
  String? _userId;
  List<String> imageUrls = [];
  bool showScript = false;
  bool _showAllClubs = false;

  // 서버 데이터 저장 변수들
  String minuteId = 'c2938668e97c425ba9794f8a7733ae28';
  String date = '';
  String title = '';
  String summary = '';
  List<Map<String, dynamic>> scriptList = [];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    fetchMainPageData();
  }

  Future<void> fetchMainPageData() async {
    final url = Uri.parse('http://momeet.meowning.kr/api/minute/detail');
    final body = jsonEncode({"minuteId": minuteId});

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
          final dateList = List<int>.from(data['date'] ?? []);
          if (dateList.length >= 3) {
            date = '${dateList[0]}년 ${dateList[1]}월 ${dateList[2]}일';
          }
          title = data['title'] ?? '';
          summary = data['summary'] ?? '';

          scriptList = List<Map<String, dynamic>>.from(data['script'] ?? []);
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
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
                        // IconButton(
                        //   icon: const Icon(Icons.arrow_back),
                          // onPressed: () {
                          //   Navigator.push(
                          //     context,
                          //     // MaterialPageRoute(builder: (context) => BoardPage()),
                          //   );
                          // },
                        // ),
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
                    const Row(
                      children: [
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
                  '회의록',
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
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  // 날짜
              Center(
                child: Text(date, style: TextStyle(color: Colors.grey)),
              ),

              const SizedBox(height: 16),

                  // AI 요약 결과 카드
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFF69B36D), // 테두리 색상 #69B36D
                        width: 1.5, // 테두리 두께 (원하는 대로 조절 가능)
                      ),
                    ),
                    // elevation: 0,
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Row(
                            children: [
                              Icon(Icons.smart_toy, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('AI 요약 결과', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(summary, style: TextStyle(color: Color(0xFF393939)),),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 스크립트 보기 / 접기 버튼
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          showScript = !showScript;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 버튼 크기 텍스트+아이콘만큼만
                        children: [
                          Text(
                            showScript ? '스크립트 접기' : '스크립트 보기',
                            style: const TextStyle(color: Color(0xFF929292)),
                          ),
                          Icon(
                            showScript ? Icons.chevron_left : Icons.chevron_right,
                            color: const Color(0xFF929292),
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 12),

                  // 스크립트 박스 (보이기 여부에 따라)
                  if (showScript)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            '회의 스크립트',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            scriptList.map((script) => '${script["speaker"]} ${script["text"]}').join('\n'),
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // 하단 안내 문구
                  const Center(
                    child: Text(
                      '회의록 요약 결과는 참고용으로만 활용 가능합니다.\n회의 당사자 스크립트와 함께 확인해주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
