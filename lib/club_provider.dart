import 'package:flutter/material.dart';

class ClubProvider extends ChangeNotifier {
  String? _clubId;
  String? _clubName;
  bool? _official;

  String? get clubId => _clubId;
  String? get clubName => _clubName;
  bool? get official => _official;

  void setClub (String clubId, String clubName, bool official) {
    _clubId = clubId;
    _clubName = clubName;
    _official = official;

    notifyListeners();
  }
}