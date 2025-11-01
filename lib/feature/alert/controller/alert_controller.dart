import 'dart:async';

import 'package:get/get.dart';

import '../../../core/utils/pagination.dart';
import '../model/alert_model.dart';
import '../service/alert_service.dart';



class AlertController extends GetxController {
  final alertService = AlertService();

  AlertController(){
    fetchAlerts();
    _listenToAlertStream();
  }
  final Rx<Pagination<AlertModel>> alerts = Rx<Pagination<AlertModel>>(NotInitialized([]));

  void fetchAlerts({bool forceFetch = false}) async {
    if (forceFetch) {
      alerts.value = RefreshingPage([]);
      print("=============================== Have alart ${alerts.value.data}");
    } else {
      alerts.value = LoadingNextPage(alerts.value.data);
      print("=============================== No alart ${alerts.value.data}");
    }
    await alertService.getAlerts().then((lr) {
      lr.fold((l){
        alerts.value = Loaded(alerts.value.data);
      }, (r){
        final allAlerts = alerts.value.data + (r.data ?? []);
        alerts.value = (r.data?.isEmpty ?? true) ? AllLoaded(allAlerts) : Loaded(allAlerts);
        r.data?.forEach((alert) {
        });
      });
    });

  }

  StreamSubscription<AlertModel>? alertSubscription;

  _listenToAlertStream() {
    alertSubscription = alertService.alertStream().listen((alert) {
      alerts.value = Loaded(alerts.value.data + [alert]);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    alertSubscription?.cancel();
  }
}
