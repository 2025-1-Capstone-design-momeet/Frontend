import 'package:flutter/material.dart';

class votePage extends StatefulWidget {

  @override
  State<votePage> createState() => _VotePageState();
}

class _VotePageState extends State<votePage> {
  int? expandedIndex; // 어떤 항목이 열려 있는지 확인

  final List<bool> isClosedList = [true, true, true, true, true, true, true];

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null; // 다시 누르면 닫힘
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("투표")),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final isExpanded = expandedIndex == index;

          return GestureDetector(
            onTap: () => toggleExpanded(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '개강파티 인원 조사',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isExpanded ? '마감' : '진행중',
                        style: TextStyle(
                          color: isExpanded ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded) const SizedBox(height: 10),
                  if (isExpanded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('안녕하세요? 전장혁? 맞나? 입니다?\n위치는 아리랑\n시간은 02:00\n\n투표 해주세요\n정산할거예요\n익명은 아닙니다\n'),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('~ 2025.03.13 18:00'),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                color: Colors.green[200],
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("너가 행복하길 바랬는데"),
                                    Row(children: [Icon(Icons.person), SizedBox(width: 4), Text("20")]),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("정작 니가 행복해지니까"),
                                    Row(children: [Icon(Icons.person), SizedBox(width: 4), Text("33")]),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[200]),
                                  onPressed: () {},
                                  child: const Text("정산 하기"),
                                ),
                              ),
                              const Center(
                                child: Text("정산 리스트에 넣을 항목을 선택해주세요", style: TextStyle(fontSize: 12)),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
