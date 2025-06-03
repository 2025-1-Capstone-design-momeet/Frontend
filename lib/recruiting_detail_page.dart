import 'package:flutter/material.dart';
import 'package:momeet/request_club_page.dart';

class RecruitingDetailPage extends StatefulWidget {
  final String clubId;

  const RecruitingDetailPage({Key? key, required this.clubId}) : super(key: key);

  @override
  RecruitingDetailPageState createState() => RecruitingDetailPageState();
}

class RecruitingDetailPageState extends State<RecruitingDetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'mo.meet',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 30 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 150),
                    const Center(
                      child: Text(
                        '모집 상세 정보',
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),

          // 스크롤 가능한 본문 내용
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔷 학교명 + 동아리명
                  const Text(
                    '금오공과대학교',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '불모지대',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔷 동아리 정보 카드
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('분류', '예술'),
                        _infoRow('대상', '전체 학과\n신입생, 재학생, 복학생, 휴학생, 졸업생'),
                        _infoRow('회비', '있음'),
                        _infoRow('면접', '없음'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔷 지원하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RequestClubPage()),
                          );
                        },
                        child: const Text(
                          '지원하기',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔷 모집 안내 텍스트
                  const Text(
                    '금오공대 유일무이 연극동아리!\n🔥불모지대🔥에서 39기 신입부원을 모집합니다!!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔷 모집 포스터 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://i.imgur.com/LZ6vRAA.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔷 설명 문단
                  const Text(
                    '안녕하세요! 금오공대 연극동아리 \'불모지대\'에서 39기 신입 부원을 모집합니다!\n'
                        '신입생, 재학생, 휴학생 누구나 연극에 관심이 있다면 들어올 수 있습니다 :)',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
