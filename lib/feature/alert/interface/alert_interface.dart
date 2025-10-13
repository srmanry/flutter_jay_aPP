import 'package:spotem/core/base/base_repository.dart';
import 'package:spotem/core/base/success.dart';
import 'package:spotem/core/helper/typedefs.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';

abstract base class AlertInterface extends BaseRepository{
  FutureRequest<Success<List<AlertModel>>> getAlerts();
  Stream<AlertModel> alertStream();
}