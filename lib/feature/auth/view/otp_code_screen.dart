
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/common/common_text.dart';

import '../../../../../core/common/widgets/save_botton.dart';
import '../../../core/utils/app_colors.dart';
import '../controller/auth_controller.dart';
import 'forget_password_view.dart';
import 'reset_password.dart';

class OtpCodeScreenView extends StatelessWidget {
  final String email;
  OtpCodeScreenView({super.key, required this.email});

  final otpController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Image.asset(
                      "assets/icons/appIcon.png",
                      height: 124,
                      width: 124,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter the OTP sent to $email',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // OTP Input
                    Pinput(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      autofocus: true,
                      length: 6,
                      controller: otpController,
                      defaultPinTheme: defaultPinTheme,
                      onCompleted: (pin) => print("Entered OTP: $pin"),
                    ),

                    const SizedBox(height: 30),
                    // Verify OTP button
                    Obx(
                      () => authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : buttonWidget(
                              text: "Verify OTP",
                              onTap: () {
                                final otp = otpController.text.trim();
                                if (otp.isEmpty) {
                                  Get.snackbar("Error", "Please enter OTP");
                                  return;
                                }

                                authController.verifyOtp(
                                  email: email,
                                  otp: otp,
                                  onSuccess: () {
                                    Get.off(
                                      () => SetResetPasswordView(
                                        email: email,
                                        otp: otp,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't Receive OTP? ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(()=> ForgetPasswordView());
                              print("*************RESEND OTP");
                              //authController.sendOtp(); // resend OTP
                            },
                            child: Text(
                              "RESEND OTP",
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
