import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {


  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor:  AppColors.black,
      foregroundColor: AppColors.white,
         toolbarHeight: 200,
    ),
    textTheme: const TextTheme(), // مش لازم هنا لأنك هتستخدم AppTextStyles مباشرة
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(   
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
         toolbarHeight: 200,
    ),
    textTheme: const TextTheme(),
  );
}
