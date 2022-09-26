import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  /// Black
  static const black = TextStyle(color: Colors.black);


  static TextStyle blackS36Bold = black.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  // S24 Bold
  static TextStyle blackS24Bold = black.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  //S24
  static TextStyle blackS14 = black.copyWith(
    fontSize: 24,
  );

  /// Light Placeholder
  static const lightPlaceholder = TextStyle(color: AppColors.lightPlaceholder);

  //S12
  static TextStyle lightPlaceholderS12 = lightPlaceholder.copyWith(
    fontSize: 12
  );

  //S14
  static TextStyle lightPlaceholderS14 = lightPlaceholder.copyWith(
    fontSize: 14
  );

  //S24 Bold
  static TextStyle lightPlaceholderS24Bold = lightPlaceholder.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );


  /// Red Accent
  static const redAccent = TextStyle(color: AppColors.redAccent);

  // s18 W500
  static TextStyle redAccentS18 = redAccent.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}
