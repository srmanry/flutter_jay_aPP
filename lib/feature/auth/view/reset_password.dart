import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotem/feature/auth/view/sign_in_view.dart';
import '../../../../../core/common/common_text.dart';

import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/save_botton.dart';
import '../controller/auth_controller.dart';

class SetResetPasswordView extends StatelessWidget {
  final String email;
  SetResetPasswordView({super.key, required this.email});

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
              Image.asset("assets/icons/appIcon.png", height: 124, width: 124),
              const SizedBox(height: 80),
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

              // Reset Password Button
              Obx(
                () => authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : buttonWidget(
                        text: "Reset Password",
                        onTap: () async {
                          final newPass = newPasswordController.text.trim();
                          final confirmPass = confirmPasswordController.text
                              .trim();

                          if (newPass.isEmpty || confirmPass.isEmpty) {
                            Get.snackbar("Error", "All fields are required");
                            return;
                          }
                          if (newPass != confirmPass) {
                            Get.snackbar("Error", "Passwords do not match");
                            return;
                          }

                          // Call API
                          await authController.resetPassword(
                            email: email,
                            newPassword: newPass,
                            onSuccess: () {
                              Get.snackbar(
                                "Success",
                                "Password reset successfully",
                              );
                              Get.off(() => SignInScreen());
                            },
                          );
                        },
                      ),
              ),

              const SizedBox(height: 40),
              const Text(
                'Your Profile helps us customize your experience',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
