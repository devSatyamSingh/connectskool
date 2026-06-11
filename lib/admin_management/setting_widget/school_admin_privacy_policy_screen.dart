import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';

class SchoolAdminPrivacyPolicyScreen extends StatefulWidget {
  const SchoolAdminPrivacyPolicyScreen({super.key});

  @override
  State<SchoolAdminPrivacyPolicyScreen> createState() =>
      _SchoolAdminPrivacyPolicyScreenState();
}

class _SchoolAdminPrivacyPolicyScreenState
    extends State<SchoolAdminPrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.glassWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText(
                    "Privacy Policy",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ===== SCROLLABLE CONTENT =====
          Expanded(
            child: SingleChildScrollView(
              padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(
                    "Privacy Policy",
                    size: 22,
                    weight: FontWeight.bold,
                  ),
                   SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "Welcome to Culture Technology School! We value your privacy and "
                        "are committed to protecting your personal information. This Privacy Policy explains "
                        "how we collect, use, and safeguard your data.",
                    size: 16,
                    color: Colors.black87,
                    weight: FontWeight.w400,
                  ),
                  SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "1. Information Collection\n"
                        "We may collect personal information such as name, email, phone number, "
                        "and other relevant details when you use our app or services.",
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "2. Information Use\n"
                        "Your information is used to provide services, improve user experience, "
                        "and communicate important updates.",
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "3. Data Security\n"
                        "We implement industry-standard security measures to protect your data "
                        "from unauthorized access, alteration, or disclosure.",
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "4. Third-Party Sharing\n"
                        "We do not share your personal information with third parties without your consent, "
                        "except as required by law.",
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.01),
                  AppText.customText(
                    "5. Changes to Policy\n"
                        "We may update this Privacy Policy from time to time. "
                        "You are encouraged to review it periodically.",
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.02),
                  AppText.customText(
                    "Thank you for trusting Culture Technology School!",
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  SizedBox(height: screenHeight*0.04),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
