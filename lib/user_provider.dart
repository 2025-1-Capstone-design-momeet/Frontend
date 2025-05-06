import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _pw;
  String? _phoneNum;
  String? _name;
  String? _email;
  bool? _gender;

  String? get userId => _userId;
  String? get pw => _pw;
  String? get phoneNum => _phoneNum;
  String? get name => _name;
  String? get email => _email;
  bool? get gender => _gender;

  void login(String userId, String pw, {String? phoneNum, String? name, String? email, bool? gender}) {
    _userId = userId;
    _pw = pw;
    _phoneNum = phoneNum;
    _name = name;
    _gender = gender;
    notifyListeners();
  }

  void logout() {

  }

  void updateUser() {

  }
}