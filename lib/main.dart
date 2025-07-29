import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/edit_profile.dart';
import 'package:food_delivery/screens/customer/customer_homepage.dart';
import 'package:food_delivery/screens/customer/restaurant_view.dart';
import 'package:food_delivery/screens/drawer/address.dart';
import 'package:food_delivery/screens/drawer/faqs.dart';
import 'package:food_delivery/screens/drawer/payments.dart';
import 'package:food_delivery/screens/drawer/personal_info.dart';
import 'package:food_delivery/screens/drawer/settings_page.dart';
import 'package:food_delivery/screens/location/get_geolocation.dart';
import 'package:food_delivery/screens/location/location_page.dart';
import 'package:food_delivery/screens/login/forgot_password/forgot_password.dart';
import 'package:food_delivery/screens/login/login.dart';
import 'package:food_delivery/screens/login/otp/otp_screen.dart';
import 'package:food_delivery/screens/onboarding_screen.dart';
import 'package:food_delivery/screens/restaurant/owner_homepage.dart';
import 'package:food_delivery/screens/signup/signup.dart';
import 'package:food_delivery/theme/theme.dart';
import 'package:food_delivery/theme/theme_provider.dart';
import 'package:food_delivery/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyBTKQUPtXgfbnQpIos4VoddRBmdMsSukzs",
    //   appId: "1:4958439163:android:21cbb7fc4a5e0c5be3125e",
    //   projectId: "foodapp-e68fd",
    //   messagingSenderId: "4958439163",
    //   storageBucket: "foodapp-e68fd.firebasestorage.app",
    // ),
  // );

  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getBool('authToken') ?? false;
  final flag = prefs.getBool('hasSeenOnboarding') ?? false;
  final role = prefs.getString('role');

  runApp(
    EasyLocalization(
      startLocale: Locale('en'),
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: Locale('en'),
      child: ProviderScope(
        child: FoodDelivery(token: token, flag: flag, role: role),
      ),
    ),
  );
}

class FoodDelivery extends ConsumerWidget {
  final bool token;
  final bool flag;
  final String? role;
  const FoodDelivery({super.key, required this.token,required this.flag, this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

     String initialRoute;
    if (flag==false) {
      initialRoute = OnboardingScreen.routeName;
    } 
    else if (token==false && flag==true) {
      initialRoute = LoginPage.routeName;
    } else {
  if (role == 'owner') {
    initialRoute = OwnerHomepage.routeName;
  } else {
    initialRoute = Homepage.routeName;
  }
}
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
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
        AddressListScreen.routeName: (context) => AddressListScreen(),
        GetGeolocation.routeName: (context) => GetGeolocation(),
        PaymentSystemScreen.routeName: (context) => PaymentSystemScreen(),
        OwnerHomepage.routeName : (context)=> OwnerHomepage() ,
        RestaurantViewScreen.routeName : (context)=> RestaurantViewScreen(),
        BottomNav.routeName: (context) => BottomNav(),
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
      ),
    );
  }
}
