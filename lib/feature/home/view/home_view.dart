import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/internet_controller.dart';
import '../../alert/ui/view/alert_view.dart';
import '../../auth/controller/auth_controller.dart';
import '../../profile/controller/theme_controller.dart';
import '../controller/home_controller.dart';
import 'view_report_screen.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({super.key});
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.put(ThemeController());
  final HomeController homeController = Get.put(HomeController());
  final InternetController internetController = Get.put(InternetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 150,
        title: internetController.isConnected.value
            ? Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                maxLines: 1,
                                authController.profileData.value?.data.name ??
                                    " ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Welcome to",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  " Spotem365",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    // color: AppColors.appColor,
                                    //color: themeController.isDarkMode.value ? Colors.white : Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),

                        //internetController.isConnected.value?Center(child: Text("No Internet Connection")):
                        internetController.isConnected.value
                            ? Row(
                                children: [
                                  Obx(
                                    () => ClipOval(
                                      child: authController.isLoading == true
                                          ? CircularProgressIndicator()
                                          :
                                            // authController.profileData.value!.data.avatar.url.isEmpty
                                            (authController
                                                    .profileData
                                                    .value
                                                    ?.data
                                                    .avatar
                                                    .url
                                                    .isEmpty ??
                                                true)
                                          ? Icon(
                                              Icons.account_circle_outlined,
                                              size: 30,
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color:
                                                      themeController
                                                          .isDarkMode
                                                          .value
                                                      ? Colors.white
                                                      : AppColors.appColor,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                                child: CachedNetworkImage(
                                                  imageUrl: authController
                                                      .profileData
                                                      .value!
                                                      .data
                                                      .avatar
                                                      .url,
                                                  height: 45,
                                                  width: 45,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => const Icon(
                                                        Icons
                                                            .account_circle_outlined,
                                                        size: 40,
                                                      ),
                                                  fadeInDuration:
                                                      const Duration(
                                                        milliseconds: 250,
                                                      ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => AlertScreen(),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          themeController.isDarkMode.value
                                          ? Colors.white
                                          : Colors.grey[300],
                                      child: Icon(
                                        Icons.notifications_none_outlined,
                                        color: themeController.isDarkMode.value
                                            ? Colors.red
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),

                    // search bar =============
                    SizedBox(height: 20),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1.5,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Color(0xFF777777),
                        ),
                      ),
                      child: Obx(
                        () => TextField(
                          onChanged: (value) {
                            homeController.searchByCategory(value);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: themeController.isDarkMode.value
                                  ? Colors.black
                                  : Colors.black,
                            ),
                            hintText: 'Search by category',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: themeController.isDarkMode.value
                                  ? Colors.grey
                                  : Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
      body: RefreshIndicator.adaptive(
        color: themeController.isDarkMode.value ? Colors.black : Colors.white,
        backgroundColor: themeController.isDarkMode.value
            ? Colors.white
            : Colors.black,
        onRefresh: () async {
          await homeController.fetchReports();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            {
              return internetController.isConnected == true
                  ? Obx(
                      () => homeController.isLoading.value
                          ? Center(
                              child: Text(
                                "Loading....",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: homeController.filteredReports.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No Reports Found",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          homeController.filteredReports.length,
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  themeController
                                                      .isDarkMode
                                                      .value
                                                  ? Colors.white
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                10.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                45,
                                                              ),
                                                          border: Border.all(
                                                            width: 1.5,
                                                            color:
                                                                themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? Colors.white
                                                                : AppColors
                                                                      .appColor,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                45,
                                                              ),
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                homeController
                                                                    .reports[index]
                                                                    .user
                                                                    .avatar
                                                                    .url,
                                                            height: 45,
                                                            width: 45,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (
                                                                  context,
                                                                  url,
                                                                ) => CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                            errorWidget:
                                                                (
                                                                  context,
                                                                  url,
                                                                  error,
                                                                ) => Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 150,
                                                                  child: Text(
                                                                    homeController
                                                                        .reports[index]
                                                                        .user
                                                                        .name,
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color:
                                                                          themeController
                                                                              .isDarkMode
                                                                              .value
                                                                          ? Colors.black
                                                                          : Colors.white,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),

                                                                Text(
                                                                  DateFormat(
                                                                    'yyyy-MM-dd – hh:mm a',
                                                                  ).format(
                                                                    homeController
                                                                        .reports[index]
                                                                        .createdAt,
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        themeController
                                                                            .isDarkMode
                                                                            .value
                                                                        ? Colors
                                                                              .black
                                                                        : Colors
                                                                              .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Get.to(
                                                                  () => ViewReportScreen(
                                                                    report: homeController
                                                                        .reports[index],
                                                                  ),
                                                                  transition:
                                                                      Transition
                                                                          .cupertino,
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color:
                                                                    themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                          .black
                                                                    : Colors
                                                                          .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Category : ",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          homeController
                                                              .filteredReports[index]
                                                              .type,
                                                          style: TextStyle(
                                                            color:
                                                                themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Location :",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                      FutureBuilder<String>(
                                                        future: homeController
                                                            .getPlaceName(
                                                              homeController
                                                                  .reports[index]
                                                                  .location
                                                                  .lat,
                                                              homeController
                                                                  .reports[index]
                                                                  .location
                                                                  .lng,
                                                            ),
                                                        builder: (context, snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Text(
                                                              "Loading...",
                                                              style: TextStyle(
                                                                color:
                                                                    themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                          .black
                                                                    : Colors
                                                                          .white,
                                                              ),
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return const Text(
                                                              "Unknown location",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          } else {
                                                            return Text(
                                                              snapshot.data ??
                                                                  "Unknown",
                                                              style: TextStyle(
                                                                color:
                                                                    themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                          .black
                                                                    : Colors
                                                                          .white,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                    child: Text(
                                                      homeController
                                                          .reports[index]
                                                          .title,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            themeController
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                    child: Text(
                                                      homeController
                                                          .reports[index]
                                                          .description,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            themeController
                                                                .isDarkMode
                                                                .value
                                                            ? Colors.black
                                                            : Colors.white,
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
                    )
                  : Center(
                      child: Text(
                        "Chack Your Internet Connection",
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
