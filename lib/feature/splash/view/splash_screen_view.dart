import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_ground.dart';
import '../../../core/common/widgets/app_icon.dart';
import '../../../core/network/api_service/token_meneger.dart';
import '../../auth/presentation/view/sign_in_view.dart';

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
    await Future.delayed(const Duration(seconds: 5));
    await Future.delayed(const Duration(milliseconds: 200));
    bool loggedIn = await TokenManager.isLoggedIn();

    if (!mounted) return;
   

    if (loggedIn) {
      Get.offAll(() => AppGroundView()); // must be offAll
    } else {
      Get.offAll(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(child: AppIconWidget()),
    );
  }
}
