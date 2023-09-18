import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  const AppTextStyle._();

  TextStyle heading1Style({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? 26,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration,
    );
  }

  static TextStyle heading2Style({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration,
    );
  }

  static TextStyle mediumStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      double? letterSpacing,
      height}) {
    return _textStyle(
        color: color,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing);
  }

  static TextStyle semiBoldStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      double? letterSpacing,
      height}) {
    return _textStyle(
        color: color,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w600,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing);
  }

  static TextStyle boldStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      double? letterSpacing,
      height}) {
    return _textStyle(
        color: color,
        fontSize: fontSize ?? 22,
        fontWeight: fontWeight ?? FontWeight.w700,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing);
  }

  static TextStyle regularStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      double? letterSpacing,
      height}) {
    return _textStyle(
        color: color,
        fontSize: fontSize ?? 12,
        decoration: decoration,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: height,
        letterSpacing: letterSpacing);
  }

  static TextStyle buttonTextStyle(
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      double? letterSpacing,
      height}) {
    return _textStyle(
        color: color,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing);
  }
}

TextStyle _textStyle(
    {Color? color = Colors.black,
    required double fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    double? letterSpacing}) {
  return GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      decoration: decoration,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing);
}
