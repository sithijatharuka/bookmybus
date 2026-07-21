import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary,
    ),

    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}