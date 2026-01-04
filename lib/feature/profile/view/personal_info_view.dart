
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../../auth/controller/auth_controller.dart';
import 'edit_profile_view.dart';
import '../controller/theme_controller.dart';
import '../widgets/profile_card.dart';

class PersonalInfoScreenView extends StatelessWidget {
  PersonalInfoScreenView({super.key});

  AuthController authController = Get.put(AuthController());

  ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(    leading: GestureDetector(onTap: () {Get.back();}, child: Icon(Icons.arrow_back_ios_rounded)),
        centerTitle: true,
        title: Text("Personal Info", style: TextStyle(color: AppColors.appColor, fontSize: 24, fontWeight: FontWeight.w700,),),
        iconTheme: IconThemeData(color: AppColors.appColor),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                final profile = authController.profileData.value?.data;
                if (profile != null) {
                  Get.to(() => EditProfileView(profile: authController.profileData.value!,),);
                }
              },
              icon: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.edit),),
            ),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await authController.fetchProfile();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [

/*
                  authController.profileData.value?.data.avatar.url == null ||
                      authController.profileData.value!.data.avatar.url.isEmpty ?

                  Icon(
                    Icons.account_circle_outlined,
                    color: const Color.fromARGB(255, 95, 94, 94),
                    size: 80,
                  ) : ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      authController.profileData.value!.data.avatar.url,
                      height: 80, width: 80, fit: BoxFit.cover,
                    ),
                  ),*/


                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.appColor, width: 2,),),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        imageUrl: "${authController.profileData.value?.data.avatar.url}",
                        placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2, color: AppColors.appColor,),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),


                  SizedBox(height: 20),
                  ProfileCardWidget(
                    data: "${authController.profileData.value?.data.name}",
                    typeName: "First Name",
                  ),

                 /* ProfileCardWidget(
                    data: "${authController.profileData.value?.data.phone}",
                    typeName: "Phone",
                  ),*/
                  ProfileCardWidget(
                    data: "${authController.profileData.value?.data.email}",
                    typeName: "Gmail",
                  ),
                /*  ProfileCardWidget(
                    data: "${authController.profileData.value?.data.address}",
                    typeName: "Address",
                  ),*/

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
      ),
      /*   bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
        child: buttonWidget(text: "Save", onTap: () {}),
      ), */
    );
  }
}
