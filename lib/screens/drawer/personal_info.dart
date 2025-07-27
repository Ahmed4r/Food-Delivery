import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/customer/edit_profile.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/personalinfo';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String img = '';

  ImageProvider _getProfileImageProvider() {
    const String defaultAsset = 'assets/images/profile_img.png';
    if (img.isEmpty) {
      return AssetImage(defaultAsset);
    }
    if (img.startsWith('http://') || img.startsWith('https://')) {
      return NetworkImage(img);
    }
    if (img.startsWith('/')) {
      // Local file path
      return FileImage(File(img));
    }
    // Try asset, fallback to default asset if error
    try {
      return AssetImage(img);
    } catch (_) {
      return AssetImage(defaultAsset);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
   
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('profile_name') ?? '';
      email = prefs.getString('profile_email') ?? '';
      phone = prefs.getString('profile_phone') ?? '';
      img = prefs.getString('profile_img') ?? '';
    });
   
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: isDark ? AppColors.secondary_white : AppColors.dark_grey,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              "Personal Info".tr(),
              style: GoogleFonts.sen(
                fontSize: 17.sp,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, EditProfile.routeName);
                if (result != null && result is Map) {
                  setState(() {
                    name = result['name'] ?? '';
                    email = result['email'] ?? '';
                    phone = result['phone'] ?? '';
                    img = result['img'] ?? '';
                  });
                }
              },
              child: Text(
               "Edit Profile".tr(),
                style: GoogleFonts.sen(
                  fontSize: 17.sp,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Material(
            color: isDark ? AppColors.secondary : Colors.white,
            child: InkWell(
              child: Container(
                height: 224.h,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundImage: _getProfileImageProvider(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Text(
                            name.isNotEmpty ? name : 'user',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xff181F20),
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xff181F20),
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
          Container(
            width: 340.w,
            decoration: BoxDecoration(
             
              color: isDark ? AppColors.dark_grey : Color(0xffF6F8FA),
            ),
            child: Column(
              children: [
                ListTile(
                  tileColor: Color(0xffF6F8FA),
                  leading: CircleAvatar(
                    backgroundColor: isDark
                        ? AppColors.dark_grey
                        : Colors.white,
                    child: FaIcon(FontAwesomeIcons.user, color: Colors.orange),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "FULL NAME".tr(),
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EMAIL".tr(),
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDark
                        ? AppColors.dark_grey
                        : Colors.white,
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PHONE NUMBER".tr(),
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        phone,
                        style: GoogleFonts.sen(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
