// professional_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:encuadrado_app/providers/professional_provider.dart';
import 'package:encuadrado_app/providers/appt_provider.dart';
import 'package:encuadrado_app/models/professional.dart';
import 'package:encuadrado_app/models/appt.dart';
import 'package:encuadrado_app/views/professional_config_screen.dart';

class ProfessionalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional View'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfessionalConfigScreen(),
                ),
              );
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

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello, ${professionalModel.username}!'),
                SizedBox(height: 20),
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    firstDayOfWeek: 1,
                    dataSource: MeetingDataSource(_getCalendarDataSource(appointments)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Meeting> _getCalendarDataSource(List<Appt> appointments) {

    List<Meeting> events = [];
    for (Appt appointment in appointments) {
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

      events.add(Meeting(
        appointment.title,
        appointmentDateTime,
        endDateTime,
        Colors.blue,
        false,
      ));
    }

    return events;
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
