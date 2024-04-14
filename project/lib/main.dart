import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'send.dart';

void main() {
  const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserListScreen(),
    );
  }
}


//https://45bd-115-240-194-54.ngrok-free.app/