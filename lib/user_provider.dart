import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _pw;
  String? _phoneNum;
  String? _name;
  String? _email;
  bool? _gender;

  String? _univName;
  bool? _schoolCertification;
  String? _department;
  int? _grade;

  String? get userId => _userId;
  String? get pw => _pw;
  String? get phoneNum => _phoneNum;
  String? get name => _name;
  String? get email => _email;
  bool? get gender => _gender;

  String? get univName => _univName;
  bool? get schoolCertification => _schoolCertification;
  String? get department => _department;
  int? get grade => _grade;

  void setUser (String userId, String pw, {String? name, String? univName, bool? schoolCertification, String? department, int? grade}) {
    _userId = userId;
    _pw = pw;
    _name = name;
    _univName = univName;
    _schoolCertification = schoolCertification;
    _department = department;
    _grade = grade;

    notifyListeners();
  }

  void logout() {
    _userId = null;
    _pw = null;
    _name = null;
    _phoneNum = null;
    _gender = null;

    notifyListeners();
  }
}