/* import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/common/custom_massage.dart';
import 'package:spotem/core/network/api_service/token_meneger.dart';
import 'package:spotem/core/utils/app_colors.dart';
import 'package:spotem/feature/auth/domain/auth_repo.dart';
import 'package:spotem/feature/auth/presentation/view/otp_code_screen.dart';
import 'package:spotem/feature/auth/repo/auth_repo.dart';
import 'package:spotem/feature/splash/view/splash_screen_view.dart';

import '../../profile/presentation/view/about_app_screen.dart';
import '../../profile/presentation/view/pricacy_screen.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  // Loading & State variables
  final isLoading = false.obs;
  final isLogin = false.obs;
  final isSignup = false.obs;
  final sentOtp = false.obs;
  final isVerfiyOtp = false.obs;
  final isResetPassword = false.obs;
  final rememberMe = false.obs;
  final iAgree = false.obs;

  var isUpdateingProfile = false.obs;

  var isSentOtp = false.obs;
  var isOTPverified = false.obs;

  // Text Controllers
  final emailController = TextEditingController();
  final singinemailcontroller = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final signupPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthController(this._authRepository);

  void toggleRemember(bool value) => rememberMe.value = value;

  void toggleRegister(bool value) => rememberMe.value = value;

  void termOfService() {
    Get.to(() => PrivacyPolicyView());
  }

  void privacyPolicy() {
    Get.to(() => AboutAppScreen());
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();
  }

  void clearSignupFields() {
    nameController.clear();
    singinemailcontroller.clear();
    signupPassword.clear();
    confirmPassword.clear();
  }

  // ──────────────────────────────────────────────
  //                  LOGIN
  // ──────────────────────────────────────────────
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validation
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required", colorText: Colors.red);
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Invalid email format", colorText: Colors.red);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required", colorText: Colors.red);
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", colorText: Colors.red);
      return;
    }

    try {
      isLogin.value = true;

      final result = await _authRepository.login(email, password);

      if (result["success"] == true) {
        final accessToken = result["data"]["accessToken"];
        final refreshToken = result["data"]["refreshToken"] ?? "";

        await TokenManager.saveToken(accessToken: accessToken, refreshToken: refreshToken);
        CustomShowMessage.success(message: "Login Successful");
        //Get.snackbar("Success", "Login Successful", colorText: AppColors.appColor, snackPosition: SnackPosition.TOP);

        clearLoginFields();
        Get.offAll(() => AppGroundView(currentIndex: 0));
      } else {
        final message = result["message"] ?? "Invalid credentials";
        CustomShowMessage.error(message: message);
      }
    } on DioException catch (e) {
      String errorMsg = "Network error";

      if (e.response?.data != null && e.response?.data is Map) {
        errorMsg = e.response?.data["message"] ?? "Login failed";
      }

      CustomShowMessage.error(message: errorMsg);
    } catch (e) {
      CustomShowMessage.error(message: "An unexpected error occurred");
    } finally {
      isLogin.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //                  SIGNUP
  // ──────────────────────────────────────────────
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // Validation
    if (name.isEmpty) {
      Get.snackbar("Error", "Name is required", colorText: Colors.red);
      return;
    }
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required", colorText: Colors.red);
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Invalid email format", colorText: Colors.red);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required", colorText: Colors.red);
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", colorText: Colors.red);
      return;
    }
    if (password != confirmPass) {
      Get.snackbar("Error", "Passwords do not match", colorText: Colors.red);
      return;
    }

    try {
      isSignup.value = true;

      final result = await _authRepository.signup(name, email, password);

      if (result["success"] == true) {
        CustomShowMessage.success(message: "Signup Successful");
        // Get.snackbar("Success", "Signup Successful! Please login", colorText: AppColors.appColor, snackPosition: SnackPosition.TOP);

        clearSignupFields();
        //Get.off(() => LoginScreenView());
      } else {
        String message = result["message"] ?? "Signup failed";

        if (message.toLowerCase().contains("already") || message.toLowerCase().contains("exist")) {
          //  Get.snackbar("Error", "User already registered", colorText: Colors.red);

          CustomShowMessage.error(message: "User already registered");
        } else {
          Get.snackbar("Error", message, colorText: Colors.red);
        }
      }
    } on DioException catch (e) {
      String errorMsg = "Signup failed";

      if (e.response?.data != null && e.response?.data is Map) {
        errorMsg = e.response?.data["message"] ?? errorMsg;
      }

      if (errorMsg.toLowerCase().contains("already") || errorMsg.toLowerCase().contains("exist")) {
        Get.snackbar("Error", "User already registered", colorText: Colors.red);
      } else {
        Get.snackbar("Error", errorMsg, colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred", colorText: Colors.red);
    } finally {
      isSignup.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //                  SEND OTP
  // ──────────────────────────────────────────────
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required", colorText: Colors.red);
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Invalid email format", colorText: Colors.red);
      return;
    }

    try {
      sentOtp.value = true;
      isSentOtp.value = true;

      final result = await _authRepository.sendOtp(email);

      if (result["success"] == true) {
        Get.snackbar(
          "Success",
          result["message"] ?? "OTP sent successfully",
          colorText: AppColors.appColor,
          snackPosition: SnackPosition.TOP,
        );

        Get.to(() => OtpCodeScreenView(email: email));
      } else {
        Get.snackbar("Error", result["message"] ?? "Failed to send OTP", colorText: Colors.red);
      }
    } on DioException catch (e) {
      String msg = "Failed to send OTP";
      if (e.response?.data != null && e.response?.data["message"] != null) {
        msg = e.response!.data["message"];
      }
      CustomShowMessage.error(message: msg);
      // Get.snackbar("Error", msg, colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    } finally {
      sentOtp.value = false;
      isSentOtp.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //                  VERIFY OTP
  // ──────────────────────────────────────────────
  Future<void> verifyOtp({required String email, required String otp, required VoidCallback onSuccess}) async {
    if (otp.isEmpty) {
      Get.snackbar("Error", "OTP is required", colorText: Colors.red);
      return;
    }

    try {
      isVerfiyOtp.value = true;

      final result = await _authRepository.verifyOtp(otp, email);

      if (result["success"] == true) {
        Get.snackbar("Success", result["message"] ?? "OTP verified successfully", colorText: AppColors.appColor);

        onSuccess();
      } else {
        Get.snackbar("Error", result["message"] ?? "Invalid OTP", colorText: Colors.red);
      }
    } on DioException catch (e) {
      String msg = "OTP verification failed";
      if (e.response?.data != null && e.response?.data["message"] != null) {
        msg = e.response!.data["message"];
      }
      Get.snackbar("Error", msg, colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    } finally {
      isVerfiyOtp.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //                  RESET PASSWORD
  // ──────────────────────────────────────────────
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required VoidCallback onSuccess,
  }) async {
    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", colorText: Colors.red);
      return;
    }

    try {
      isResetPassword.value = true;

      final result = await _authRepository.resetPassword(email, otp, newPassword);

      if (result["success"] == true) {
        Get.snackbar("Success", result["message"] ?? "Password reset successfully", colorText: AppColors.appColor);

        onSuccess();
      } else {
        Get.snackbar("Error", result["message"] ?? "Failed to reset password", colorText: Colors.red);
      }
    } on DioException catch (e) {
      String msg = "Failed to reset password";
      if (e.response?.data != null && e.response?.data["message"] != null) {
        msg = e.response!.data["message"];
      }
      Get.snackbar("Error", msg, colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    } finally {
      isResetPassword.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //                  CHANGE PASSWORD
  // ──────────────────────────────────────────────
  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (currentPassword.isEmpty) {
      Get.snackbar("Error", "Current password is required", colorText: Colors.red);
      return;
    }
    if (newPassword.isEmpty) {
      Get.snackbar("Error", "New password is required", colorText: Colors.red);
      return;
    }
    if (confirmPassword.isEmpty) {
      Get.snackbar("Error", "Confirm password is required", colorText: Colors.red);
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters", colorText: Colors.red);
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "New password and confirm password do not match", colorText: Colors.red);
      return;
    }

    try {
      isLoading.value = true;

      final result = await _authRepository.changePassword(currentPassword, newPassword, confirmPassword);

      if (result["success"] == true) {
        Get.snackbar("Success", result["message"] ?? "Password changed successfully", colorText: AppColors.appColor);
      } else {
        Get.snackbar("Error", result["message"] ?? "Failed to change password", colorText: Colors.red);
      }
    } on DioException catch (e) {
      String msg = "Failed to change password";
      if (e.response?.data != null && e.response?.data["message"] != null) {
        msg = e.response!.data["message"];
      }
      Get.snackbar("Error", msg, colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred", colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await TokenManager.clearToken();
    Get.snackbar(colorText: AppColors.appColor, "Success", "Logged out");
    Get.offAll(() => SplashScreen());
  }

  // ──────────────────────────────────────────────
  //                  LOGOUT
  // ──────────────────────────────────────────────
  //                  FETCH PROFILE

  @override
  void onClose() {
    emailController.dispose();
    singinemailcontroller.dispose();
    passwordController.dispose();
    nameController.dispose();
    signupPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
 */
