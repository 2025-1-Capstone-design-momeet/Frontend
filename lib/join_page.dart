import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'http_service.dart';

class joinPage extends StatefulWidget {
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

    print("$requestBody");

    try {
      final response = await HttpService().postRequest('user/register', requestBody);

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == "true") {
          _showDialog('성공!');

        }
      } else if (response.statusCode == 409) {
        _showDialog('이미 존재하는 사용자 ID 입니다');
      }
    } catch (e) {
      _showDialog('요청 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text('회원가입'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Text(
                  '회원가입',
                  style: TextStyle(
                    fontFamily: 'freesentation',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '성별',
                      style: TextStyle(
                        fontFamily: 'freesentation',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: gender,
                          onChanged: (bool? value) {
                            setState(() {
                              gender = value ?? false;
                            });
                          },
                        ),
                        Text('남자', style: TextStyle(fontFamily: 'freesentation')),
                        SizedBox(width: 20),
                        Radio<bool>(
                          value: false,
                          groupValue: gender,
                          onChanged: (bool? value) {
                            setState(() {
                              gender = value ?? false;
                            });
                          },
                        ),
                        Text('여자', style: TextStyle(fontFamily: 'freesentation')),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.6 > 250 ? screenWidth * 0.6 : 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF69B36D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
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
      ),
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
}
