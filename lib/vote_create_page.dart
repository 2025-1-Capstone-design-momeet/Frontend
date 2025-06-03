import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/user_provider.dart';
import 'package:momeet/vote_page.dart';
import 'package:provider/provider.dart';

class CreateVotePage extends StatefulWidget {
  final dynamic clubId;

  const CreateVotePage({super.key, required this.clubId});

  @override
  State<CreateVotePage> createState() => _CreateVotePageState();
}

class _CreateVotePageState extends State<CreateVotePage> {
  String? userId;


  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(
        context, listen: false); // listen: false로 값을 가져옴
    userId = user.userId ?? "";
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool isApproved = true;
  bool anonymousVote = false;
  DateTime? selectedDate;

  Future<void> _submitVote() async {
    if (_titleController.text.trim().isEmpty) {
      _showLimitDialog("투표 제목을 입력해주세요.");
      return;
    }

    if (selectedDate == null) {
      _showLimitDialog("종료일을 선택해주세요.");
      return;
    }

    final List<Map<String, dynamic>> voteContents = [];
    for (int i = 0; i < _optionControllers.length; i++) {
      String text = _optionControllers[i].text.trim();
      if (text.isNotEmpty) {
        voteContents.add({
          "field": text,
          "voteNum": i + 1,
        });
      }
    }

    if (voteContents.length < 2) {
      _showLimitDialog("항목은 최소 2개 이상이어야 합니다.");
      return;
    }

    final Map<String, dynamic> voteData = {
      "userId": "gam1017",
      "clubId": widget.clubId,
      "endDate": "${selectedDate!.toIso8601String().split('T')[0]}T23:59:00",
      "title": _titleController.text.trim(),
      "content": _contentController.text.trim(),
      "anonymous": anonymousVote,
      "voteContents": voteContents,
    };

    try {
      final response = await HttpService().postRequest("vote/write", voteData);

      print("$voteData");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == "true") {
          _showLimitDialog("투표가 성공적으로 생성되었습니다.");
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VotePage(clubId: widget.clubId)),
          );
        } else {
          _showLimitDialog("투표 생성 실패: ${result['message']}");
        }
      } else {
        _showLimitDialog("서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      _showLimitDialog(e.toString());
    }
  }


  void _addOption() {
    if (_optionControllers.length >= 5) {
      _showLimitDialog("항목은 최대 5개까지 추가할 수 있습니다.");
      return;
    }
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= 2) {
      _showLimitDialog("항목은 최소 2개 이상이어야 합니다.");
      return;
    }
    setState(() {
      _optionControllers.removeAt(index);
    });
  }

  void _showLimitDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("알림"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VotePage(clubId: widget.clubId)),
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              const Text(
                '불모지대',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isApproved) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.green, size: 20),
              ],
              const SizedBox(width: 12),
            ],
          )
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      '투표 생성',
                      style: TextStyle(
                        fontFamily: 'jamsil',
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black26, thickness: 0.7),
            Padding(
              padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: '투표 제목을 입력해주세요',
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: '투표 설명을 입력해주세요',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          DateTime now = DateTime.now();
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? now,
                            firstDate: now,
                            lastDate: DateTime(now.year + 5),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "종료일: " +
                                (selectedDate != null
                                    ? "${selectedDate!.year}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.day.toString().padLeft(2, '0')}"
                                    : "투표 종료 날짜 선택"),
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._optionControllers.asMap().entries.map((entry) {
                        int index = entry.key;
                        TextEditingController controller = entry.value;
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: "항목 ${index + 1}",
                                    filled: true,
                                    fillColor: const Color(0xFFEFEFEF),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _removeOption(index),
                              icon: const Icon(Icons.close),
                            )
                          ],
                        );
                      }).toList(),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[400]),
                        onPressed: _addOption,
                        child: const Text("+ 항목 추가",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: anonymousVote,
                            onChanged: (val) =>
                                setState(() => anonymousVote = val ?? false),
                          ),
                          const Text("익명 투표"),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitVote,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("투표 등록", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
            )

        ]
        ),
      ),
    );
  }
}
