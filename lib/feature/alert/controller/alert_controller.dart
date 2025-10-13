import 'dart:async';

import 'package:get/get.dart';
import 'package:spotem/core/utils/pagination.dart';
import 'package:spotem/feature/alert/interface/alert_interface.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';
import 'package:spotem/feature/alert/service/alert_service.dart';


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
    } else {
      alerts.value = LoadingNextPage(alerts.value.data);
    }
    await alertService.getAlerts().then((lr) {
      lr.fold((l){}, (r){
        final allAlerts = alerts.value.data + (r.data ?? []);
        alerts.value = (r.data?.isEmpty ?? true) ? AllLoaded(allAlerts) : Loaded(allAlerts);
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
