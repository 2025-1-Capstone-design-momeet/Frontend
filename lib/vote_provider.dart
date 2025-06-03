class Vote {
  final String voteID;
  final String clubId;
  final List<int> endDate;
  final String title;
  final String content;
  final List<VoteContent> voteContents;
  final bool anonymous;
  final bool payed;
  final bool end;

  Vote({
    required this.voteID,
    required this.clubId,
    required this.endDate,
    required this.title,
    required this.content,
    required this.voteContents,
    required this.anonymous,
    required this.payed,
    required this.end,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      voteID: json['voteID'] ?? '',
      clubId: json['clubId'] ?? '',
      endDate: json['endDate'] != null ? List<int>.from(json['endDate']) : [],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      voteContents: (json['voteContets'] as List<dynamic>? ?? [])
          .map((item) => VoteContent.fromJson(item))
          .toList(),
      anonymous: json['anonymous'] ?? false,
      payed: json['payed'] ?? false,
      end: json['end'] ?? false,
    );
  }
}

class VoteContent {
  final String voteContentID;
  final String voteID;
  final String field;
  final int voteNum;
  final int voteContentNum;

  VoteContent({
    required this.voteContentID,
    required this.voteID,
    required this.field,
    required this.voteNum,
    required this.voteContentNum,
  });

  factory VoteContent.fromJson(Map<String, dynamic> json) {
    return VoteContent(
      voteContentID: json['voteContentID'] ?? '',
      voteID: json['voteID'] ?? '',
      field: json['field'] ?? '',
      voteNum: json['voteNum'] ?? 0,
      voteContentNum: json['voteContentNum'] ?? 0,
    );
  }
}
