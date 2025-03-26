import 'package:flutter/material.dart';

class joinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '회원가입',
                style: TextStyle(
                  fontFamily: 'freesentation',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 50),

              // 아이디 입력 필드 (한 줄로 배치)
              Row(
                children: [
                  SizedBox(
                    width: 60, // 텍스트 너비 고정
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '아이디',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'freesentation',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '아이디 입력',
                        hintStyle: TextStyle(
                          fontFamily: 'freesentation',
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // 비밀번호 입력 필드 (한 줄로 배치)
              Row(
                children: [
                  SizedBox(
                    width: 60, // 텍스트 너비 고정
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '비밀번호',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'freesentation',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호 입력',
                        hintStyle: TextStyle(
                          fontFamily: 'freesentation',
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF69B36D), // 녹색 버튼
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
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
              SizedBox(height: 20),

              // 회원가입 안내 문구
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '아직 회원이 아니신가요?',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontFamily: 'freesentation',
                        color: Color(0xFF69B36D), // 초록색 텍스트
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
