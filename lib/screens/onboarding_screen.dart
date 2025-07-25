import 'package:animated_introduction/animated_introduction.dart';
import 'package:easy_localization/easy_localization.dart';
// Onboarding Screen
//
// Description:
//   Provides an animated onboarding experience for the food delivery app.
//   Introduces users to key features and guides them to the login screen.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/login/login.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding-screen';
   OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedIntroduction(
      
      activeDotColor: isDark ? AppColors.white : Colors.black,
      containerBg:isDark ? AppColors.secondary : AppColors.white, //background color
      textColor: isDark ?AppColors.white : Colors.white, //text color : lightmode
      footerBgColor: isDark ? AppColors.black :Colors.orange, //footer container background color
      inactiveDotColor:isDark ? AppColors.primary : Colors.white,
      slides: pages,
      indicatorType: IndicatorType.circle,
      onDone: () {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      },
    );
    
    
  }
   List<SingleIntroScreen> pages = [
  
   SingleIntroScreen(
    title:  'onboarding_title_1'.tr(),
    description:'onboarding_desc_1'.tr(),
    imageAsset: 'assets/images/onboarding1.png',
  ),
  SingleIntroScreen(
  title:  'onboarding_title_2'.tr(),
  description:'onboarding_desc_2'.tr(),
  imageAsset: 'assets/images/onboarding2.png',
),
  SingleIntroScreen(
  title: 'onboarding_title_3'.tr(),
  description:  'onboarding_desc_3'.tr(),
  imageAsset: 'assets/images/onboarding3.png',
),
];
}