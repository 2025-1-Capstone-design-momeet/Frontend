import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

class SettlementPersonalPage extends StatefulWidget {
  final String clubId;
  const SettlementPersonalPage({Key? key, required this.clubId}) : super(key: key);

  @override
  State<SettlementPersonalPage> createState() => _SettlementPersonalPageState();
}

class _SettlementPersonalPageState extends State<SettlementPersonalPage> {
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);

  String? userId;

  Map<String, dynamic>? membershipFee;
  List<Map<String, dynamic>> unpaidItems = [];
  List<Map<String, dynamic>> paidItems = [];

  bool showMoreUnpaid = false;
  bool showMorePaid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false);
      userId = user.userId ?? "";
      _fetchAll();
    });
  }

  Future<void> _fetchAll() async {
    await Future.wait([
      getMembership(),
      getSettle(),
    ]);
  }

  Future<void> getMembership() async {
    final data = {
      "userId": userId,
      "clubId": widget.clubId
    };

    try {
      final response = await HttpService().postRequest("membershipFee/getPaymentList", data);

      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        final body = jsonDecode(bodyString);

        if (body['success'] == "true") {
          final fee = body['data'];  // 리스트 아님!
          setState(() {
            membershipFee = {
              'title': fee['title'] ?? '가입비',
              'date': fee['payDate'] ?? '',  // payDate가 없으면 '' 처리
              'amount': fee['amount'] ?? 0,
              'complete': fee['complete'] ?? false
            };
          });
        } else {
          _showDialog("오류", body['message'] ?? "가입비 데이터를 불러오지 못했습니다.");
        }
      }
    } catch (e) {
      _showDialog("네트워크 오류", "가입비 조회 중 오류 발생");
    }
  }

  Future<void> getSettle() async {
    final data = {
      "userId": userId,
      "clubId": widget.clubId
    };

    try {
      final response = await HttpService().postRequest("pay/getPaymentList", data);

      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        final body = jsonDecode(bodyString);

        if (body['success'] == "true") {
          final data = body['data'];

          setState(() {
            paidItems = (data['completePay'] as List<dynamic>).map<Map<String, dynamic>>((item) {
              return {
                'title': item['title'] ?? '',
                'date': item['payDate'] ?? '',
                'amount': item['amount'] ?? 0,
              };
            }).toList();

            unpaidItems = (data['uncompletePay'] as List<dynamic>).map<Map<String, dynamic>>((item) {
              return {
                'title': item['title'] ?? '',
                'date': '',
                'amount': item['amount'] ?? 0,
              };
            }).toList();
          });
        } else {
          _showDialog("오류", body['message'] ?? "정산 데이터 오류");
        }
      } else {
        _showDialog("서버 오류", "정산 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "정산 데이터 조회 중 오류 발생");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("확인"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(String title, String date, int amount, bool isPaid) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFFDFF2E1) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: isPaid ? [] : [BoxShadow(color: Colors.grey.shade300, offset: Offset(0, 2), blurRadius: 5)],
      ),
      child: Row(
        children: [
          if (isPaid) const Icon(Icons.check, color: Colors.green),
          if (isPaid) const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                if (date.isNotEmpty)
                  Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(color: Color(0xFF36B368), fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
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
        ...displayItems.map((item) =>
            _buildItemCard(item['title'], item['date'], item['amount'], isPaid)),
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
        title: const Text('정산 현황', style: TextStyle(color: Colors.black)),
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
            membershipFee != null
                ? _buildItemCard(
              membershipFee!['title'],
              membershipFee!['date'],
              membershipFee!['amount'],
                membershipFee!['complete'] ?? false
            )
                : const Text("가입비 정보 없음", style: TextStyle(color: Colors.grey)),

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
