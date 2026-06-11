// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:school_pro/admin_management/school_management_dashboard_screen.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
// import 'package:school_pro/student_management/student_exam_screen.dart';
// import 'package:school_pro/student_management/student_fees_screen.dart';
// import 'package:school_pro/student_management/student_record_screen.dart';
// import 'package:school_pro/teacher_management/attendance_screen.dart';
// import 'package:school_pro/teacher_management/message_screen.dart';
//
//
// class ModuleScreen extends StatelessWidget {
//   final String title;
//   const ModuleScreen({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Tab> tabs = [];
//     List<Widget> tabViews = [];
//
//     if (title == "Admin") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SchoolManagementDashboardScreen(),
//         ),
//       );
//       // Navigator.pushNamed(context, RoutesName.)
//       // tabs = const [
//       //   // Tab(text: "Classes"),
//       //   Tab(text: "All Students"),
//       //   Tab(text: "Sections"),
//       //   Tab(text: "Fees"),
//       // ];
//       // tabViews = [
//       //   AllStudentList(),
//       //   // ClassesPage(),
//       //   SectionsPage(),
//       //   FeesPage()
//       // ];
//     } else if (title == "Teacher Panel") {
//       tabs = const [
//         Tab(text: "Attendance"),
//         // Tab(text: "Performance"),
//         Tab(text: "Messages"),
//       ];
//       tabViews = [
//         AttendanceScreen(),
//         // PerformanceScreen(),
//         MessagesPage(),
//       ];
//     } else if (title == "Accountant") {
//       tabs = const [
//         Tab(text: "Records"),
//         Tab(text: "Exams"),
//         Tab(text: "Fees"),
//       ];
//       tabViews = [
//         StudentRecordsPage(),
//         StudentExamScreen(),
//         StudentFeesScreen(),
//         // Center(child: AppText.customText("Student Records")),
//         // Center(child: AppText.customText("Student Exams")),
//         // Center(child: AppText.customText("Student Fees")),
//       ];
//     }
//
//     // else if (title == "Accountant") {
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   Navigator.pushNamed(context, RoutesName.studentDashboardScreen);
//     //   });
//     //   tabs = const [
//     //     Tab(text: "Records"),
//     //     Tab(text: "Exams"),
//     //     Tab(text: "Fees"),
//     //   ];
//     //   tabViews = [
//     //     StudentRecordsPage(),
//     //     StudentExamScreen(),
//     //     StudentFeesScreen(),
//     //     // Center(child: AppText.customText("Student Records")),
//     //     // Center(child: AppText.customText("Student Exams")),
//     //     // Center(child: AppText.customText("Student Fees")),
//     //   ];
//     //   // tabs = const [Tab(text: "Loading")];
//     //   // tabViews = [const SizedBox()];
//     // }
//
//     return DefaultTabController(
//       length: tabs.length == 0 ? 1 : tabs.length, // safety fix ✅
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: AppColor.lightBlueColor,
//           elevation: 0,
//
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//
//           title: AppText.customText(
//             title,
//             size: 20,
//             weight: FontWeight.w700,
//             color: Colors.white,
//           ),
//
//           bottom: TabBar(
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white70,
//             indicatorColor: Colors.white,
//             indicatorWeight: 3,
//             tabs: tabs.isEmpty ? const [Tab(text: "Coming Soon")] : tabs,
//           ),
//         ),
//
//         body: TabBarView(
//           children: tabViews.isEmpty
//               ? [Center(child: AppText.customText("Coming Soon"))]
//               : tabViews,
//         ),
//       ),
//     );
//   }
// }
