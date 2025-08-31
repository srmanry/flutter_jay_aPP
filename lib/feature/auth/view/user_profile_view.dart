/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:preisslerslunch/feature/auth/view/edit_profile_view.dart';

import '../controller/auth_controller.dart';
import '../widget/profile_card.dart';

class UserProfileView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  UserProfileView({super.key}) {
    authController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        /*  actions: [
          IconButton(
            onPressed: () {},
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            ),
          ),
        ], */
      ),

      body: Obx(() {
        if (authController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = authController.profileData.value;

        if (profile == null) {
          return Center(child: Text("No Profile Data"));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.black12,
                      child:
                          authController.profileData.value?.profileImage == null
                          ? Icon(
                              Icons.photo_size_select_large_rounded,
                              color: const Color.fromARGB(255, 95, 94, 94),
                            )
                          : Image.network(
                              "${authController.profileData.value?.profileImage.toString()}",
                            ),
                    ),

                    Positioned(
                      bottom: -4,
                      right: -5,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => EditProfileView(profile: profile));
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    /*  Positioned(
                      bottom: -5,
                      right: -5,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => EditProfileView(profile: profile));
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ), */
                  ],
                ),
              ),

              /*        Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                  Positioned(top: 50,left: 75,child: InkWell(
                    onTap: (){
                      Get.to(()=>EditProfileView());
                    },
                    child: Icon(Icons.edit_note,size: 30,),

                  ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    child: CachedNetworkImage(
                      imageUrl: profile.profileImage ?? "",
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.photo, size: 40,color: Colors.grey[500],),
                    ),
                  ),
                ],),
              ),*/
              SizedBox(height: 16),
              ProfileCardWidget(data: profile.name, typeName: "Name"),
              ProfileCardWidget(data: profile.email, typeName: "Email"),
              ProfileCardWidget(
                data: profile.phoneNumber,
                typeName: "Phone Number",
              ),
              ProfileCardWidget(
                data: profile.companyName,
                typeName: "Company Name",
              ),

              // ProfileCardWidget(data: profile.name, typeName: "Name"),
              // ProfileCardWidget(data: profile.name, typeName: "Name"),
            ],
          ),
        );
      }),
    );
  }
}
 */