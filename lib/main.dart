import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await loadSavedThemeMode(container);
  WebViewPlatform.instance ??= AndroidWebViewPlatform();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBTKQUPtXgfbnQpIos4VoddRBmdMsSukzs",
      appId: "1:4958439163:ios:4d9f7e7d8a5e9e6cbe3125e",
      projectId: "foodapp-e68fd",
      messagingSenderId: "4958439163",
      storageBucket: "foodapp-e68fd.firebasestorage.app",
      iosBundleId: "com.example.food_delivery",
      iosClientId:
          "4958439163-75t6jvm7cuhn0jncvov9v16g09kf92fc.apps.googleusercontent.com",
    ));
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBTKQUPtXgfbnQpIos4VoddRBmdMsSukzs",
        appId: "1:4958439163:android:21cbb7fc4a5e0c5be3125e",
        projectId: "foodapp-e68fd",
        messagingSenderId: "4958439163",
        storageBucket: "foodapp-e68fd.firebasestorage.app",
      ),
    );
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // Send to Firebase Crashlytics if needed
  };

  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getBool('authToken') ?? false;
  final flag = prefs.getBool('hasSeenOnboarding') ?? false;
  final role = prefs.getString('role');
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runZonedGuarded(() {
    runApp(
      EasyLocalization(
        startLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        child: ProviderScope(
            child: UncontrolledProviderScope(
                container: container,
                child: FoodDelivery(
                    token: token,
                    flag: flag,
                    role: role,
                    isDarkMode: isDarkMode))),
      ),
    );
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class FoodDelivery extends ConsumerWidget {
  final bool token;
  final bool flag;
  final String? role;
  final bool? isDarkMode;
  const FoodDelivery(
      {super.key,
      required this.token,
      required this.flag,
      this.role,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    String initialRoute;
    initialRoute = LoginPage.routeName;
    if (flag == false) {
      initialRoute = OnboardingScreen.routeName;
    } else if (token == false && flag == true) {
      initialRoute = LoginPage.routeName;
    } else {
      if (role == 'owner') {
        initialRoute = OwnerHomepage.routeName;
      } else {
        initialRoute = Homepage.routeName;
      }
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
          // home: LoginPage(),

          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          routes: {
            OnboardingScreen.routeName: (context) => OnboardingScreen(),
            LoginPage.routeName: (context) => const LoginPage(),
            ForgotPassword.routeName: (context) => const ForgotPassword(),
            OtpScreen.routeName: (context) => const OtpScreen(),
            SignupPage.routeName: (context) => const SignupPage(),
            LocationAccessPage.routeName: (context) =>
                const LocationAccessPage(),
            Homepage.routeName: (context) => const Homepage(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            EditProfile.routeName: (context) => const EditProfile(),
            SettingsPage.routeName: (context) => const SettingsPage(),
            FaqsScreen.routeName: (context) => FaqsScreen(),
            AddressListScreen.routeName: (context) => const AddressListScreen(),
            GetGeolocation.routeName: (context) => const GetGeolocation(),
            PaymentSystemScreen.routeName: (context) =>
                const PaymentSystemScreen(),
            OwnerHomepage.routeName: (context) => const OwnerHomepage(),
            RestaurantViewScreen.routeName: (context) =>
                const RestaurantViewScreen(),
            BottomNav.routeName: (context) => const BottomNav(),
          },
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeAnimationCurve: Curves.fastOutSlowIn,
         
          themeMode: themeMode),
    );
  }
}
