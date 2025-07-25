import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/customer/homepage.dart';
import 'package:food_delivery/screens/login/forgot_password/forgot_password.dart';
import 'package:food_delivery/screens/signup/signup.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/app_text_styles.dart';
import 'package:food_delivery/widgets/custom_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = '/login_page';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _login_pageState();
}

class _login_pageState extends ConsumerState<LoginPage> {
  SharedPreferences? sahredPref;
  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    sahredPref = await SharedPreferences.getInstance();
    setState(() {
      checkboxvalue = sahredPref!.getBool('remember') ?? false;
      if (checkboxvalue == true) {
        Emailcontroller.text = sahredPref!.getString('email') ?? '';
        Passwordcontroller.text = sahredPref!.getString('password') ?? '';
      } else {
        Emailcontroller.text = '';
        Passwordcontroller.text = '';
      }
    });
  }

  TextEditingController Emailcontroller = TextEditingController(text: '');
  TextEditingController Passwordcontroller = TextEditingController(text: '');
  bool isobsecured = false;
  bool checkboxvalue = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'login'.tr(),
              style: GoogleFonts.sen(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
            Text(
              'Please sign in to your existing account'.tr(),
              style: GoogleFonts.sen(
                fontSize: 16.sp,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(height: 40.h),

                SizedBox(
                  width: 327.w,

                  child: TextField(
                    controller: Emailcontroller,

                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      label: Padding(
                        padding: EdgeInsets.only(bottom: 20.0.h),
                        child: Text(
                          'email'.tr(),
                          style: GoogleFonts.cairo(fontSize: 20.sp),
                        ),
                      ),
                      hintStyle: GoogleFonts.sen(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),

                      hintText: 'example@gmail.com'.tr(),
                      labelStyle: GoogleFonts.sen(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                SizedBox(
                  width: 327.w,

                  child: TextField(
                    controller: Passwordcontroller,
                    obscureText: isobsecured == true ? false : true,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isobsecured = !isobsecured;
                          });
                        },
                        icon: isobsecured
                            ? FaIcon(FontAwesomeIcons.eye)
                            : FaIcon(FontAwesomeIcons.eyeSlash),
                      ),

                      hintStyle: GoogleFonts.sen(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      label: Padding(
                        padding: EdgeInsets.only(bottom: 20.0.h),
                        child: Text(
                          'password'.tr(),
                          style: GoogleFonts.sen(fontSize: 20.sp),
                        ),
                      ),
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.sen(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),

                      hintText: 'password'.tr(),

                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                      value: checkboxvalue,
                      onChanged: (value) async {
                        setState(() {
                          checkboxvalue = value!;
                        });
                        SharedPreferences sahredPref =
                            await SharedPreferences.getInstance();
                        checkboxvalue == true &&
                                Emailcontroller.text.isNotEmpty &&
                                Passwordcontroller.text.isNotEmpty
                            ? sahredPref.setBool('remember', checkboxvalue)
                            : sahredPref.remove('remember');
                        sahredPref.setString('email', Emailcontroller.text);
                        sahredPref.setString(
                          'password',
                          Passwordcontroller.text,
                        );
                      },
                    ),

                    Text("Remember me".tr(), style: AppTextStyles.bodyText),
                    Spacer(),

                    TextButton(
                      onPressed: () {
                        log('clicked');
                        Navigator.pushNamed(context, ForgotPassword.routeName);
                      },
                      child: Text(
                        'Forgot password'.tr(),
                        style: AppTextStyles.bodyText.copyWith(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () => _login(),
                  child: Container(
                    width: 327.w,
                    height: 62.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text('login'.tr(), style: AppTextStyles.button),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?'.tr(),
                      style: AppTextStyles.bodyText,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignupPage.routeName);
                      },
                      child: Text(
                        'Sign up'.tr(),
                        style: AppTextStyles.bodyText.copyWith(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('Or'.tr(), style: AppTextStyles.bodyText),
                SizedBox(height: 20.h),

                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

 void _login() async {
    final email = Emailcontroller.text.trim();
    final password = Passwordcontroller.text;

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      CustomAlert.error(context, title: 'Please enter email and password');
      return;
    }

    // For demonstration: hardcoded admin credentials
    const adminEmail = 'admin';
    const adminPassword = '123';

    // Check credentials
    bool isValid = false;

    // If remember me is checked, compare with stored credentials
    if (checkboxvalue) {
      final storedEmail = sahredPref?.getString('email') ?? '';
      final storedPassword = sahredPref?.getString('password') ?? '';
      if (email == storedEmail && password == storedPassword) {
        isValid = true;
      }
    }

    // Also allow hardcoded admin login
    if (email == adminEmail && password == adminPassword) {
      isValid = true;
    }

    if (isValid) {
      // Set login flag (or token)
      await sahredPref?.setBool('isLoggedIn', true);

      // Optionally, store token if you have one
      await sahredPref?.setBool('authToken', true);

      // If remember me is checked, store credentials
      if (checkboxvalue) {
        await sahredPref?.setString('email', email);
        await sahredPref?.setString('password', password);
        await sahredPref?.setBool('remember', true);
      } else {
        await sahredPref?.remove('email');
        await sahredPref?.remove('password');
        await sahredPref?.setBool('remember', false);
      }

      Navigator.pushNamed(context, Homepage.routeName);
      CustomAlert.success(context, title: 'Successfully logged in');
    } else {
      CustomAlert.error(context, title: 'Incorrect email or password');
    }
  }
}
