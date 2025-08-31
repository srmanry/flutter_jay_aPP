import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/widgets/save_botton.dart';
import 'package:spotem/core/util/app_colors.dart';

import 'package:spotem/feature/profile/widgets/profile_card.dart';

class PersonalInfoScreenView extends StatelessWidget {
  const PersonalInfoScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Personal Info",
          style: TextStyle(
            color: AppColors.appColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ProfileCardWidget(data: "John Doe", typeName: "First Name"),
              ProfileCardWidget(data: "Foerer", typeName: "Last Name"),
              ProfileCardWidget(data: "25", typeName: "Age"),

              ProfileCardWidget(
                data: "Male",
                typeName: "Gender",
                widget: Icon(Icons.arrow_drop_down_circle_outlined),
              ),
              ProfileCardWidget(data: "uk", typeName: "Nationality"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
        child: buttonWidget(text: "Save", onTap: () {}),
      ),
    );
  }
}
