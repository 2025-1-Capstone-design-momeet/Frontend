import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'create_schedule_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isApproved = true;

  DateTime _normalizeDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  final Map<DateTime, List<Map<String, String>>> events = {
    DateTime(2025, 3, 26): [
      {
        'title': '김종욱 찾기 연극 연습',
        'description': '저녁 6시에 대학로에서 연습',
      },
      {
        'title': '험냐뤼',
        'description': '이건 뭔진 모르지만 중요한 일정',
      },
    ],
    DateTime(2025, 3, 27): [
      {
        'title': 'MT 회의',
        'description': '모임 장소, 인원 논의',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final normalizedSelectedDay =
    _selectedDay != null ? _normalizeDate(_selectedDay!) : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Row(
            children: [
              Text(
                '불모지대',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isApproved) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 20,
                ),
              ],
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
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
                    icon: Icon(Icons.edit),
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
                          SnackBar(content: Text('날짜를 먼저 선택해주세요!')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black26,
            thickness: 0.7,
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
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
          SizedBox(height: 16),
          if (normalizedSelectedDay != null &&
              events.containsKey(normalizedSelectedDay))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 초록색 원형 날짜
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          '${normalizedSelectedDay.month}월',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${normalizedSelectedDay.day}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 일정 제목
                  // 일정 제목 (터치 가능하게 변경)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final firstEvent = events[normalizedSelectedDay]![0];
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(firstEvent['title']!),
                            content: Text(firstEvent['description']!),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('닫기'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        '“${events[normalizedSelectedDay]![0]['title']!}”',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.underline, // 누를 수 있다는 느낌 줄 수도 있어요
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: normalizedSelectedDay != null &&
                events.containsKey(normalizedSelectedDay)
                ? ListView(
              children: events[normalizedSelectedDay]!
                  .map(
                    (event) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50], // 배경 색
                    borderRadius: BorderRadius.circular(16), // 둥근 테두리
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     blurRadius: 4,
                    //     offset: Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(event['title']!),
                          content: Text(event['description']!),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('닫기'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.sunny, color: Colors.green[800]),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            )
                : Center(
              child: Text('선택된 날짜의 일정이 없습니다.'),
            ),
          ),
        ],
      ),
    );
  }
}
