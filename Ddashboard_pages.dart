// doctor_dashboard_pages.dart

import 'package:flutter/material.dart';

// Add Note Page
class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Write your note:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter note here...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the note (this could be saved to Firebase or local storage)
                print('Note added: ${_noteController.text}');
                Navigator.pop(context);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}

// View Appointments Page
class ViewAppointmentsPage extends StatelessWidget {
  const ViewAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Upcoming Appointments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: const [
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text('Patient: Valentine - 10:00 AM'),
                  subtitle: Text('Condition: Hypertension'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text('Patient: Laurence Ochieng - 2:00 PM'),
                  subtitle: Text('Condition: Diabetes'),
                ),
                // Add more appointments dynamically if needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}
