import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/schedule_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'create_schedule_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isApproved = true;

  Map<DateTime, List<Schedule>> scheduleEvents = {};
  String clubId = "7163f660e44a4a398b28e4653fe35507";

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final fetched = await _fetchSchedules(clubId);
    setState(() {
      scheduleEvents = fetched;
    });
  }

  DateTime _normalizeDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  Future<Map<DateTime, List<Schedule>>> _fetchSchedules(String clubId) async {
    final calendarData = {
      "clubId": clubId
    };

    final response = await HttpService().postRequest("calendar/list", calendarData);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['success'] == 'true') {
        List data = jsonResponse['data'];
        Map<DateTime, List<Schedule>> eventMap = {};
        for (var item in data) {
          final schedule = Schedule.fromJson(item);
          final date = DateTime(schedule.dateTime.year, schedule.dateTime.month, schedule.dateTime.day);
          eventMap[date] = eventMap[date] ?? [];
          eventMap[date]!.add(schedule);
        }
        return eventMap;
      }
    }
    return {};
  }

  Future<bool> _deleteSchedule(String scheduleId) async {
    try {
      final response = await HttpService().postRequest('calendar/delete', {
        "scheduleId": scheduleId
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['success'] == 'true';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalizedSelectedDay = _selectedDay != null ? _normalizeDate(_selectedDay!) : null;
    final selectedDayEvents = normalizedSelectedDay != null
        ? scheduleEvents[normalizedSelectedDay] ?? []
        : [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Row(
            children: [
              const Text(
                '불모지대',
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              if (isApproved) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.green, size: 20),
              ],
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    '캘린더',
                    style: TextStyle(
                      fontFamily: 'jamsil',
                      fontWeight: FontWeight.w200,
                      fontSize: 24,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      if (_selectedDay != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateSchedulePage(selectedDate: _selectedDay!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('날짜를 먼저 선택해주세요!')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black26, thickness: 0.7),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          const SizedBox(height: 16),
          if (selectedDayEvents.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          '${normalizedSelectedDay!.month}월',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${normalizedSelectedDay.day}',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final firstEvent = selectedDayEvents[0];
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(firstEvent.title),
                            content: Text(firstEvent.content),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(), // 닫기
                                child: const Text('확인'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // 삭제 API 호출
                                  final success = await _deleteSchedule(firstEvent.scheduleId);
                                  if (success) {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    await _loadSchedules(); // 목록 갱신
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('일정이 삭제되었습니다.')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('삭제 실패. 다시 시도해주세요.')),
                                    );
                                  }
                                },
                                child: const Text('삭제', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        '“${selectedDayEvents[0].title}”',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (selectedDayEvents.length > 1)
            Expanded(
              child: ListView(
                children: selectedDayEvents.sublist(1).map(
                      (event) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(event.title),
                            content: Text(event.content),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(), // 닫기
                                child: const Text('확인'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // 삭제 API 호출
                                  final success = await _deleteSchedule(event.scheduleId);
                                  if (success) {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    await _loadSchedules(); // 목록 갱신
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('일정이 삭제되었습니다.')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('삭제 실패. 다시 시도해주세요.')),
                                    );
                                  }
                                },
                                child: const Text('삭제', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.sunny, color: Colors.green[800]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
          if (normalizedSelectedDay != null && selectedDayEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('선택된 날짜의 일정이 없습니다.'),
            ),
        ],
      ),
    );
  }
}
