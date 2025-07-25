import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/theme_provider.dart';
import 'package:food_delivery/widgets/custom_alert.dart';
import 'package:food_delivery/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editprofile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  String img = 'assets/images/profile_img.png';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namecontroller.text = prefs.getString('profile_name') ?? '';
      emailcontroller.text = prefs.getString('profile_email') ?? '';
      phonecontroller.text = prefs.getString('profile_phone') ?? '';
      img = prefs.getString('profile_img') ?? 'assets/images/profile_img.png';
    });
  }

  bool _validateInputs() {
    if (namecontroller.text.trim().isEmpty ||
        emailcontroller.text.trim().isEmpty ||
        phonecontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields'.tr())),
      );
      return false;
    }
    // Add more validation as needed (e.g., email format, phone number)
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'.tr())),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundImage: img.startsWith('assets/')
                          ? AssetImage(img) as ImageProvider
                          : (File(img).existsSync()
                              ? FileImage(File(img))
                              : AssetImage('assets/images/profile_img.png')),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      child: IconButton(
                        onPressed: () async {
                          ImagePicker imgpicker = ImagePicker();
                          final XFile? image = await imgpicker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              img = image.path;
                            });
                          }
                        },
                        icon: FaIcon(FontAwesomeIcons.pen, size: 20.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 327.w,
                  child: TextField(
                    controller: namecontroller,
                    style: GoogleFonts.sen(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.dark_grey,
                      labelText: 'FULL NAME'.tr(),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 327.w,
                  child: TextField(
                    controller: emailcontroller,
                    style: GoogleFonts.sen(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.dark_grey,
                      labelText: 'EMAIL'.tr(),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 327.w,
                  child: TextField(
                    controller: phonecontroller,
                    style: GoogleFonts.sen(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.dark_grey,
                      labelText: 'PHONE NUMBER'.tr(),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                customButtom(
                  title: 'SAVE'.tr(),
                  onTap: () async {
                    if (!_validateInputs()) return;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('profile_name', namecontroller.text);
                    await prefs.setString('profile_email', emailcontroller.text);
                    await prefs.setString('profile_phone', phonecontroller.text);
                    if (img.isNotEmpty) {
                      await prefs.setString('profile_img', img);
                    }
                    CustomAlert.success(
                      context,
                      title: 'Profile updated successfully!'.tr(),

                    
                    );
                   
                    Navigator.pop(context, {
                      'name': namecontroller.text,
                      'email': emailcontroller.text,
                      'phone': phonecontroller.text,
                      'img': img,
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}