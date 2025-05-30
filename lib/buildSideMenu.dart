import 'package:flutter/material.dart';

class buildSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFFFFF),
      width: 300,
      child: ListView(

        padding: EdgeInsets.zero,
        children: [
          // 상단 사용자 정보
          Container(

            height: 250, // 원하는 높이로 조절
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),

                Text("4학년", style: TextStyle(fontSize: 14, color: Colors.grey)),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[400],
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    Text("강채희", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Color(0xFF585858))),
                    Icon(Icons.female, color: Colors.pink, size: 18),
                  ],
                ),
                Text(
                  "금오공과대학교 ✔",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text("소프트웨어전공",
                    style: TextStyle(color: Color(0xFF7C7C7C))),
                Text("20220031",
                style: TextStyle(color: Color(0xFF7C7C7C))),
              ],
            ),
          ),


          // 내 동아리 / 소모임
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("내 동아리 : 소모임", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // 버튼 클릭 시 실행할 코드
                      print('달리고 버튼 클릭됨');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            // spreadRadius: -1,
                            blurRadius: 1,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "달리고",
                        style: TextStyle(fontSize: 16, color: Color(0xFF636363)),
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 8),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // 버튼 클릭 시 실행할 코드
                      print('달리고 버튼 클릭됨');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            // spreadRadius: -1,
                            blurRadius: 1,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "불모지대",
                        style: TextStyle(fontSize: 16, color: Color(0xFF636363)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Container(
                width: 300 * 0.8, // Drawer 너비 300 기준 80% (240px)
                child: Divider(thickness: 1),
              ),
            ),
          ),

          // 메뉴 목록
          buildSectionTitle("동아리"),
          buildMenuItem("모집 공고"),
          buildMenuItem("동아리 활동"),
          buildMenuItem("창설하기"),

          buildSectionTitle("소모임"),
          buildMenuItem("모집 공고"),
          buildMenuItem("소모임 활동"),
          buildMenuItem("창설하기"),

          buildSectionTitle("기타"),
          buildMenuItem("문의하기"),
          SizedBox(height: 50)
        ],

      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          decoration: TextDecoration.underline, // 밑줄 추가
          decorationThickness: 2, // 밑줄 두께 조절
          decorationColor: Color(0xFF69B36D), // 밑줄 색
        ),
      ),
    );
  }



  Widget buildMenuItem(String title) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 30, right: 16),
      visualDensity: VisualDensity(vertical: -2, horizontal: 0),// 왼쪽 padding 줄임
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF636363),
          fontWeight:  FontWeight.w500,
          wordSpacing: -1, // 기본값인 0으로 글자 간격 조절 (기본보다 넓으면 0보다 큰 값)
        ),
      ),
      onTap: () {
        // TODO: Handle navigation
      },
    );
  }



}
