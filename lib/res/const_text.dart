import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static Text customText(
      String text, {
        double size = 14,
        Color color = Colors.black,
        FontWeight weight = FontWeight.w400,
        TextAlign align = TextAlign.start,
        int? maxLines,
        TextOverflow? overflow,
        String? fontFamily,
      }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
    ),
    );
  }
}