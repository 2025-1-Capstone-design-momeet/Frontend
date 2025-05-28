import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momeet/settlement_info_page.dart';

class SettlementPresidentPage extends StatefulWidget {
  const SettlementPresidentPage({super.key});

  @override
  State<SettlementPresidentPage> createState() => _SettlementPresidentPageState();
}

class _SettlementPresidentPageState extends State<SettlementPresidentPage> {
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);

  final Map<String, dynamic> membershipFee = {
    'title': '가입비',
    'date': '2025.03.17',
    'amount': 5800,
    'current': 40,
    'total': 40,
  };

  final List<Map<String, dynamic>> unpaidItems = [
    {'title': '개강파티 - 2차', 'date': '2025.03.17', 'amount': 5800, 'current': 22, 'total': 40},
    {'title': '바이올린 회식', 'date': '2025.04.10', 'amount': 25000, 'current': 18, 'total': 40},
    {'title': '중간 회식', 'date': '2025.05.27', 'amount': 17550, 'current': 31, 'total': 40},
    {'title': '야유회', 'date': '2025.06.10', 'amount': 12000, 'current': 27, 'total': 40},
  ];

  final List<Map<String, dynamic>> paidItems = [
    {'title': '개강파티 - 2차', 'date': '2025.03.17', 'amount': 5800, 'current': 26, 'total': 40},
    {'title': '바이올린 회식', 'date': '2025.04.10', 'amount': 25000, 'current': 35, 'total': 40},
    {'title': '중간 회식', 'date': '2025.05.27', 'amount': 17550, 'current': 31, 'total': 40},
    {'title': '봄축제 회식', 'date': '2025.06.03', 'amount': 8800, 'current': 28, 'total': 40},
  ];

  bool showMoreUnpaid = false;
  bool showMorePaid = false;

  Widget _buildItemCard(String title, String date, int amount, int current, int total, {bool isPaid = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettlementInfoPage(
              title: title,
              date: date,
              amount: amount,
              current: current,
              total: total,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isPaid ? const Color(0xFFDFF2E1) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isPaid
              ? []
              : [BoxShadow(color: Colors.grey.shade300, offset: const Offset(0, 2), blurRadius: 5)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Icon(Icons.person, color: Colors.green),
                const SizedBox(height: 2),
                Text(
                  '$current/$total',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                currencyFormat.format(amount),
                style: const TextStyle(
                  color: Color(0xFF36B368),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items, bool isPaid, bool showMore, VoidCallback onToggle) {
    final displayItems = showMore ? items : items.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...displayItems.map((item) => _buildItemCard(
          item['title'],
          item['date'],
          item['amount'],
          item['current'],
          item['total'],
          isPaid: isPaid,
        )),
        if (items.length > 3)
          Center(
            child: TextButton(
              onPressed: onToggle,
              child: Text(showMore ? '접기 ▲' : '더보기 ▼'),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정산', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("가입비", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildItemCard(
              membershipFee['title'],
              membershipFee['date'],
              membershipFee['amount'],
              membershipFee['current'],
              membershipFee['total'],
              isPaid: true,
            ),
            _buildSection(
              "정산 - 미완료",
              unpaidItems,
              false,
              showMoreUnpaid,
                  () => setState(() => showMoreUnpaid = !showMoreUnpaid),
            ),
            _buildSection(
              "정산 - 완료",
              paidItems,
              true,
              showMorePaid,
                  () => setState(() => showMorePaid = !showMorePaid),
            ),
          ],
        ),
      ),
    );
  }
}
