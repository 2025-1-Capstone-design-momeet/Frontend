import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'http_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? userId;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";
    getAlarm();
  }

  Future<void> getAlarm() async {
    final data = {"userId": userId};

    try {
      final response = await HttpService().postRequest("alarm/getList", data);

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          notifications = List<Map<String, dynamic>>.from(responseData['data']);
        });
      } else {
        _showDialog("에러", "알림을 불러오지 못했습니다.");
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];

          String titleText = "";
          String content1 = "";
          String content2 = "";
          bool showPay = false;

          if (item['type'] == 0) {
            titleText = "정산되지 않은 내역이 있어요.";
            content1 = item['title'] ?? "";
            content2 = "정산을 완료해주세요.";
            showPay = true;
          } else {
            titleText = "알림";
            content1 = item['title'] ?? "";
            content2 = item['content']?.split('\n').first ?? "";
          }

          return GestureDetector(
            onTap: () {
              _showDialog(
                item['title'] ?? "알림",
                item['content'] ?? "",
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText,
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          content1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(content2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
