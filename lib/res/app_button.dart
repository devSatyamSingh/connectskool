import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../res/app_color.dart';
import '../res/const_text.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double height;
  final double radius;

  final LinearGradient? gradient;
  final Color? bgColor;
  final Color? textColor;
  final IconData? icon;
  final bool loading;

  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.height = 52,
    this.radius = 16,
    this.gradient,
    this.bgColor,
    this.textColor,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalTextColor = textColor ?? Colors.white;
    final LinearGradient finalGradient = bgColor == null
        ? (gradient ?? AppColor.primaryGradient)
        : LinearGradient(colors: [bgColor!, bgColor!]);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: finalGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: (bgColor ?? AppColor.lightBlueColor).withOpacity(.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: loading ? null : onTap,
          child: Container(
            alignment: Alignment.center,
              child: loading
                  ? SpinKitThreeBounce(
                color: finalTextColor,
                size: 20,
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: finalTextColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                ],
                AppText.customText(
                  title,
                  color: finalTextColor,
                  weight: FontWeight.w600,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}