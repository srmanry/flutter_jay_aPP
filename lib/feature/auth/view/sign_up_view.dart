import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:spotem/core/common/common_text.dart';
import 'package:spotem/core/common/widgets/custom_text_field.dart';
import 'package:spotem/core/common/widgets/save_botton.dart';

import '../controller/auth_controller.dart';
import '../widget/by_registation.dart';
import 'sign_in_view.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.white,

        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset("assets/icons/appIcon.png", height: 124, width: 124),
          ],
        ),
      ), */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                "assets/icons/appIcon.png",
                height: 124,
                width: 124,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Create Your Account",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // fieldName("Name"),
            CustomTextField(
              controller: authController.nameController,
              hintText: "Enter your Full Name",
              prefixIcon: Icons.person_outline_outlined,
            ),
            const SizedBox(height: 15),

            //fieldName("Email"),
            CustomTextField(
              controller: authController.emailController,
              hintText: "Enter your Email",
              prefixIcon: Icons.email,
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

            // fieldName("Phone Number"),
            CustomTextField(
              controller: authController.phoneController,
              hintText: "Enter Phone Number",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: authController.address,
              hintText: "Enter Address",
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),
            CustomTextField(
              controller: authController.passwordController,
              hintText: "Create a Password",
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: () {
                if (authController.passwordController.text.isEmpty) {
                  return "Password is required";
                }
              },
            ),
            const SizedBox(height: 15),
            // fieldName("Password"),
            CustomTextField(
              controller: authController.confirmPasswordController,
              hintText: "Create a Password",
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: () {
                if (authController.confirmPasswordController.text.isEmpty) {
                  return "Password is required";
                }
              },
            ),
            const SizedBox(height: 8),

            ByRegistation(),
            const SizedBox(height: 20),

            Obx(() {
              return authController.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : buttonWidget(
                      text: "Sign Up",
                      onTap: () {
                        authController.signUp();
                        
                      },
                    );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => Get.to(() => SignInScreen()),
                  child: const Text(
                    "Sign In Here",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
