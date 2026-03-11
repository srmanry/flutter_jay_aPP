import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/feature/profile/data/model/profile.dart';
import 'package:spotem/feature/profile/presentation/controller/profile_controller.dart';

import '../../../../core/utils/app_colors.dart';

import 'edit_profile_view.dart';
import '../controller/theme_controller.dart';
import '../widgets/profile_card.dart';

class PersonalInfoScreenView extends StatefulWidget {
  const PersonalInfoScreenView({super.key});

  @override
  State<PersonalInfoScreenView> createState() => _PersonalInfoScreenViewState();
}

class _PersonalInfoScreenViewState extends State<PersonalInfoScreenView> {
  late final ProfileController profileController;
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    themeController = Get.put(ThemeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.to(() => AppGroundView(currentIndex: 4));
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        title: Text(
          "Personal Info",
          style: TextStyle(color: AppColors.appColor, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                final profile = profileController.userData.value;
                if (profile != null) {
                  Get.to(
                    () => EditProfileView(
                      profile: UserProfileModel(data: profile, success: true, message: ''),
                    ),
                  );
                }
              },
              icon: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.edit)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await profileController.fetchProfile();
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
                      border: Border.all(color: AppColors.appColor, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,

                        imageUrl: "${profileController.userData.value?.avatar.url}",
                        placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2, color: AppColors.appColor),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ProfileCardWidget(data: "${profileController.userData.value?.name}", typeName: "Name"),

                  /* ProfileCardWidget(
                    data: "${authController.profileData.value?.data.phone}",
                    typeName: "Phone",
                  ),*/
                  ProfileCardWidget(data: "${profileController.userData.value?.email}", typeName: "Gmail"),

                  /*  ProfileCardWidget(
                    data: "${authController.profileData.value?.data.address}",
                    typeName: "Address",
                  ),*/
                  ProfileCardWidget(
                    data: "${profileController.userData.value?.totalPosts}",
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
