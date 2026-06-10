import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_colors.dart';
import '../../data/model/profile.dart';
import '../controller/profile_controller.dart';
import '../controller/theme_controller.dart';

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

  ThemeController themeController = Get.put(ThemeController());
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ── Avatar ───────────────────────────────────────
                    Center(
                      child: Stack(
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
                    ),

                    const SizedBox(height: 40),

                    // ── Fields ───────────────────────────────────────
                    Text(
                      "Full Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 8),
                    _buildField("Name", nameCtrl),
                    const SizedBox(height: 10),

                    /*   Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                    ), */
                    const SizedBox(height: 8),

                    //   _buildField("Phone Number", phoneCtrl, keyboard: TextInputType.phone),
                    const SizedBox(height: 16),
                    /*     Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildField("Address", addressCtrl, maxLines: 2), */

                    //const SizedBox(height: 48),

                    // ── Save Button ──────────────────────────────────
                    /*   Obx(
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
                              : const Text("Save", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ), */
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!controller.isUpdating.value) {
                              _saveProfile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: controller.isUpdating.value
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : const Text("Save", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
    if (url.isNotEmpty && url.startsWith('http')) {
      return NetworkImage(url);
    }
    return null;
  }

  /*   Widget _buildField(String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        fillColor: ,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  } */

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    final theme = Theme.of(context);
    final ThemeController themeController = Get.put(ThemeController());
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor.withValues(alpha: 0.1),
        // labelText: label,
        //labelStyle: theme.textTheme.bodyMedium?.copyWith(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(color: themeController.isDarkMode.value ? Colors.white : Colors.black),
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
    ); */ controller.updateProfile(name: nameCtrl.text.trim(), address: addressCtrl.text, avatar: controller.selectedAvatar.value);
  }
}
