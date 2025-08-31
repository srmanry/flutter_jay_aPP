import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:spotem/core/common/widgets/dialog_widget.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/auth/controller/auth_controller.dart';
import 'package:spotem/feature/auth/view/change_password_view.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

import 'package:spotem/feature/profile/view/notificataion_view.dart';
import 'package:spotem/feature/profile/view/personal_info_view.dart';
import 'package:spotem/feature/profile/view/privacy_screen.dart';
import 'package:spotem/feature/profile/widgets/profile_botton_widget.dart';

class ProfileScreenView extends StatelessWidget {
  ProfileScreenView({super.key});

  AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Obx(
          () => Row(
            children: [
              authController.profileData.value?.avatar.url != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        "${authController.profileData.value?.avatar.url}",
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundColor: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.grey[400],
                      child: Icon(
                        Icons.photo_size_select_large_rounded,
                        color: themeController.isDarkMode.value
                            ? Colors.black
                            : Colors.black,
                      ),
                    ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Text(
                            authController.profileData.value?.name != null
                                ? authController.profileData.value!.name
                                : 'Loading...',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : AppColors.appColor,
                            ),
                          );
                        }),
                        Obx(() {
                          return Text(
                            authController.profileData.value?.email != null
                                ? authController.profileData.value!.email
                                : 'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : AppColors.appColor,
                            ),
                          );
                        }),

                        /*     Text(
                         authController.profileData.value?.name != null? authController.profileData.value?.name :'Loading...',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color:
                                authController.profileData.value?.name != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ), */
                        /*  Text(
                          "${authController.profileData.value?.email != null ? authController.profileData.value?.name : 'Loading...'}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color:
                                authController.profileData.value?.email != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ), */
                      ],
                    ),
                    Spacer(),
                    Obx(
                      () => Switch(
                        value: themeController.isDarkMode.value,
                        onChanged: (_) => themeController.toggleTheme(),
                        activeColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileButtonWidget(
              onTap: () {
                Get.to(PersonalInfoScreenView());
              },
              bottomIcon: Obx(
                () => Icon(
                  Icons.payment_rounded,
                  color: themeController.isDarkMode.value
                      ? Colors.black
                      : Colors.black,
                ),
              ),

              name: "Personal Info",
            ),
            profileButtonWidget(
              onTap: () {
                Get.to(ChangePasswordView());
              },
              bottomIcon: Obx(
                () => Icon(
                  Icons.lock_outline_rounded,
                  color: themeController.isDarkMode.value
                      ? Colors.black
                      : Colors.black,
                ),
              ),

              name: "Change Password",
            ),
            profileButtonWidget(
              onTap: () {
                Get.to(NotificataionScreenView());
              },
              bottomIcon: Obx(
                () => Icon(
                  Icons.notification_important_rounded,
                  color: themeController.isDarkMode.value
                      ? Colors.black
                      : Colors.black,
                ),
              ),
              name: "Notification Settings",
            ),
            profileButtonWidget(
              onTap: () {
                Get.to(AboutAppScreen());
              },
              bottomIcon: Icon(Icons.help_outline_rounded, color: Colors.black),
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
      ),
    );
  }
}
