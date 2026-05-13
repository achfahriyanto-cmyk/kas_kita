import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _isEnabled = false;
  bool _dailyReminder = true;
  bool _weeklyReport = true;
  bool _budgetAlert = true;

  bool get isEnabled => _isEnabled;
  bool get dailyReminder => _dailyReminder;
  bool get weeklyReport => _weeklyReport;
  bool get budgetAlert => _budgetAlert;

  void toggleNotification(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  void updateSettings({bool? daily, bool? weekly, bool? budget}) {
    if (daily != null) _dailyReminder = daily;
    if (weekly != null) _weeklyReport = weekly;
    if (budget != null) _budgetAlert = budget;
    notifyListeners();
  }
}
