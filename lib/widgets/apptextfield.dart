import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData? suffixIcon;
 
  final bool obscureText;
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.hint,
    this.suffixIcon,   
    this.obscureText = false,
    required this.controller, required InputDecoration decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 300.w,
     
      child: TextField(
        
        
        
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon != null
          ? IconButton(onPressed: (){}, icon: Icon(suffixIcon))
          : null,
          hintStyle: GoogleFonts.sen(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          
          hintText: hint,
       
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          filled: true,
          fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
