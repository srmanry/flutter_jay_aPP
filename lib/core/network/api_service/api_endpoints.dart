// lib/core/network/api_endpoints.dart

const String apiVersion = "api/v1";
//const String baseUrl = "http://localhost:8001"; // Postman baseURL থেকে
const String baseUrl = "https://backend-sonko.onrender.com/api/v1";
String get baseApiUrl => "$baseUrl/$apiVersion";

// ================= AUTH MODULE =================
class AuthEndpoints {
  static String register = "$baseApiUrl/auth/register";
  static String login = "$baseApiUrl/auth/login";
  static String refreshToken = "$baseApiUrl/auth/refresh-token";
  static String forgotPassword = "$baseApiUrl/auth/forget";
  static String verifyOtp = "$baseApiUrl/auth/verify-otp";
  static String resetPassword = "$baseApiUrl/auth/reset-password";
  static String logout = "$baseApiUrl/auth/logout";
  static String deleteAccount = "$baseApiUrl/user/delete-account";
}

// ================= PROFILE MODULE =================
class ProfileEndpoints {
  static String getProfile = "$baseApiUrl/user/profile";
  static String updateProfile = "$baseApiUrl/user/update-profile";
  static String changePassword = "$baseApiUrl/user/change-password";
}

// ================= REPORTS MODULE =================
class ReportEndpoints {
  static String createReport = "$baseApiUrl/report/";
  static String getReports = "$baseApiUrl/report/";
  static String getCoordinates = "$baseApiUrl/report/coordinates";
  static String getAlerts = "$baseApiUrl/report/alerts";
  static String getAlertById(String id) => "$baseApiUrl/report/alerts/$id";
  static String markAlertRead(String id) => "$baseApiUrl/report/alerts/$id/read";
}

// ================= ADMIN MODULE =================
class AdminEndpoints {
  static String getUsers = "$baseApiUrl/admin/users";
  static String deleteUser(String id) => "$baseApiUrl/admin/users/$id";
  static String getMonthlyStatus({required int year, required int month}) => "$baseApiUrl/admin/stats/monthly?year=$year&month=$month";
}

// ================= SETTINGS MODULE =================
class SettingsEndpoints {
  static String getSettings = "$baseApiUrl/settings/";
  static String toggleDnd = "$baseApiUrl/settings/";
}
