import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/create_settlement_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'http_service.dart';

class CalculateMembersPage extends StatefulWidget {
  final String voteID;
  final String voteContentId;

  const CalculateMembersPage({
    super.key,
    required this.voteID,
    required this.voteContentId,
  });

  @override
  _CalculateMembersPageState createState() => _CalculateMembersPageState();
}

class _CalculateMembersPageState extends State<CalculateMembersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userId;

  List<Map<String, dynamic>> selectedMembers = [];
  List<Map<String, dynamic>> unselectedMembers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";

    members(); // API 호출
  }

  void _toggleMember(Map<String, dynamic> member, bool isSelectedTab) {
    setState(() {
      if (isSelectedTab) {
        selectedMembers.remove(member);
        unselectedMembers.add(member);
      } else {
        unselectedMembers.remove(member);
        selectedMembers.add(member);
      }
    });
  }

  Future<void> members() async {
    final data = {
      "userId": userId,
      "voteID": widget.voteID,
      "voteContentId": widget.voteContentId,
      "voteNum": null,
    };

    try {
      final response = await HttpService().postRequest("pay/payMembers", data);

      if (response.statusCode == 200) {
        final res = jsonDecode(utf8.decode(response.bodyBytes));
        final checkMembers = res['data']['checkMembers'] as List;
        final unCheckMembers = res['data']['unCheckMembers'] as List;

        setState(() {
          selectedMembers = checkMembers.cast<Map<String, dynamic>>();
          unselectedMembers = unCheckMembers.cast<Map<String, dynamic>>();
        });
      } else {
        _showDialog("에러", "서버에서 데이터를 불러오지 못했습니다.");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "네트워크 오류가 발생했습니다.");
      print("Error: $e");
    }
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
                Navigator.of(context).pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMemberList(List<Map<String, dynamic>> members, bool isSelectedTab) {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final name = member['name'] ?? '이름 없음';
        return ListTile(
          title: Text(name),
          trailing: Icon(
            isSelectedTab ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelectedTab ? Colors.green : Colors.grey,
          ),
          onTap: () => _toggleMember(member, isSelectedTab),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateSettlementPage(
                  selectedMembers: selectedMembers,
                  voteID: widget.voteID,
                ),
              ),
            );
          }, child: Text("다음"))
        ],
        title: const Text(
          "mo.meet",
          style: TextStyle(
            fontFamily: '런드리고딕',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              '인원 선택',
              style: TextStyle(
                fontFamily: 'jamsil',
                fontWeight: FontWeight.w200,
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '선택'),
              Tab(text: '미선택'),
            ],
          ),
          Expanded(  // <-- 여기를 추가하세요
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMemberList(selectedMembers, true),
                _buildMemberList(unselectedMembers, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
