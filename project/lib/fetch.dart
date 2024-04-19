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

  Future<void> _fetchRecordsForTable() async {
    if (_selectedTable != null && _selectedTable!.isNotEmpty) {
      var uri = Uri.parse(
          'https://d557-2401-4900-634a-86ca-b144-3300-50ee-7251.ngrok-free.app/$_selectedTable');

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          setState(() {
            _records =
                List<Map<String, dynamic>>.from(json.decode(response.body));
          });
        } else {
          // Handle server error
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle exception
        print('Failed to fetch records: $e');
      }
    } else {
      // Handle user error
      print('Please select a table from the dropdown.');
    }
  }

  List<DataColumn> _createColumns() {
    if (_records.isEmpty) {
      return [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data into DataTable'),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: _createColumns(),
                  rows: _createRows(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
