import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Server Ping',
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
  String _serverResponse = 'Server response will be shown here';

  Future<void> _pingServer() async {
    final response = await http
        .get(Uri.parse('http://<your-flask-server-ip>:<port>/some-endpoint'));

    if (response.statusCode == 200) {
      setState(() {
        _serverResponse = response.body;
      });
    } else {
      setState(() {
        _serverResponse = 'Failed to load response from server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Server Ping'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Ping Server'),
              onPressed: _pingServer,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(_serverResponse),
            ),
          ],
        ),
      ),
    );
  }
}
