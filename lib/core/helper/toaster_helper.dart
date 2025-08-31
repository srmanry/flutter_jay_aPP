/* import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_project/helper/responsive_helper.dart';
import 'package:test_project/util/dimensions.dart';
import 'package:test_project/util/styles.dart';


ColorFilter? svgIconColor([Color? color]){
  if(color == null){return null;}
  return ColorFilter.mode(color, BlendMode.srcIn);
}

void showCustomSnackBar(String message, {bool isError = true, bool getXSnackBar = false, int seconds = 3, bool isToaster = false}) {

  isToaster?
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0
  ):

  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(
      right: ResponsiveHelper.isDesktop ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    content: Text(message, style: textMedium.copyWith(color: Colors.white)),
  ));
}
 */