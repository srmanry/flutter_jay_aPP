
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/controller/theme_controller.dart';

class ChangePasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final String? textFieldName;
  final String? fieldName;
  final String? hinText;
  final bool? obscureText;
  final Widget? priFixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool? obscureCharacter;
  final Color? focusColor;
  final Widget? outLineBorder;
  final bool? isReadOnly;

  ChangePasswordField({
    super.key,
    this.textFieldName,
    this.hinText,
    this.priFixIcon,
    this.suffixIcon,
    this.controller,
    this.textInputType,
    this.obscureCharacter,
    this.outLineBorder,
    this.focusColor,
    this.fieldName,
    this.obscureText,
    this.isReadOnly,
  });
  ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$fieldName",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black,
            fontSize: 16,

          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),

            //color: AppColors.fieldColor,
            // border: Border.all(color: Colors.red),
            //color: const Color(0xFFE8ECF1),
            color: themeController.isDarkMode.value?Colors.white
               // ? const Color.fromARGB(221, 32, 32, 32)
                : Color(0xFFE8ECF1)
          ),
          child: TextFormField(
            // obscureText: obscureText,
            controller: controller,
            keyboardType: textInputType,
            decoration: InputDecoration(
              focusColor: focusColor,

              hintText: hinText,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF777D87),
              ),
              prefixIcon: priFixIcon,
              suffixIcon: suffixIcon,
              iconColor: Colors.black,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: themeController.isDarkMode.value
                      ? Colors.black
                      : Color(0xFFFFFFFF),
                  width: 0.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFFFFFF)),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
