import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../app_ground.dart';
import '../../../core/common/widgets/app_icon.dart';
import '../../../core/service/local/token_manager.dart';
import '../../auth/view/sign_in_view.dart';

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

    print('no------------------------');
   // _initFlow();
  }

  Future<void> _initFlow() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay


    //await locationController.requestLocationPermission(context);


    bool loggedIn = await TokenManager.isLoggedIn();

    if (!mounted) return;

    if (loggedIn ) {
      Get.offAll(() => AppGroundView());
    } else {
      Get.to(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('no------------------------ 2 ');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:
      Text("JAY"),
      //Center(child: AppIconWidget()),
    );
  }
}
