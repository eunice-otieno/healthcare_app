// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MedicationStatusPage extends StatelessWidget {
  final List<String> medicationStatuses = [
    'Not Working',
    'Finished',
    'Side Effects'
  ];
  String _selectedStatus = 'Not Working';

  MedicationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Medication Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Medication Status:',
                style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectedStatus = newValue;
                }
              },
              items: medicationStatuses
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the medication status submission logic
                print('Medication status: $_selectedStatus');
              },
              child: const Text('Submit Status'),
            ),
          ],
        ),
      ),
    );
  }
}
