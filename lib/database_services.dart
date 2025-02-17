// ignore_for_file: constant_identifier_names
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static Db? db;
  static DbCollection? collection;

  static const MONGO_URL = "mongodb://192.168.1.100:27017/mydatabase";
  static const String COLLECTION_NAME = "users";

  /// Connect to MongoDB
  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_URL);
      await db!.open();
      collection = db!.collection(COLLECTION_NAME);
      print("✅ Connected to MongoDB!");
    } catch (e) {
      print("❌ Error connecting to MongoDB: $e");
    }
  }

  /// Insert User Data
  static Future<void> insertUser(Map<String, dynamic> user) async {
    if (collection == null) {
      print("❌ Database not connected!");
      return;
    }
    try {
      await collection!.insertOne(user);
      print("✅ User Inserted: $user");
    } catch (e) {
      print("❌ Error inserting user: $e");
    }
  }

  /// Fetch All Users
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    if (collection == null) {
      print("❌ Database not connected!");
      return [];
    }
    try {
      final users = await collection!.find().toList();
      return users;
    } catch (e) {
      print("❌ Error fetching users: $e");
      return [];
    }
  }

  /// Close Connection
  static Future<void> closeConnection() async {
    if (db == null) return;
    try {
      await db!.close();
      print("✅ MongoDB Connection Closed");
    } catch (e) {
      print("❌ Error closing MongoDB connection: $e");
    }
  }
}
