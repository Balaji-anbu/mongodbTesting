
import 'dart:convert';

import 'package:crypto/crypto.dart';

class AuthService {
  static String? _currentUserEmail;

  static void setLoggedIn(String email) {
    _currentUserEmail = email;
  }

  static void logout() {
    _currentUserEmail = null;
  }

  static String? getCurrentUserEmail() {
    return _currentUserEmail;
  }

  static bool isLoggedIn() {
    return _currentUserEmail != null;
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
