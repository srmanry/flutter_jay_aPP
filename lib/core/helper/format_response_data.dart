import 'package:dio/dio.dart';


  dynamic extractBodyData(Response<dynamic> response) {
    return response.data["data"];
  }

  String? extractSuccessMessage(Response<dynamic> response,){
    try {
      return (response.data["success"] as bool) == true ? response.data["message"] as String : null;
    } catch (e) {
      return null;
    }
  }

  