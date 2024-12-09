import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDashboard extends StatelessWidget {
  final int userId; // Change to integer

  const PatientDashboard(
      {super.key, required this.userId, required String patientId});

  DocumentReference<Object?>? get patientDocRef => null;

  // Fetch patient data from Firestore
  Future<Map<String, dynamic>?> fetchPatientData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users') // Using 'users' collection
          .where('userId', isEqualTo: userId) // Fetch data by userId
          .limit(1) // Limit to 1 result, since userId is unique
          .get();

      if (doc.docs.isNotEmpty) {
        return doc.docs.first.data(); // Get data from the first document
      } else {
        print('No patient data found for this user');
        return null;
      }
    } catch (e) {
      print('Error fetching patient data: $e');
      return null;
    }
  }

//// Method to show the vitals input form in a modal
  void _showVitalsForm(BuildContext context) {
    // Create controllers to capture user input
    TextEditingController vitalsController = TextEditingController();
    TextEditingController symptomsController = TextEditingController();

    // Show the modal dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Patient Vitals'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Input for Vitals (e.g., BP, Heart Rate)
                TextField(
                  controller: vitalsController,
                  decoration: const InputDecoration(
                      labelText: 'Vitals (e.g., BP, Heart Rate)'),
                ),
                const SizedBox(height: 10),
                // Input for Symptoms
                TextField(
                  controller: symptomsController,
                  decoration: const InputDecoration(labelText: 'Symptoms'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Simulating a successful submission
                String vitals = vitalsController.text.trim();
                String symptoms = symptomsController.text.trim();

                if (vitals.isNotEmpty && symptoms.isNotEmpty) {
                  // Simulating successful data submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Data sent successfully to doctor!')),
                  );

                  // Clear the text fields and close the modal
                  vitalsController.clear();
                  symptomsController.clear();
                  Navigator.pop(context); // Close the dialog after submission
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all fields!')),
                  );
                }
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
        backgroundColor: Colors.green,
        title: const Text('Patient Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchPatientData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching data. Please try again.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No patient data found.'));
          }
          final data = snapshot.data!; // Data from Firestore

          // Check if the fields we want exist in the fetched data
          final name = data['name'] ?? 'ensure to refresh details';
          final email = data['email'] ?? '_@gmail.com';
          final gender = data['gender'] ?? '';

          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/logo2.jpg', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information Section
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Name:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(name),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(email),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Gender:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(gender),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Health Records Section
                      const Text(
                        'Health Records',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Last Appointment Date:'),
                                  Text(data['lastAppointmentDate'] ??
                                      '23/12/2024'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Condition:'),
                                  Text(data['condition'] ?? 'diabetis'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Prescribed Medication:'),
                                  Text(data['medication'] ?? 'rest'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Blood Pressure:'),
                                  Text(data['bloodPressure'] ?? '200hzs'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Heart Rate:'),
                                  Text(data['heartRate'] ?? '64/90'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Temperature:'),
                                  Text(data['temperature'] ?? '37c'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Oxygen Saturation:'),
                                  Text(data['oxygenSaturation'] ?? 'good'),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Add the "Enter Health Data" Button
                              ElevatedButton(
  onPressed: () {
    _showVitalsForm(context); // Show vitals form without Firestore reference
  },
  child: const Text('Enter Health Data'),
),

                              // Add spacing before the section
                              const Text(
                                'Patient Activities',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          backgroundColor: const Color.fromARGB(
                                              255, 127, 54, 244),
                                        ),
                                        onPressed: () {
                                          // Report Changes in Symptoms
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Changes in Symptoms'),
                                              content:
                                                  const SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      title: Text('Kemboi'),
                                                      subtitle: Text(
                                                          'Reported: Persistent headache'),
                                                    ),
                                                    ListTile(
                                                      title: Text('Cate'),
                                                      subtitle: Text(
                                                          'Reported: Fever and dizziness'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      'send to doctor'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.warning),
                                        label: const Text('Report Symptoms'),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          // Ask for Ambulance
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Ambulance Requests'),
                                              content:
                                                  const SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      title: Text('Cate'),
                                                      subtitle: Text(
                                                          'Ambulance ETA: 10 minutes'),
                                                    ),
                                                    ListTile(
                                                      title: Text('Eunice'),
                                                      subtitle: Text(
                                                          'Ambulance dispatched'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('acknowledge'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.local_hospital),
                                        label: const Text('Ask Ambulance'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          backgroundColor: Colors.purple,
                                        ),
                                        onPressed: () {
                                          // Controller for the message input
                                          final TextEditingController
                                              messageController =
                                              TextEditingController();

                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Message Doctor'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                      'Write your message to the doctor:'),
                                                  const SizedBox(height: 10),
                                                  TextField(
                                                    controller:
                                                        messageController,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Enter your message here...',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // Close dialog without sending
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Send the message (simulated here)
                                                    final message =
                                                        messageController.text
                                                            .trim();
                                                    if (message.isNotEmpty) {
                                                      // In real implementation, save the message to Firebase or handle accordingly
                                                      print(
                                                          'Message sent to the doctor: $message');
                                                      Navigator.pop(
                                                          context); // Close dialog after sending
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Message sent: $message')),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Please write a message before sending.'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Send'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.message),
                                        label: const Text('Message Doctor'),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: () {
                                          // View Doctor's Diagnoses
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Doctor\'s Diagnoses'),
                                              content:
                                                  const SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      title: Text('Akinyi'),
                                                      subtitle: Text(
                                                          'Diagnosis: Mild dehydration'),
                                                    ),
                                                    ListTile(
                                                      title: Text('Kemboi'),
                                                      subtitle: Text(
                                                          'Diagnosis: Hypertension'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('receve'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.fact_check),
                                        label: const Text('View Diagnoses'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
