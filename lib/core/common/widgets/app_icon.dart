import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

class AppIconWidget extends StatelessWidget {
  AppIconWidget({super.key});
  final ThemeController themeController = ThemeController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/app_icon.png', width: 100, height: 100),
        const SizedBox(height: 10),

        Obx(
          () => Text(
            'Spot’em365',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode.value
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }
}
