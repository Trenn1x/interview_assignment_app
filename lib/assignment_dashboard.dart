import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class AssignmentDashboard extends StatefulWidget {
  @override
  _AssignmentDashboardState createState() => _AssignmentDashboardState();
}

class _AssignmentDashboardState extends State<AssignmentDashboard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Placeholder function to get assignments from Firestore (you'll customize this)
  Future<List<Map<String, dynamic>>> _getAssignmentsForDay(DateTime day) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('assignments')
        .where('dueDate', isEqualTo: day)
        .get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

Map<DateTime, List<dynamic>> _events = {};

void _loadAssignments() {
  _firestore.collection('assignments').get().then((snapshot) {
    snapshot.docs.forEach((doc) {
      var assignment = doc.data() as Map<String, dynamic>;
      var dueDate = assignment['dueDate'] is Timestamp 
        ? (assignment['dueDate'] as Timestamp).toDate() 
        : DateTime.parse(assignment['dueDate']);

      if (_events[dueDate] == null) {
        _events[dueDate] = [];
      }
      _events[dueDate]?.add(assignment['title']);
    });
    setState(() {});  // Rebuild to show the events
  });
}

void _showAssignmentDetails(List<dynamic> events) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Assignment Details', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: events.map((event) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.assignment, color: Colors.deepOrange),
                  title: Text(event, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                  subtitle: Text("Add assignment questions or details here..."), 
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}


@override
void initState() {
  super.initState();
  _loadAssignments();
}

void _createNewAssignment() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create New Assignment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your form fields for assignment creation here
            TextField(
              decoration: InputDecoration(labelText: 'Assignment Title'),
              onChanged: (value) {
                // Save title value
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Due Date'),
              onTap: () {
                // Show date picker
              },
            ),
            // Add more fields as needed (questions, etc.)
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Handle saving assignment here
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Assignment Calendar')),
    body: Column(
      children: [
        TableCalendar(
          events: _events,
          calendarStyle: CalendarStyle(
            todayColor: Colors.blue,
            selectedColor: Colors.deepOrange,
          ),
          onDaySelected: (date, events, _) {
            setState(() {
              _selectedEvents = events;
            });
            if (events.isNotEmpty) {
              _showAssignmentDetails(events);
            }
          },
        ),
        // Display assignment details here if needed
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _createNewAssignment(),
      child: Icon(Icons.add),
      tooltip: 'Create New Assignment',
    ),
  );
}


);

          SizedBox(height: 20),
          _selectedDay != null
              ? FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getAssignmentsForDay(_selectedDay!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error fetching assignments');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No assignments for this day');
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var assignment = snapshot.data![index];
                            return ListTile(
                              title: Text(assignment['title']),
                              subtitle: Text(
                                  'Due: ${(assignment['dueDate'] as Timestamp).toDate()}'),
                            );
                          },
                        ),
                      );
                    }
                  },
                )
              : Text('Select a day to see assignments'),
        ],
      ),
    );
  }
}
