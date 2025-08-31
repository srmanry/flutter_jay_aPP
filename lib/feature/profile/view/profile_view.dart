import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:spotem/core/common/widgets/dialog_widget.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/auth/controller/auth_controller.dart';
import 'package:spotem/feature/auth/view/change_password_view.dart';

import 'package:spotem/feature/profile/view/notificataion_view.dart';
import 'package:spotem/feature/profile/view/personal_info_view.dart';
import 'package:spotem/feature/profile/view/privacy_screen.dart';
import 'package:spotem/feature/profile/widgets/profile_botton_widget.dart';

class ProfileScreenView extends StatelessWidget {
  ProfileScreenView({super.key});

  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            CircleAvatar(radius: 30),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("UserName", style: TextStyle(color: Colors.black)),
                      Text("Address", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.toggle_off_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          profileButtonWidget(
            onTap: () {
              Get.to(PersonalInfoScreenView());
            },
            bottomIcon: Icon(Icons.payment_rounded),
            name: "Personal Info",
          ),
          profileButtonWidget(
            onTap: () {
              Get.to(ChangePasswordView());
            },

            bottomIcon: Icon(Icons.lock_outline_rounded),
            name: "Change Password",
          ),
          profileButtonWidget(
            onTap: () {
              Get.to(NotificataionScreenView());
            },
            bottomIcon: Icon(Icons.notifications_outlined),
            name: "Notification Settings",
          ),
          profileButtonWidget(
            onTap: () {
              Get.to(AboutAppScreen());
            },
            bottomIcon: Icon(Icons.help_outline_rounded),
            name: "About",
          ),
          profileButtonWidget(
            onTap: () {
              Get.defaultDialog(
                title: "",
                content: Column(
                  children: [
                    Image.asset(
                      "assets/icons/appIcon.png",
                      height: 102,
                      width: 102,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Are You Sure To Log Out?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            authController.logout();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.appColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: AppColors.appColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.appColor,
                            ),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            bottomIcon: Icon(Icons.logout_rounded, color: Colors.red),
            name: "Log Out",
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
