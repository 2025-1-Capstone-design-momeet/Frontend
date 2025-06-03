import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/user_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class RequestClubPage extends StatefulWidget {
  @override
  _RequestClubPageState createState() => _RequestClubPageState();
}

class _RequestClubPageState extends State<RequestClubPage> {
  String? name;
  String? major;
  String? studentId;
  int? grade;

  String? _userId;

  String? _why;
  String? _what;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context as BuildContext, listen: false);
      setState(() {
        _userId = user.userId ?? "";
        name = user.name ?? "";
        major = user.department ?? "";
        studentId = user.userId ?? "";
        grade = user.grade;
      });
    });
  }


  final TextEditingController _whyController = TextEditingController();
  final TextEditingController _whatController = TextEditingController();

  Future<void> postToServer() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/apply");

    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
      // 'Authorization': 'Bearer YOUR_TOKEN_HERE',  // 필요 시 추가
    };

    final body = jsonEncode({
      "userId": "meowning",
      "clubId": "7163f660e44a4a398b28e4653fe35507",
      "why": _why ?? "",
      "what": _what ?? "",
    });

    print('🌟🌟🌟body: ${body}');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print("✅ 동아리 신청 성공: $decodedBody");

        final Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          print("🎉 서버에서 받은 데이터: $data");
        } else {
          print("❌ 서버 응답 실패: ${jsonResponse['message']}");
        }
      } else {
        print("❌ HTTP 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 요청 중 에러 발생: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("가입 신청", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              CircleAvatar(radius: 50, backgroundColor: Colors.grey),
              SizedBox(height: 8),
              Text(grade as String, style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(name!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(major!, style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text(studentId!, style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 24),

              _buildTextInputSection("신청 사유", _whyController, "예: 활동에 참여하고 싶어요!"),
              SizedBox(height: 16),
              _buildTextInputSection("원하는 활동", _whatController, "예: 댄스, 노래 등"),

              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("신청", Colors.green),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputSection(String title, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, color: Colors.green),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _why = _whyController.text.trim();
          _what = _whatController.text.trim();
        });
        postToServer();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
