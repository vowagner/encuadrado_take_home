import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:encuadrado_app/providers/professional_provider.dart';
import 'package:encuadrado_app/models/professional.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ProfessionalConfigScreen extends StatefulWidget {
  @override
  _ProfessionalConfigScreenState createState() => _ProfessionalConfigScreenState();
}

class _ProfessionalConfigScreenState extends State<ProfessionalConfigScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _minDurationController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();
  final TextEditingController _costPerHourController = TextEditingController();

  late List<bool> _selectedDays;
  final TextEditingController _startTimeHourController = TextEditingController();
  final TextEditingController _startTimeMinuteController = TextEditingController();
  final TextEditingController _endTimeHourController = TextEditingController();
  final TextEditingController _endTimeMinuteController = TextEditingController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final professionalProvider = Provider.of<ProfessionalProvider>(context);
    final professionalModel = professionalProvider.professionalModel;

    _serviceNameController.text = professionalModel.serviceName;
    _minDurationController.text = professionalModel.minDuration.toString();
    _maxDurationController.text = professionalModel.maxDuration.toString();
    _costPerHourController.text = professionalModel.costPerHour.toString();
    _startTimeHourController.text = professionalModel.availableTimeStart.hour.toString();
    _startTimeMinuteController.text = professionalModel.availableTimeStart.minute.toString();
    _endTimeHourController.text = professionalModel.availableTimeEnd.hour.toString();
    _endTimeMinuteController.text = professionalModel.availableTimeEnd.minute.toString();



    // Ensure _selectedDays has exactly 7 elements
    _selectedDays = List<bool>.from(professionalModel.availableDays.map((day) => day == 1));
    while (_selectedDays.length < 7) {
      _selectedDays.add(false);
    }
    while (_selectedDays.length > 7) {
      _selectedDays.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Configuration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Service Name
            TextField(
              controller: _serviceNameController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),

            // Days of the Week
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Days of the Week',
              ),
            ),
            WeekdaySelector(
              onChanged: (int day) {
                setState(() {
                  _selectedDays[day % 7] = !_selectedDays[day % 7];
                });
              },
              values: _selectedDays,
            ),

            Row(
              children: [
                Text('Start Time: '),
                SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _startTimeHourController,
                    decoration: InputDecoration(labelText: 'Hours'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _startTimeMinuteController,
                    decoration: InputDecoration(labelText: 'Minutes'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                  ),
                ),
              ],
            ),

            // Time End
            Row(
              children: [
                Text('End Time: '),
                SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _endTimeHourController,
                    decoration: InputDecoration(labelText: 'Hours'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _endTimeMinuteController,
                    decoration: InputDecoration(labelText: 'Minutes'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                  ),
                ),
              ],
            ),

            // Min Duration
            TextField(
              controller: _minDurationController,
              decoration: InputDecoration(labelText: 'Min Duration'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
            ),

            // Max Duration
            TextField(
              controller: _maxDurationController,
              decoration: InputDecoration(labelText: 'Max Duration'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
            ),

            // Cost Per Hour
            TextField(
              controller: _costPerHourController,
              decoration: InputDecoration(labelText: 'Cost Per Hour (\$)'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
            ),

            ElevatedButton(
              onPressed: () {
                int startTimeHour = int.parse(_startTimeHourController.text);
                int startTimeMinute = int.parse(_startTimeMinuteController.text);
                int endTimeHour = int.parse(_endTimeHourController.text);
                int endTimeMinute = int.parse(_endTimeMinuteController.text);
                int minDuration = int.parse(_minDurationController.text);
                int maxDuration = int.parse(_maxDurationController.text);
                String serviceName = _serviceNameController.text;
                List<int> daysOfWeek =  _selectedDays.map((selected) => selected ? 1 : 0).toList();
                
                if (!daysOfWeek.contains(1)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one day of the week.'),
                    ),
                  );
                  return;
                }
                if (serviceName == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a service name.'),
                    ),
                  );
                  return;
                }

                if (endTimeHour > 23 || endTimeHour < 0 || endTimeMinute > 59 || endTimeMinute < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('End Time must be a valid time.'),
                    ),
                  );
                  return;
                }
                if (startTimeHour > 23 || startTimeHour < 0 || startTimeMinute > 59 || startTimeMinute < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Start Time must be a valid time.'),
                    ),
                  );
                  return;
                }
                if (endTimeHour < startTimeHour || (endTimeHour == startTimeHour && endTimeMinute <= startTimeMinute)) {
                  // Show an error message or handle the validation failure as needed
                  // For example, you can display a SnackBar:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('End Time must be greater than Start Time.'),
                    ),
                  );
                  return; // Do not proceed with saving if validation fails
                  }
                if (maxDuration < minDuration) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Max Duration must be greater than or equal to Min Duration.'),
                    ),
                  );
                  return;
                }
                
                // Save the modified model
                final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
                professionalProvider.saveProfessionalModel(
                  professionalProvider.professionalModel.copyWith(
                    serviceName: _serviceNameController.text,
                    availableDays: daysOfWeek,
                    availableTimeStart: TimeOfDay(hour: startTimeHour, minute: startTimeMinute),
                    availableTimeEnd: TimeOfDay(hour: endTimeHour, minute: endTimeMinute),
                    minDuration: minDuration,
                    maxDuration: maxDuration,
                    costPerHour: int.parse(_costPerHourController.text),
                  ),
                );

                Navigator.pop(context); // Close the configuration screen
              },
              child: Text('Save Configuration'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
