import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Server Record Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Changed _serverResponse to be a map to store parsed JSON response
  Map<String, dynamic> _record = {};
  String? _selectedTable;
  String? _primaryKeyValue;

  final _primaryKeyController = TextEditingController();

  Future<void> _fetchRecord() async {
    if (_selectedTable != null &&
        _primaryKeyValue != null &&
        _primaryKeyValue!.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://72ad-2401-4900-6271-5b61-a1b5-fcad-17f7-59d9.ngrok-free.app/get_record?table_name=$_selectedTable&primary_key=$_primaryKeyValue'),
          // headers are optional here, remove if not required by your server
        );

        if (response.statusCode == 200) {
          setState(() {
            // Parse the JSON response and set the _record map
            _record = json.decode(response.body);
          });
        } else {
          setState(() {
            // Set _record map to be empty and show error message
            _record = {};
            _primaryKeyValue = 'Server error: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          // Set _record map to be empty and show error message
          _record = {};
          _primaryKeyValue = 'Failed to fetch record';
        });
      }
    } else {
      setState(() {
        // Set _record map to be empty and show error message
        _record = {};
        _primaryKeyValue =
            'Please select a table and provide a non-empty primary key value';
      });
    }
  }

  @override
  void dispose() {
    _primaryKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Server Record Fetch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedTable,
              hint: Text('Select Table'),
              onChanged: (newValue) {
                setState(() {
                  _selectedTable = newValue;
                });
              },
              items: <String>[
                'student',
                'book',
                'course',
                'faculty',
                'menu',
                'mess',
                'hostel',
                'maintenance',
                'borrow',
                'enrollment',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _primaryKeyController,
              decoration: InputDecoration(
                hintText: 'Enter Primary Key Value',
              ),
              onChanged: (newValue) {
                _primaryKeyValue = newValue;
              },
            ),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
                _primaryKeyValue = _primaryKeyController
                    .text; // Update the primary key value from the controller
                _fetchRecord();
              },
              child: Text('Fetch Record'),
            ),
            // Modify this Expanded widget to display data
            Expanded(
              child: _record.isNotEmpty
                  ? ListView.builder(
                      itemCount: _record.length,
                      itemBuilder: (context, index) {
                        String key = _record.keys.elementAt(index);
                        return ListTile(
                          title: Text(key),
                          subtitle: Text(_record[key].toString()),
                        );
                      },
                    )
                  : Center(
                      child: Text(_primaryKeyValue ?? 'No record to display'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
