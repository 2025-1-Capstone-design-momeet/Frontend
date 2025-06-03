class UserInfo {
  final String userId;
  final String name;
  final String univName;
  final bool schoolCertification;
  final bool gender;
  final List<MyClub> myClubs;
  final List<Poster> posters;
  final List<ClubPromotion> clubPromotions;

  UserInfo({
    required this.userId,
    required this.name,
    required this.univName,
    required this.schoolCertification,
    required this.gender,
    required this.myClubs,
    required this.posters,
    required this.clubPromotions,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      name: json['name'],
      univName: json['univName'],
      schoolCertification: json['schoolCertification'],
      gender: json['gender'],
      myClubs: (json['myClubs'] as List).map((e) => MyClub.fromJson(e)).toList(),
      posters: (json['posters'] as List).map((e) => Poster.fromJson(e)).toList(),
      clubPromotions: (json['clubPromotions'] as List).map((e) => ClubPromotion.fromJson(e)).toList(),
    );
  }
}

class MyClub {
  final String clubId;
  final String clubName;
  final String category;
  final bool official;

  MyClub({required this.clubId, required this.clubName, required this.category, required this.official});

  factory MyClub.fromJson(Map<String, dynamic> json) {
    return MyClub(
      clubId: json['clubId'],
      clubName: json['clubName'],
      category: json['category'],
      official: json['official'],
    );
  }
}

class Poster {
  final String postNum;
  final String img;

  Poster({required this.postNum, required this.img});

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      postNum: json['postNum'],
      img: json['img'],
    );
  }
}

class ClubPromotion {
  final String clubId;
  final String clubName;
  final String category;
  final dynamic endDate; // [2025, 2, 20, 0, 0] 이거나 null
  final bool official;
  final bool recruiting;

  ClubPromotion({
    required this.clubId,
    required this.clubName,
    required this.category,
    required this.endDate,
    required this.official,
    required this.recruiting,
  });

  factory ClubPromotion.fromJson(Map<String, dynamic> json) {
    return ClubPromotion(
      clubId: json['clubId'],
      clubName: json['clubName'],
      category: json['category'],
      endDate: json['endDate'],
      official: json['official'],
      recruiting: json['recruiting'],
    );
  }
}
