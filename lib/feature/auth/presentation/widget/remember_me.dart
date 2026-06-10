import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/auth/presentation/contro/contro.dart';



class RememberForgotRow extends StatelessWidget {
  const RememberForgotRow({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    return Row(

      children: [
        // Remember me (checkbox + label)
        Obx(() => Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: c.rememberMe.value,
            onChanged: (v) => c.toggleRemember(v ?? false),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        )),


       const Text("Remember me"),

       // Forgot password

      ],
    );
  }
}
