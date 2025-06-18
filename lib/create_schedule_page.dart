import 'package:flutter/material.dart';
import 'package:momeet/calendar_page.dart';
import 'dart:convert';

import 'package:momeet/http_service.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';

import 'clubMain_page.dart';
import 'club_provider.dart';

class CreateSchedulePage extends StatefulWidget {
  final DateTime selectedDate;

  const CreateSchedulePage({super.key, required this.selectedDate});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  bool isPrivate = true;
  final titleController = TextEditingController();
  final detailController = TextEditingController();

  bool _isLoading = false;
  late String clubId;
  late String clubName;
  late bool official;
  String? userId;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";

    final club = Provider.of<ClubProvider>(context, listen: false);
    clubId = club.clubId ?? "";
    clubName = club.clubName ?? "";
    official = club.official ?? false;
  }

  Future<void> _submitSchedule() async {
    final date = widget.selectedDate;
    final dateString = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final timeString = "23:59:00"; // 고정된 시간, 필요하면 입력 받거나 변경 가능

    final title = titleController.text.trim();
    final content = detailController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('일정명을 입력해주세요.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      "clubId": clubId,
      "date": dateString,
      "time": timeString,
      "title": title,
      "content": content
    };

    try {
      final response = await HttpService().postRequest("calendar", data);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == 'true') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage())
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final year = widget.selectedDate.year;
    final month = widget.selectedDate.month;
    final day = widget.selectedDate.day;
    final weekday = ['일', '월', '화', '수', '목', '금', '토'][widget.selectedDate.weekday % 7];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                clubName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (official) ...[
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(40), // 높이 조절 가능
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '일정 생성',
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
              Divider(color: Colors.black26, thickness: 0.7),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      '${year}년',
                      style: const TextStyle(color: Colors.pinkAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${month}월 ${day}일',
                      style: const TextStyle(color: Colors.green, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Text(
                        weekday,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '일정명',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: detailController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '일정 상세 정보',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitSchedule,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("일정 등록", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
