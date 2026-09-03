import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/utils/permission_keys.dart';
import 'package:school_pro/utils/routes/routes_name.dart';

class DashboardModule {
  final String title;
  final String titleKey;
  final String subTitle;
  final String subTitleKey;
  final IconData icon;
  final Color color;
  final String permission;
  final String route;

  const DashboardModule({
    required this.title,
    required this.titleKey,
    required this.subTitle,
    required this.subTitleKey,
    required this.icon,
    required this.color,
    required this.permission,
    required this.route,
  });

  // ✅ Getter jo .tr() apply karega
  String get localizedTitle => titleKey.tr();
  String get localizedSubTitle => subTitleKey.tr();
}

class DashboardModules {
  static const List<DashboardModule> modules = [

    DashboardModule(
      title: "All Students",
      titleKey: "dashboard_modules.all_students",
      subTitle: "Manage students",
      subTitleKey: "dashboard_modules.all_students_sub",
      icon: Icons.people_alt_rounded,
      color: Color(0xFF1976D2),
      permission: PermissionKeys.viewAllStudent,
      route: RoutesName.allStudentList,
    ),

    DashboardModule(
      title: "All Teachers",
      titleKey: "dashboard_modules.all_teachers",
      subTitle: "Staff list",
      subTitleKey: "dashboard_modules.all_teachers_sub",
      icon: Icons.school_rounded,
      color: Color(0xFF00897B),
      permission: PermissionKeys.viewAllTeacher,
      route: RoutesName.allTeacherListScreen,
    ),

    DashboardModule(
      title: "All Accountants",
      titleKey: "dashboard_modules.all_accountants",
      subTitle: "Finance team",
      subTitleKey: "dashboard_modules.all_accountants_sub",
      icon: Icons.account_balance_rounded,
      color: Color(0xFFF57C00),
      permission: PermissionKeys.viewAccountants,
      route: RoutesName.allAccountantListScreen,
    ),

    DashboardModule(
      title: "Classes",
      titleKey: "dashboard_modules.classes",
      subTitle: "View classes",
      subTitleKey: "dashboard_modules.classes_sub",
      icon: Icons.layers_rounded,
      color: Color(0xFF7B1FA2),
      permission: PermissionKeys.viewClasses,
      route: RoutesName.classesPage,
    ),

    DashboardModule(
      title: "Timetable",
      titleKey: "dashboard_modules.timetable",
      subTitle: "Weekly schedule",
      subTitleKey: "dashboard_modules.timetable_sub",
      icon: Icons.schedule_rounded,
      color: Color(0xFF2E7D32),
      permission: PermissionKeys.viewTimetable,
      route: RoutesName.schoolTimetableScreen,
    ),

    DashboardModule(
      title: "Subjects",
      titleKey: "dashboard_modules.subjects",
      subTitle: "All subjects",
      subTitleKey: "dashboard_modules.subjects_sub",
      icon: Icons.menu_book_rounded,
      color: Color(0xFF00695C),
      permission: PermissionKeys.viewSubjects,
      route: RoutesName.allSubjectsScreen,
    ),

    DashboardModule(
      title: "Fees",
      titleKey: "dashboard_modules.fees",
      subTitle: "Fee collection",
      subTitleKey: "dashboard_modules.fees_sub",
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF27AE60),
      permission: PermissionKeys.viewFees,
      route: RoutesName.feesManagementScreen,
    ),

    DashboardModule(
      title: "Transport Fee",
      titleKey: "dashboard_modules.transport_fee",
      subTitle: "Bus fees",
      subTitleKey: "dashboard_modules.transport_fee_sub",
      icon: Icons.directions_bus_rounded,
      color: Color(0xFF0097A7),
      permission: PermissionKeys.manageTransport,
      route: RoutesName.transportFeeManagementScreen,
    ),

    DashboardModule(
      title: "Exams",
      titleKey: "dashboard_modules.exams",
      subTitle: "Exam schedule",
      subTitleKey: "dashboard_modules.exams_sub",
      icon: Icons.assignment_turned_in_rounded,
      color: Color(0xFFD4A017),
      permission: PermissionKeys.viewExam,
      route: RoutesName.examScreen,
    ),

    DashboardModule(
      title: "Marksheet",
      titleKey: "dashboard_modules.marksheet",
      subTitle: "View marks",
      subTitleKey: "dashboard_modules.marksheet_sub",
      icon: Icons.description_rounded,
      color: Color(0xFF1565C0),
      permission: PermissionKeys.viewMarks,
      route: RoutesName.marksheetScreen,
    ),

    DashboardModule(
      title: "Admit Card",
      titleKey: "dashboard_modules.admit_card",
      subTitle: "Generate cards",
      subTitleKey: "dashboard_modules.admit_card_sub",
      icon: Icons.badge_rounded,
      color: Color(0xFFC62828),
      permission: PermissionKeys.generateAdmitCard,
      route: RoutesName.schoolAdmitCardScreen,
    ),

    DashboardModule(
      title: "Attendance",
      titleKey: "dashboard_modules.attendance",
      subTitle: "Daily attendance",
      subTitleKey: "dashboard_modules.attendance_sub",
      icon: Icons.fact_check_rounded,
      color: Color(0xFF0288D1),
      permission: PermissionKeys.markStudentAttendance,
      route: RoutesName.staffAttendanceScreen,
    ),

    DashboardModule(
      title: "Homework",
      titleKey: "dashboard_modules.homework",
      subTitle: "Assignments",
      subTitleKey: "dashboard_modules.homework_sub",
      icon: Icons.auto_stories_rounded,
      color: Color(0xFF00796B),
      permission: PermissionKeys.viewHomework,
      route: RoutesName.allHomeWorkScreen,
    ),

    DashboardModule(
      title: "Notifications",
      titleKey: "dashboard_modules.notifications",
      subTitle: "Alerts & updates",
      subTitleKey: "dashboard_modules.notifications_sub",
      icon: Icons.notifications_active_rounded,
      color: Color(0xFFE65100),
      permission: PermissionKeys.notificationView,
      route: RoutesName.notificationScreen,
    ),

    DashboardModule(
      title: "Exam Marks",
      titleKey: "dashboard_modules.exam_marks",
      subTitle: "Enter marks",
      subTitleKey: "dashboard_modules.exam_marks_sub",
      icon: Icons.grading_rounded,
      color: Color(0xFF558B2F),
      permission: PermissionKeys.manageExamMarks,
      route: RoutesName.schoolExamMarksScreen,
    ),

    // ADMIN ONLY
    DashboardModule(
      title: "Permission",
      titleKey: "dashboard_modules.permission",
      subTitle: "Access control",
      subTitleKey: "dashboard_modules.permission_sub",
      icon: Icons.admin_panel_settings_rounded,
      color: Color(0xFF4527A0),
      permission: PermissionKeys.managePermissions,
      route: RoutesName.managePermission,
    ),
  ];
}