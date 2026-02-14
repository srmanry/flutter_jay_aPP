/* import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // image picker
import 'package:spotem/feature/profile/presentation/controller/profile_controller.dart';

import '../../../../../../core/common/widgets/save_botton.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../data/model/profile.dart';
import '../../../auth/presentation/widget/change_password_field.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileModel profile;
  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
 final ProfileController profileController = Get.find<ProfileController>();

  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();

  File? pickedImage;

  @override
  void initState() {
    super.initState();

    imageController.text = widget.profile.data.avatar.url;
    nameController.text = widget.profile.data.name;

    phoneController.text = widget.profile.data.phone;
    addressController.text = widget.profile.data.address;
    genderController.text = widget.profile.data.gender;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor, size: 30),
        centerTitle: true,
        title: profileController.isLoading.value == true ? const Text("Profile") : const Text("Edit Profile"),

        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.appColor, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black12,
                            backgroundImage: pickedImage != null
                                ? FileImage(pickedImage!)
                                // ignore: unnecessary_null_comparison
                                : (widget.profile.data.avatar.url != null
                                      ? NetworkImage(widget.profile.data.avatar.url.toString()) as ImageProvider
                                      : null),
                            child:
                                (pickedImage == null &&
                                    // ignore: unnecessary_null_comparison
                                    widget.profile.data.avatar.url == null)
                                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: InkWell(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.appColor,
                              child: Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==== Fields ====
                  ChangePasswordField(fieldName: "Full Name", hinText: "full name", controller: nameController),
                  /*   ChangePasswordField(
                      fieldName: "Date of Birth",
                      hinText: "date off birth",
                      controller: emailController,
                    )*/
                  /*     ChangePasswordField(
                      fieldName: "Phone Number",
                      hinText: "phone number",
                      controller: phoneController,
                    ),
                    ChangePasswordField(
                      fieldName: "Address",
                      hinText: "Address",
                      controller: addressController,
                    ),
*/
                  const SizedBox(height: 20),

                  // ==== Save Button ====
                  /*   buttonWidget(
                    text: authController.isUpdateingProfile.value
                        ? "Saving..."
                        : "Save",
                    onTap: () async {
                      await authController.profileUpdate(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                        imageFile: pickedImage,
                      );
                    },
                  ), */
                  Obx(
                    () => buttonWidget(
                      text: profileController.isUpdating.value ? "Please wait..." : "Save",
                      onTap: profileController.isUpdating.value
                          ? null
                          : () async {
                              await profileController.updateProfile (
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                address: addressController.text,
                                imageFile: pickedImage,
                              );
                            },
                    ), 
                    
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_colors.dart';
import '../../data/model/profile.dart';
import '../controller/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileModel profile;
  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final ProfileController controller;

  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();

    nameCtrl = TextEditingController(text: widget.profile.data.name.trim());
    phoneCtrl = TextEditingController(text: widget.profile.data.phone.trim());
    addressCtrl = TextEditingController(text: widget.profile.data.address.trim());

    // Optional: pre-select current avatar (but usually we show network one)
    // controller.selectedAvatar.value = null; // ← normally start fresh
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    await controller.pickAvatar(ImageSource.gallery);
    if (mounted) setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Get.back()),
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // ── Avatar ───────────────────────────────────────
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.appColor, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.grey.shade200,
                            foregroundImage: _getAvatarImage(),
                            child: const Icon(Icons.person, size: 60, color: Colors.grey),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.appColor,
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // ── Fields ───────────────────────────────────────
                    _buildField("Full Name", nameCtrl),
                    const SizedBox(height: 16),
                    _buildField("Phone Number", phoneCtrl, keyboard: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildField("Address", addressCtrl, maxLines: 2),

                    const SizedBox(height: 48),

                    // ── Save Button ──────────────────────────────────
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isUpdating.value ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: controller.isUpdating.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text("Save Changes", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (controller.selectedAvatar.value != null) {
      return FileImage(controller.selectedAvatar.value!);
    }
    final url = widget.profile.data.avatar.url;
    if (url != null && url.isNotEmpty && url.startsWith('http')) {
      return NetworkImage(url);
    }
    return null;
  }

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (nameCtrl.text.trim().isEmpty) {
      Get.snackbar("Required", "Name cannot be empty");
      return;
    }

    final success = await /* controller.updateProfile(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      // avatar is already in controller.selectedAvatar
    ); */
    controller.updateProfile(
  name: nameCtrl.text.trim(),

  address: addressCtrl.text,
  avatar: controller.selectedAvatar.value,
);


    
  }
}
