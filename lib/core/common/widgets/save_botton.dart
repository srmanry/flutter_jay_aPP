import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

Widget buttonWidget({required String text, VoidCallback? onTap, Widget? child, bool isLoading = false}) {
  return InkWell(
    //splashColor: ,
    onTap: isLoading ? null : onTap,
    child: Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
              )
            : (child ??
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                )),
      ),
    ),
  );
}
