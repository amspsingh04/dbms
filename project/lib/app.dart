import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Flask App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String apiUrl =
      'http://YOUR_SERVER_IP:5000'; // Replace with your server IP

  Future<List<dynamic>> _fetchStudents() async {
    final response = await http.get(Uri.parse('$apiUrl/student'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<http.Response> _addStudent(Map<String, dynamic> studentData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add_student'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(studentData),
    );
    return response;
  }

  // UI Widget to add a student
  Widget _buildAddStudentWidget() {
    final TextEditingController studentIdController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController hostelIdController = TextEditingController();

    return ElevatedButton(
      onPressed: () async {
        // Collecting student data
        Map<String, dynamic> studentData = {
          'studentId': studentIdController.text,
          'name': nameController.text,
          'email': emailController.text,
          'hostelId': hostelIdController.text,
        };

        // Sending post request to add student
        final response = await _addStudent(studentData);
        if (response.statusCode == 201) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Student added successfully!'),
          ));
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add a student.'),
          ));
        }
      },
      child: Text('Add Student'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter & Flask App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final students = await _fetchStudents();
                // You can now use the list of students in your UI
              },
              child: Text('Get Students'),
            ),
            _buildAddStudentWidget(),
            // ... Add other buttons and corresponding methods for rest of your CRUD operations,
          ],
        ),
      ),
    );
  }
}
