import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/save_botton.dart';
import '../../../core/common/widgets/app_icon.dart';
import '../controller/auth_controller.dart';

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});

  final AuthController authController = Get.find<AuthController>();

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
              SizedBox(height: 80),
             AppIconWidget(),
              const SizedBox(height: 40),

              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email to receive the OTP',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Use controller from AuthController
              CustomTextField(
                controller: authController.emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: 30),
              buttonWidget(
                text: "Send OTP",
                onTap: () {
                  authController.sendOtp();
                },
              ),

              /* Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : ), */
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
