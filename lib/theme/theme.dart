import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {


  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
   scaffoldBackgroundColor:AppColors.white,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor:  AppColors.black,
      foregroundColor: AppColors.white,
         toolbarHeight: 200,
    ),
    textTheme: const TextTheme(), // مش لازم هنا لأنك هتستخدم AppTextStyles مباشرة
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor:AppColors.secondary,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(   
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
         toolbarHeight: 200,
    ),
    textTheme: const TextTheme(),
  );
}
