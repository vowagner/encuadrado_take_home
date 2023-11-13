// utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  static const String professionalUsername = "encuadrado";
  static const String professionalHashedPassword = "ef6d1481ba6ae3d9d81c9514f504061da281d7e4b77db1a357e178a2b8e55509";
  static const List<int> availableDays = [1, 2, 3, 4, 5];
  static const TimeOfDay availableTimeStart =  TimeOfDay(hour: 9, minute: 0);
  static const TimeOfDay availableTimeEnd = TimeOfDay(hour: 17, minute: 30);
  static const String serviceName = "Clase de Yoga";
  static const int minDuration = 30;
  static const int maxDuration = 180;
  static const int costPerHour = 35000;
  static const String appt1Title = "Clase de Yoga";
  static const String appt2Title = "Clase de Boxeo";
  static const TimeOfDay appt1StartTime = TimeOfDay(hour: 10, minute: 0);
  static const TimeOfDay appt2StartTime = TimeOfDay(hour: 12, minute: 30);
  static const TimeOfDay appt1EndTime = TimeOfDay(hour: 11, minute: 0);
  static const TimeOfDay appt2EndTime = TimeOfDay(hour: 16, minute: 0);
}
