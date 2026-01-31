import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../../core/common/widgets/save_botton.dart';
import '../../../../core/common/widgets/app_icon.dart';
import '../controller/auth_controller.dart';
import 'sign_in_view.dart';

class SetResetPasswordView extends StatelessWidget {
  final String email;
  final String otp;
  SetResetPasswordView({super.key, required this.email, required this.otp});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              AppIconWidget(),

              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter a new password for $email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: newPasswordController,
                hintText: "New Password",
                prefixIcon: Icons.lock_outline,
                //obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline,
                  // obscureText: true,
                ),
              ),

              SizedBox(height: 30),
              Obx(
                () => buttonWidget(
                  text: authController.isResetPassword.value
                      ? "Loading..."
                      : "Reset Password",
                  onTap: () async {
                    final newPass = newPasswordController.text.trim();
                    final confirmPass = confirmPasswordController.text.trim();

                    if (newPass.isEmpty || confirmPass.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "All fields are required",
                        colorText: Colors.red,
                      );
                      return;
                    }
                    if (newPass != confirmPass) {
                      Get.snackbar(
                        "Error",
                        "Passwords do not match",
                        colorText: Colors.red,
                      );
                      return;
                    }

                    // Call API
                    await authController.resetPassword(
                      otp: otp,
                      email: email,
                      newPassword: newPass,
                      onSuccess: () {
                        Get.snackbar(
                          "Success",
                          "Password reset successfully",
                          colorText: AppColors.appColor,
                        );
                        Get.off(() => SignInScreen());
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
