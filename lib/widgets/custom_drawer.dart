import 'package:easy_localization/easy_localization.dart';
// Custom Drawer Widget
//
// Description:
//   A customizable navigation drawer for the food delivery app.
//   Displays user profile information and provides navigation links to profile, address, cart, favorites, notifications, payments, FAQs, user reviews, settings, and logout.
//   Supports dark and light themes, and loads user data from shared preferences.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/customer/homepage.dart';
import 'package:food_delivery/screens/drawer/faqs.dart';
import 'package:food_delivery/screens/drawer/personal_info.dart';
import 'package:food_delivery/screens/drawer/settings_page.dart';
import 'package:food_delivery/screens/login/login.dart';
import 'package:food_delivery/screens/onboarding_screen.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  String name = '';
  String email = '';
  String? img;

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('profile_name') ?? '';
      email = prefs.getString('profile_email') ?? '';
      img = prefs.getString('profile_img');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      elevation: 10,
     shadowColor: Colors.grey,
      backgroundColor: isDark ? const Color(0xff181F20) : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header of the Drawer
            Material(
              // color: isDark ? Colors.white : Colors.black,
              child: InkWell(
                onTap: () {
                  /// Close Navigation drawer before
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                },
                child: SizedBox(
                  height: 224,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 30),
                        child: CircleAvatar(
                          radius: 40.r,
                          backgroundImage: AssetImage(
                            img ?? 'assets/images/profile_img.png',
                          ),
                        ),
                      ),

                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 25.sp,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff181F20),
                              ),
                            ),

                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.grey : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                            FontAwesomeIcons.map,
                            color: Colors.deepPurple,
                          ),
                        ),
                        title: Text(
                          'Address'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {
                          /// Close Navigation drawer before
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen()),);
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
                            FontAwesomeIcons.shoppingCart,
                            color: Colors.blueAccent,
                          ),
                        ),
                        title: Text(
                          'Cart'.tr(),
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
                            FontAwesomeIcons.heart,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        title: Text(
                          'Favorites'.tr(),
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
                            FontAwesomeIcons.bell,
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          'Notification'.tr(),
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
                            FontAwesomeIcons.creditCard,
                            color: Colors.lightBlue,
                          ),
                        ),
                        title: Text(
                          'Payments'.tr(),
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
                            FontAwesomeIcons.circleQuestion,
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          'FAQs'.tr(),
                          style: GoogleFonts.sen(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
Navigator.pushNamed(context, FaqsScreen.routeName);
                        },
                      ),
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
                        onTap: ()async {
                         SharedPreferences pref = await SharedPreferences.getInstance();
                         pref.remove('authToken');
                          Navigator.pushReplacementNamed(context, LoginPage.routeName);
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
