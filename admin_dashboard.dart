import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  final String userId;

  const AdminDashboard({super.key, required this.userId});

  // Fetch dynamic data (Total Patients, Doctors, Appointments)
  Future<Map<String, int>> fetchOverviewData() async {
    try {
      // Fetching data for Total Patients
      int totalPatients = (await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'patient')
              .get())
          .size;

      // Fetching data for Total Doctors
      int totalDoctors = (await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'doctor')
              .get())
          .size;

      // Fetching data for Total Appointments
      int totalAppointments =
          (await FirebaseFirestore.instance.collection('appointments').get())
              .size;

      // Returning data as a map
      return {
        'totalPatients': totalPatients,
        'totalDoctors': totalDoctors,
        'totalAppointments': totalAppointments
      };
    } catch (e) {
      print("Error fetching overview data: $e");
      return {'totalPatients': 0, 'totalDoctors': 0, 'totalAppointments': 0};
    }
  }

  // Fetch user details by userId (e.g., name)
  Future<String> fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] ?? 'Admin'; // Return user name if exists
      } else {
        return 'Admin'; // Default to 'Admin' if no name found
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return 'Admin'; // Default value in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, int>>(
            future: fetchOverviewData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading data"));
              }

              final overviewData = snapshot.data;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    FutureBuilder<String>(
                      future: fetchUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error loading user data"));
                        }
                        final userName = snapshot.data ?? 'Admin';
                        return _buildSectionTitle('Welcome, $userName');
                      },
                    ),

                    const SizedBox(height: 20),

                    // Overview Section (e.g., statistics)
                    _buildSectionTitle('System Overview'),
                    _buildOverviewCard('Total Patients',
                        overviewData?['totalPatients']?.toString() ?? '5'),
                    _buildOverviewCard('Total Doctors',
                        overviewData?['totalDoctors']?.toString() ?? '2'),
                    _buildOverviewCard('Total Appointments Today',
                        overviewData?['totalAppointments']?.toString() ?? '3'),

                    const SizedBox(height: 20),

                    // User Management Section
                    _buildSectionTitle('User Management'),
                    _buildNavigationCard(
                      context,
                      'View All Users',
                      Icons.person,
                      UserListPage(),
                    ),
                    _buildNavigationCard(
                      context,
                      'Approve New Users',
                      Icons.person_add,
                      ApproveUsersPage(),
                    ),

                    const SizedBox(height: 20),

                    // Appointment Management Section
                    _buildSectionTitle('Manage Appointments'),
                    _buildNavigationCard(
                      context,
                      'View All Appointments',
                      Icons.calendar_today,
                      AppointmentPage(),
                    ),

                    const SizedBox(height: 20),

                    // Health Data Management
                    _buildSectionTitle('Health Records Management'),
                    _buildNavigationCard(
                      context,
                      'View Health Records',
                      Icons.medical_services,
                      HealthRecordsPage(),
                    ),

                    const SizedBox(height: 20),

                    // Analytics & Reports
                    _buildSectionTitle('Analytics & Reports'),
                    _buildNavigationCard(
                      context,
                      'View Health Analytics',
                      Icons.show_chart,
                      AnalyticsPage(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // Helper method to create overview cards for statistics
  Widget _buildOverviewCard(String title, String count) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(count),
        leading: const Icon(Icons.info_outline),
      ),
    );
  }

  // Helper method to create navigation cards
  Widget _buildNavigationCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

// Example pages for navigation (replace with actual implementations)
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: const Center(child: Text('List of Users')),
    );
  }
}

class ApproveUsersPage extends StatelessWidget {
  const ApproveUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve New Users')),
      body: const Center(child: Text('Approve or Reject Users')),
    );
  }
}

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: const Center(child: Text('Manage Appointments')),
    );
  }
}

class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: const Center(child: Text('Manage Health Records')),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Analytics')),
      body: const Center(child: Text('View Health Analytics')),
    );
  }
}
