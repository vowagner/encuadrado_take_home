import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:encuadrado_app/providers/professional_provider.dart';
import 'package:encuadrado_app/providers/appt_provider.dart';
import 'package:encuadrado_app/models/appt.dart';
import 'package:encuadrado_app/models/professional.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer View'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
              if (professionalProvider.isProfessionalModelInitialized) {
                _showAppointmentDialog(context, professionalProvider.professionalModel!);
              } else {
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer2<ProfessionalProvider, ApptProvider>(
          builder: (context, professionalProvider, apptProvider, child) {
            if (!professionalProvider.isProfessionalModelInitialized ||
                !apptProvider.isApptsInitialized) {
              return CircularProgressIndicator();
            }

            final professionalModel = professionalProvider.professionalModel!;
            final List<Appt> appointments = apptProvider.appts;

            return FutureBuilder<List<Meeting>>(
              future: _getCalendarDataSource(appointments),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SfCalendar(
                    view: CalendarView.workWeek,
                    firstDayOfWeek: 1,
                    dataSource: MeetingDataSource(snapshot.data!),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: professionalModel.availableTimeStart.hour + 0,
                      endHour: professionalModel.availableTimeEnd.hour + 1,
                      nonWorkingDays: _getNonWorkingDays(professionalModel.availableDays),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Meeting>> _getCalendarDataSource(List<Appt> appts) async {
    List<DateTime> holidays = await _fetchHolidays();
    List<Meeting> appointments = _getExistingAppointments(appts);
    List<Meeting> holidayMeetings = _convertHolidaysToMeetings(holidays);
    List<Meeting> events = [...appointments, ...holidayMeetings];

    return events;
  }

  List<int> _getNonWorkingDays(List<int> availableDays) {
    return List.generate(availableDays.length, (index) => availableDays[index] == 0 ? index : -1)
        .where((day) => day != -1)
        .toList();
  }

  Future<List<DateTime>> _fetchHolidays() async {
    final response = await http.get(Uri.parse('https://api.victorsanmartin.com/feriados/en.json'));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final List<dynamic> holidaysJson = data['data'];
        final List<DateTime> holidays = holidaysJson.map((holiday) => DateTime.parse(holiday['date'])).toList();
        return holidays;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch holidays');
    }
  }

  List<Meeting> _getExistingAppointments(List<Appt> appts) {
    List<Meeting> existingAppointments = appts.map((appointment) {
      DateTime appointmentDateTime = DateTime(
        appointment.day.year,
        appointment.day.month,
        appointment.day.day,
        appointment.startTime.hour,
        appointment.startTime.minute,
      );

      DateTime endDateTime = DateTime(
        appointment.day.year,
        appointment.day.month,
        appointment.day.day,
        appointment.endTime.hour,
        appointment.endTime.minute,
      );

      return Meeting(
        "Ocupado",
        appointmentDateTime,
        endDateTime,
        Colors.blue,
        false,
      );
    }).toList();

    return existingAppointments;
  }

  List<Meeting> _convertHolidaysToMeetings(List<DateTime> holidays) {
    final List<Meeting> holidayMeetings = [];

    for (DateTime holiday in holidays) {
      final meeting = Meeting(
        "Feriado",
        holiday,
        DateTime(holiday.year, holiday.month, holiday.day, 23, 59),
        Color.fromARGB(255, 255, 101, 101),
        false,
      );
      holidayMeetings.add(meeting);
    }

    return holidayMeetings;
  }

  void _showAppointmentDialog(BuildContext context, ProfessionalModel professional) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AppointmentDialog(professional: professional);
      },
    );
  }
}

class AppointmentDialog extends StatefulWidget {
  final ProfessionalModel professional;

  const AppointmentDialog({Key? key, required this.professional}) : super(key: key);

  @override
  _AppointmentDialogState createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  DateTime? selectedDate;
  int startTimeHour = 9;
  int startTimeMinute = 0;
  int endTimeHour = 17;
  int endTimeMinute = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Servicio: ${widget.professional.serviceName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Costo por hora: ${widget.professional.costPerHour}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Horario: ${widget.professional.availableTimeStart.format(context)} - ${widget.professional.availableTimeEnd.format(context)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Duración de la sesión: ${widget.professional.minDuration} - ${widget.professional.maxDuration} minutos',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Seleccionar fecha y hora:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Fecha'),
              subtitle: selectedDate != null
                  ? Text('${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}')
                  : Text('Seleccionar fecha'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora de inicio'),
              subtitle: Text('$startTimeHour:$startTimeMinute'),
              onTap: () {
                _selectTime(context, true);
              },
            ),
            ListTile(
              title: Text('Hora de fin'),
              subtitle: Text('$endTimeHour:$endTimeMinute'),
              onTap: () {
                _selectTime(context, false);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitAppointment();
              },
              child: Text('Agendar Cita'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay initialTime = TimeOfDay.now();

    if (isStartTime) {
      initialTime = TimeOfDay(hour: startTimeHour, minute: startTimeMinute);
    } else {
      initialTime = TimeOfDay(hour: endTimeHour, minute: endTimeMinute);
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          child: child!,
        ),
      );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTimeHour = pickedTime.hour;
          startTimeMinute = pickedTime.minute;
        } else {
          endTimeHour = pickedTime.hour;
          endTimeMinute = pickedTime.minute;
        }
      });
    }
  }

  void _submitAppointment() {
    if (selectedDate == null) {
      _showValidationError('Por favor selecciona una fecha');
      return;
    }
    if (startTimeHour < widget.professional.availableTimeStart.hour ||
        (startTimeHour == widget.professional.availableTimeStart.hour && startTimeMinute < widget.professional.availableTimeStart.minute)) {
      _showValidationError('La hora de inicio debe ser después de ${widget.professional.availableTimeStart.format(context)}');
      return;
    }
    if (endTimeHour > widget.professional.availableTimeEnd.hour ||
        (endTimeHour == widget.professional.availableTimeEnd.hour && endTimeMinute > widget.professional.availableTimeEnd.minute)) {
      _showValidationError('La hora de fin debe ser antes de ${widget.professional.availableTimeEnd.format(context)}');
      return;
    }
    if (startTimeHour > endTimeHour || (startTimeHour == endTimeHour && startTimeMinute >= endTimeMinute)) {
      _showValidationError('La hora de inicio debe ser antes de la hora de fin');
      return;
    }

    int durationInMinutes = (endTimeHour - startTimeHour) * 60 + (endTimeMinute - startTimeMinute);
    if (durationInMinutes < widget.professional.minDuration || durationInMinutes > widget.professional.maxDuration) {
      _showValidationError('La duración de la sesión debe estar entre ${widget.professional.minDuration} y ${widget.professional.maxDuration} minutos');
      return;
    }
    
    if (widget.professional.availableDays[selectedDate!.weekday % 7] == 0) {
      _showValidationError('No se pueden hacer citas en este día');
      return;
    } 


    DateTime startDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTimeHour,
      startTimeMinute,
    );

    DateTime endDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTimeHour,
      endTimeMinute,
    );

    if (_hasSchedulingConflict(startDateTime, endDateTime)) {
      _showValidationError('Ya hay una cita agendada en este horario');
      return;
  }

    Provider.of<ApptProvider>(context, listen: false).addAppt(
      Appt(
        day: startDateTime,
        startTime: TimeOfDay(hour: startTimeHour, minute: startTimeMinute),
        endTime: TimeOfDay(hour: endTimeHour, minute: endTimeMinute),
        title: widget.professional.serviceName
      ),
    );
    Navigator.pop(context);
  }


  bool _hasSchedulingConflict(DateTime newStart, DateTime newEnd) {
    List<Appt> existingAppointments = Provider.of<ApptProvider>(context, listen: false).appts;

    for (Appt existingAppointment in existingAppointments) {
      DateTime existingStart = DateTime(
        existingAppointment.day.year,
        existingAppointment.day.month,
        existingAppointment.day.day,
        existingAppointment.startTime.hour,
        existingAppointment.startTime.minute,
      );

      DateTime existingEnd = DateTime(
        existingAppointment.day.year,
        existingAppointment.day.month,
        existingAppointment.day.day,
        existingAppointment.endTime.hour,
        existingAppointment.endTime.minute,
      );

      if ((newStart.isBefore(existingEnd) || newStart.isAtSameMomentAs(existingEnd)) &&
          (newEnd.isAfter(existingStart) || newEnd.isAtSameMomentAs(existingStart))) {
        return true;
      }
    }

    return false;
  }


  void _showValidationError(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

}



class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}