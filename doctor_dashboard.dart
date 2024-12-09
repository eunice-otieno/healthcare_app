import 'package:firebase_auth/firebase_auth.dart'; // Add FirebaseAuth import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'patient_details_page.dart';
class DoctorDashboard extends StatelessWidget {
  final int userId;
  const DoctorDashboard({super.key, required this.userId});

  // Fetch doctor data from Firestore
  Future<Map<String, dynamic>?> fetchDoctorData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return doc.data();
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
    return null;
  }

  // Fetch assigned patients to the doctor
  Future<List<Patient>> fetchPatients() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final patientsSnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .where('assignedDoctorId', isEqualTo: user.uid)
            .get();

        return patientsSnapshot.docs.map((doc) {
          return Patient(
           
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: FutureBuilder<Map<String, dynamic>?>(  // Display doctor name dynamically
          future: fetchDoctorData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Doctor Dashboard');
            }
            final doctorName = snapshot.data?['name'] ?? 'Dr. Unknown';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Doctor Dashboard'),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    const SizedBox(width: 6),
                    Text(doctorName, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 38, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dr. davinx', // Dynamic name from Firestore
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'davinx.@gmail.com', // Dynamic email from Firestore
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                // Navigate to profile page (to be implemented)
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Appointments'),
              onTap: () {
                // Show appointments in a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Appointments'),
                      content: const SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Kemboi'),
                              subtitle: Text('2024-12-06 at 10:00 AM'),
                            ),
                            ListTile(
                              title: Text('Cate'),
                              subtitle: Text('2024-12-07 at 2:00 PM'),
                            ),
                            ListTile(
                              title: Text('Eunice'),
                              subtitle: Text('2024-12-08 at 9:00 AM'),
                            ),
                            ListTile(
                              title: Text('Akinyi'),
                              subtitle: Text('2024-12-09 at 1:00 PM'),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate to login
              },
            ),
          ],
        ),
      ),
      body: Stack(
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
                  const Text(
                    'Assigned Patients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 120),
                  FutureBuilder<List<Patient>>(
                    future: fetchPatients(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error fetching patients'));
                      }
                      final patients = snapshot.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          final patientDocRef = FirebaseFirestore.instance
                              .collection('patients')
                              .doc(patient.name as String?); // Get reference using patient name
                          
                          return Card(
                            child: ListTile(
                              leading:
                                  const Icon(Icons.person, color: Colors.blue),
                              title: Text(patient.name as String),
                              subtitle: Text('Condition: ${patient.condition}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // Navigate to PatientDetailsPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientDetailsPage(
                                      patientDocRef: patientDocRef, initialPatientName: '', initialCondition: '', patientName: '', condition: '',  // Pass doc reference
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          // Navigate to Add Note page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNotePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.note_add),
                        label: const Text('Diagnoses'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          // Navigate to Lab Request page (to be implemented)
                          Navigator.pushNamed(context, '/lab_requests');
                        },
                        icon: const Icon(Icons.medical_services),
                        label: const Text('View Lab Requests'),
                      ),
                    ],
                  ),
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.green,
      ),
      onPressed: () {
        // Navigate to Add Note page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddNotePage(),
          ),
        );
      },
      icon: const Icon(Icons.note_add),
      label: const Text('Notes'),
    ),
    
  ],
),
const SizedBox(height: 8), // Add spacing between rows
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.purple,
      ),
      onPressed: () {
        // Show sample data for "Review Reports"
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reports to Review'),
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Lab Report for Kemboi'),
                    subtitle: Text('Blood test results: Normal'),
                  ),
                  ListTile(
                    title: Text('X-ray Report for Cate'),
                    subtitle: Text('No fractures detected'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('send'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.description),
      label: const Text('Review Reports'),
    ),
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.blue,
      ),
      onPressed: () {
        // Show sample data for "Send Recommendations"
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Recommendations to Patients'),
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('For Kemboi'),
                    subtitle: Text('Continue current medication for 1 week.'),
                  ),
                  ListTile(
                    title: Text('For Cate'),
                    subtitle: Text('Increase water intake and light exercises.'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('send'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.recommend),
      label: const Text('Send Recommendations'),
    ),
  ],
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Patient {
  get condition => String;
  
  Type get name => String;
}
