// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCCblA0oQlyuEzcMwK4gsAJDSlU_qrTNnc',
    appId: '1:242814998730:web:5276f0d3c9b7a9b67ffc33',
    messagingSenderId: '242814998730',
    projectId: 'assignment-18750',
    authDomain: 'assignment-18750.firebaseapp.com',
    storageBucket: 'assignment-18750.appspot.com',
    measurementId: 'G-BS6ZP8QVZG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpxG4VmDMsx60Tr7eMJgMekhcaqJaIo5E',
    appId: '1:242814998730:android:0638e73738da2fcd7ffc33',
    messagingSenderId: '242814998730',
    projectId: 'assignment-18750',
    storageBucket: 'assignment-18750.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpAu3Cc8dLejeWXoH0cGRP_hj8cag3Iho',
    appId: '1:242814998730:ios:a489f286e884df377ffc33',
    messagingSenderId: '242814998730',
    projectId: 'assignment-18750',
    storageBucket: 'assignment-18750.appspot.com',
    iosBundleId: 'com.example.assignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpAu3Cc8dLejeWXoH0cGRP_hj8cag3Iho',
    appId: '1:242814998730:ios:f16fd7ac4c3b51ac7ffc33',
    messagingSenderId: '242814998730',
    projectId: 'assignment-18750',
    storageBucket: 'assignment-18750.appspot.com',
    iosBundleId: 'com.example.assignment.RunnerTests',
  );
}