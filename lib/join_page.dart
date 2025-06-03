import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momeet/login_page.dart';
import 'package:momeet/verification_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'http_service.dart';

class joinPage extends StatefulWidget {
  const joinPage({super.key});

  @override
  _joinPageState createState() => _joinPageState();
}

class _joinPageState extends State<joinPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool gender = false; // false = 여자, true = 남자

  @override
  void initState() {
    super.initState();
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

  Future<void> register() async {
    final userId = _userIdController.text.trim();
    final pw = _pwController.text.trim();
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    final requestBody = {
      "userId": userId,
      "pw": pw,
      "phoneNum": phone,
      "name": name,
      "email": email,
      "gender": gender
    };

    try {
      final response =
      await HttpService().postRequest('user/register', requestBody);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == "true") {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('회원가입 성공!'),
                content: const Text('회원가입에 성공하셨습니다.'),
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

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerificationPage(userId: userId,)),
          );
        } else {
          _showDialog("회원가입 실패", "회원가입에 실패하였습니다. 잠시후 다시 시도해 주십시오.");
        }
      } else if (response.statusCode == 409) {
        _showDialog("존재하는 회원", "이미 등록된 사용자입니다.");
      } else {
        _showDialog('서버 오류', "서버와의 통신 중 오류가 발생했습니다.");
      }
    } catch (e) {
      print(e);
      _showDialog('네트워크 오류', "네트워크 연결이 원활하지 않습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * 0.04),
              _buildTextField('아이디', '아이디 입력', _userIdController),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('비밀번호', '비밀번호 입력', _pwController, obscure: true),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('전화번호', '010xxxxnnnn', _phoneController),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('이름', '홍길동', _nameController),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField('이메일', 'example@example.com', _emailController),
              SizedBox(height: screenHeight * 0.02),
              _buildGenderSelector(),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.6 > 250 ? screenWidth * 0.6 : 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF69B36D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
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

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '성별',
          style: TextStyle(
            fontFamily: 'freesentation',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ToggleButtons(
            isSelected: [gender == true, gender == false],
            onPressed: (int index) {
              setState(() {
                gender = index == 0; // 0이면 남자(true), 1이면 여자(false)
              });
            },
            borderRadius: BorderRadius.circular(10),
            fillColor: const Color(0xFF69B36D),
            selectedColor: Colors.white,
            color: Colors.black,
            textStyle: const TextStyle(
              fontFamily: 'freesentation',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('남자'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('여자'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
