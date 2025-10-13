import 'package:flutter/material.dart';
import 'package:spotem/core/utils/app_colors.dart';

Widget buttonWidget({required String text, VoidCallback? onTap}) {
  return InkWell(
    //splashColor: ,
    onTap: onTap,
    child: Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
