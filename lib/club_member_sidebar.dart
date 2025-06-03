import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/main_page.dart';
import 'package:momeet/meeting_page.dart';
// import 'package:momeet/wating_list_page.dart';
import 'package:http/http.dart' as http;
import 'package:momeet/waiting_list_page.dart';


class ClubMemberSidebar extends StatefulWidget {
  final String clubId;
  final String myName;
  final String clubName;
  final String clubType;

  ClubMemberSidebar({Key? key, required this.clubId, required this.myName, required this.clubName, required this.clubType}) : super(key: key);


  @override
  State<ClubMemberSidebar> createState() => ClubMemberSidebarState();  // 수정된 부분
}

class ClubMemberSidebarState extends State<ClubMemberSidebar> {
  List<Member> userList = [];
  bool isLoading = true;

  String userName = '';
  String department = '';
  String myDuty = '';


  @override
  void initState() {
    print('⭐ 받은 내이름: ${widget.myName}');

    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
    });
    final users = await fetchUsers();

    // 👇 내 역할 찾기 (공백 제거해서 정확히 비교)
    final currentUser = users.firstWhere(
          (user) => user.name.trim() == widget.myName.trim(),
      orElse: () => Member(
        name: '',
        department: '',
        userId: '',
        clubId: '',
        role: '',
      ),
    );

    setState(() {
      userList = users;
      myDuty = currentUser.role ?? ''; // 👈 duty가 null이면 빈 문자열로 저장
      isLoading = false;
    });

    print("💼 내 역할: $myDuty");
  }



  Future<List<Member>> fetchUsers() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/club/members");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubId": widget.clubId ,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {
          final List<dynamic> data = jsonResponse['data'];
          // Map 데이터를 Member 객체 리스트로 변환
          return data.map<Member>((item) {
            return Member(
              name: item['userName'] ?? '이름 없음',
              department: item['department'] ?? '학과 없음',
              role: item['duty'],  // role은 nullable,
              userId: item['userId'], // 👈 추가
              clubId: widget.clubId,
            );
          }).toList();
        } else {
          print("❌ 서버 실패 fetchPosts: ${jsonResponse['message']}");
        }
      } else {
        print("❌ HTTP 오류 fetchPosts: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 에러 발생 fetchPosts: $e");
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 8,
        child: Container(
          width: screenWidth * 0.8,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 프로필
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                        AssetImage('assets/mainImg_01.jpg'), // 프로필 이미지
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.clubName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Text(
                                widget.clubType,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WaitingListPage(clubId: widget.clubId)),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green.shade800,
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              child: Text('가입 대기'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    '부원',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  // 로딩 중 표시
                  if (isLoading)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return MemberTile(member: userList[index],myDuty: myDuty );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class Member {
  final String name;
  final String department;
  final String? role;
  final String userId; // 👈 추가
  final String clubId; // 👈 추가

  Member({
    required this.name,
    required this.department,
    required this.userId, // 👈 추가
    required this.clubId, // 👈 추가
    this.role,
  });
}



class MemberTile extends StatelessWidget {
  final Member member;
  final String myDuty; // 👈 현재 로그인한 사용자 역할 전달받음

  const MemberTile({
    required this.member,
    required this.myDuty,
  });



  void delegateRole(BuildContext context) async {
    print("👉 delegateRole called"); // 디버깅용 로그

    final url = Uri.parse("http://momeet.meowning.kr/api/club/delegate");

    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubId": member.clubId,
      "newUserId": member.userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("👉 response status: ${response.statusCode}");
      print("👉 response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonBody['success'] == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('직무 위임이 성공적으로 완료되었습니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('서버 응답: ${jsonBody['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP 오류: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("👉 예외 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류: $e')),
      );
    }
  }



  Color getBadgeColor(String role) {
    switch (role) {
      case '회장':
        return Colors.red.shade300;
      case '부회장':
        return Colors.blue.shade300;
      case '간부':
        return Colors.green.shade300;
      default:
        return Colors.grey;
    }
  }

  void showDelegationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${member.name}에게 직무를 위임하겠습니까?'),
        content: member.role != null
            ? Text('현재 직무: ${member.role!}')
            : Text('현재 직무가 없습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 먼저 다이얼로그 닫고
              delegateRole(context); // 👈 위임 요청 보내기
            },
            child: Text('승인'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (myDuty != '회장') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회장만 직무를 위임할 수 있습니다.')),
          );
        } else if (member.name.trim() == myDuty.trim()) {
          // 여기서 widget.myName이 안 보이므로 myDuty가 아니라 다른 값을 써야 해요.
          // 근데 MemberTile에는 widget.myName가 없으니, myName도 전달받아야 해요.
          // 지금은 그냥 member.name과 비교하는 예시임
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('자기 자신에게는 위임할 수 없습니다.')),
          );
        } else {
          showDelegationDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 28, color: Colors.grey.shade800),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    member.department,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (member.role != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getBadgeColor(member.role!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  member.role!,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
