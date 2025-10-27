import 'package:flutter/cupertino.dart';

import '../../../core/base/success.dart';
import '../../../core/helper/format_response_data.dart';
import '../../../core/helper/typedefs.dart';
import '../../../core/service/api_services/api_service.dart';
import '../interface/alert_interface.dart';
import '../model/alert_model.dart';


base class AlertService extends AlertInterface{

  final ApiService apiService = ApiService();
  
  @override
  Stream<AlertModel> alertStream() {
    return apiService.listen("newAlerts").map((e) => AlertModel.fromJson(e));
  }

  @override
  FutureRequest<Success<List<AlertModel>>> getAlerts() async{
    return await asyncTryCatch(tryFunc: () async{
      final response = await apiService.get(
        "/report/alerts",
      );
        return Success(
          data: (extractBodyData(response) as List<dynamic>)
              .map((e) {
                final alert = AlertModel.fromJson(e as Map<String, dynamic>);
                debugPrint("Alert >> ${alert.toString()}");
                return alert;
          })
              .toList(),
        );
    });
  }

}