import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';

class ProfileCardWidget extends StatelessWidget {
  final String data;
  final String typeName;
  final Widget? widget;

  ProfileCardWidget({
    super.key,
    required this.data,
    required this.typeName,
    this.widget,
  });
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            typeName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value
                ? const Color.fromARGB(221, 32, 32, 32)
                : Color(0xffE8ECF1),

            // AppColors.fieldColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  //width:250,
                //width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  data,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              widget ?? const SizedBox(),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
