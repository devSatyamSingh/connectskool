import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/student_management/student_widget/student_attandence_screen.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_color.dart';
import '../../res/const_text.dart';

import '../../teacher_management/teacher_attendance_screen.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import 'all_student_admin_attendance_screen.dart';
import 'school_accountant_attendance_screen.dart';

class StaffAttendanceScreen extends StatelessWidget {
  const StaffAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> roles = [
      {
        "role": 'staff_attendance.accountant'.tr(),
        "status": 'staff_attendance.status_present'.tr(),
        "key": "accountant"
      },
      {
        "role": 'staff_attendance.student'.tr(),
        "status": 'staff_attendance.status_absent'.tr(),
        "key": "student"
      },
      {
        "role": 'staff_attendance.teacher'.tr(),
        "status": 'staff_attendance.status_late'.tr(),
        "key": "teacher"
      },
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
                    'staff_attendance.title'.tr(),
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
                final key = roles[index]["key"]!;

                Color statusColor = status == 'staff_attendance.status_present'.tr()
                    ? Colors.green
                    : status == 'staff_attendance.status_absent'.tr()
                    ? Colors.red
                    : Colors.orange;

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    if (key == "accountant") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const SchoolAccountantAttendanceScreen(),
                        ),
                      );
                    }
                    else if (key == "student") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AllStudentAdminAttendanceScreen(),
                        ),
                      );
                    }
                    else if (key == "teacher") {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.viewAllTeacherAttendance)) {
                        Utils.show(
                          'staff_attendance.permission_teacher'.tr(),
                          context,
                        );
                        return;
                      }

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