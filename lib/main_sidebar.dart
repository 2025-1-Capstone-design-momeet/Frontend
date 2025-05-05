import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SideMenuPage(),
    );
  }
}

class SideMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // Drawer 위젯을 사이드바로 설정
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 중앙 제목과 이미지, 이름, 학과 정보
            Text(
              '4학년',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '강채희',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 8),
                Icon(Icons.female, size: 18),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '금오공과대학교',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              '소프트웨어전공',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              '20220031',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 32),

            // 내 동아리 / 소모임
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '내 동아리 / 소모임',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                // 버튼들을 가로로 꽉 차게 만들기 위해 Expanded 사용
                Row(
                  children: [
                    Expanded(child: MenuButton(title: '불모지대')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: MenuButton(title: '하모니')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: MenuButton(title: '불멸의 용사들')),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('더보기'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1),

            // 동아리 섹션
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '동아리',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Text('모집 공고'),
                  SizedBox(height: 4),
                  Text('동아리 활동'),
                  SizedBox(height: 4),
                  Text('창설 하기'),
                ],
              ),
            ),

            // 소모임 섹션
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '소모임',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Text('모집 공고'),
                  SizedBox(height: 4),
                  Text('동아리 활동'),
                  SizedBox(height: 4),
                  Text('창설 하기'),
                ],
              ),
            ),

            // 기타 섹션
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '기타',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('문의 하기'),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomDrawer 클래스를 생성하여 사이드바를 구현
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 사이드바 헤더 (프로필 이미지와 이름)
          UserAccountsDrawerHeader(
            accountName: Text('강채희'),
            accountEmail: Text('20220031@kumoh.ac.kr'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: Text('내 동아리 / 소모임'),
            onTap: () {},
          ),
          ListTile(
            title: Text('동아리'),
            onTap: () {},
          ),
          ListTile(
            title: Text('소모임'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('기타'),
            onTap: () {},
          ),
          ListTile(
            title: Text('설정'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;

  MenuButton({required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(title),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
        backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
      ),
    );
  }
}
