import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/customer/customer_homepage.dart';
import 'package:food_delivery/screens/login/forgot_password/forgot_password.dart';
import 'package:food_delivery/screens/signup/signup.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/app_text_styles.dart';
import 'package:food_delivery/widgets/bottom_nav.dart';
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

  Future<void> getPref() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final remember = prefs.getBool('remember');

    if (remember != null && remember) {
      Emailcontroller.text = email ?? '';
      Passwordcontroller.text = password ?? '';
      checkboxvalue = true;
    }
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
                            ? const FaIcon(FontAwesomeIcons.eye)
                            : const FaIcon(FontAwesomeIcons.eyeSlash),
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
                        log(checkboxvalue.toString());
                      },
                    ),
                    Text("Remember me".tr(), style: AppTextStyles.bodyText),
                    const Spacer(),
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
                  onTap: () async {
                    // signInWithGoogle();
                  },
                  child: const CircleAvatar(
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    await Firebase.initializeApp(); // 👈 دي مهمة جدًا على iOS

    final email = Emailcontroller.text.trim();
    final password = Passwordcontroller.text;

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      CustomAlert.error(context, title: 'Please enter email and password');
      return;
    }

    try {
      // Use Firebase Auth to sign in
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user role from Firestore
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final role = userData['role'] as String?;

          // Save credentials if "Remember me" is checked
          if (checkboxvalue) {
            await SharedPreferences.getInstance().then((prefs) {
              prefs.setString('email', email);
              prefs.setString('password', password);
              prefs.setBool('remember', true);
              prefs.setBool('authToken', true);
            });
          } else {
            await SharedPreferences.getInstance().then((prefs) {
              prefs.remove('email');
              prefs.remove('password');
              prefs.setBool('remember', false);
            });
          }

          // Navigate based on role
          if (role == 'owner') {
            Navigator.pushNamed(context, BottomNav.routeName);
          } else if (role == 'customer') {
            Navigator.pushNamed(context, Homepage.routeName);
          } else {
            CustomAlert.error(context, title: 'Unknown or no role found');
            return;
          }
        } else {
          CustomAlert.error(context, title: 'User data not found');
          return;
        }
      } else {
        CustomAlert.error(context, title: 'User not found');
        return;
      }

      CustomAlert.success(context, title: 'Successfully logged in');
    } on FirebaseAuthException catch (e) {
      CustomAlert.error(context, title: 'Error logging in: ${e.message}');
    } catch (e) {
      CustomAlert.error(context, title: 'An error occurred: $e');
    }
  }
}
