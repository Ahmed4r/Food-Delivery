import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/drawer/address.dart';
import 'package:food_delivery/screens/drawer/faqs.dart';
import 'package:food_delivery/screens/drawer/payments.dart';
import 'package:food_delivery/screens/drawer/personal_info.dart';
import 'package:food_delivery/screens/drawer/settings_page.dart';
import 'package:food_delivery/screens/login/login.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResDrawer extends StatefulWidget {
  const ResDrawer({super.key});

  @override
  State<ResDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<ResDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      width: 300.w,
      elevation: 10,
      shadowColor: Colors.grey,
      backgroundColor: isDark ? const Color(0xff181F20) : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
      
          children: [
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 350,
                  child: Container(
                    height: 200.h,
                    decoration: BoxDecoration(color: AppColors.primary),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,),),
                        
                          Text('My Profile', style: GoogleFonts.sen(color: Colors.white, fontSize: 20.sp),)
                        ],),
                        SizedBox(height: 20.h,),
                        Text('avaliable Balance'.tr(), style: GoogleFonts.sen(color: Colors.white, fontSize: 15.sp),),
                         SizedBox(height: 10.h,),
                        Text("\$500 ", style: GoogleFonts.sen(color: Colors.white, fontSize: 30.sp,fontWeight: FontWeight.bold),), SizedBox(height: 20.h,),
ElevatedButton(
  onPressed: () {
    // Add withdraw functionality here
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary, // Use your desired button color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.white)
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: Text(
    'Withdraw',
    style: GoogleFonts.sen(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
),


                      ],
                    ),
                  ),
                  
                  
                ),
              ),
            ),

            /// Header Menu items
            Column(
              children: [
                Container(
                  width: 260.w,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff181F20) : Color(0xffF6F8FA),
                  ),

                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Color(0xffF6F8FA),
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.dark_grey
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.user,
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          'Personal Info'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {
                          /// Close Navigation drawer before
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            ProfileScreen.routeName,
                            arguments: {},
                          );
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.dark_grey
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.cog,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          'Settings'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {
                          /// Close Navigation drawer before
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            SettingsPage.routeName,
                            arguments: {},
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white),

                Container(
                  width: 260.w,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff181F20) : Color(0xffF6F8FA),
                  ),

                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.dark_grey
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.moneyBill,
                            color: Colors.blueAccent,
                          ),
                        ),
                        title: Text(
                          'witrhdraw history'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.dark_grey
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.file,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        title: Text(
                          'number of orders'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.white),
                Container(
                  width: 260.w,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff181F20) : Color(0xffF6F8FA),
                  ),

                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.dark_grey
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.commenting,
                            color: Colors.greenAccent,
                          ),
                        ),
                        title: Text(
                          'User Review'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white),
                Container(
                  width: 260.w,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff181F20) : Color(0xffF6F8FA),
                  ),

                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? Color(0xff303537)
                              : Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.signOut,
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          'Log Out'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.remove('authToken');
                          pref.remove('email');
                          pref.remove('password');
                          Navigator.pushReplacementNamed(
                            context,
                            LoginPage.routeName,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

