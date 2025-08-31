import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/auth/controller/auth_controller.dart';
import 'package:spotem/feature/home/controller/home_controller.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({super.key});
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 150,
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${authController.profileData.value?.name}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.appColor,
                          ),
                        ),
                        Text(
                          "Welcome to Spot'em365",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            // color: AppColors.appColor,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Spacer(),

                authController.profileData.value?.avatar != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          "${authController.profileData.value?.avatar.url}",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor: themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.grey[400],
                        child: Icon(
                          Icons.person,
                          color: themeController.isDarkMode.value
                              ? Colors.black
                              : Colors.black,
                        ),
                      ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.grey[300],
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: themeController.isDarkMode.value
                        ? Colors.red
                        : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 45,
              decoration: BoxDecoration(
                // color: AppColors.appColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.5, color: AppColors.appColor),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppColors.appColor),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          var shortestSide = MediaQuery.of(context).size.shortestSide;
          bool isMobile = shortestSide < 600;
          if (isMobile) {
            return Obx(
              () => Padding(
                padding: const EdgeInsets.all(16.0),
                // ignore: unnecessary_null_comparison
                child: homeController.reports == null
                    ? Center(child: Text("No Reports Found"))
                    : ListView.builder(
                        itemCount: homeController.reports.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode.value
                                    ? const Color.fromARGB(255, 32, 32, 32)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(45),
                                          child: Image.network(
                                            homeController
                                                .reports[index]
                                                .user
                                                .avatar
                                                .url,
                                            height: 45,
                                            width: 45,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    homeController
                                                        .reports[index]
                                                        .user
                                                        .name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),

                                                  // ...
                                                  Text(
                                                    DateFormat(
                                                      'yyyy-MM-dd – hh:mm a',
                                                    ).format(
                                                      homeController
                                                          .reports[index]
                                                          .createdAt,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          themeController
                                                              .isDarkMode
                                                              .value
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.more_vert),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Category: ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  themeController
                                                      .isDarkMode
                                                      .value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            homeController.reports[index].type,
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "Location : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                themeController.isDarkMode.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${homeController.reports[index].location}",
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        homeController
                                            .reports[index]
                                            .description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              themeController.isDarkMode.value
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          }
          return Center(child: Text("Other  Screen View"));
        },
      ),
    );
  }
}
