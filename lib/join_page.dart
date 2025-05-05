import 'package:flutter/material.dart';

class joinPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 2),

              Text(
                '회원가입',
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
                  Text(
                    '아이디',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '아이디 입력?',
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
                    )
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 비밀번호 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '비밀번호',
                    style: TextStyle(
                      fontFamily: 'freesentation',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호 입력?',
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
                ],
              ),
              Spacer(flex: 3),

              SizedBox(
                width: screenWidth * 0.6 > 250 ? screenWidth * 0.6 : 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
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
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
