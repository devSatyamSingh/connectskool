import 'package:flutter/material.dart';
import 'package:school_pro/admin_management/student/all_student_list.dart';
import 'package:school_pro/utils/routes/routes_name.dart';

import '../../accountant_management/accountant_management_dash_board_screen.dart';
import '../../admin_management/marksheet/Exam_marks_grade_selection_screen.dart';
import '../../admin_management/fees/admin_view_fees_structure_screen.dart';
import '../../admin_management/accountant/all_accountant_list_screen.dart';
import '../../admin_management/homework/all_home_work_screen.dart';
import '../../admin_management/section/all_section_screen.dart';
import '../../admin_management/subject/all_subjects_screen.dart';
import '../../admin_management/teacher/all_teachers_screen.dart';
import '../../admin_management/attendance_widget/staff_attendence_screen.dart';
import '../../admin_management/classes/classes_screen.dart';
import '../../admin_management/classes/create_class_screen.dart';
import '../../admin_management/exam/exam_screen.dart';
import '../../admin_management/fees/fees_head_management_screen.dart';
import '../../admin_management/fees/fees_management_screen.dart';
import '../../admin_management/fees/fine_screen.dart';
import '../../admin_management/settings/help_support_screen.dart';
import '../../admin_management/permission/manage_permission.dart';
import '../../admin_management/marksheet/co_scholastic_grade_screen.dart';
import '../../admin_management/marksheet/generate_marksheet_screen.dart';
import '../../admin_management/marksheet/marksheet_screen.dart';
import '../../admin_management/marksheet/marksheet_selection_screen.dart';
import '../../admin_management/notification/notification_screen.dart';
import '../../admin_management/permission/role_permission_screen.dart';
import '../../admin_management/exam/school_admit_card_screen.dart';
import '../../admin_management/attendance_widget/school_attendance_screen.dart';
import '../../admin_management/fees/school_collect_fees_screen.dart';
import '../../admin_management/exam/school_exam_marks_screen.dart';
import '../../admin_management/school_management_dashboard_screen.dart';
import '../../admin_management/timetable/school_timetable_screen.dart';
import '../../admin_management/setting_widget/school_admin_privacy_policy_screen.dart';
import '../../admin_management/transport_fee_widget/transport_fee_management_screen.dart';
import '../../admin_management/transport_fee_widget/route_screen.dart';
import '../../admin_management/transport_fee_widget/stop_screen.dart';
import '../../admin_management/transport_fee_widget/student_transport_fee_screen.dart';
import '../../admin_management/transport_fee_widget/transport_fee_screen.dart';
import '../../admin_management/permission/user_permission_screen.dart';
import '../../auth/login_screen.dart';
import '../../dash_board_screen.dart';
import '../../on_boarding/on_boarding_screen.dart';
import '../../splash_screen.dart';
import '../../student_management/student_dash_board_screen.dart';
import '../../student_management/student_notification_screen.dart';
import '../../student_management/student_widget/student_attandence_screen.dart';
import '../../student_management/student_widget/student_home_work_screen.dart';
import '../../student_management/student_widget/student_profile_screen.dart';
import '../../student_management/student_widget/student_subject_screen.dart';
import '../../teacher_management/teacher_management_dashboard_screen.dart';
import '../../teacher_management/teacher_profile_screen.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splash:
        return (context) => const SplashScreen();
      case RoutesName.onboardingScreen:
        return (context) => const OnboardingScreen();
      case RoutesName.dashboardScreen:
        return (context) => const DashboardScreen();
      case RoutesName.loginScreen:
        return (context) => const LoginScreen();
      case RoutesName.studentDashboardScreen:
        return (context) => const StudentDashboardScreen();
        case RoutesName.schoolManagementDashboardScreen:
        return (context) => const SchoolManagementDashboardScreen();
      case RoutesName.allStudentList:
        return (context) => const AllStudentList();
      case RoutesName.allTeacherListScreen:
        return (context) => const AllTeacherListScreen();
      case RoutesName.allAccountantListScreen:
        return (context) => const AllAccountantListScreen();
      case RoutesName.classesPage:
        return (context) => const ClassesPage();
      case RoutesName.createClassScreen:
        return (context) => const CreateClassScreen();
      case RoutesName.allSectionScreen:
        return (context) => const SectionsPage();
      case RoutesName.allSubjectsScreen:
        return (context) => const AllSubjectsScreen();
      case RoutesName.fineManagementScreen:
        return (context) => const FineManagementScreen();
      case RoutesName.feesManagementScreen:
        return (context) => const FeesManagementScreen();
      case RoutesName.feesHeadManagementScreen:
        return (context) => const FeesHeadManagementScreen();
      case RoutesName.examScreen:
        return (context) => const ExamScreen();
      case RoutesName.allHomeWorkScreen:
        return (context) => const AllHomeWorkScreen();
        case RoutesName.schoolAdminPrivacyPolicyScreen:
        return (context) => const SchoolAdminPrivacyPolicyScreen();
        case RoutesName.notificationScreen:
        return (context) => const NotificationScreen();
        // case RoutesName.studentSubjectScreen:
        // return (context) => const StudentSubjectScreen();
      case RoutesName.studentProfileScreen:
        return (context) => const StudentProfileScreen();
      case RoutesName.studentAttendanceScreen:
        return (context) => const StudentAttendanceScreen();
      case RoutesName.studentHomeworkScreen:
        return (context) => const StudentHomeworkScreen();
        case RoutesName.rolePermissionScreen:
        return (context) => const RolePermissionScreen();
        case RoutesName.schoolAttendanceScreen:
        return (context) => const SchoolAttendanceScreen();
        case RoutesName.schoolExamMarksScreen:
        return (context) => const ExamMarksGradeSelectionScreen();
        case RoutesName.staffAttendanceScreen:
        return (context) => const StaffAttendanceScreen();
        case RoutesName.managePermission:
        return (context) => const ManagePermission();
        case RoutesName.userPermissionScreen:
        return (context) => const UserPermissionsScreen();
        case RoutesName.adminViewFeesStructureScreen:
        return (context) => const AdminViewFeesStructureScreen();
        case RoutesName.schoolTimetableScreen:
        return (context) => const SchoolTimetableScreen();
        case RoutesName.schoolCollectFeesScreen:
        return (context) => const SchoolCollectFeesScreen();
        case RoutesName.marksheetScreen:
        return (context) => const GenerateMarksheetScreen();
      // case RoutesName.marksheetScreen:
      //   return (context) => const marksheetScreen();
        case RoutesName.schoolAdmitCardScreen:
        return (context) => const SchoolAdmitCardScreen();
        case RoutesName.accountantManagementDashBoardScreen:
        return (context) => const AccountantManagementDashBoardScreen();
        case RoutesName.transportFeeManagementScreen:
        return (context) => const TransportFeeManagementScreen();
        case RoutesName.routeScreen:
        return (context) => const RouteScreen();
        case RoutesName.stopScreen:
        return (context) => const StopScreen();
        case RoutesName.transportFeeScreen:
        return (context) => const TransportFeeScreen();
        case RoutesName.studentTransportFeeScreen:
        return (context) => const StudentTransportFeeScreen();
        case RoutesName.teacherManagementDashBoardScreen:
        return (context) => const TeacherManagementDashBoardScreen();
        case RoutesName.teacherProfileScreen:
        return (context) => const TeacherProfileScreen();
        case RoutesName.studentNotificationScreen:
        return (context) => const StudentNotificationScreen();
      case RoutesName.helpSupportScreen:
        return (context) => const HelpSupportScreen();


      default:
        return (context) => const Scaffold(
          body: Center(
            child: Text(
              'No Route Found!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        );
    }
  }
}
