import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  @override
  _FetchDataState createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  String? _selectedTable;
  List<Map<String, dynamic>> _records = [];
  bool _isFetching = false; // Track if we are currently fetching data

  Future<void> _fetchRecordsForTable() async {
    if (_selectedTable != null && _selectedTable!.isNotEmpty) {
      setState(() {
        _isFetching = true; // Indicate that fetching has started
      });

      var uri = Uri.parse(
          'https://d557-2401-4900-634a-86ca-b144-3300-50ee-7251.ngrok-free.app/$_selectedTable');

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _records = data
                .map<Map<String, dynamic>>(
                    (item) => item as Map<String, dynamic>)
                .toList();
            _isFetching =
                false; // Reset fetching indicator after data is fetched
          });
        } else {
          // Handle server error
          print('Server error: ${response.statusCode}');
          setState(() {
            _isFetching = false;
          });
        }
      } catch (e) {
        // Handle exception
        print('Failed to fetch records: $e');
        setState(() {
          _isFetching = false;
        });
      }
    } else {
      // Handle user error
      print('Please select a table from the dropdown.');
    }
  }

  List<DataColumn> _createColumns() {
    if (_records.isEmpty) {
      // Show at least an empty message if the list is empty.
      return [DataColumn(label: Text('No Data'))];
    }

    return _records.first.keys
        .map((String column) => DataColumn(
              label: Text(column.toUpperCase()),
            ))
        .toList();
  }

  List<DataRow> _createRows() {
    return _records.map((Map<String, dynamic> record) {
      return DataRow(
        cells: record.values.map((dynamic value) {
          return DataCell(Text(value.toString()));
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isFetching) {
      content = Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while fetching data
      );
    } else if (_records.isEmpty) {
      content = Center(
        child: Text(
            'No records found'), // Message displayed when no records are found (or before fetching)
      );
    } else {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _createColumns(),
          rows: _createRows(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('University Dashboard'),
      ),
      body: Column(
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
          ElevatedButton(
            onPressed: _fetchRecordsForTable,
            child: Text('Fetch Records for Table'),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: content, // Display content based on the current state
            ),
          ),
        ],
      ),
    );
  }
}
