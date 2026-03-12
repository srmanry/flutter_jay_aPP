import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:spotem/feature/home/view/home_view.dart';

import 'core/utils/app_colors.dart';
import 'feature/alert/controller/alert_controller.dart';
import 'feature/home/controller/home_controller.dart';

import 'feature/map/view/map_view.dart';
import 'feature/new_featuer/presentation/controller/new_feature_controller.dart';
import 'feature/new_featuer/presentation/view/cleancode_new_feature_screen_view.dart';

import 'feature/profile/presentation/controller/profile_controller.dart';
import 'feature/profile/presentation/view/profile_view.dart';
import 'feature/report/presentation/view/report_create_view.dart';

class AppGroundView extends StatefulWidget {
  final int currentIndex;
  const AppGroundView({super.key, required this.currentIndex});

  @override
  State<AppGroundView> createState() => _AppGroundViewState();
}

class _AppGroundViewState extends State<AppGroundView> {
  @override
  void initState() {
    super.initState();

    Get.put(AlertController(), permanent: true);
    _currentIndex = widget.currentIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));

      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().fetchReports();
      }
      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchProfile();
      }
      if (Get.isRegistered<NewFeatureController>()) {
        await Get.find<NewFeatureController>().fetchReports();
      }
    });
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreenView(),

    GoogleMapScreen(),

    //MapScreen(),
    CleancodeNewFeatureScreenView(),
    // NewFeatureScreen(),
    ReportScreenView(),

    ProfileScreenView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),

          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: AppColors.appColor,
          backgroundColor: AppColors.navBarColor,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.home_outlined)),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.location_on_outlined)),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.local_activity)),
              label: "Acticity",
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.report_gmailerrorred_outlined)),
              label: "Report",
            ),

            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.account_circle_outlined)),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
