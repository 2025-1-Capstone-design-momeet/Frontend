import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettlementInfoPage extends StatefulWidget {
  final String title;
  final String date;
  final int amount;
  final int current;
  final int total;

  const SettlementInfoPage({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.current,
    required this.total,
  });

  @override
  State<SettlementInfoPage> createState() => _SettlementInfoPageState();
}

class _SettlementInfoPageState extends State<SettlementInfoPage> {
  List<Map<String, dynamic>> users = [
    {'name': '강채희', 'paid': true},
    {'name': '송채빈', 'paid': false},
    {'name': '임나경', 'paid': true},
    {'name': '허겸', 'paid': false},
    {'name': '강채희', 'paid': false},
    {'name': '송채빈', 'paid': false},
  ];

  bool isApproved = true;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => TextButton(
            onPressed: () { },
            child: const Text(
            '취소'
          ),
          )
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
                onPressed: () {},
                child: const Text(
                    '확인',
                ),
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    '정산',
                    style: TextStyle(
                      fontFamily: 'jamsil',
                      fontWeight: FontWeight.w200,
                      fontSize: 24,
                      color: Colors.black54,
                    ),
                  )
                ),
                Row(
                  children: [
                    const Text(
                        'C.O.K',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    if (isApproved) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.green, size: 20),
                    ],
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.black26,
              thickness: 0.7
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF2E1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 왼쪽: 제목 + 날짜
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.date,
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),

                  // 오른쪽: 금액
                  Center(
                    child: Text(
                      '${currencyFormat.format(widget.amount)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5FB574),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 16, color: Colors.transparent),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Row(
                    children: [
                      Container(
                        width: 4,
                        height: 36,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.account_circle,
                          size: 36, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user['name'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Checkbox(
                        value: user['paid'],
                        onChanged: (value) {
                          setState(() {
                            users[index]['paid'] = value;
                          });
                        },
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
