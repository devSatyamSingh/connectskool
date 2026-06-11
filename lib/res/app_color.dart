import 'package:flutter/material.dart';

class AppColor {

  // static const Color lightBlueColor = Color(0xff1E88E5);
  static const Color lightBlueColor = Color(0xFF0D2B6B);
  static const Color darkBlueColor  = Color(0xff1565C0);

  // Background
  static const Color pageBgColor = Color(0xffF6F9FF);
  static const Color cardWhite = Colors.white;

  // Text
  static const Color softGreyText = Color(0xff757575);

  // Shadows
  static const Color blueShadow = Color(0x331E88E5);
  static const Color cardShadow = Color(0x1A000000);

  // Glass
  static Color glassWhite = Colors.white.withOpacity(0.25);

  // Student colors
  static const Color maleColor = Color(0xff6C5CE7);
  static const Color maleLight = Color(0xff8B7EF7);

  static const Color screenBg = Color(0xFFF6F9FF);

  static const Color white = Colors.white;

  static const Color textGrey = Color(0xFF6B7280);

  static const Color femaleColor = Color(0xff00B894);
  static const Color femaleLight = Color(0xff00D2A4);
  static const bg           = AppColor.screenBg;          // was 0xFFF6F8FF
  static const card         = AppColor.white;              // was Colors.white
  static const primary      = AppColor.lightBlueColor;     // was 0xFF4361EE
  static const primaryLight = Color(0xFFEEF1FF);           // kept (no AppColor equivalent)
  static const gradA        = AppColor.lightBlueColor;     // was 0xFF4361EE
  static const gradB        = AppColor.darkBlueColor;      // was 0xFF7209B7
  static const editGradA    = Color(0xFF0AA98F);           // kept
  static const editGradB    = AppColor.lightBlueColor;     // was 0xFF4361EE
  static const text         = Color(0xFF1A1D3B);           // kept
  static const sub          = AppColor.textGrey;           // was 0xFF6B7280
  static const border       = Color(0xFFE2E8F0);           // kept
  static const error        = Color(0xFFEF4444);           // kept
  static const success      = Color(0xFF0AA98F);           //
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightBlueColor, darkBlueColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
class _DS {
  // ── Mapped from AppColor ──
  static const bg           = AppColor.bg;
  static const card         = AppColor.card;
  static const primary      = AppColor.primary;           // Color(0xFF0D2B6B)
  static const primaryLight = AppColor.primaryLight;      // Color(0xFFEEF1FF)
  static const textDark     = AppColor.text;              // Color(0xFF1A1D3B)
  static const textMid      = AppColor.sub;               // Color(0xFF6B7280)
  static const border       = AppColor.border;            // Color(0xFFE2E8F0)

  // ── Not in AppColor – kept as-is ──
  static const textLight = Color(0xFF9CA3AF);
  static const accent    = Color(0xFFFF6B6B);
  static const green     = Color(0xFF27AE7A);
  static const orange    = Color(0xFFF59E0B);
  static const red       = AppColor.error;                // Color(0xFFEF4444)

  // ── Gradient using AppColor ──
  static const gradientHeader = AppColor.primaryGradient; // lightBlue → darkBlue

  static BoxDecoration cardDecor({double radius = 20}) => BoxDecoration(
    color: card,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: AppColor.primary.withOpacity(0.07),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
