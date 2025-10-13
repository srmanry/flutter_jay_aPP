import 'package:get/get.dart';
import 'package:spotem/core/utils/pagination.dart';
import 'package:spotem/feature/alert/interface/alert_interface.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';


class AlertController extends GetxController {
  final Rx<Pagination<AlertModel>> alerts = NotInitialized<AlertModel>([]).obs;

  void fetchAlerts({bool forceFetch = false}) async {
    if (forceFetch) {
      alerts.value = RefreshingPage([]);
    } else {
      alerts.value = LoadingNextPage(alerts.value.data);
    }
    Get.find<AlertInterface>().getAlerts().then((lr) {
      lr.fold((l){}, (r){
        final allAlerts = alerts.value.data + (r.data ?? []);
        alerts.value = (r.data?.isEmpty ?? true) ? AllLoaded(allAlerts) : Loaded(allAlerts);
      });
    });

  }
}
