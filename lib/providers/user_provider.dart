import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Pengguna KasKita';
  String _email = 'pengguna@kaskita.com';
  String _phone = '081234567890';
  String _gender = 'Laki-laki';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get gender => _gender;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _gender = gender;
    notifyListeners();
  }
}
