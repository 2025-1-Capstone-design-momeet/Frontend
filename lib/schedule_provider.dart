class Schedule {
  final String scheduleId;
  final String clubId;
  final DateTime dateTime;
  final String title;
  final String content;

  Schedule({
    required this.scheduleId,
    required this.clubId,
    required this.dateTime,
    required this.title,
    required this.content,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final date = json['date']; // [2025, 6, 10]
    final time = json['time']; // [23, 59]
    final dateTime = DateTime(date[0], date[1], date[2], time[0], time[1]);

    return Schedule(
      scheduleId: json['scheduleId'],
      clubId: json['clubId'],
      dateTime: dateTime,
      title: json['title'],
      content: json['content'],
    );
  }
}
