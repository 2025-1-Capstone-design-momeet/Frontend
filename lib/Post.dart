// post.dart
class Post {
  final String postNum;
  final String title;
  final String content;
  final int type;
  final String typeLabel;
  final String? file;
  final int like;
  final int fixation;
  final DateTime date;

  Post({
    required this.postNum,
    required this.title,
    required this.content,
    required this.type,
    required this.typeLabel,
    this.file,
    required this.like,
    required this.fixation,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final dateList = json['date'] as List<dynamic>;
    final dateTime = DateTime(
      dateList[0],
      dateList[1],
      dateList[2],
      dateList[3],
      dateList[4],
    );

    return Post(
      postNum: json['postNum'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      typeLabel: json['typeLabel'],
      file: json['file'],
      like: json['like'],
      fixation: json['fixation'],
      date: dateTime,
    );
  }
}
