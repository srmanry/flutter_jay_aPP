import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/widgets/save_botton.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/auth/controller/auth_controller.dart';
import 'package:spotem/feature/auth/view/edit_profile_view.dart';

import 'package:spotem/feature/profile/widgets/profile_card.dart';

class PersonalInfoScreenView extends StatelessWidget {
  PersonalInfoScreenView({super.key});

  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Personal Info",
          style: TextStyle(
            color: AppColors.appColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              final profile = authController.profileData.value?.data;
              if (profile != null) {
                Get.to(
                  () => EditProfileView(
                    profile: authController.profileData.value!,
                  ),
                );
              }
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                authController.profileData.value == null
                    ? Center(child: CircularProgressIndicator())
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black12,
                        child:
                            authController.profileData.value?.data.avatar ==
                                null
                            ? Icon(
                                Icons.photo_size_select_large_rounded,
                                color: const Color.fromARGB(255, 95, 94, 94),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(45),
                                child: Image.network(
                                  "${authController.profileData.value?.data.avatar.url.toString()}",
                                  height: 67,
                                  fit: BoxFit.cover,
                                  width: 70,
                                ),
                              ),
                      ),
                SizedBox(height: 20),
                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.name}",
                  typeName: "First Name",
                ),

                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.gender}",
                  typeName: "Gender",
                ),
                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.phone}",
                  typeName: "Phone",
                ),
                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.email}",
                  typeName: "Gmail",
                ),
                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.address}",
                  typeName: "Address",
                ),

                ProfileCardWidget(
                  data: "${authController.profileData.value?.data.totalPosts}",
                  typeName: "Total Posts",
                  // widget: Icon(Icons.arrow_drop_down_circle_outlined),
                ),
                //ProfileCardWidget(data: "uk", typeName: "Nationality"),
              ],
            ),
          ),
        ),
      ),
      /*   bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
        child: buttonWidget(text: "Save", onTap: () {}),
      ), */
    );
  }
}
