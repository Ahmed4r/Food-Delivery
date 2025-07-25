import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/login/forgot_password/forgot_password.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/app_text_styles.dart';

import 'package:google_fonts/google_fonts.dart';

/// A page that provides the signup form for new users.
class SignupPage extends ConsumerStatefulWidget {
  /// The route name for navigation to the signup page.
  static const String routeName = '/signup_page';

  /// Creates a [SignupPage].
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  // State implementation here


  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Passwordcontroller = TextEditingController();
  bool isobsecured = false;
  bool checkboxvalue = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'sign up'.tr(),
                style: GoogleFonts.sen(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark?Colors.black:Colors.white
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Please sign up to get started'.tr(),
                style: GoogleFonts.sen(fontSize: 16.sp,  color: isDark?Colors.black:Colors.white),
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
                SizedBox(height: 20.h,),
       
        
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
                        padding:  EdgeInsets.only(bottom: 20.0.h),
                        child: Text('name'.tr(),style: GoogleFonts.cairo(fontSize: 20.sp),),
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
                    controller: Emailcontroller,

                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                     label: Padding(
                        padding:  EdgeInsets.only(bottom: 20.0.h),
                        child: Text('email'.tr(),style: GoogleFonts.cairo(fontSize: 20.sp),),
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
                        padding:  EdgeInsets.only(bottom: 20.0.h),
                        child: Text('password'.tr(),style: GoogleFonts.sen(fontSize: 20.sp),),
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
                        padding:  EdgeInsets.only(bottom: 20.0.h),
                        child: Text('re password'.tr(),style: GoogleFonts.sen(fontSize: 20.sp),),
                      ),
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.sen(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white : Colors.black,
                        ),

                      hintText: 're password'.tr(),


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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                      value: checkboxvalue,
                      onChanged: (value) {
                        setState(() {
                          checkboxvalue = value!;
                        });
                      },
                    ),

                    Text('Remember me'.tr(), style: AppTextStyles.bodyText),

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
                Container(
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
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?'.tr(),
                      style: AppTextStyles.bodyText,
                    ),
                    TextButton(
                      onPressed: () {},
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
                SizedBox(height: 20.h,),
              
                  InkWell(
                    onTap: () {
                      
                    },
                    child: CircleAvatar(
                      child: FaIcon(FontAwesomeIcons.google,color: Colors.orange,),
                    ),
                  ),
                  SizedBox(height: 200,)
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
