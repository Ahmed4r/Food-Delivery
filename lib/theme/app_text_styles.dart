import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final headline1 = GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final headline2 = GoogleFonts.sen(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final bodyText = GoogleFonts.sen(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static final button = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
