abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> signup(String name, String email, String password, String confirmPassword);
  Future<Map<String, dynamic>> sendOtp(String email);
  Future<Map<String, dynamic>> verifyOtp(String otp, String email);
  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword);
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword);
}
