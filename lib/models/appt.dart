// Appt_model.dart
import 'package:flutter/material.dart';
import 'dart:convert';

class Appt {
  DateTime day;
  String title;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Appt({
    required this.day,
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day.toIso8601String(),
      'title': title,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  factory Appt.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return Appt(
      day: DateTime.parse(data['day']),
      title: data['title'],
      startTime: TimeOfDay(hour: data['startTime']['hour'], minute: data['startTime']['minute']),
      endTime: TimeOfDay(hour: data['endTime']['hour'], minute: data['endTime']['minute']),
    );
  }
}
