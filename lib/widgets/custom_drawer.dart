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

  ImageProvider _getProfileImageProvider() {
    const String defaultAsset = 'assets/images/profile_img.png';
    if (img == null || img!.isEmpty) {
      return AssetImage(defaultAsset);
    }
    if (img!.startsWith('http://') || img!.startsWith('https://')) {
      return NetworkImage(img!);
    }
    if (img!.startsWith('/')) {
      // Local file path
      return FileImage(File(img!));
    }
    // Try asset, fallback to default asset if error
    try {
      return AssetImage(img!);
    } catch (_) {
      return AssetImage(defaultAsset);
    }
  }

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
         
            Material(
            
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
                          backgroundImage: _getProfileImageProvider(),
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
                          Navigator.pushNamed(context, AddressListScreen.routeName);
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
                        onTap: () {
                          /// Close Navigation drawer before
                          Navigator.pop(context);
                          Navigator.pushNamed(context, PaymentSystemScreen.routeName);
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

class SeeAllCategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const SeeAllCategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: GoogleFonts.sen(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 1,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  category['image'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image),
                ),
                const SizedBox(width: 12),
                Text(
                  category['title'],
                  style: GoogleFonts.sen(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SeeAllRestaurantsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> restaurants;
  final Widget Function(Map<String, dynamic>) restaurantCardBuilder;

  const SeeAllRestaurantsScreen({
    super.key,
    required this.restaurants,
    required this.restaurantCardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Opened Restaurants',
          style: GoogleFonts.sen(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return restaurantCardBuilder(restaurants[index]);
        },
      ),
    );
  }
}
