import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import 'package:spotem/app_ground.dart';
import 'package:spotem/core/common/widgets/dialog_widget.dart';
import 'package:spotem/core/network/local/token_manager.dart';
import 'package:spotem/feature/auth/view/sign_in_view.dart';
import 'package:spotem/feature/profile/view/privacy_screen.dart';
import 'package:spotem/feature/profile/view/trems_condition_screen.dart';

import '../model/profile.dart';
import '../view/otp_code_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
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
    Get.to(() => TermsConditionsView());
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
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  //==================================================Login function

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔹 Basic validation
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required");
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioClient.post(
        "/auth/login",
        data: {"email": email, "password": password},
        options: dio.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => true,
        ),
      );

      isLoading.value = false;

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      if (response.statusCode == 200) {
        final data = response.data["data"];
        final token = data["accessToken"];
        final role = data["role"];
        await TokenManager.saveToken(accessToken: token, role: role);

        Get.offAll(() => AppGroundView());
        Get.snackbar("Success", "Login Successful 🎉");
      } else if (response.statusCode == 403) {
        final msg = response.data['message'] ?? "Access forbidden";
        Get.snackbar("Error", msg);
      } else {
        final msg = response.data['message'] ?? "Invalid email or password";
        Get.snackbar("Error", msg);
      }
    } catch (e) {
      isLoading.value = false;
      print("EXCEPTION IN LOGIN: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "required & valid email address");
      return;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar("Error", "Phone Number is required");
      return;
    }
    if (address.text.isEmpty) {
      Get.snackbar("Error", "Address is required");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long");
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "Password and Confirm Password do not match");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password and Confirm Password do not match");
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
        options: dio.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => true,
        ),
      );

      isLoading.value = false;

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Account Created 🎉");
        Get.to(() => SignInScreen());
      } else {
        final msg = response.data['message'] ?? "Something went wrong";
        Get.snackbar("Error", msg);
      }
    } catch (e) {
      print("Password: '${passwordController.text}'");
      print("ConfirmPassword: '${confirmPasswordController.text}'");

      print("EXCEPTION IN SIGNUP: $e");
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong");
    }
  }

  Future<void> logout() async {
    try {
      // Clear token & role
      await TokenManager.clear();
      await TokenManager.clear();

      // Navigate to login screen
      Get.offAll(() => SignInScreen());

      Get.snackbar("Success", "Logged out successfully");
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }

  //=================== Send OTP Function========================
  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Email is required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioClient.post(
        "/auth/forget",
        data: {"email": emailController.text},
        options: dio.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "OTP sent successfully",
        );
        Get.to(() => OtpCodeScreenView(email: emailController.text));
      } else {
        Get.snackbar("Error", response.data["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      /*   print("Exception: $e");
      final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    } finally {
      isLoading.value = false;
    }
  }

  // ==================OTP VERIFICATION
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required Function onSuccess,
  }) async {
    try {
      isLoading.value = true;

      final response = await dioClient.post(
        "/auth/verify-otp",
        data: {"email": email, "otp": otp},
        options: dio.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isLoading.value = false;

      // print("VERIFY OTP STATUS: ${response.statusCode}");
      // print("VERIFY OTP DATA: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "OTP Verified Successfully",
        );
        onSuccess(); // navigate to Reset Password
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Error",
          response.data["message"] ?? "Invalid OTP or Bad Request",
        );
      } else {
        Get.snackbar("Error", "Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      /*  isLoading.value = false;
      final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    }
  }

  // ResetPassword===================================
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required Function onSuccess,
  }) async {
    try {
      /*  if (passwordController.text.length < 6) {
        Get.snackbar("Error", "Password must be at least 6 characters long");
        return;
      } */
      isLoading.value = true;
      final response = await dioClient.post(
        "/auth/reset-password",
        data: {"email": email, "password": newPassword, "otp": otp},
        options: dio.Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "Password reset successfully",
        );
        onSuccess();
      } else {
        Get.snackbar(
          "Error",
          response.data["message"] ?? "Failed to reset password",
        );
      }
    } catch (e) {
      isLoading.value = false;

      /*     final errorMessage = getErrorMessage(e);
      Get.snackbar("Error", errorMessage); */
    }
  }

  // ChangePassword==========================================
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      // 
      if (currentPassword.isEmpty) {
        Get.snackbar("Error", "Current Password is required");
        return;
      }
      if (newPassword.length < 6) {
        Get.snackbar(
          "Error",
          "New Password must be at least 6 characters long",
        );
        return;
      }
      if (newPassword != confirmPassword) {
        Get.snackbar("Error", "New Password and Confirm Password do not match");
        return;
      }

      isLoading.value = true;

      // 🔹 Token
      final token = await TokenManager.getAccessToken();
      if (token == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      // 🔹 API call
      final response = await dioClient.post(
        "/user/change-password",
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // 🔹 Response handling
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password changed successfully");
        CustomDialog(
          buttonTitle: "Done",
          title: "Password Changed",
          content: "Your password has been changed successfully.",
        );
        Get.to(() => AppGroundView());
      } else {
        // 🔹 Show server error (like current password mismatch)
        final message = response.data?["message"] ?? "Something went wrong";
        Get.snackbar("Error", message);
        print("Change Password Error: $message"); // debug log
      }
    } catch (e, stacktrace) {
      // 🔹 Show actual exception if API fails
      print("Exception changing password: $e");
      print(stacktrace);
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> profileUpdate({
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

      isLoading.value = false;

      if (response.statusCode == 200) {
        print("Profile updated successfully");

        Get.snackbar("Success", "Profile updated successfully 🎉");

        Get.to(() => AppGroundView());
        // refresh profile data
        await fetchProfile();
      } else {
        //Get.snackbar("Error", response.data["message"] ?? "Update failed");
      }
    } catch (e) {
      print(
        "Error: Profile not updated ->====================================== $e",
      );

      isLoading.value = false;
      // Get.snackbar("not updated" );
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final token = await TokenManager.getAccessToken();
      if (token == null) {
        profileData.value = null;
        print("No token found");
        return;
      }

      final response = await dioClient.get(
        "/user/profile",
        options: dio.Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data != null) {
        profileData.value = UserProfileModel.fromJson(response.data!);
        print("Profile fetched successfully: ${profileData.value?.toJson()}");
      } else {
        profileData.value = null;
        print(
          "Failed to fetch profile: ${response.data?["message"] ?? "Unknown error"}",
        );
      }
    } catch (e) {
      profileData.value = null;
      print("==============================Exception fetching profile: $e");
    } finally {
      isLoading.value = false;
      print("Profile data: ${profileData.value?.toJson()}");
    }
  }
}
