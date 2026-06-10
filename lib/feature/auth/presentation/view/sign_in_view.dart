import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/auth/presentation/contro/contro.dart';

import '../../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../../core/common/widgets/save_botton.dart';
import '../../../../core/common/widgets/app_icon.dart';
import '../../../../core/utils/app_colors.dart';
// a1@gmail.com
import 'forget_password_view.dart';
import 'sign_up_view.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  //final AuthController authController = Get.find(AuthController());
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppIconWidget(),
            const SizedBox(height: 40),
            const Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),

            // Email field
            CustomTextField(
              controller: authController.emailController,
              hintText: "Enter your email",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return "Email is required";
                if (authController.isValidEmail(value)) {
                  return "Invalid email format";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            //  Password field
            CustomTextField(
              controller: authController.passwordController,
              hintText: "Enter your password",
              prefixIcon: Icons.lock_outlined,
              isPassword: true,
              validator: () {
                if (authController.passwordController.text.isEmpty) {
                  return "Password is required";
                }
              },
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const RememberForgotRow(),
                InkWell(
                  onTap: () {
                    Get.to(() => ForgetPasswordView());
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appColor,

                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.appColor,
                      decorationThickness: 1.5,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Obx(() {
              return buttonWidget(
                text: "Sign In",
                isLoading: authController.isLogin.value,
                onTap: authController.isLogin.value
                    ? null
                    : () {
                        authController.login();
                      },
              );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New to our platform? "),
                InkWell(
                  onTap: () => Get.to(() => SignupScreen()),
                  child: const Text("Sign Up Here", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
