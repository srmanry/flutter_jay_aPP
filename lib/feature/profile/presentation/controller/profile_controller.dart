import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotem/core/common/custom_massage.dart';
import 'package:spotem/feature/profile/domain/repo/profile_repo.dart';
import 'package:spotem/feature/profile/presentation/view/personal_info_view.dart';
import 'package:spotem/feature/profile/presentation/view/profile_view.dart';

import '../../data/model/profile.dart';

class ProfileController extends GetxController {
  final ProfileRepo _repository;

  ProfileController(this._repository);

  // ── State ────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;

  final userData = Rxn<UserData>();

  final Rx<File?> selectedAvatar = Rx<File?>(null);
  @override
  void onInit() {
    super.onInit();
    print("🔥 ProfileController INIT");
    fetchProfile();
  }

  // ── Fetch ────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _repository.getUserProfile();
      userData.value = data.isNotEmpty ? data.first : null;
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Pick image ───────────────────────────────────────────
  Future<void> pickAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, imageQuality: 75, maxWidth: 1024);

      if (file != null) {
        selectedAvatar.value = File(file.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Couldn't pick image", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateProfile({required String name, required String address, File? avatar}) async {
    try {
      isUpdating.value = true;

      final response = await _repository.updateProfile(name: name, address: address, avatar: avatar);

      userData.value = response.data;
      CustomShowMessage.success(message: response.message);
      //Get.snackbar("Success", response.message);
      refresh();
      Get.to(() => PersonalInfoScreenView()); // Close the edit screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }
}
