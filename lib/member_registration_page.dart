import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/login_page.dart';

class MemberRegistrationPage extends StatefulWidget {
  final String? userId;

  const MemberRegistrationPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MemberRegistrationPage> createState() => _MemberRegistrationPageState();
}

class _MemberRegistrationPageState extends State<MemberRegistrationPage> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  Future<void> regist() async {
    final data = {
      "userId": widget.userId,
      "department": departmentController.text.trim(),
      "studentNum": studentIdController.text.trim(),
      "grade": yearController.text.trim()
    };

    try {
      final response = await HttpService().postRequest("user/updateSchoolInfo", data);

      print(data);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == 'true') {
          print("성공티비");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const loginPage()),
          );
        }
      }
    } catch (e) {
      _showDialog("네트워크 오류.", "네트워크 오류가 발생했습니다.");
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
                Navigator.of(context).pop(); // 다이얼로그 닫기
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '회원 정보 등록',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'freesentation',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('학과 정보', '예: 컴퓨터공학과', departmentController),
                  const SizedBox(height: 20),
                  _buildTextField('학번', '예: 2025xxxxxx', studentIdController),
                  const SizedBox(height: 20),
                  _buildTextField('학년', '예: 3', yearController),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        regist();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF69B578),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '등록',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'freesentation',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'freesentation',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: (label == '학년' || label == '학번')
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: (label == '학년' || label == '학번')
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'freesentation',
              fontWeight: FontWeight.w400,
              color: Color(0xFF818585),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
          ),
        ),
      ],
    );
  }
}
