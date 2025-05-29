import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showScript = false; // 스크립트 박스 표시 여부

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => WritePostPage()),
                            // );
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
                Row(
                  children: [
                    const SizedBox(width: 150),  // 왼쪽 공백 고정 (원하는 값으로 조절)
                    const Center(
                      child: Text(
                        '게시판',
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()), // 오른쪽 공백은 유동적
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📌 공지사항 카드 (접기/펼치기 적용)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFF69B36D),
                        width: 1.5,
                      ),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제목 + 펼치기 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.push_pin, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text('불모지대 필독 공지사항',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showScript = !showScript;
                                  });
                                },
                                child: Text(
                                  showScript ? '접기 ▲' : '펼치기 ▼',
                                  style: const TextStyle(color: Color(0xFF69B36D)),
                                ),
                              ),
                            ],
                          ),

                          // 펼쳐졌을 때만 보이는 내용 + 작성자 정보
                          if (showScript) ...[
                            const SizedBox(height: 5),

                            const Text('1. 개강파티 일정\n- 개강파티는 3월 13일로 결정됨.'),

                            const SizedBox(height: 12),

                            // 작성자 및 좋아요 우측 하단 정렬
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '작성자: 홍길동 | 좋아요: 23',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 12),

                  // 안내 문구
                  const Center(
                    child: Text(
                      '마지막 글입니다.',
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
