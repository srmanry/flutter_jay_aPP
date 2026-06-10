import 'dart:io';

import 'package:spotem/feature/profile/data/model/profile.dart';

abstract class ProfileRepo {
Future<List<UserData>> getUserProfile();



  Future<UserProfileModel> updateProfile({
    required String name,
    required String address,
    File? avatar,
  });


}


