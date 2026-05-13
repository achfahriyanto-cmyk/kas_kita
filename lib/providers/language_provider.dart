import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isIndonesian = true;

  bool get isIndonesian => _isIndonesian;

  void setLanguage(bool isIndonesian) {
    _isIndonesian = isIndonesian;
    notifyListeners();
  }

  // Helper untuk mendapatkan teks berdasarkan bahasa
  String getText(String id, String en) {
    return _isIndonesian ? id : en;
  }
}
