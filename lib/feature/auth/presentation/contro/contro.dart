// feature/auth/controller/auth_controller.dart de@gmail.com
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/network/api_service/token_meneger.dart';
import 'package:spotem/core/common/custom_massage.dart';

import 'package:spotem/feature/auth/domain/auth_repo.dart';
import 'package:spotem/feature/auth/presentation/view/sign_in_view.dart';
import 'package:spotem/feature/profile/presentation/view/about_app_screen.dart';
import 'package:spotem/feature/profile/presentation/view/pricacy_screen.dart';
import '../../../splash/view/splash_screen_view.dart';

import '../view/otp_code_screen.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  // ─── States ──────────────────────
  var isLogin = false.obs;
  var isSignup = false.obs;
  var isChangepassword = false.obs;
  var sentOtp = false.obs;
  var isVerifyOtp = false.obs;
  var isResetPassword = false.obs;
  var isLoading = false.obs;
  var isSentOtp = false.obs;
  final rememberMe = false.obs;
  final iAgree = false.obs;
  // ─── Text Controllers ─────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

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
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // ─── Helpers ─────────────────────

  // ─── LOGIN ───────────────────────
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) return CustomShowMessage.error(message: "Email required");
    if (!isValidEmail(email)) return CustomShowMessage.error(message: "Invalid email");
    if (password.isEmpty) return CustomShowMessage.error(message: "Password required");
    if (password.length < 6) return CustomShowMessage.error(message: "Password min 6 chars");

    try {
      isLogin.value = true;
      final result = await _authRepository.login(email, password);

      if (result["success"] == true) {
        await TokenManager.saveToken(accessToken: result["data"]["accessToken"], refreshToken: result["data"]["refreshToken"] ?? "");

        CustomShowMessage.success(message: "Login Successful");
        clearLoginFields();
        Get.offAll(() => AppGroundView(currentIndex: 0));
      } else {
        CustomShowMessage.error(message: result["message"] ?? "Login failed");
      }
    } catch (e) {
      CustomShowMessage.error(message: "Something went wrong");
    } finally {
      isLogin.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      isLoading.value = true;
      final result = await _authRepository.deleteAccount();

      if (result["success"] == true) {
        await TokenManager.clearToken();
        CustomShowMessage.success(message: result["message"]?.toString() ?? "Account deleted");
        Get.offAll(() => SignInScreen());
      } else {
        CustomShowMessage.error(message: result["message"]?.toString() ?? "Failed to delete account");
      }
    } catch (e) {
      CustomShowMessage.error(message: e.toString().replaceFirst("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── SIGNUP ──────────────────────
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (name.isEmpty) return CustomShowMessage.error(message: "Name required");
    if (email.isEmpty) return CustomShowMessage.error(message: "Email required");
    if (!isValidEmail(email)) return CustomShowMessage.error(message: "Invalid email");
    if (password.isEmpty) return CustomShowMessage.error(message: "Password required");
    if (password != confirmPass) return CustomShowMessage.error(message: "Passwords do not match");

    try {
      isSignup.value = true;
      final result = await _authRepository.signup(name, email, password, confirmPass);

      if (result["success"] == true) {
        CustomShowMessage.success(message: "Signup Successful");
        Get.to(() => SignInScreen());
        clearSignupFields();
      } else {
        CustomShowMessage.error(message: result["message"] ?? "Signup failed");
      }
    } catch (e) {
      debugPrint("Signup error: $e");
      CustomShowMessage.error(message: "Something went wrong: $e");
    } finally {
      isSignup.value = false;
    }
  }

  // ─── SEND OTP ────────────────────
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) return CustomShowMessage.error(message: "Email required");
    if (!isValidEmail(email)) return CustomShowMessage.error(message: "Invalid email");

    try {
      sentOtp.value = true;
      final result = await _authRepository.sendOtp(email);

      if (result["success"] == true) {
        CustomShowMessage.success(message: result["message"] ?? "OTP sent");
        Get.to(() => OtpCodeScreenView(email: email));
      } else {
        CustomShowMessage.error(message: result["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      CustomShowMessage.error(message: "Something went wrong");
    } finally {
      sentOtp.value = false;
    }
  }

  // ─── VERIFY OTP ──────────────────
  Future<void> verifyOtp({required String email, required String otp, required VoidCallback onSuccess}) async {
    if (otp.isEmpty) return CustomShowMessage.error(message: "OTP required");

    try {
      isVerifyOtp.value = true;
      final result = await _authRepository.verifyOtp(otp, email);

      if (result["success"] == true) {
        CustomShowMessage.success(message: result["message"] ?? "OTP Verified");
        onSuccess();
      } else {
        CustomShowMessage.error(message: result["message"] ?? "Invalid OTP");
      }
    } catch (e) {
      CustomShowMessage.error(message: "Something went wrong");
    } finally {
      isVerifyOtp.value = false;
    }
  }

  // ─── RESET PASSWORD ──────────────
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required VoidCallback onSuccess,
  }) async {
    if (newPassword.length < 6) return CustomShowMessage.error(message: "Password min 6 chars");

    try {
      isResetPassword.value = true;
      final result = await _authRepository.resetPassword(email, otp, newPassword);

      if (result["success"] == true) {
        CustomShowMessage.success(message: result["message"] ?? "Password reset");
        onSuccess();
      } else {
        CustomShowMessage.error(message: result["message"] ?? "Failed to reset password");
      }
    } catch (e) {
      CustomShowMessage.error(message: "Something went wrong");
    } finally {
      isResetPassword.value = false;
    }
  }

  // ─── CHANGE PASSWORD ─────────────
  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (currentPassword.isEmpty) return CustomShowMessage.error(message: "Current password required");
    if (newPassword.isEmpty) return CustomShowMessage.error(message: "New password required");
    if (confirmPassword.isEmpty) return CustomShowMessage.error(message: "Confirm password required");
    if (newPassword.length < 6) return CustomShowMessage.error(message: "Password min 6 chars");
    if (newPassword != confirmPassword) {
      return CustomShowMessage.error(message: "New password and confirm password do not match");
    }

    try {
      isChangepassword.value = true;
      final result = await _authRepository.changePassword(currentPassword, newPassword, confirmPassword);

      final errorSources = result["errorSources"];
      final errorSourceMessage = (errorSources is List && errorSources.isNotEmpty && errorSources.first is Map)
          ? (errorSources.first["message"]?.toString())
          : null;
      final message = result["message"]?.toString() ?? errorSourceMessage;

      if (result["success"] == true) {
        CustomShowMessage.success(message: message ?? "Password changed");
      } else {
        CustomShowMessage.error(message: message ?? "Failed to change password");
      }
    } catch (e) {
      CustomShowMessage.error(message: "Something went wrong: $e");
    } finally {
      isChangepassword.value = false;
    }
  }

  // ─── LOGOUT ──────────────────────
  Future<void> logout() async {
    await TokenManager.clearToken();
    CustomShowMessage.success(message: "Log Out");
    Get.offAll(() => SplashScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
