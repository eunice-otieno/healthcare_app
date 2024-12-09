import 'package:flutter/material.dart';

class ScheduleAppointmentPage extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  ScheduleAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Appointment Date:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(hintText: 'Enter Date'),
            ),
            const SizedBox(height: 20),
            const Text('Select Appointment Time:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(hintText: 'Enter Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the appointment scheduling logic
                print('Appointment scheduled for ${_dateController.text} at ${_timeController.text}');
              },
              child: const Text('Schedule Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
