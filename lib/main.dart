import 'package:flutter/material.dart';
import 'package:mongodb/database_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseService.connect(); // Connect to MongoDB
    runApp(MyApp());
  } catch (e) {
    print("Error connecting to MongoDB: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), 
          bodyMedium: TextStyle(color: Colors.black), 
        ),
      ),
      home: MongoDBTest(),
    );
  }
}

class MongoDBTest extends StatefulWidget {
  @override
  _MongoDBExampleState createState() => _MongoDBExampleState();
}

class _MongoDBExampleState extends State<MongoDBTest> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    var data = await DatabaseService.fetchUsers();
    setState(() {
      users = data;
    });
  }

  Future<void> addUser() async {
    await DatabaseService.insertUser({"name": "Alice", "age": 27});
    loadUsers(); // Reload data after inserting
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MongoDB Data",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),backgroundColor: Colors.black,),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView(
              children: snapshot.data!.map((user) => ListTile(
                title: Text(user["name"]),
                subtitle: Text("Age: ${user["age"]}"),
              )).toList(),
            );
          }
        },
      ),
    );
  }
}


