import 'package:flutter/material.dart';
import 'home.dart'; // Home page widget (you should have it implemented in home.dart)
import 'fetch.dart'; // FetchData widget (the one described to display data in a table format)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Server Record Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  // Lazy loading of the widgets to preserve state independently
  final List<Widget> _children = [
    HomePage(), // Make sure this is a const constructor if possible
    FetchData(), // FetchData should have a non-const constructor due to dynamic content
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Using IndexedStack to maintain state when switching tabs
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Fetch Data',
          ),
        ],
      ),
    );
  }
}
