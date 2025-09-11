import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/common/widgets/app_icon.dart';
import 'package:spotem/core/network/local/token_manager.dart';
import 'package:spotem/feature/auth/view/sign_in_view.dart';
import 'package:spotem/feature/map/controller/map_controller.dart'; // তোমার LocationController এখানে আছে

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final locationController = Get.find<LocationController>();
  //final locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    _initFlow();
  }

  Future<void> _initFlow() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay


    //await locationController.requestLocationPermission(context);


    bool loggedIn = await TokenManager.isLoggedIn();

    if (!mounted) return;

    if (loggedIn ) {
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
      body: Center(child: AppIconWidget()),
    );
  }
}
