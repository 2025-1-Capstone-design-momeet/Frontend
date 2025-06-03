import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:momeet/user_provider.dart';

import 'main_page.dart';

class CreateClubPage extends StatefulWidget {
  final String univName;

  const CreateClubPage({Key? key, required this.univName}) : super(key: key);

  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  String? name;
  String? major;
  String? studentId;
  int? grade;


  String? _userId;
  String? _clubName;
  String? _category;



  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();


  final List<String> _categories = [
    '레저 분야',
    '사회·종교· 분야',
    '체육활동 분야',
    '학술 분야',
    '문화예술 분야',
  ];

  @override
  void initState() {
    super.initState();

    // Post-frame callback을 사용하여 context 안전하게 접근
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        _userId = user.userId ?? "";
        name = user.name ?? "";
        major = user.department ?? "";
        studentId = user.userId ?? "";
        grade = user.grade ?? 0;

      });

      if (_userId == null || _userId!.isEmpty) {
        print("⚠️ 사용자 ID가 없습니다.");
      }
      print('⭐⭐${widget.univName}');
    });
  }

  Future<bool> postToServer() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/create");

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubName": _clubName ?? "",
      "managerId": _userId ?? "",
      "category": _categoryController.text ?? "",
      "univName": widget.univName ?? "",
    });

    print('🌟 요청 바디: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print("✅ 동아리 생성 성공: $decodedBody");

        final Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {  // ← 여기!
          final data = jsonResponse['data'];
          print("🎉 서버에서 받은 데이터: $data");
          return true;
        } else {
          print("❌ 서버 응답 실패: ${jsonResponse['message']}");
          return false;
        }
      } else {
        print("❌ HTTP 오류: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🚨 요청 중 에러 발생: $e");
      return false;
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


              _buildTextInputSection("동아리명", _clubNameController, "동아리명을 입력하세요"),
              SizedBox(height: 16),
              _buildDropdownSection("카테고리", _categories),

              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("신청", Colors.green),
                ],
              ),
              SizedBox(height: 50),
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

  Widget _buildDropdownSection(String title, List<String> options) {
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
        DropdownButtonFormField<String>(
          value: _category,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _category = newValue;
              _categoryController.text = newValue ?? '';
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }


  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _clubName = _clubNameController.text.trim();
          _category = _categoryController.text.trim();
        });

        postToServer();

        // 동아리 생성 완료 메시지 보여주기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('동아리 생성 완료!'),
            // duration: Duration(seconds: ),
          ),
        );

        // 2초 후 메인 페이지로 이동
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        });
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
