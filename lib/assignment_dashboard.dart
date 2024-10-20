import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // To format dates

class AssignmentDashboard extends StatefulWidget {
  @override
  _AssignmentDashboardState createState() => _AssignmentDashboardState();
}

class _AssignmentDashboardState extends State<AssignmentDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showUpcoming = true; // Toggle for showing upcoming vs overdue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_showUpcoming ? Icons.event_available : Icons.event_busy),
            onPressed: () {
              setState(() {
                _showUpcoming = !_showUpcoming;
              });
            },
            tooltip: _showUpcoming ? 'Show Overdue' : 'Show Upcoming',
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('assignments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final assignments = snapshot.data!.docs;
          DateTime now = DateTime.now();

          // Filter assignments based on due date
          List<DocumentSnapshot> filteredAssignments = assignments.where((assignment) {
            DateTime dueDate = assignment['dueDate'].toDate();
            if (_showUpcoming) {
              return dueDate.isAfter(now); // Show upcoming assignments
            } else {
              return dueDate.isBefore(now); // Show overdue assignments
            }
          }).toList();

          return ListView.builder(
            itemCount: filteredAssignments.length,
            itemBuilder: (context, index) {
              var assignment = filteredAssignments[index];
              DateTime dueDate = assignment['dueDate'].toDate();
              String formattedDate = DateFormat('yyyy-MM-dd').format(dueDate);

              return ListTile(
                title: Text(assignment['title']),
                subtitle: Text('Due Date: $formattedDate'),
                trailing: Text('Questions: ${assignment['questions'].length}'),
              );
            },
          );
        },
      ),
    );
  }
}
