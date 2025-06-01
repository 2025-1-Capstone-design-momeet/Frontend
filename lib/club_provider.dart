import 'package:flutter/material.dart';

class ClubProvider extends ChangeNotifier {
  String? _clubId;
  String? _clubName;

  String? get clubId => _clubId;
  String? get clubName => _clubName;

  void setClub (String clubId, String clubName) {
    _clubId = clubId;
    _clubName = clubName;

    notifyListeners();
  }
}