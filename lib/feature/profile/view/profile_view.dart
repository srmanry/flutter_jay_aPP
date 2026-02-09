import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/profile/controller/profile_controller.dart';
import 'package:spotem/feature/profile/model/profile.dart';

import '../../../core/common/widgets/app_icon.dart';
import '../../../core/utils/app_colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/presentation/view/change_password_view.dart';
import '../controller/theme_controller.dart';
import '../widgets/profile_botton_widget.dart';
import 'personal_info_view.dart';
import 'about_app_screen.dart';
import 'pricacy_screen.dart';

class ProfileScreenView extends StatelessWidget {
  ProfileScreenView({super.key});

  ProfileController profileController = Get.find<ProfileController>();

  final authController = Get.find<AuthController>();
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Obx(() {
          final profile = profileController.userData.value;
          if (profile == null) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[400],
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 20, width: 100, color: Colors.grey[300]),
                      SizedBox(height: 5),
                      Container(height: 14, width: 150, color: Colors.grey[300]),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ],
            );
          } else {
            final avatarUrl = profile.avatar?.url ?? '';
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.appColor, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),

                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.value ? Colors.white : AppColors.appColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        profile.email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch(
                    value: themeController.isDarkMode.value,
                    onChanged: (_) => themeController.toggleTheme(),
                    // activeColor: Colors.white,
                  ),
                ),
              ],
            );
          }
        }),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            profileButtonWidget(
              onTap: () {
                // Get.to(PersonalInfoScreenView());
              },
              bottomIcon: Obx(() => Icon(Icons.payment_rounded, color: themeController.isDarkMode.value ? Colors.white : Colors.black)),

              name: "Personal Info",
            ),
            profileButtonWidget(
              onTap: () {
                Get.to(ChangePasswordView());
              },
              bottomIcon: Obx(
                () => Icon(Icons.lock_outline_rounded, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
              ),

              name: "Change Password",
            ),
            /* profileButtonWidget(
              onTap: () {
                Get.to(NotificataionScreenView());
              },
              bottomIcon: Obx(
                () => Icon(
                  Icons.notifications_outlined,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              name: "Notification Settings",
            ),*/
            profileButtonWidget(
              onTap: () {
                Get.to(AboutAppScreen());
              },
              bottomIcon: Obx(
                () => Icon(Icons.help_outline_rounded, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
              ),
              name: "About",
            ),

            profileButtonWidget(
              onTap: () {
                Get.to(PrivacyPolicyView());
              },
              bottomIcon: Obx(
                () => Icon(Icons.privacy_tip_outlined, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
              ),
              name: "Privacy Policy",
            ),

            profileButtonWidget(
              onTap: () {
                Get.defaultDialog(
                  title: "",
                  content: Column(
                    children: [
                      AppIconWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Are you sure to account Delete?",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              //  authController.deleteAccount();
                            },
                            child: Container(
                              width: 100,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.red,
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.appColor),
                              child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
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
              bottomIcon: Icon(Icons.delete, color: Colors.red),
              name: "Delete Account",
            ),

            profileButtonWidget(
              onTap: () {
                Get.defaultDialog(
                  title: "",
                  content: Column(
                    children: [
                      AppIconWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Are You Sure To Log Out?",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
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
                                border: Border.all(color: AppColors.appColor, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w600, fontSize: 16),
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.appColor),
                              child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}
