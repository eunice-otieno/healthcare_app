import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore user data storage
import 'package:carousel_slider/carousel_slider.dart'; // For Carousel Slider

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'Patient'; // Default role

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of images for carousel (you can keep your carousel if needed)
  final List<String> imgList = [
    'assets/logo.jpg',
    'assets/logo.jpg',
    'assets/logo.jpg',
  ];

  // Sign-up function
  Future<void> _signUp() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        // Firebase Authentication: Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Generate an integer userId for the new user
        int newUserId = await _generateUserId();

        // Create user data in Firestore with email, name, role, and userId as integer
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': _emailController.text
              .trim(), // You can use another field for the name
          'email': _emailController.text.trim(),
          'role': _selectedRole, // Store the selected role
          'userId': newUserId, // Store the integer userId
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User registered successfully!'),
        ));

        // Navigate to login page after successful sign-up
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        // Handle sign-up errors (e.g., weak password, email already in use)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign-up failed: ${e.message}'),
        ));
      }
    } else {
      // Show error if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Passwords do not match! Please check and try again.')),
      );
    }
  }

  // Function to generate a new integer userId by checking the user count
  Future<int> _generateUserId() async {
    // Get the current number of users in Firestore
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    int userCount = snapshot.size; // Get the total number of users

    // Generate a new userId (this is just an example, you can use any logic here)
    return userCount +
        1; // Assuming user IDs start from 1 and increase sequentially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 162, 76, 175),
      ),
      body: Stack(
        children: [
          // Background image or carousel slider as background image
          Positioned.fill(
            child: Image.asset(
              'assets/logo.jpg', // Replace with your image path
              fit: BoxFit.cover, // Ensure it covers the entire screen
            ),
          ),
          // Carousel slider (optional)
          Positioned.fill(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true, // Auto-slide
                enlargeCenterPage: true, // Larger center image
                aspectRatio: 16 / 9, // Aspect ratio
                enableInfiniteScroll: true, // Infinite scrolling
                viewportFraction: 1.0, // Display one image at a time
              ),
              items: imgList
                  .map((item) => Image.asset(item, fit: BoxFit.cover))
                  .toList(),
            ),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Dropdown for selecting user role
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
                          _selectedRole = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email input
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(0.7), // No const here
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password input
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(0.7), // No const here
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    // Confirm password input
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(0.7), // No const here
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Sign-up button
                    ElevatedButton(
                      onPressed: _signUp, // Call the sign-up function
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 175, 76, 168),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                      ),
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 20),
                    // Already have an account? Navigate to login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/login'); // Navigate to login page
                      },
                      child: const Text('Already have an account? Log In'),
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
