import 'package:flutter/material.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // Drawer 위젯을 사이드바로 설정
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 중앙 제목과 이미지, 이름, 학과 정보
            const Text(
              '4학년',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
            const SizedBox(height: 16),
            const Row(
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
            const SizedBox(height: 8),
            const Text(
              '금오공과대학교',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              '소프트웨어전공',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '20220031',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // 내 동아리 / 소모임
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '내 동아리 / 소모임',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                // 버튼들을 가로로 꽉 차게 만들기 위해 Expanded 사용
                const Row(
                  children: [
                    Expanded(child: MenuButton(title: '불모지대')),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(child: MenuButton(title: '하모니')),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(child: MenuButton(title: '불멸의 용사들')),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Text('더보기'),
                ),
              ],
            ),
            const Divider(color: Colors.grey, thickness: 1),

            // 동아리 섹션
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '동아리',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
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
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '소모임',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
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
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '기타',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
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
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 사이드바 헤더 (프로필 이미지와 이름)
          const UserAccountsDrawerHeader(
            accountName: Text('강채희'),
            accountEmail: Text('20220031@kumoh.ac.kr'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
            ),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: const Text('내 동아리 / 소모임'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('동아리'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('소모임'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('기타'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('설정'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;

  const MenuButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        backgroundColor: WidgetStateProperty.all(Colors.grey.shade200),
      ),
      child: Text(title),
    );
  }
}
