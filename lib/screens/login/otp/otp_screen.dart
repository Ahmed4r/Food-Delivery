import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/location/location_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp-screen';
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  int _seconds = 60;
  bool _isRunning = false;
  bool is_clicked =false;

  void _startTimer() {
    _isRunning = true;
    _seconds = 60;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _isRunning = false;
        timer.cancel();
        setState(() {
          
        });
      }
    });
  }

  void _verifyOtp() {
    print(_otpController.text);
  }

  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
     final args = ModalRoute.of(context)!.settings.arguments as Map<String,String>;
     final email =args['email'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'verification'.tr(),
               style: GoogleFonts.sen(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark?Colors.black:Colors.white
                ),
              ),
            ),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                text: 'we have sent a code to your email'
                    .tr(),
                 style: GoogleFonts.sen(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: isDark?Colors.black:Colors.white
                )
              ),
            ),
            RichText(
              text: TextSpan(
                text:email,
                 style: GoogleFonts.sen(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark?Colors.black:Colors.white
                )
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CODE'),

                _isRunning? Text('Resend in $_seconds',style: TextStyle(fontWeight: FontWeight.bold,
                             
                color: Colors.white
                ),) 
                : 
                InkWell(
                  onTap: () =>_startTimer(),
                  child: Text('Resend',style: TextStyle(fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.white
                  )),
                )
              ],
            ),
            SizedBox(height: 20),
            buildPinPut(context),
            SizedBox(height: 20),
            ElevatedButton(
              
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(327.w, 70.h)),
                backgroundColor: MaterialStateProperty.all(Colors.orange ),
              ),
              
              onPressed: _verifyOtp, child: Text('verify'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),))
           
          ],
        ),
      ),
    );
  }
}

final defaultPinTheme = PinTheme(
  width: 300.w,
  height: 56.h,
  textStyle: TextStyle(
    fontSize: 20,
    color: Color.fromRGBO(30, 60, 87, 1),
    fontWeight: FontWeight.w600,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromARGB(255, 154, 160, 166)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: Color(0xffF0F5FA)),
  borderRadius: BorderRadius.circular(8),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration!.copyWith(
    color: Color.fromRGBO(196, 204, 210, 1),
  ),
);

Widget buildPinPut(context) {
  return Pinput(
    autofocus: true,

    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: focusedPinTheme,
    submittedPinTheme: submittedPinTheme,
    validator: (s) {
      if (s=='2222') {
        Navigator.pushReplacementNamed(context, LocationAccessPage.routeName);
      }
      
    },

    errorTextStyle: TextStyle(color: Colors.red),
    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    showCursor: true,
    onCompleted: (pin) => print(pin),
  );
}
