import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'teacher_dashboard.dart'; // import your TeacherDashboard
import 'teacher_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyC_FCtIII5itHLvwmN7a-CS1aE1a8DtLLg",
  authDomain: "test1-8f2e2.firebaseapp.com",
  projectId: "test1-8f2e2",
  storageBucket: "test1-8f2e2.appspot.com",
  messagingSenderId: "280122613736",
  appId: "1:280122613736:web:1188ac45cd25b80a044e5d",
  measurementId: "G-72R3HC9F96", // Optional
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Assignment App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.deepOrange,
        ),
      ),
      home: TeacherLogin(),  // Start with the login screen
    );
  }
}
