import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});

  @override
  _HealthRecordsPageState createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();

  Future<void> addHealthRecordToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('healthRecords').add({
        'patientName': patientNameController.text,
        'symptoms': symptomsController.text,
        'diagnosis': diagnosisController.text,
        'treatment': treatmentController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      patientNameController.clear();
      symptomsController.clear();
      diagnosisController.clear();
      treatmentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health record added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding health record')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: patientNameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter symptoms';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: diagnosisController,
                decoration: const InputDecoration(labelText: 'Diagnosis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter diagnosis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: treatmentController,
                decoration: const InputDecoration(labelText: 'Treatment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter treatment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    addHealthRecordToFirestore();
                  }
                },
                child: const Text('Add Health Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
