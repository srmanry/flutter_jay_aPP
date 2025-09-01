import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:spotem/core/util/app_colors.dart';

import '../../../../../core/common/common_text.dart';
import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/save_botton.dart';
import '../controller/auth_controller.dart';
import '../widget/remember_me.dart';
import 'forget_password_view.dart';
import 'sign_up_view.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icons/appIcon.png", height: 124, width: 124),
            const SizedBox(height: 40),
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RememberForgotRow(),
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
              return authController.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : buttonWidget(
                      text: "Sign In",
                      onTap: () {
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
                  child: const Text(
                    "Sign Up Here",
                    style: TextStyle(color: Colors.blue),
                  ),
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
