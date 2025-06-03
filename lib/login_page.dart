import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/join_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 로그인 상태 확인
    Future.delayed(Duration.zero, () {
      final userProvider = context.read<UserProvider>();
      if (userProvider.userId != null && userProvider.pw != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  MainPage()),
        );
      }
    });
  }

  Future<void> login() async {
    final userId = _userIdController.text.trim();
    final pw = _pwController.text.trim();

    if (userId.isEmpty|| pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '아이디와 비밀번호를 입력하세요.'),
          ));
      return;
    }

    final loginData = {
      "userId": userId,
      "pw": pw
    };

    try {
      final response = await HttpService().postRequest("user/login", loginData);

      print("LoginData: $loginData");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);

        if(data['success'] == 'true') {
          final userData = data['data'];

          context.read<UserProvider>().setUser(
              userId,
              pw,
              name: userData['name'],
              univName: userData['univName'],
              schoolCertification: userData['schoolCertification'],
              department: userData['department'],
              grade: int.tryParse(userData['grade'].toString())
          );

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  MainPage())
          );
        } else {
          _showDialog('오류', '회원 정보 조회 서버 오류가 발생했습니다.');
        }
      } else {
        _showDialog('오류', '아이디와 비밀번호를 확인해주세요.');
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // 로그인 텍스트 위쪽 공간 추가

              const Text(
                '로그인',
                style: TextStyle(
                  fontFamily: 'freesentation',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // 아이디 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildTextField('아이디', '아이디를 입력하세요', _userIdController),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 비밀번호 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('비밀번호', '비밀번호를 입력하세요', _pwController),
                ],
              ),
              const Spacer(flex: 3), // 로그인 버튼을 좀 더 아래로 내리기 위한 공간 추가

              SizedBox(
                width: screenWidth * 0.6 > 250 ? screenWidth * 0.6 : 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF69B36D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '아직 회원이 아니신가요?',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const joinPage()),
                      );
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        fontFamily: 'freesentation',
                        color: Color(0xFF69B36D),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2), // 아래쪽 공간 추가
            ],
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
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'freesentation',
              fontWeight: FontWeight.w400,
              color: Color(0xFF818585),
            ),
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
