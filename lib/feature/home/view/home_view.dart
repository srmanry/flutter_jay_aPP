import 'package:cached_network_image/cached_network_image.dart';
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
      //backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 150,
        title: Obx(
          () => Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello 👋 ${authController.profileData.value?.data.name ?? "Loading..."}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.appColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "🎉 Welcome to Spot'em365",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          // color: AppColors.appColor,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.grey[800],

                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),



                   Row(children: [Container(height: 40,width: 40,
                     child: Obx(()=>  ClipOval(
                       child: authController.profileData.value!.data.avatar.url.isEmpty?
                       Icon(Icons.account_circle_outlined,size: 30,)
                       :CachedNetworkImage(
                         imageUrl: authController.profileData.value!.data.avatar.url,
                         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                         errorWidget: (context, url, error) => const Icon(Icons.account_circle_outlined),
                         fadeInDuration: const Duration(milliseconds: 250),
                         fit: BoxFit.cover,
                       ),
                     ),


                     ),
                   ),

                     SizedBox(width: 10,),
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
                     ),],)
                ],
              ),

              // search bar =============
              SizedBox(height: 20),
              Obx(()=>Container(
                height: 45,
                decoration: BoxDecoration(
                  // color: AppColors.appColor,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1.5, color: themeController.isDarkMode.value?Colors.white:Color(0xFF777777)),
                ),
                child: TextField(
                  onChanged: (value){
                    homeController.searchByType(value);
                  },
                  decoration: InputDecoration(

                    prefixIcon: Icon(Icons.search, color: themeController.isDarkMode.value?Colors.grey:Colors.grey),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode.value?Colors.grey: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),)
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          var shortestSide = MediaQuery.of(context).size.shortestSide;
          bool isMobile = shortestSide < 600;
          if (isMobile) {
            return Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),

                child: homeController.filteredReports.isEmpty
                    ? Center(child: Text("No Reports Found",style: TextStyle(color: Colors.black),))
                    : ListView.builder(
                        itemCount: homeController.filteredReports.length,
                        itemBuilder: (_, index) {
                          final report = homeController.filteredReports[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                               color: themeController.isDarkMode.value ?  Colors.white: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(45),
                                          child: Image.network(
                                            homeController.reports[index].user.avatar.url,
                                            height: 45, width: 45, fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(homeController.reports[index].user.name,
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: themeController.isDarkMode.value ? Colors.black : Colors.white,),
                                                  ),

                                                  Text(
                                                    DateFormat('yyyy-MM-dd – hh:mm a',).format(homeController.reports[index].createdAt,),
                                                    style: TextStyle(
                                                      fontSize: 12, fontWeight: FontWeight.w400,
                                                      color: themeController.isDarkMode.value ? Colors.black : Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.more_vert,color: themeController.isDarkMode.value ? Colors.black : Colors.white,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10,),
                                      child: Row(
                                        children: [
                                          Text("Category: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: themeController.isDarkMode.value ? Colors.black : Colors.white,),),
                                          Text(
                                            homeController.filteredReports[index].type,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "Location : ", style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: themeController.isDarkMode.value ? Colors.black : Colors.white,
                                          ),
                                        ),

                                        Text(
                                          "${homeController.reports[index].location}",
                                          style: TextStyle(color: themeController.isDarkMode.value ? Colors.black : Colors.white,),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        homeController.reports[index].description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode.value ? Colors.black : Colors.white,
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
