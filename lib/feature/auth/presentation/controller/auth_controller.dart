import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:spotem/core/utils/app_colors.dart';
import '../../../../app_ground.dart';
import '../../../../core/common/widgets/dialog_widget.dart';
import '../../../../core/service/local/token_manager.dart';
import '../../../profile/view/about_app_screen.dart';
import '../../../profile/view/pricacy_screen.dart';
import '../../../splash/view/splash_screen_view.dart';
import '../../model/profile.dart';
import '../view/otp_code_screen.dart';
import '../view/sign_in_view.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isUpdateingProfile = false.obs;
  var isLogin = false.obs;
  var isSentOtp = false.obs;
  var isOTPverified = false.obs;
  var isResetPassword = false.obs;
  var profileData = Rxn<UserProfileModel>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameController = TextEditingController();
  final address = TextEditingController();
  final phoneController = TextEditingController();
  final password = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final rememberMe = false.obs;

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
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    print("fetchProfile called"); // debug print
  }

  //================================================== Dio
  final dio.Dio dioClient = dio.Dio(
    dio.BaseOptions(
      // baseUrl: "https://api.spotem365.com/api/v1",
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  //==================================================Login function

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required", colorText: Colors.red);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required", colorText: Colors.red);
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address");
      return;
    }

    try {
      isLogin.value = true;

      final response = await dioClient.post(
        "/auth/login",
        data: {"email": email, "password": password},
        options: dio.Options(headers: {"Content-Type": "application/json"}, validateStatus: (status) => true),
      );

      isLogin.value = false;

      if (response.statusCode == 200) {
        final data = response.data["data"];
        final token = data["accessToken"];
        final role = data["role"];
        await TokenManager.saveToken(accessToken: token, role: role);

        Get.offAll(() => AppGroundView());
        Get.snackbar("Success", "Login Successful 🎉", colorText: AppColors.appColor);
      } else if (response.statusCode == 403) {
        final msg = response.data['message'] ?? "Access forbidden";
        Get.snackbar("Error", msg, colorText: Colors.red);
      } else {
        final msg = response.data['message'] ?? "Invalid email or password";
        Get.snackbar("Error", msg, colorText: Colors.red);
      }
    } catch (e) {
      isLogin.value = false;

      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    }
  }

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Name is required", colorText: Colors.red);
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "required & valid email address", colorText: Colors.red);
      return;
    }

    /*    if (phoneController.text.isEmpty) {
      Get.snackbar("Error", "Phone Number is required");
      return;
    }*/
    /*  if (address.text.isEmpty) {
      Get.snackbar("Error", "Address is required");
      return;
    }*/
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long", colorText: Colors.red);
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "Password and Confirm Password do not match", colorText: Colors.red);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password and Confirm Password do not match", colorText: Colors.red);
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioClient.post(
        "/auth/register",
        data: {
          "name": nameController.text,
          "address": address.text,
          "email": email,
          "phone": phoneController.text,
          "password": password,
          "confirmPassword": confirmPassword,
        },
        options: dio.Options(headers: {"Content-Type": "application/json"}, validateStatus: (status) => true),
      );

      isLoading.value = false;

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Account Created 🎉", colorText: AppColors.appColor);
        Get.to(() => SignInScreen());
      } else {
        final msg = response.data['message'] ?? "Something went wrong";
        Get.snackbar("Error", msg, colorText: Colors.red);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    }
  }

  Future<void> logout() async {
    try {
      // Clear token & role
      await TokenManager.clear();
      await TokenManager.clear();

      // Navigate to login screen
      Get.offAll(() => SignInScreen());

      Get.snackbar("Success", "Logged out successfully", colorText: AppColors.appColor);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.red);
    }
  }

  //=================== Send OTP Function========================
  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Email is required", colorText: Colors.red);
      return;
    }

    try {
      isSentOtp.value = true;

      final response = await dioClient.post(
        "/auth/forget",
        data: {"email": emailController.text},
        options: dio.Options(headers: {"Content-Type": "application/json"}, validateStatus: (status) => status != null && status < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", response.data["message"] ?? "OTP sent successfully", colorText: AppColors.appColor);
        Get.to(() => OtpCodeScreenView(email: emailController.text));
      } else {
        Get.snackbar("Error", response.data["message"] ?? "Failed to send OTP", colorText: Colors.red);
        isSentOtp.value = false;
      }
    } catch (e) {
      /*   print("Exception: $e");
      final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    } finally {
      isSentOtp.value = false;
    }
  }

  // ==================OTP VERIFICATION
  Future<void> verifyOtp({required String email, required String otp, required Function onSuccess}) async {
    try {
      isOTPverified.value = true;

      final response = await dioClient.post(
        "/auth/verify-otp",
        data: {"email": email, "otp": otp},
        options: dio.Options(headers: {"Content-Type": "application/json"}, validateStatus: (status) => status != null && status < 500),
      );

      isOTPverified.value = false;

      // print("VERIFY OTP STATUS: ${response.statusCode}");
      // print("VERIFY OTP DATA: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.data["message"] ?? "OTP Verified Successfully", colorText: AppColors.appColor);
        onSuccess(); // navigate to Reset Password
      } else if (response.statusCode == 400) {
        Get.snackbar("Error", response.data["message"] ?? "Invalid OTP or Bad Request", colorText: Colors.red);
        isOTPverified.value = false;
      } else {
        Get.snackbar("Error", "Unexpected error: ${response.statusCode}", colorText: Colors.red);
        isOTPverified.value = false;
      }
    } catch (e) {
      /*  isLoading.value = false;
      final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    } finally {
      isOTPverified.value = false;
    }
  }

  // ResetPassword===================================
  Future<void> resetPassword({required String email, required String otp, required String newPassword, required Function onSuccess}) async {
    try {
      /*  if (passwordController.text.length < 6 && confirmPasswordController.text.length &&passwordController.text.) {
        Get.snackbar("Error", "Password must be at least 6 characters long");
        return;
      }*/
      isResetPassword.value = true;
      final response = await dioClient.post(
        "/auth/reset-password",
        data: {"email": email, "password": newPassword, "otp": otp},
        options: dio.Options(headers: {"Content-Type": "application/json"}, validateStatus: (status) => status != null && status < 500),
      );

      isResetPassword.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        /*  Get.snackbar(
          "Success",
          response.data["message"] ?? "Password reset successfully",
          colorText: AppColors.appColor,
        ); */
        onSuccess();
      } else {
        Get.snackbar("Error", response.data["message"] ?? "Failed to reset password", colorText: Colors.red);
      }
    } catch (e) {
      isResetPassword.value = false;

      /*     final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    } finally {
      isResetPassword.value = false;
    }
  }

  // ChangePassword==========================================
  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      //
      if (currentPassword.isEmpty) {
        Get.snackbar("Error", "Current Password is required", colorText: Colors.red);
        return;
      }
      if (newPassword.length < 6) {
        Get.snackbar("Error", "New Password must be at least 6 characters long", colorText: Colors.red);
        return;
      }
      if (newPassword != confirmPassword) {
        Get.snackbar("Error", "New Password and Confirm Password do not match", colorText: Colors.red);
        return;
      }

      isLoading.value = true;

      final token = await TokenManager.getAccessToken();
      if (token == null) {
        Get.snackbar("Error", "User not logged in", colorText: Colors.red);
        return;
      }

      final response = await dioClient.post(
        "/user/change-password",
        data: {"currentPassword": currentPassword, "newPassword": newPassword, "confirmPassword": confirmPassword},
        options: dio.Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password changed successfully", colorText: AppColors.appColor);
        CustomDialog(buttonTitle: "Done", title: "Password Changed", content: "Your password has been changed successfully.");
        Get.to(() => AppGroundView());
      } else {
        //  Show server error (like current password mismatch)
        final message = response.data?["message"] ?? "Something went wrong";
        Get.snackbar("Error", message, colorText: Colors.red);
      }
      isLoading.value = false;
    } catch (e, stacktrace) {
      //  Show actual exception if API fails
      isLoading.value = false;
      Get.snackbar("Error", "An unexpected error occurred", colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /*   Future<void> profileUpdate({
    required String name,
    required String email,
    required String phone,
    String? gender,
    required String address,
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;

      final token = await TokenManager.getAccessToken();

      dio.FormData formData = dio.FormData.fromMap({
        "name": name,
        //"email": email,
        "phone": phone,
        "address": address,
        if (imageFile != null)
          "avatar": await dio.MultipartFile.fromFile(imageFile.path.toString()),
      });

      final response = await dioClient.patch(
        "/user/update-profile",
        data: formData,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isUpdateingProfile.value = true;

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile updated successfully 🎉",
          colorText: AppColors.appColor,
        );

        Get.to(() => AppGroundView());
        // refresh profile data
        await fetchProfile();
      } else {
        //Get.snackbar("Error", response.data["message"] ?? "Update failed");
        final msg = response.data['message'] ?? "Something went wrong";
        Get.snackbar("Error", msg, colorText: Colors.red);
        isUpdateingProfile.value = false;
      }
    } catch (e) {
      print(
        "Error: Profile not updated ->====================================== $e",
      );

      isUpdateingProfile.value = false;
      // Get.snackbar("not updated" );
    } finally {
      isUpdateingProfile.value = false;
    }
  }


 */
  Future<void> profileUpdate({
    required String name,
    required String email,
    required String phone,
    String? gender,
    required String address,
    File? imageFile,
  }) async {
    isUpdateingProfile.value = true;

    try {
      final token = await TokenManager.getAccessToken();

      dio.FormData formData = dio.FormData.fromMap({
        "name": name,
        "phone": phone,
        "address": address,
        if (imageFile != null) "avatar": await dio.MultipartFile.fromFile(imageFile.path),
      });

      final response = await dioClient.patch(
        "/user/update-profile",
        data: formData,
        options: dio.Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "multipart/form-data"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully 🎉", colorText: AppColors.appColor);

        await fetchProfile();
        Get.to(() => AppGroundView());
      } else {
        final msg = response.data['message'] ?? "Something went wrong";
        Get.snackbar("Error", msg, colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Profile update failed", colorText: Colors.red);
    } finally {
      isUpdateingProfile.value = false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final token = await TokenManager.getAccessToken();
      if (token == null) {
        profileData.value = null;

        return;
      }

      final response = await dioClient.get(
        "/user/profile",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}, validateStatus: (status) => status != null && status < 500),
      );

      if (response.data != null) {
        profileData.value = UserProfileModel.fromJson(response.data!);
      } else {
        profileData.value = null;
      }
    } catch (e) {
      profileData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  //=================== Delete Account (Server-side only) =========================
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      // Get user token from local storage
      final token = await TokenManager.getAccessToken();
      if (token == null) {
        Get.snackbar("Error", "User not logged in", colorText: Colors.red);
        isLoading.value = false;
        return;
      }

      // Call the delete account API
      final response = await dioClient.delete(
        "/user/delete-account",
        options: dio.Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Success", response.data?["message"] ?? "Account deleted successfully 🎉", colorText: AppColors.appColor);
        TokenManager.clear();
        Get.to(() => SplashScreen());
      } else {
        final msg = response.data?['message'] ?? "Failed to delete account";
        Get.snackbar("Error", msg, colorText: Colors.red);
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar("Error", "Something went wrong while deleting account", colorText: Colors.red);
    }
  }
}
