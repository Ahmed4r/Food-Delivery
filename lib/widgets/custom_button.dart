import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/app_text_styles.dart';

class customButtom extends StatelessWidget {
  String title;
  Function()? onTap;
   customButtom({super.key,required this.title,this.onTap});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 327.w,
                    height: 62.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(title.tr(), style: AppTextStyles.button),
                    ),
                  ),
                );
  }
}