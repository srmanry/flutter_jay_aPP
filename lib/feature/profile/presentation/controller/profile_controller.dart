import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotem/feature/profile/repo/profile_repo.dart';

import '../../data/model/profile.dart';


class ProfileController extends GetxController {
  final ProfileRepository _repository;

  ProfileController(this._repository);

  // ================= STATE =================

  var isLoading = false.obs;
  var isUpdating = false.obs;

  Rx<UserData?> userData = Rx<UserData?>(null);

  File? selectedAvatar;

  // ================= FETCH PROFILE =================

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final data = await _repository.getProfileData();
      userData.value = data;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load profile",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PICK IMAGE =================

  Future<void> pickAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedAvatar = File(pickedFile.path);
        update(); // for GetBuilder if needed
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================= UPDATE PROFILE =================

  Future<void> updateProfile({required String name}) async {
    try {
      isUpdating.value = true;

      final updatedUser = await _repository.updateProfile(
        name: name,
        avatar: selectedAvatar,
      );

      userData.value = updatedUser;
      selectedAvatar = null;

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= LIFECYCLE =================

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }
}
