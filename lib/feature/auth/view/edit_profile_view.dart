/* import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // image picker
import 'package:preisslerslunch/feature/auth/controller/auth_controller.dart';
import 'package:preisslerslunch/feature/auth/model/profile.dart';
import 'package:preisslerslunch/feature/auth/widget/change_password_field.dart';

import '../../../../../core/common/widgets/save_botton.dart';

class EditProfileView extends StatefulWidget {
  final ProfileModel profile;
  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController authController = Get.put(AuthController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profile.name;
    emailController.text = widget.profile.email;
    phoneController.text = widget.profile.phoneNumber;
    companyController.text = widget.profile.companyName;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: authController.rememberMe.value == true
            ? const Text("Profile")
            : const Text("Edit Profile"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ==== Profile Image ====
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black12,
                            backgroundImage: pickedImage != null
                                ? FileImage(pickedImage!)
                                : (widget.profile.profileImage != null
                                      ? NetworkImage(
                                              widget.profile.profileImage!,
                                            )
                                            as ImageProvider
                                      : null),
                            child:
                                (pickedImage == null &&
                                    widget.profile.profileImage == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: InkWell(
                              onTap: pickImage,
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
                        ],
                      ),
                    ),

                    // ==== Fields ====
                    ChangePasswordField(
                      fieldName: "Full Name",
                      hinText: "full name",
                      controller: nameController,
                    ),
                    ChangePasswordField(
                      fieldName: "Email",
                      hinText: "Email",
                      controller: emailController,
                    ),
                    ChangePasswordField(
                      fieldName: "Phone Number",
                      hinText: "phone number",
                      controller: phoneController,
                    ),
                    ChangePasswordField(
                      fieldName: "Company Name",
                      hinText: "Company Name",
                      controller: companyController,
                    ),

                    const SizedBox(height: 20),

                    // ==== Save Button ====
                    buttonWidget(
                      text: "Save",
                      onTap: () async {
                        print("Save Button Clicked");
                        await authController.profileUpdate(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          company: companyController.text,
                          imageFile: pickedImage,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("Desktop View"));
          }
        },
      ),
    );
  }
}
 */