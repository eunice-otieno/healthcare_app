import 'package:flutter/material.dart';

class InputSymptomsPage extends StatelessWidget {
  final TextEditingController _symptomsController = TextEditingController();

  InputSymptomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input New Symptoms')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Describe Your Symptoms:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(hintText: 'Enter your symptoms'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle symptom submission logic
                print('New symptoms: ${_symptomsController.text}');
              },
              child: const Text('Submit Symptoms'),
            ),
          ],
        ),
      ),
    );
  }
}
