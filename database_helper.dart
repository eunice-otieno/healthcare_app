import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Import Firebase Auth with alias
import 'models/user.dart'; // Import your custom User model

class FirestoreHelper {
  // Firebase Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance; // Correct FirebaseAuth reference

  // Collections
  static const userCollection = 'users';
  static const appointmentCollection = 'appointments';
  static const symptomCollection = 'symptoms';
  static const medicationCollection = 'medications';

  // Singleton pattern
  FirestoreHelper._privateConstructor();
  static final FirestoreHelper instance = FirestoreHelper._privateConstructor();

  // Insert a new user (without password)
  Future<void> insertUser(User user) async {
    // Use your local User model
    try {
      // Get the current user from Firebase Authentication
      firebase_auth.User? currentUser =
          _auth.currentUser; // Corrected usage of firebase_auth.User

      if (currentUser != null) {
        // Use Firebase Auth UID as the document ID
        await _firestore
            .collection(userCollection)
            .doc(currentUser.uid)
            .set(user.toMap());
        print("User inserted successfully!");
      } else {
        print("No user is logged in");
      }
    } catch (e) {
      print("Error inserting user: $e");
    }
  }

  // Insert an appointment
  Future<void> insertAppointment(Map<String, dynamic> appointment) async {
    try {
      await _firestore.collection(appointmentCollection).add(appointment);
    } catch (e) {
      print("Error inserting appointment: $e");
    }
  }

  // Insert a symptom
  Future<void> insertSymptom(Map<String, dynamic> symptom) async {
    try {
      await _firestore.collection(symptomCollection).add(symptom);
    } catch (e) {
      print("Error inserting symptom: $e");
    }
  }

  // Insert a medication record
  Future<void> insertMedication(Map<String, dynamic> medication) async {
    try {
      await _firestore.collection(medicationCollection).add(medication);
    } catch (e) {
      print("Error inserting medication: $e");
    }
  }

  // Fetch appointments for a patient
  Future<List<Map<String, dynamic>>> getAppointments(String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(appointmentCollection)
          .where('patientId', isEqualTo: patientId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching appointments: $e");
      return [];
    }
  }

  // Fetch symptoms for a patient
  Future<List<Map<String, dynamic>>> getSymptoms(String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(symptomCollection)
          .where('patientId', isEqualTo: patientId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching symptoms: $e");
      return [];
    }
  }

  // Fetch medication for a patient
  Future<List<Map<String, dynamic>>> getMedications(String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(medicationCollection)
          .where('patientId', isEqualTo: patientId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching medications: $e");
      return [];
    }
  }

  // Fetch user by ID using Firebase Authentication UID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection(userCollection).doc(userId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}
