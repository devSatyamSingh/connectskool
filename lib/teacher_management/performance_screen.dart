import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.01),
      child: ListView(
        children: [

          _performanceCard("Rahul Kumar", "Roll No: 01", 85),
          _performanceCard("Anjali Singh", "Roll No: 02", 72),
          _performanceCard("Rohit Verma", "Roll No: 03", 91),
          _performanceCard("Pooja Sharma", "Roll No: 04", 65),
          _performanceCard("Aman Gupta", "Roll No: 05", 78),

        ],
      ),
    );
  }

  Widget _performanceCard(String name, String roll, int percent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(18),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(.06),
      //       blurRadius: 12,
      //       offset: const Offset(0, 6),
      //     ),
      //   ],
      // ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [

          // soft top glow
          BoxShadow(
            color: AppColor.lightBlueColor.withValues(alpha: .06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),

          // main depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),

          // sharp edge lift
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.lightBlueColor.withOpacity(.15),
                child: const Icon(
                  Icons.person,
                  color: AppColor.lightBlueColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(name, size: 16, weight: FontWeight.w600),
                    const SizedBox(height: 4),
                    AppText.customText(roll, size: 12, color: Colors.grey),
                  ],
                ),
              ),

              AppText.customText(
                "$percent%",
                size: 16,
                weight: FontWeight.w700,
                color: AppColor.lightBlueColor,
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              color: AppColor.lightBlueColor,
            ),
          ),

          const SizedBox(height: 6),

          AppText.customText(
            percent >= 75
                ? "Excellent Performance"
                : percent >= 60
                ? "Good Performance"
                : "Needs Improvement",
            size: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
