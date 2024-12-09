import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'firebase_options.dart'; // Firebase configuration
import 'landing_page.dart'; // Landing page
import 'sign_up.dart'; // Sign-up page
import 'login.dart'; // Login page
import 'patient_dashboard.dart'; // Patient dashboard
import 'doctor_dashboard.dart'; // Doctor dashboard
import 'admin_dashboard.dart'; // Admin dashboard

void main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  get userId => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Landing page is the default route
      onGenerateRoute: (settings) {
        // Handle dynamic routes
        switch (settings.name) {
          case '/patient_dashboard':
            final args = settings.arguments as Map<String, dynamic>;
            final userId = args['userId']; // Extract userId from arguments
            return MaterialPageRoute(
              builder: (context) => PatientDashboard(userId: userId, patientId: '',),
            );

          case '/doctor_dashboard':
            final args = settings.arguments as Map<String, dynamic>?;
            final userId =
                args?['userId']; // Extract userId from arguments if needed
            return MaterialPageRoute(
              builder: (context) => DoctorDashboard(userId: userId),
            );

          case '/admin_dashboard':
          final args = settings.arguments as Map<String, dynamic>?;
            final userId =
                args?['userId'];
// Extract userData from arguments
            return MaterialPageRoute(
              builder: (context) => AdminDashboard(userId: userId),
            );

          default:
            return null; // Undefined route fallback
        }
      },
      routes: {
        '/': (context) => const LandingPage(), // Landing page
        '/signup': (context) => const SignUpPage(), // Sign-up page
        '/login': (context) => const LoginPage(), // Login page
      },
    );
  }
}
