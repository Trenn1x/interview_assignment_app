import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentForm extends StatefulWidget {
  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _selectedDueDate = DateTime.now();
  List<String> _questions = [];
  List<String> _students = [];
  final _questionController = TextEditingController();
  final _studentController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Badge logic (for simplicity, we'll use a hardcoded badge name for now)
  String badgeName = 'Animal Adventurer'; // Example badge

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      print('Starting form submission...');
      print('Assignment Title: $_title');
      print('Selected Due Date: $_selectedDueDate');
      print('Questions: $_questions');
      print('Students: $_students');
      
      // Save assignment data to Firestore
      DocumentReference assignmentRef = await _firestore.collection('assignments').add({
        'title': _title,
        'dueDate': _selectedDueDate,
        'questions': _questions,
        'students': _students,
        'created_at': Timestamp.now(),
      });

      print('Assignment added successfully to Firestore with ID: ${assignmentRef.id}');

      // Badge logic (simplified for now)
      for (String student in _students) {
        print('Checking badges for student: $student');
        
        DocumentSnapshot studentDoc = await _firestore.collection('users').doc(student).get();
        if (studentDoc.exists) {
          List<dynamic> badges = studentDoc.get('badges') ?? [];
          print('Current badges for $student: $badges');
          
          badges.add(badgeName); // Add badge to student's profile
          await _firestore.collection('users').doc(student).update({
            'badges': badges,
          });
          
          print('Badge awarded to student: $student');
        } else {
          print('Student document not found for: $student');
        }
      }

      // Success message
      print('Form submission successful: Assignment and badges updated');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assignment and badge awarded successfully!')),
      );

      // Reset the form
      _formKey.currentState!.reset();
      setState(() {
        _questions.clear();
        _students.clear();
      });
      
    } catch (e) {
      print('Error while submitting the form: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not add assignment.')),
      );
    }
  } else {
    print('Form validation failed');
  }
}

  // Function to handle date picker
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Assignment Title Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Assignment Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                // Due Date Picker
                Row(
                  children: [
                    Text(
                      'Due Date: ${_selectedDueDate.toLocal()}'.split(' ')[0],
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () => _selectDueDate(context),
                      child: Text('Select Due Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Questions Field
                Text('Questions:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_questions[index]),
                    );
                  },
                ),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Add a Question'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      setState(() {
                        _questions.add(_questionController.text);
                        _questionController.clear();
                      });
                    }
                  },
                  child: Text('Add Question'),
                ),
                SizedBox(height: 20),
                // Student Names Field
                Text('Student Names:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_students[index]),
                    );
                  },
                ),
                TextFormField(
                  controller: _studentController,
                  decoration: InputDecoration(labelText: 'Add a Student Name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_studentController.text.isNotEmpty) {
                      setState(() {
                        _students.add(_studentController.text);
                        _studentController.clear();
                      });
                    }
                  },
                  child: Text('Add Student'),
                ),
                SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

