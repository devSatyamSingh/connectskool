import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/student_management/student_widget/student_attandence_screen.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';

import '../../teacher_management/teacher_attendance_screen.dart';
import 'all_student_admin_attendance_screen.dart';
import 'school_accountant_attendance_screen.dart';

class StaffAttendanceScreen extends StatelessWidget {
  const StaffAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> roles = [
      {"role": "Accountant", "status": "Present"},
      {"role": "Student", "status": "Absent"},
      {"role": "Teacher", "status": "Late"},
    ];

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        children: [
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
                    "Staff Attendance",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: roles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final role = roles[index]["role"]!;
                final status = roles[index]["status"]!;

                Color statusColor = status == "Present"
                    ? Colors.green
                    : status == "Absent"
                    ? Colors.red
                    : Colors.orange;

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    if (role == "Accountant") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const SchoolAccountantAttendanceScreen(),
                        ),
                      );
                    }
                    else if (role == "Student") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AllStudentAdminAttendanceScreen(),
                        ),
                      );
                    }
                    else if (role == "Teacher") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const TeacherAttendanceScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.cardShadow,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40, color: statusColor),
                        const SizedBox(height: 12),
                        AppText.customText(
                          role,
                          size: 15,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 4),
                        //   decoration: BoxDecoration(
                        //     color: statusColor.withOpacity(0.12),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: AppText.customText(
                        //     status.toUpperCase(),
                        //     size: 11,
                        //     weight: FontWeight.bold,
                        //     color: statusColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}