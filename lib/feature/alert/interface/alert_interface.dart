

import '../../../core/base/base_repository.dart';
import '../../../core/base/success.dart';
import '../../../core/helper/typedefs.dart';
import '../model/alert_model.dart';

abstract base class AlertInterface extends BaseRepository{
  FutureRequest<Success<List<AlertModel>>> getAlerts();
  Stream<AlertModel> alertStream();
}