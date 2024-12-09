import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient Notes'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Note for Patient:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Enter Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle saving the note (e.g., send to Firestore)
                // For now, just show the entered text
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Note Saved: ${_noteController.text}')),
                );
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
