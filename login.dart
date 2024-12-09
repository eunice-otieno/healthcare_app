import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_app/patient_dashboard.dart'; // Import Patient Dashboard
import 'package:healthcare_app/admin_dashboard.dart'; // Import Admin Dashboard
import 'package:healthcare_app/doctor_dashboard.dart'; // Import Doctor Dashboard
// Import Admin Dashboard
import 'package:carousel_slider/carousel_slider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Patient'; // Default role

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> imgList = [
    'assets/logo.jpg',
    'assets/logo.jpg',
    'assets/logo.jpg',
  ];
  // Login function
  Future<void> _handleLogin() async {
    try {
      // Perform Firebase authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetch user data from Firestore (to check the role and associated data)
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid) // Use Firebase User ID
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String role = userData['role'] ?? 'Patient'; // Default role: Patient
        int userId =
            userData['userId']?.toInt() ?? 0; // Ensure userId is an integer

        // Handle role-based navigation
        if (role == 'Patient') {
          // Navigate to Patient Dashboard with userId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDashboard(
                userId: userId,
                patientId: '',
              ),
            ),
          );
        } else if (role == 'Doctor') {
          // Navigate to Doctor Dashboard with userId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDashboard(userId: userId),
            ),
          );
        } else if (role == 'Admin') {
          // Navigate to Admin Dashboard without requiring userId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboard(
                userId: '',
              ),
            ),
          );
        } else {
          // Handle other roles here (if applicable)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Role not implemented yet!')),
          );
        }
      } else {
        // Handle case where user does not exist in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User data not found. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          
Positioned.fill(
            child: Image.asset(
              'assets/logo.jpg', // Replace with your image path
              fit: BoxFit.cover, // Ensure it covers the entire screen
            ),
          ),
          // Carousel slider as the background
          Positioned.fill(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
              ),
              items: [
                'assets/logo.jpg', // Add more images here if needed
                'assets/logo.jpg',
                'assets/logo.jpg',
              ].map((item) => Image.asset(item, fit: BoxFit.cover)).toList(),
            ),
          ),
          // Login form overlay
          Center(
            child: SingleChildScrollView(
              child: Padding(
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
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password input field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
