import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/settlement_president_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';


class SettlementInfoPage extends StatefulWidget {
  final String title;
  final String date;
  final int amount;
  final String payId;


  const SettlementInfoPage({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.payId,
  });

  @override
  State<SettlementInfoPage> createState() => _SettlementInfoPageState();
}

class _SettlementInfoPageState extends State<SettlementInfoPage> {
  String? userId;
  List<Map<String, dynamic>> users = [];
  bool isApproved = true;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";
    getInfo();
  }

  Future<void> check(String userId, bool hasPaid) async {
    final checkData = {
      "payId": widget.payId,
      "userId": userId,
      "hasPaid": hasPaid,
    };

    try {
      final response = await HttpService().postRequest("pay/check", checkData);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("전송 결과: ${data["message"]}");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "네트워크 오류가 발생했습니다.");
      print("Error: $e");
    }
  }

  Future<void> getInfo() async {
    final infoData = {
      "payId": widget.payId,
      "userId": "gam1017",
      "name": null,
      "hasPaid": null,
    };

    try {
      final response = await HttpService().postRequest("pay/getPaymentStatesByPayId", infoData);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final info = data['data'];
        if (info is List) {
          setState(() {
            users = info.map<Map<String, dynamic>>((user) {
              return {
                "name": user["name"],
                "paid": user["hasPaid"],
                "userId": user["userId"], // ✅ userId 포함
              };
            }).toList();
          });
        }
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              for (var user in users) {
                await check(user["userId"], user["paid"]);
              }
              _showDialog("완료", "정산 상태가 성공적으로 전송되었습니다.");

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettlementPresidentPage(clubId: "7163f660e44a4a398b28e4653fe35507")),
              );
            },
            child: const Text('확인'),
          ),
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
                    '정산 현황',
                    style: TextStyle(
                      fontFamily: 'jamsil',
                      fontWeight: FontWeight.w200,
                      fontSize: 24,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'C.O.K',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
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
            const Divider(color: Colors.black26, thickness: 0.7),
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
