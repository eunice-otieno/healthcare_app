import 'package:flutter/material.dart';

// Simulated lab request data
class LabRequest {
  final String id;
  final String patientName;
  final String testType;
  final String status;

  LabRequest({
    required this.id,
    required this.patientName,
    required this.testType,
    required this.status,
  });
}

class LabRequestPage extends StatelessWidget {
  final String doctorId;

  LabRequestPage({Key? key, required this.doctorId}) : super(key: key);

  // Simulated lab requests list
  final List<LabRequest> labRequests = [
    LabRequest(id: '1', patientName: 'John Doe', testType: 'Blood Test', status: 'Pending'),
    LabRequest(id: '2', patientName: 'Jane Smith', testType: 'Urine Test', status: 'Completed'),
    LabRequest(id: '3', patientName: 'Alice Johnson', testType: 'X-ray', status: 'In Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Lab Requests'),
      ),
      body: ListView.builder(
        itemCount: labRequests.length,
        itemBuilder: (context, index) {
          var labRequest = labRequests[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.medical_services, color: Colors.blue),
              title: Text(labRequest.patientName),
              subtitle: Text('Test: ${labRequest.testType}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LabRequestDetailPage(
                      labRequestId: labRequest.id,  // Pass the lab request ID
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LabRequestDetailPage extends StatelessWidget {
  final String labRequestId;

  LabRequestDetailPage({Key? key, required this.labRequestId}) : super(key: key);

  // Simulated lab request details data
  final Map<String, LabRequest> labRequestDetails = {
    '1': LabRequest(id: '1', patientName: 'John Doe', testType: 'Blood Test', status: 'Pending'),
    '2': LabRequest(id: '2', patientName: 'Jane Smith', testType: 'Urine Test', status: 'Completed'),
    '3': LabRequest(id: '3', patientName: 'Alice Johnson', testType: 'X-ray', status: 'In Progress'),
  };

  @override
  Widget build(BuildContext context) {
    var labRequest = labRequestDetails[labRequestId];

    if (labRequest == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Lab Request Details'),
        ),
        body: Center(
          child: Text('Lab request not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Lab Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Name: ${labRequest.patientName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Test Type: ${labRequest.testType}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${labRequest.status}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.