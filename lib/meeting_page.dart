import 'package:flutter/material.dart';
import 'package:momeet/meeting_detail_page.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _memos = [
    {'date': '2025.03.15', 'content': '개강파티 일정과 장소 잡기 및 다음 회의 안건'},
    {'date': '2025.03.19', 'content': '연습 일정과 재정 관리'},
    {'date': '2025.03.30', 'content': '총동아리에 제출 할 자료 정리'},
    {'date': '2025.04.01', 'content': '신입 부원 홍보 아이디어 공유'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final filteredMemos = _memos.where((memo) {
      final content = memo['content']!.toLowerCase();
      return content.contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 고정 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
              color: Colors.white,
              child: Column(
                children: [
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
                                MaterialPageRoute(builder: (context) => MeetingDetailPage()),
                              );
                              // Navigator.pop(context);
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
                    '회의장',
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
              color: Color(0xFFE0E0E0), // 조금 더 연한 회색
            ),

            // 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),

                    // 회의 + 녹음중
                    Row(
                      children: [
                        const Text(
                          '회의',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF27070),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.fiber_manual_record, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('녹음중', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 버튼 2개
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              backgroundColor: const Color(0xFFFBFBFB),
                              elevation: 2,
                              shadowColor: Colors.grey.withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.file_upload, color: Color(0xFF9F9F9F)),
                                SizedBox(width: 8),
                                Text(
                                  '파일 업로드',
                                  style: TextStyle(color: Color(0xFF9F9F9F)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            side: const BorderSide(color: Color(0xFF68B26C)),
                            backgroundColor: Colors.white,
                          ),
                          label: const Text('요약', style: TextStyle(color: Color(0xFF68B26C))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 검색창
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: '회의록 검색',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF69B36D), // ← 여기가 핵심!
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      '회의록',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 16),

                    // 회의 카드
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredMemos.length,
                      itemBuilder: (context, index) {
                        final memo = filteredMemos[index];
                        return _buildMemoCard(
                            memo['date']!, memo['content']!, screenSize.width > 600);
                      },
                    ),
                    const SizedBox(height: 10),

                    // 더보기
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF929292), // 텍스트 및 아이콘 색상
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('더보기'),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Color(0xFF929292)),
                          ],
                        ),
                      ),
                    )



                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoCard(String date, String content, bool isLargeScreen) {
    return Card(
      color: Colors.white, // ← 배경색을 흰색으로 명시
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: isLargeScreen ? 20 : 16,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
