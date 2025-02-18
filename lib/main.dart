import 'package:flutter/material.dart';
import 'package:mongodb/database_services.dart';

import 'package:mongodb/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseService.connect(); // Connect to MongoDB
    runApp(MyApp());
  } catch (e) {
    print("Error connecting to MongoDB: $e");
    runApp(ErrorApp(error: e.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Error connecting to MongoDB: $error", style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MongoDB Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), 
          bodyMedium: TextStyle(color: Colors.black), 
        ),
      ),
      home: LoginScreen(),
    );
  }
}