import 'package:spotem/feature/profile/data/model/profile.dart';

abstract class ProfileRepo {
Future<List<UserData>> getUserProfile();
}