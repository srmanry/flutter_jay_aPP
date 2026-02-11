import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:spotem/feature/home/view/home_view.dart';



import 'core/utils/app_colors.dart';
import 'feature/alert/controller/alert_controller.dart';

import 'feature/map/view/map_view.dart';
import 'feature/profile/presentation/view/profile_view.dart';
import 'feature/report/presentation/view/report_create_view.dart';

class AppGroundView extends StatefulWidget {
  const AppGroundView({super.key});



  @override
  State<AppGroundView> createState() => _AppGroundViewState();
}



class _AppGroundViewState extends State<AppGroundView> {


  @override
  void initState() {

    Get.put(AlertController(), permanent: true);
    // TODO: implement initState
    super.initState();
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreenView(),

    GoogleMapScreen(),
    //MapScreen(),

    ReportScreenView(),

    ProfileScreenView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,),

          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: AppColors.appColor,
          backgroundColor: AppColors.navBarColor,
          currentIndex: _currentIndex,
          onTap: (index) {setState(() {_currentIndex = index;});},
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.home_outlined),), label: "Home",),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.location_on_outlined),), label: "Map",),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(top: 10.0), child: Icon(Icons.report_gmailerrorred_outlined),), label: "Report",),

            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.account_circle_outlined),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
