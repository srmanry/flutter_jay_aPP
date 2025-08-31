import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _accessTokenKey = "accessToken";
  static const _roleKey = "role";
  static const _isLoggedInKey = "isLoggedIn";

  // Save token and role after login
  static Future<void> saveToken({
    required String accessToken,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_roleKey, role);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Check login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear all on logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_isLoggedInKey);
  }
}
