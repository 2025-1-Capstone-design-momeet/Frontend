import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momeet/club_provider.dart';
import 'package:momeet/settlement_info_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'http_service.dart';
import 'membershipFee_info_page.dart';

class SettlementPresidentPage extends StatefulWidget {
  final String clubId;
  const SettlementPresidentPage({Key? key, required this.clubId}) : super(key: key);

  @override
  State<SettlementPresidentPage> createState() => _SettlementPresidentPageState();
}

class _SettlementPresidentPageState extends State<SettlementPresidentPage> {
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩', decimalDigits: 0);

  String? userId;
  String? clubId;
  String? clubName;

  // 서버에서 받아온 데이터를 저장할 리스트
  List<Map<String, dynamic>> unpaidItems = [];
  List<Map<String, dynamic>> paidItems = [];

  // 가입비 항목
  Map<String, dynamic>? membershipFee;

  bool showMoreUnpaid = false;
  bool showMorePaid = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";

    final club = Provider.of<ClubProvider>(context, listen: false);
    clubId = club.clubId ?? "";
    clubName = club.clubName ?? "";
    getMembership();
    getSettle();
  }

  Future<void> getMembership() async {
    final data = {
      "userId": "gam1017",
      "clubId": widget.clubId
    };

    try {
      final response = await HttpService().postRequest("membershipFee/getManagementPaymentList", data);

      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        final body = jsonDecode(bodyString);

        if (body['success'] == "true") {
          final feeData = body['data'];
          setState(() {
            membershipFee = {
              'title': '가입비',
              'date': feeData['createdAt']?.split('T')[0]?.replaceAll('-', '.') ?? '',
              'amount': feeData['amount'] ?? 0,
              'current': feeData['paidMemberCount'] ?? 0,
              'total': feeData['totalMemberCount'] ?? 0,
              'payId': feeData['payId'] ?? '',
            };
          });
        } else {
          _showDialog("오류", body['message'] ?? "가입비 정보를 불러오지 못했습니다.");
        }
      } else {
        _showDialog("오류", "서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "네트워크 오류가 발생했습니다.");
      print("Error: $e");
    }
  }

  Future<void> getSettle() async {
    final data = {
      "userId": "gam1017",
      "clubId": widget.clubId,
    };

    try {
      final response = await HttpService().postRequest("pay/getManagementPaymentList", data);

      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        final body = jsonDecode(bodyString);

        if (body['success'] == "true") {
          final payData = body['data'];

          List<dynamic> completePay = payData['completePay'] ?? [];
          List<dynamic> uncompletePay = payData['uncompletePay'] ?? [];

          setState(() {
            paidItems = completePay.map<Map<String, dynamic>>((item) {
              return {
                'title': item['title'] ?? '',
                'date': '',
                'amount': item['amount'] ?? 0,
                'current': 0,
                'total': 0,
                'payId': item['payId'] ?? '',
              };
            }).toList();

            unpaidItems = uncompletePay.map<Map<String, dynamic>>((item) {
              return {
                'title': item['title'] ?? '',
                'date': '',
                'amount': item['amount'] ?? 0,
                'current': 0,
                'total': 0,
                'payId': item['payId'] ?? '',
              };
            }).toList();
          });
        } else {
          _showDialog("오류", body['message'] ?? "정산 정보를 불러오지 못했습니다.");
        }
      } else {
        _showDialog("오류", "서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "네트워크 오류가 발생했습니다.");
      print("Error: $e");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemCard(String title, String date, int amount, int current, int total, String payId, {bool isPaid = false}) {
    return GestureDetector(
      onTap: () {
        if (title == '가입비') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MembershipfeeInfoPage (
                title: title,
                date: date,
                amount: amount,
                payId: payId,
              ), // 가입비 관련 페이지로 이동
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettlementInfoPage(
                title: title,
                date: date,
                amount: amount,
                payId: payId,
              ),
            ),
          );
        }
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
          item['payId'],
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
            if (membershipFee != null)
              _buildItemCard(
                membershipFee!['title'],
                membershipFee!['date'],
                membershipFee!['amount'],
                membershipFee!['current'],
                membershipFee!['total'],
                membershipFee!['payId'],
                isPaid: true,
              )
            else
              const Text("가입비 정보를 불러오는 중..."),
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
