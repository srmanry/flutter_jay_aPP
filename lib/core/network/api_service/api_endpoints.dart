// lib/core/network/api_endpoints.dart

// ================= BASE CONFIG =================

const String apiVersion = "api/v1";


 const String baseUrl = "http://localhost:8001";
//const String baseUrl = "https://shyfinance-backend.onrender.com";

String get baseApiUrl => "$baseUrl/$apiVersion";

// ================= AUTH MODULE =================

class AuthEndpoints {
  static String register = "$baseApiUrl/auth/register";
  static String login = "$baseApiUrl/auth/login";
  static String verifyEmail = "$baseApiUrl/auth/verify";
  static String forgotPassword = "$baseApiUrl/auth/forget";
  static String verifyOtp = "$baseApiUrl/auth/verify-otp";
  static String resetPassword = "$baseApiUrl/auth/reset-password";
  static String changePassword = "$baseApiUrl/auth/change-password";
  static String refreshToken = "$baseApiUrl/auth/refresh-token";
  static String logout = "$baseApiUrl/auth/logout";
}

// ================= PROFILE / USER MODULE =================

class UserEndpoints {
  static String getProfile = "$baseApiUrl/user/profile";
  static String updateProfile = "$baseApiUrl/user/update-profile";
  static String changePassword = "$baseApiUrl/user/change-password";
  static String deleteAccount = "$baseApiUrl/user/delete-account";
}

// ================= REPORT MODULE =================

class ReportEndpoints {
  static String create = "$baseApiUrl/report";
  static String getAll = "$baseApiUrl/report";
  static String getCoordinates = "$baseApiUrl/report/coordinates";
  static String getAlerts = "$baseApiUrl/report/alerts";

  static String alertById(String alertId) => "$baseApiUrl/report/alerts/$alertId";

  static String markAlertAsRead(String alertId) => "$baseApiUrl/report/alerts/$alertId/read";
}

// ================= ADMIN MODULE =================

class AdminEndpoints {
  static String getUsers = "$baseApiUrl/admin/users";

  static String deleteUser(String userId) => "$baseApiUrl/admin/users/$userId";

  static String monthlyStats({required int year, required int month}) => "$baseApiUrl/admin/stats/monthly?year=$year&month=$month";
}

// ================= SETTINGS MODULE =================

class SettingsEndpoints {
  static String getSettings = "$baseApiUrl/settings";
  static String updateSettings = "$baseApiUrl/settings";
}

// ================= TRIP ROUTES MODULE =================

class TripEndpoints {
  static String startTrip = "$baseApiUrl/trip";
  static String myTrips = "$baseApiUrl/trip/me";
  static String activeTrip = "$baseApiUrl/trip/me/active";

  static String markReached(String tripRouteId) => "$baseApiUrl/trip/$tripRouteId/reach";
}

// ================= OCCURRENCE POINTS =================

class OccurrenceEndpoints {
  static String create = "$baseApiUrl/occurrence";
  static String getAll = "$baseApiUrl/occurrence";
}

// ================= SUBSCRIPTION MODULE =================

class SubscriptionEndpoints {
  static String getAll = "$baseApiUrl/subscription";

  static String byId(String subscriptionId) => "$baseApiUrl/subscription/$subscriptionId";

  static String create = "$baseApiUrl/subscription";

  static String update(String subscriptionId) => "$baseApiUrl/subscription/$subscriptionId";

  static String delete(String subscriptionId) => "$baseApiUrl/subscription/$subscriptionId";
}

// ================= PAYMENT MODULE =================

class PaymentEndpoints {
  static String createPayment = "$baseApiUrl/payment/create-payment";
  static String confirmPayment = "$baseApiUrl/payment/confirm-payment";
}
