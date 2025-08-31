import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/network/local/token_manager.dart';
import 'package:spotem/feature/auth/view/sign_in_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 8)); // splash delay
    bool loggedIn = await TokenManager.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Get.offAll(() => AppGroundView());
    } else {
      Get.offAll(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/icons/appIcon.png", height: 214, width: 214),
      ),
    );
  }
}
