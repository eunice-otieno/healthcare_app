

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'patient_dashboard.dart'; // Import Patient Dashboard
 // Import Admin Dashboard

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

   @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Patient'; // Default role

  // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login function
  Future<void> _handleLogin() async {
    try {
      // Perform Firebase authentication

      // Fetch user data from Firestore (to check the role and associated data)
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc() // Use Firebase User ID
          .get();

      

        // Handle role-based navigation
         if (userDoc.exists) {
        String role = userDoc['role'] ??
            'Patient'; // Default to 'Patient' if no role is found
// Fetch patientId if available (Change)
        // Show SnackBar with success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logged in as $role'),
        ));

        // Navigate based on selected role
        if (role == 'Patient') {
       Navigator.pushReplacement(
  context, '/patient_dashboard' as Route<Object?>
 
  
);
        } else if (role == 'Doctor') {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/doctor_dashboard');
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        }
      } else {
        // Handle case where the user does not have a role in Firestore
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Role not found. Please contact admin.')),
        );
      }
    } catch (e) {
      // Handle login errors (invalid email/password, etc.)
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed: $e'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown to select user role
            DropdownButton<String>(
              value: _selectedRole,
              items: ['Patient', 'Doctor', 'Admin'].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue!; // Update selected role
                });
              },
            ),
            const SizedBox(height: 20),
            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Login Button
            ElevatedButton(
              onPressed: _handleLogin, // Call login function
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
