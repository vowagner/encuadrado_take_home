// appt_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:encuadrado_app/models/appt.dart';
import 'package:encuadrado_app/utils/constants.dart';

class ApptProvider extends ChangeNotifier {
  late List<Appt> _appts;
  bool isApptsInitialized = false;
  List<Appt> get appts => _appts;

  ApptProvider() {
    _loadAppts();
  }

  void _loadAppts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? storedAppts = prefs.getStringList('appts');

    if (storedAppts != null) {
      _appts = storedAppts.map((jsonString) => Appt.fromJson(jsonString)).toList();
    } else {
      _appts = [
        Appt(
          day: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 0, 0, 0),
          title: AppConstants.appt1Title,
          startTime: AppConstants.appt1StartTime,
          endTime: AppConstants.appt1EndTime,
        ),
        Appt(
          day: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 0, 0, 0),
          title: AppConstants.appt1Title,
          startTime: AppConstants.appt2StartTime,
          endTime: AppConstants.appt2EndTime,
        ),
        Appt(
          day: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 0, 0, 0),
          title: AppConstants.appt1Title,
          startTime: AppConstants.appt3StartTime,
          endTime: AppConstants.appt3EndTime,
        ),
        Appt(
          day: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3, 0, 0, 0),
          title: AppConstants.appt1Title,
          startTime: AppConstants.appt1StartTime,
          endTime: AppConstants.appt1EndTime,
        ),
      ];
    }
    isApptsInitialized = true;
    notifyListeners();
  }

  void addAppt(Appt appt) {
    _appts.add(appt);
    _saveAppts();
    notifyListeners();
  }

  void _saveAppts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final jsonData = _appts.map((appt) => appt.toJsonString()).toList();
    prefs.setStringList('appts', jsonData);
  }
}
