import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/auth/presentation/contro/contro.dart';

import '../../../../core/utils/app_colors.dart';

import '../widget/change_password_field.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});
  //final AuthController authController = Get.put(AuthController());
  final authController = Get.find<AuthController>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor),
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w700, fontSize: 24),
        ),
        elevation: 0,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ChangePasswordField(fieldName: "Current Password", hinText: "Current Password", controller: currentPasswordController),

                  // ChangePasswordField(fieldName: "New Password",
                  //   hinText: "",),
                  ChangePasswordField(fieldName: "New Password", hinText: "New Password", controller: newPasswordController),
                  ChangePasswordField(fieldName: "Confirm Password", hinText: "Confirm Password", controller: confirmPasswordController),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appColor,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          authController.changePassword(
                            currentPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            // confirmPasswordController.text.trim(),
                          );
                        },

                        child: authController.isChangepassword.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Save",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                        //label: Icon(Icons.arrow_forward, color: Colors.white,size: 20,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
