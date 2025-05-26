import 'package:flutter/material.dart';
import 'package:momeet/board_page.dart';

import 'meeting_page.dart';

void main() {
  runApp(const MaterialApp(home: MeetingDetailPage()));
}

class MeetingDetailPage extends StatefulWidget {
  const MeetingDetailPage({super.key});

  @override
  State<MeetingDetailPage> createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<MeetingDetailPage> {
  bool showScript = false; // 스크립트 박스 표시 여부

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
                    child: const Text(
                      '개강파티 일정과 장소 잡기 및 다음 회의 안건',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  // 날짜
                  const Center(
                    child: Text('2025.03.05', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),

                  // AI 요약 결과 카드
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Color(0xFF69B36D), // 테두리 색상 #69B36D
                        width: 1.5, // 테두리 두께 (원하는 대로 조절 가능)
                      ),
                    ),
                    // elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.smart_toy, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('AI 요약 결과', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text('1. 개강파티 일정\n- 개강파티는 3월 13일로 결정됨.'),
                          SizedBox(height: 8),
                          Text('2. 개강파티 장소\n- 장소는 학교 앞 아리랑으로 정해짐.\n- 예약은 하민이 담당하기로 함.'),
                          SizedBox(height: 8),
                          Text('3. 동아리 박람회\n- 동아리 박람회 행사에 대한 공지가 필요함.\n- 포스터를 3월 7일까지 제작해야 함.\n- 포스터는 기혁쌤이 담당하기로 함.'),
                          SizedBox(height: 8),
                          Text('4. 신입생 환영회 공연 준비\n- 공연 연습을 3월 8일에 진행하기로 함.\n- 장소는 동방으로 정해짐.'),
                          SizedBox(height: 8),
                          Text('5. 다음 회의 안건\n- 다음 회의는 3월 12일로 정해짐.\n- 향후 계획 및 포스터 디자인 검토, 개강파티 준비 상황 점검을 다룰 예정임.'),
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
                            style: TextStyle(color: Color(0xFF929292)),
                          ),
                          Icon(
                            showScript ? Icons.chevron_left : Icons.chevron_right,
                            color: Color(0xFF929292),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                            '여기에 회의 스크립트 내용이 들어갑니다.\n'
                                '회의 참여자들이 나눈 대화 및 토론 내용 등을 자세히 기록합니다.\n'
                                '필요 시 줄바꿈과 문단 구분을 포함할 수 있습니다.',
                            style: TextStyle(color: Colors.black87),
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
