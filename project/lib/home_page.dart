import 'package:flutter/material.dart';
import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _databaseHelper.initializeDatabase();
  }

  Future<void> _insertData(String name) async {
    await _databaseHelper.insertData(name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter SQLite Demo'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['name']),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _insertData('Name ${DateTime.now().millisecondsSinceEpoch}'),
        tooltip: 'Insert Data',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _databaseHelper.closeDatabase();
    super.dispose();
  }
}
