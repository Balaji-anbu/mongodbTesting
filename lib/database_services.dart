
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static Db? db;
  static DbCollection? usersCollection;  // Renamed to be more specific

  static const MONGO_URL = "mongodb://mongo:xYsbASnLgBNpcNSuMNVvfNaZlvgjgLYO@maglev.proxy.rlwy.net:23990";
  static const String USERS_COLLECTION = "users";  // Keep the same collection name

  /// Connect to MongoDB
  static Future<void> connect() async {
    try {
      print("Attempting to connect to MongoDB at $MONGO_URL");
      db = await Db.create(MONGO_URL);
      await db!.open();
      usersCollection = db!.collection(USERS_COLLECTION);
      
      // Create index on email for faster queries and to ensure uniqueness
      await usersCollection!.createIndex(keys: {'email': 1}, unique: true);
      
      print("✅ Connected to MongoDB!");
    } catch (e) {
      print("❌ Error connecting to MongoDB: $e");
      rethrow;
    }
  }

  /// Find user by email
  static Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    if (usersCollection == null) {
      print("❌ Database not connected!");
      return null;
    }
    try {
      var user = await usersCollection!.findOne(where.eq('email', email));
      return user;
    } catch (e) {
      print("❌ Error finding user by email: $e");
      throw e;
    }
  }

  /// Insert User Data (unchanged, but now used for user registration)
  static Future<void> insertUser(Map<String, dynamic> user) async {
    if (usersCollection == null) {
      print("❌ Database not connected!");
      return;
    }
    try {
      await usersCollection!.insertOne(user);
      print("✅ User Inserted: ${user['email']}");
    } catch (e) {
      print("❌ Error inserting user: $e");
      throw e;
    }
  }

  /// Fetch All Users (keep for admin purposes)
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    if (usersCollection == null) {
      print("❌ Database not connected!");
      return [];
    }
    try {
      final users = await usersCollection!.find().toList();
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