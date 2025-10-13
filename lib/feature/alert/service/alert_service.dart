import 'package:spotem/core/base/success.dart';
import 'package:spotem/core/helper/format_response_data.dart';
import 'package:spotem/core/helper/typedefs.dart';
import 'package:spotem/core/service/api_services/api_service.dart';
import 'package:spotem/feature/alert/interface/alert_interface.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';

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
        "/alert",
      );
        return Success(
          data: (extractBodyData(response) as List<dynamic>)
              .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
    });
  }

}