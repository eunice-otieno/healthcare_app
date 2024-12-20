// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_Bfq11QXhBMnUkh2HkMhoJw_nB-P3Hz0',
    appId: '1:613313238838:android:4ff65854da79327683c597',
    messagingSenderId: '613313238838',
    projectId: 'healthcare-flutter-app-5b38a',
    storageBucket: 'healthcare-flutter-app-5b38a.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKu_ABlzsgt2Cc48kzH7jB5PSp9syj_vo',
    appId: '1:613313238838:web:ca9391ebcf86489683c597',
    messagingSenderId: '613313238838',
    projectId: 'healthcare-flutter-app-5b38a',
    authDomain: 'healthcare-flutter-app-5b38a.firebaseapp.com',
    storageBucket: 'healthcare-flutter-app-5b38a.firebasestorage.app',
    measurementId: 'G-YEZRESDY0T',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQvpqpOm1IxmDXApBnX8lrPt5DMJ5kTek',
    appId: '1:613313238838:ios:71dbe1b13466382383c597',
    messagingSenderId: '613313238838',
    projectId: 'healthcare-flutter-app-5b38a',
    storageBucket: 'healthcare-flutter-app-5b38a.firebasestorage.app',
    iosBundleId: 'com.example.healthcareApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAKu_ABlzsgt2Cc48kzH7jB5PSp9syj_vo',
    appId: '1:613313238838:web:cfe81760eeefdf7f83c597',
    messagingSenderId: '613313238838',
    projectId: 'healthcare-flutter-app-5b38a',
    authDomain: 'healthcare-flutter-app-5b38a.firebaseapp.com',
    storageBucket: 'healthcare-flutter-app-5b38a.firebasestorage.app',
    measurementId: 'G-K13DNB2PB9',
  );

}