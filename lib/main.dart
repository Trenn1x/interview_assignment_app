import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'assignment_form.dart';
import 'assignment_dashboard.dart'; // Import the dashboard

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyC_FCtIII5itHLvwmN7a-CS1aE1a8DtLLg",
  authDomain: "test1-8f2e2.firebaseapp.com",
  projectId: "test1-8f2e2",
  storageBucket: "test1-8f2e2.appspot.com",
  messagingSenderId: "280122613736",
  appId: "1:280122613736:web:1188ac45cd25b80a044e5d",
  measurementId: "G-72R3HC9F96",  // You can optionally remove this line if not needed
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures Firebase is initialized
  await Firebase.initializeApp(
    options: firebaseConfig,  // Initialize Firebase with your configuration
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Assignment App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignmentForm()),
                );
              },
              child: Text('Create Assignment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignmentDashboard()), // Navigate to Dashboard
                );
              },
              child: Text('View Assignments'),
            ),
          ],
        ),
      ),
    );
  }
}


