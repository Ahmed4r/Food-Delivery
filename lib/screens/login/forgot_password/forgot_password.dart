import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/login/otp/otp_screen.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgot_password';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController Emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'forgot password'.tr(),
                style: GoogleFonts.sen(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark?Colors.black:Colors.white
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Please sign in to your existing account'.tr(),
                style: GoogleFonts.sen(fontSize: 16.sp,  color: isDark?Colors.black:Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(children: [
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
                    
                          label: Padding(
                            padding:  EdgeInsets.only(bottom: 25.0.h),
                            child: Text('email'.tr(),style: GoogleFonts.cairo(fontSize: 20.sp),),
                          ),
                          hintStyle: GoogleFonts.sen(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          alignLabelWithHint: true,
          
                          hintText: 'example@gmail.com'.tr(),
                         
          
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
            
            SizedBox(height: 20.h,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                minimumSize: WidgetStatePropertyAll(Size(327.w, 50.h)),
              ),
              onPressed: (){
                Navigator.pushNamed(context, OtpScreen.routeName,arguments:{'email': Emailcontroller.text});
              }, child: Text('sendcode'.tr(),
              style: GoogleFonts.cairo(fontSize: 20.sp,color: Colors.white
              ),))
          
          
          ],),
        ),
      ),
    );
  }
}