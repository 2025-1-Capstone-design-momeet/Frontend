import 'package:flutter/material.dart';

class JoinRequestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WaitingListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WaitingListPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {"name": "강채희", "major": "소프트웨어전공"},
    {"name": "송채빈", "major": "소프트웨어전공"},
    {"name": "임나경", "major": "소프트웨어전공"},
    {"name": "허겸", "major": "소프트웨어전공"},
    {"name": "강채희", "major": "소프트웨어전공"},
    {"name": "송채빈", "major": "소프트웨어전공"},
    {"name": "임나경", "major": "소프트웨어전공"},
    {"name": "허겸", "major": "소프트웨어전공"},
    {"name": "강채희", "major": "소프트웨어전공"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 40),
            const Text(
              '가입 요청 리스트',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: SizedBox(
              width: 48,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: Colors.green.shade400,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              user['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user['major']!,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovalRequestPage(
                    name: user['name']!,
                    major: user['major']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ApprovalRequestPage extends StatelessWidget {
  final String name;
  final String major;

  const ApprovalRequestPage({super.key, required this.name, required this.major});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가입 승인 페이지'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          '이름: $name\n전공: $major',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
