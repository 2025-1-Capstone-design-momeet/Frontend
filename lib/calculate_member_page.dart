import 'package:flutter/material.dart';

class calculateMembersPage extends StatefulWidget {
  const calculateMembersPage({super.key});

  @override
  _CalculateMembersPageState createState() => _CalculateMembersPageState();
}

class _CalculateMembersPageState extends State<calculateMembersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 임시 예제 데이터
  List<String> selectedMembers = ['김철수', '박영희'];
  List<String> unselectedMembers = ['이민수', '최지우', '장도연'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _toggleMember(String name, bool isSelectedTab) {
    setState(() {
      if (isSelectedTab) {
        selectedMembers.remove(name);
        unselectedMembers.add(name);
      } else {
        unselectedMembers.remove(name);
        selectedMembers.add(name);
      }
    });
  }

  Widget _buildMemberList(List<String> members, bool isSelectedTab) {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final name = members[index];
        return ListTile(
          title: Text(name),
          trailing: Icon(
            isSelectedTab ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelectedTab ? Colors.green : Colors.grey,
          ),
          onTap: () => _toggleMember(name, isSelectedTab),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인원 선택'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '선택'),
            Tab(text: '미선택'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMemberList(selectedMembers, true),
          _buildMemberList(unselectedMembers, false),
        ],
      ),
    );
  }
}
