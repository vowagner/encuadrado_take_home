// professional_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encuadrado_app/models/professional.dart';
import 'package:encuadrado_app/utils/constants.dart';

class ProfessionalProvider extends ChangeNotifier {
  late ProfessionalModel _professionalModel;
  bool isProfessionalModelInitialized = false;
  ProfessionalModel get professionalModel => _professionalModel;

  ProfessionalProvider() {
    _loadProfessionalModel();
  }

  void _loadProfessionalModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _professionalModel = ProfessionalModel(
      username: prefs.getString('username') ?? AppConstants.professionalUsername,
      passwordHash: prefs.getString('passwordHash') ?? AppConstants.professionalHashedPassword,
      availableDays: (prefs.getStringList('availableDays') ?? ['0', '1', '1', '1', '1', '1', '0']).map(int.parse).toList(),
      availableTimeStart: _convertStringToTimeOfDay(
            prefs.getString('availableTimeStartHour'), 
            prefs.getString('availableTimeStartMinute')
      ) ?? AppConstants.availableTimeStart,
      availableTimeEnd: _convertStringToTimeOfDay(
            prefs.getString('availableTimeEndHour'), 
            prefs.getString('availableTimeEndMinute')
      ) ?? AppConstants.availableTimeEnd,
      serviceName: prefs.getString('serviceName') ?? AppConstants.serviceName,
      minDuration: prefs.getInt('minDuration') ?? AppConstants.minDuration,
      maxDuration: prefs.getInt('maxDuration') ?? AppConstants.maxDuration,
      costPerHour: prefs.getInt('costPerHour') ?? AppConstants.costPerHour,
    );
    isProfessionalModelInitialized = true;
    notifyListeners();
  }

  void saveProfessionalModel(ProfessionalModel newModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _professionalModel = newModel;
    prefs.setString('username', newModel.username);
    prefs.setString('passwordHash', newModel.passwordHash);
    prefs.setStringList('availableDays', newModel.availableDays.map((day) => day.toString()).toList());
    prefs.setString('availableTimeStartHour', newModel.availableTimeStart.hour.toString());
    prefs.setString('availableTimeStartMinute', newModel.availableTimeStart.minute.toString());
    prefs.setString('availableTimeEndHour', newModel.availableTimeEnd.hour.toString());
    prefs.setString('availableTimeEndMinute', newModel.availableTimeEnd.minute.toString());
    prefs.setString('serviceName', newModel.serviceName);
    prefs.setInt('minDuration', newModel.minDuration);
    prefs.setInt('maxDuration', newModel.maxDuration);
    prefs.setInt('costPerHour', newModel.costPerHour);

    notifyListeners();
  }

  TimeOfDay? _convertStringToTimeOfDay(String? hour, String? minute) {
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
  }
}
