import 'package:flutter/material.dart';
import 'package:spotem/core/util/app_colors.dart';

class ProfileCardWidget extends StatelessWidget {
  final String data;
  final String typeName;
  final Widget? widget;

  const ProfileCardWidget({
    
    super.key,
    required this.data,
    required this.typeName,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          typeName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.fieldColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                    color: Color(0xff777d87),
                  
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
