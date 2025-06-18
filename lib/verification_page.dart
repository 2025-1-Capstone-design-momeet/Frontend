import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:momeet/member_registration_page.dart';
import 'http_service.dart';

class VerificationPage extends StatefulWidget {
  final String? userId;
  const VerificationPage({super.key, required this.userId});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _schoolEmailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool isCodeWrong = false;

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("알림"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
        if (label.isNotEmpty)
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

  Future<void> sendEmail() async {
    final userId = widget.userId;
    final email = "${_schoolEmailController.text.trim()}@kumoh.ac.kr";

    final requestBody = {
      "email": email,
      "code": "",
      "userId": userId,
    };

    try {
      final response = await HttpService().postRequest("univ/match", requestBody);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == "true" && data['data'] == true) {
          _showToast("이메일 전송 완료!");
        } else {
          _showToast(data['message']);
        }
      }
    } catch (e) {
      _showDialog("이메일 전송 실패: $e");
    }
  }

  Future<void> verifyCode() async {
    final userId = widget.userId;
    final email = "${_schoolEmailController.text.trim()}@kumoh.ac.kr";
    final code = _codeController.text.trim();

    final requestBody = {
      "email": email,
      "code": code,
      "userId": userId,
    };

    try {
      final response = await HttpService().postRequest("univ/match", requestBody);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == "true") {
          _showToast(data['message']);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MemberRegistrationPage(userId: widget.userId)),
          );

        } else {
          setState(() {
            isCodeWrong = true;
          });
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldLeave = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("입력값 삭제됨"),
                content: const Text("뒤로가기를 하면 입력하신 정보가 모두 사라질 수 있습니다.\n그래도 나가시겠습니까?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("취소"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("나가기"),
                  ),
                ],
              );
            },
          );

          if (shouldLeave == true) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        appBar: AppBar(
          title: const Text('학교 인증'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldLeave = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("입력 정보 삭제 경고"),
                    content: const Text("뒤로가기를 하면 입력하신 정보가 모두 사라질 수 있습니다.\n그래도 나가시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("취소"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("나가기"),
                      ),
                    ],
                  );
                },
              );

              if (shouldLeave == true) {
                Navigator.of(context).pop();
              }
            },
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
                    const Text(
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
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _schoolEmailController,
                                  decoration: const InputDecoration(
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
                              const Text(
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF69B870)),
                      child: const Text(
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
                    const Text(
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
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          '코드가 올바르지 않습니다.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.04),
                    ElevatedButton(
                      onPressed: verifyCode,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF69B870)),
                      child: const Text(
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
      ),
    );
  }
}
