import 'package:flutter/material.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitoring App'),
        backgroundColor: const Color.fromARGB(255, 175, 173, 76),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background2.jpg', // Replace with your image path
              fit: BoxFit.cover, // Ensure it covers the entire screen
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the Health Monitoring App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 175, 158, 76), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  ),
                  child: Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 165, 175, 76), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
