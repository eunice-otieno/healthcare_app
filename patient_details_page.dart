import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsPage extends StatefulWidget {
  final String initialPatientName;
  final String initialCondition;
  final DocumentReference patientDocRef; // Firestore document reference

  const PatientDetailsPage({
    super.key,
    required this.initialPatientName,
    required this.initialCondition,
    required this.patientDocRef,
    required String patientName,
    required String condition, // Document reference passed here
  });

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _conditionController;
  late TextEditingController _vitalsController;
  late TextEditingController _symptomsController;
  

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialPatientName);
    _conditionController = TextEditingController(text: widget.initialCondition);
    _vitalsController = TextEditingController();
    _symptomsController = TextEditingController();

  }

  @override
  void dispose() {
    _nameController.dispose();
    _conditionController.dispose();
   _vitalsController.dispose();
    _symptomsController.dispose();

    super.dispose();
  }

  // Method to update patient details
  void _updatePatientDetails() async {
    String updatedName = _nameController.text.trim();
    String updatedCondition = _conditionController.text.trim();

    try {
      // Update the patient details in Firestore
      await widget.patientDocRef.update({
        'name': updatedName,
        'condition': updatedCondition,
      });

      // Return updated data to the previous screen (e.g., doctor's dashboard)
      Navigator.pop(context, {
        'name': updatedName,
        'condition': updatedCondition,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient details updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating details: $e')),
      );
    }
  }

 // Method to show the vitals input form in a modal
  void _showVitalsForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Patient Vitals'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _vitalsController,
                  decoration: const InputDecoration(labelText: 'Vitals (e.g., BP, Heart Rate)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _symptomsController,
                  decoration: const InputDecoration(labelText: 'Symptoms'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _submitVitalsData();
                Navigator.pop(context); // Close the dialog after submission
              },
              child: const Text('Submit Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without submitting
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_nameController.text} Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Editable Patient Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Editable Condition Field
            TextField(
              controller: _conditionController,
              decoration: const InputDecoration(labelText: 'Condition'),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Update Button
            ElevatedButton(
              onPressed: _updatePatientDetails,
              child: const Text('Update Details'),
            ),
            const SizedBox(height: 20),

            // Notes section (static or dynamic)
            const Text(
              'Patient Notes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'This section can display any notes related to the patient or previous appointments.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Button to navigate to lab request page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LabRequestPage(),
                  ),
                );
              },
              child: const Text('Request Lab Test'),
            ),
          ],
        ),
      ),
    );
  }
}

class _submitVitalsData {
}

// Dummy LabRequestPage class for navigation
class LabRequestPage extends StatelessWidget {
  const LabRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Lab Test')),
      body: Center(child: const Text('Lab Request Form will go here')),
    );
  }
}
