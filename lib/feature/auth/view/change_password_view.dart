import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/util/app_colors.dart';

import 'package:spotem/feature/auth/widget/change_password_field.dart';

import '../controller/auth_controller.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});
  final AuthController authController = Get.put(AuthController());
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appColor),
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(
            color: AppColors.appColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ChangePasswordField(
                      fieldName: "Current Password",
                      hinText: "Current Password",
                      controller: currentPasswordController,
                    ),

                    // ChangePasswordField(fieldName: "New Password",
                    //   hinText: "",),
                    ChangePasswordField(
                      fieldName: "New Password",
                      hinText: "New Password",
                      controller: newPasswordController,
                    ),
                    ChangePasswordField(
                      fieldName: "Confirm Password",
                      hinText: "Confirm Password",
                      controller: newPasswordController,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text("Desktop View"));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Obx(
          () => authController.isLoading.value
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    authController.changePassword(
                      currentPasswordController.text.trim(),
                      newPasswordController.text.trim(),
                    );
                  },

                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  //label: Icon(Icons.arrow_forward, color: Colors.white,size: 20,),
                ),
        ),
      ),
    );
  }
}
