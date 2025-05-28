import 'package:flutter/material.dart';

class VotePage extends StatefulWidget {
  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  int? expandedIndex;
  bool isApproved = true;

  // ✅ 정산 항목 리스트와 선택 상태
  final List<String> voteOptions = [
    "너가 행복하길 바랬는데",
    "정작 니가 행복해지니까",
    "기억이란 사랑보다 더 아픈 거라서",
  ];
  int? selectedOptionIndex;

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                '불모지대',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isApproved) ...[
                SizedBox(width: 4),
                Icon(Icons.verified, color: Colors.green, size: 20),
              ],
              SizedBox(width: 12),
            ],
          )
        ],
        title: const Text(
          "투표",
          style: TextStyle(
              fontFamily: 'jamsil',
              fontSize: 25,
              fontWeight: FontWeight.w200,
              color: Colors.black54),
        ),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final isExpanded = expandedIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '개강파티 인원 조사',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          isExpanded ? '마감' : '진행중',
                          style: TextStyle(
                            color: isExpanded ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down),
                          onPressed: () => toggleExpanded(index),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isExpanded) const SizedBox(height: 10),
                if (isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          '안녕하세요? 전장혁? 맞나? 입니다?\n위치는 아리랑\n시간은 02:00\n\n투표 해주세요\n정산할거예요\n익명은 아닙니다\n'),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('~ 2025.03.13 18:00'),
                            ),
                            const SizedBox(height: 10),

                            // ✅ 선택 가능한 정산 항목 리스트
                            Column(
                              children:
                              List.generate(voteOptions.length, (i) {
                                final isSelected = selectedOptionIndex == i;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOptionIndex = i;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green[200]
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(voteOptions[i]),
                                        Row(
                                          children: [
                                            Icon(Icons.person),
                                            const SizedBox(width: 4),
                                            Text("${20 + i * 10}"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[200],
                                ),
                                onPressed: () {
                                  if (selectedOptionIndex != null) {
                                    // 예시: 선택된 항목 처리
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "선택된 항목: ${voteOptions[selectedOptionIndex!]}"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("정산 하기"),
                              ),
                            ),
                            const Center(
                              child: Text("정산 리스트에 넣을 항목을 선택해주세요",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
