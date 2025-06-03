import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'approvalRequest_page.dart';


class WaitingListPage extends StatefulWidget {
  final String clubId;
  const WaitingListPage({Key? key, required this.clubId}) : super(key: key);

  @override
  WaitingListPageState createState() => WaitingListPageState();
}

class WaitingListPageState extends State<WaitingListPage> {
  List<Map<String, dynamic>> userList = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
    });
    final lists = await fetchPosts();
    setState(() {
      userList = lists;
      isLoading = false;
    });
  }


  Future<List<Map<String, dynamic>>> fetchPosts({String? clubId}) async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/application/list");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',  // User-Agent 추가

    };

    final body = jsonEncode({
      "clubId": widget.clubId ?? "7163f660e44a4a398b28e4653fe35507",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {
          final List<dynamic> data = jsonResponse['data'];
          print("✅✅ 가입 요청 리스트 fetchPosts: ${data}");
          return data.cast<Map<String, dynamic>>();
        } else {
          print("❌ 서버 실패 fetchPosts: ${jsonResponse['message']}");
        }
      } else {
        print("❌ HTTP 오류 fetchPosts: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 에러 발생 fetchPosts: $e");
    }

    return [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 40),
            const Text(
              '가입 요청 리스트',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        itemCount: userList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: SizedBox(
              width: 48,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: Colors.green.shade400,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              user['userName'] ?? '이름 없음',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user['department'] ?? '학과 없음',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovalRequestPage(
                    clubId: widget.clubId,
                    userName: user['userName']?? '',
                    department: user['department']?? '',
                    userId: user['userId']?? '',
                    grade: user['grade']?? '',
                    studentNum: user['studentNum']?? '',
                    why: user['why']?? '',
                    what: user['what']?? '',

                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
