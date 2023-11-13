// professional_model.dart
import 'package:flutter/material.dart';

class ProfessionalModel {
  String username;
  String passwordHash;

  List<int> availableDays; 
  TimeOfDay availableTimeStart;
  TimeOfDay availableTimeEnd;
  String serviceName;
  int minDuration;
  int maxDuration;
  int costPerHour;

  ProfessionalModel({
    required this.username,
    required this.passwordHash,
    required this.availableDays,
    required this.availableTimeStart,
    required this.availableTimeEnd,
    required this.serviceName,
    required this.minDuration,
    required this.maxDuration,
    required this.costPerHour,
  });

  ProfessionalModel copyWith({
    String? username,
    String? passwordHash,
    List<int>? availableDays,
    TimeOfDay? availableTimeStart,
    TimeOfDay? availableTimeEnd,
    String? serviceName,
    int? minDuration,
    int? maxDuration,
    int? costPerHour,
  }) {
    return ProfessionalModel(
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      availableDays: availableDays ?? this.availableDays,
      availableTimeStart: availableTimeStart ?? this.availableTimeStart,
      availableTimeEnd: availableTimeEnd ?? this.availableTimeEnd,
      serviceName: serviceName ?? this.serviceName,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      costPerHour: costPerHour ?? this.costPerHour,
    );
  }
}
