import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'http_service.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _schoolEmailController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool isCodeWrong = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _userIdController.text = user.userId ?? "";
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("알림"),
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

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'freesentation',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'freesentation',
              fontWeight: FontWeight.w400,
              color: Color(0xFF818585),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Color(0xFFF0F0F0),
          ),
        ),
      ],
    );
  }

  Future<void> sendEmail() async {
    final userId = _userIdController.text.trim();
    final email = "${_schoolEmailController.text.trim()}@kumoh.ac.kr"; // 👈 이메일 조합

    final requestBody = {
      "email": email,
      "code": "",
      "userId": userId,
    };

    print("$requestBody");

    try {
      final response = await HttpService().postRequest("univ/match", requestBody);

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == "true" && data['data'] == true) {
          _showToast("이메일 전송 완료!");
        } else {
          _showToast(data['message']);
        }
      }
    } catch (e) {
      print('요청 실패: $e');
      _showDialog("이메일 전송 실패: $e");
    }
  }

  Future<void> verifyCode() async {
    final userId = _userIdController.text.trim();
    final email = "${_schoolEmailController.text.trim()}@kumoh.ac.kr"; // 👈 이메일 조합
    final code = _codeController.text.trim();

    final requestBody = {
      "email": email,
      "code": code,
      "userId": userId,
    };

    try {
      final response = await HttpService().postRequest("univ/match", requestBody);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == "true") {
          _showToast(data['message']);
        } else {
          isCodeWrong = true;
          _showToast(data['message']);
        }
      }
    } catch (e) {
      _showDialog("인증 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text('학교 인증'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    '인증할 학교 이메일을 입력해주세요',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _schoolEmailController,
                              decoration: InputDecoration(
                                hintText: "ex) 123abc",
                                hintStyle: TextStyle(
                                  fontFamily: 'freesentation',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF818585),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text(
                            "@kumoh.ac.kr",
                            style: TextStyle(
                              fontFamily: 'freesentation',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    onPressed: sendEmail,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF69B870)),
                    child: Text(
                      '인증번호 보내기',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'freesentation',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(height: screenHeight * 0.1),

                  Text(
                    '메일에 전송된 코드를 입력해주세요',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  _buildTextField('', '', _codeController),

                  if (isCodeWrong)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '코드가 올바르지 않습니다.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    onPressed: verifyCode,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF69B870)),
                    child: Text(
                      '인증',
                      style: TextStyle(
                        fontFamily: 'freesentation',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
