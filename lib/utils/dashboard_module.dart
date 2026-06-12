import 'package:flutter/material.dart';
import 'package:school_pro/utils/permission_keys.dart';
import 'package:school_pro/utils/routes/routes_name.dart';

class DashboardModule {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color color;
  final String permission;
  final String route;

  const DashboardModule({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.color,
    required this.permission,
    required this.route,
  });
}

class DashboardModules {
  static const List<DashboardModule> modules = [

    DashboardModule(
      title: "All Students",
      subTitle: "Manage students",
      icon: Icons.people_alt_rounded,
      color: Color(0xFF1976D2),
      permission: PermissionKeys.viewAllStudent,
      route: RoutesName.allStudentList,
    ),

    DashboardModule(
      title: "All Teachers",
      subTitle: "Staff list",
      icon: Icons.school_rounded,
      color: Color(0xFF00897B),
      permission: PermissionKeys.viewAllTeacher,
      route: RoutesName.allTeacherListScreen,
    ),

    DashboardModule(
      title: "All Accountants",
      subTitle: "Finance team",
      icon: Icons.account_balance_rounded,
      color: Color(0xFFF57C00),
      permission: PermissionKeys.viewAccountants,
      route: RoutesName.allAccountantListScreen,
    ),

    DashboardModule(
      title: "Classes",
      subTitle: "View classes",
      icon: Icons.layers_rounded,
      color: Color(0xFF7B1FA2),
      permission: PermissionKeys.viewClasses,
      route: RoutesName.classesPage,
    ),

    DashboardModule(
      title: "Timetable",
      subTitle: "Weekly schedule",
      icon: Icons.schedule_rounded,
      color: Color(0xFF2E7D32),
      permission: PermissionKeys.viewTimetable,
      route: RoutesName.schoolTimetableScreen,
    ),

    DashboardModule(
      title: "Subjects",
      subTitle: "All subjects",
      icon: Icons.menu_book_rounded,
      color: Color(0xFF00695C),
      permission: PermissionKeys.viewSubjects,
      route: RoutesName.allSubjectsScreen,
    ),

    DashboardModule(
      title: "Fees",
      subTitle: "Fee collection",
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF27AE60),
      permission: PermissionKeys.viewFees,
      route: RoutesName.feesManagementScreen,
    ),

    DashboardModule(
      title: "Transport Fee",
      subTitle: "Bus fees",
      icon: Icons.directions_bus_rounded,
      color: Color(0xFF0097A7),
      permission: PermissionKeys.manageTransport,
      route: RoutesName.transportFeeManagementScreen,
    ),

    DashboardModule(
      title: "Exams",
      subTitle: "Exam schedule",
      icon: Icons.assignment_turned_in_rounded,
      color: Color(0xFFD4A017),
      permission: PermissionKeys.viewExam,
      route: RoutesName.examScreen,
    ),

    DashboardModule(
      title: "Marksheet",
      subTitle: "View marks",
      icon: Icons.description_rounded,
      color: Color(0xFF1565C0),
      permission: PermissionKeys.viewMarks,
      route: RoutesName.marksheetScreen,
    ),

    DashboardModule(
      title: "Admit Card",
      subTitle: "Generate cards",
      icon: Icons.badge_rounded,
      color: Color(0xFFC62828),
      permission: PermissionKeys.generateAdmitCard,
      route: RoutesName.schoolAdmitCardScreen,
    ),

    DashboardModule(
      title: "Attendance",
      subTitle: "Daily attendance",
      icon: Icons.fact_check_rounded,
      color: Color(0xFF0288D1),
      permission: PermissionKeys.markStudentAttendance,
      route: RoutesName.schoolAttendanceScreen,
    ),

    DashboardModule(
      title: "Homework",
      subTitle: "Assignments",
      icon: Icons.auto_stories_rounded,
      color: Color(0xFF00796B),
      permission: PermissionKeys.viewHomework,
      route: RoutesName.allHomeWorkScreen,
    ),

    DashboardModule(
      title: "Notifications",
      subTitle: "Alerts & updates",
      icon: Icons.notifications_active_rounded,
      color: Color(0xFFE65100),
      permission: PermissionKeys.notificationView,
      route: RoutesName.notificationScreen,
    ),

    DashboardModule(
      title: "Exam Marks",
      subTitle: "Enter marks",
      icon: Icons.grading_rounded,
      color: Color(0xFF558B2F),
      permission: PermissionKeys.manageExamMarks,
      route: RoutesName.schoolExamMarksScreen,
    ),

    // ADMIN ONLY
    DashboardModule(
      title: "Permission",
      subTitle: "Access control",
      icon: Icons.admin_panel_settings_rounded,
      color: Color(0xFF4527A0),
      permission: PermissionKeys.managePermissions,
      route: RoutesName.managePermission,
    ),
  ];
}