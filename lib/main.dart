import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/edit_profile.dart';
import 'package:food_delivery/screens/customer/homepage.dart';
import 'package:food_delivery/screens/drawer/faqs.dart';
import 'package:food_delivery/screens/drawer/personal_info.dart';
import 'package:food_delivery/screens/drawer/settings_page.dart';
import 'package:food_delivery/screens/location/location_page.dart';
import 'package:food_delivery/screens/login/forgot_password/forgot_password.dart';
import 'package:food_delivery/screens/login/login.dart';
import 'package:food_delivery/screens/login/otp/otp_screen.dart';
import 'package:food_delivery/screens/onboarding_screen.dart';
import 'package:food_delivery/screens/signup/signup.dart';
import 'package:food_delivery/theme/theme.dart';
import 'package:food_delivery/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      
      startLocale: Locale('en'),
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: Locale('en'),
      child: ProviderScope(child: FoodDelivery()),
    ),
  );
}

class FoodDelivery extends ConsumerWidget {
  const FoodDelivery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return ScreenUtilInit(
      designSize: Size(375, 812),
      
      
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        initialRoute: OnboardingScreen.routeName,
        routes: {
          OnboardingScreen.routeName: (context) => OnboardingScreen(),
     
        LoginPage.routeName: (context) => LoginPage(),
        ForgotPassword.routeName: (context) => ForgotPassword(),
        OtpScreen.routeName: (context) => OtpScreen(),
        SignupPage.routeName: (context) => SignupPage(),
        LocationAccessPage.routeName: (context) => LocationAccessPage(),
        Homepage.routeName: (context) => Homepage(),
        ProfileScreen.routeName:  (context) => ProfileScreen(),
        EditProfile.routeName: (context) => EditProfile(),
        SettingsPage.routeName: (context) => SettingsPage(),
        FaqsScreen.routeName: (context) => FaqsScreen(),
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
