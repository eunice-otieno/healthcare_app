import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordsListPage extends StatelessWidget {
  const HealthRecordsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('healthRecords').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading records'));
          }

          final healthRecords = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: healthRecords.length,
            itemBuilder: (context, index) {
              final record =
                  healthRecords[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(record['patientName']),
                subtitle: Text('Symptoms: ${record['symptoms']}'),
                onTap: () {
                  // Navigate to Health Record Details Page (optional)
                },
              );
            },
          );
        },
      ),
    );
  }
}
