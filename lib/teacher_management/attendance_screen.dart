// // import 'package:flutter/material.dart';
// // import 'package:school_pro/res/app_color.dart';
// // import 'package:school_pro/res/const_text.dart';
// //
// // class AttendanceScreen extends StatelessWidget {
// //   const AttendanceScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: ListView(
// //         children: [
// //
// //           _studentCard("Rahul Kumar", "Roll No: 01", true),
// //           _studentCard("Anjali Singh", "Roll No: 02", false),
// //           _studentCard("Rohit Verma", "Roll No: 03", true),
// //           _studentCard("Pooja Sharma", "Roll No: 04", true),
// //           _studentCard("Aman Gupta", "Roll No: 05", false),
// //
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _studentCard(String name, String roll, bool present) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 14),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(18),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.06),
// //             blurRadius: 12,
// //             offset: const Offset(0, 6),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //
// //           CircleAvatar(
// //             radius: 24,
// //             backgroundColor: AppColor.lightBlueColor.withOpacity(.15),
// //             child: const Icon(
// //               Icons.person,
// //               color: AppColor.lightBlueColor,
// //               size: 28,
// //             ),
// //           ),
// //
// //           const SizedBox(width: 14),
// //
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 AppText.customText(name, size: 16, weight: FontWeight.w600),
// //                 const SizedBox(height: 4),
// //                 AppText.customText(roll, size: 12, color: Colors.grey),
// //               ],
// //             ),
// //           ),
// //
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: present ? Colors.green.withOpacity(.15) : Colors.red.withOpacity(.15),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: AppText.customText(
// //               present ? "Present" : "Absent",
// //               size: 12,
// //               weight: FontWeight.w600,
// //               color: present ? Colors.green : Colors.red,
// //             ),
// //           ),
// //
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// import '../res/app_button.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }
//
// class _AttendanceScreenState extends State<AttendanceScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   final List<Map<String, dynamic>> students = [
//     {
//       "name": "Rahul Kumar",
//       "roll": "01",
//       "isPresent": true,
//       "avatar": "R",
//       "color": Color(0xFF6C5CE7),
//     },
//     {
//       "name": "Anjali Singh",
//       "roll": "02",
//       "isPresent": false,
//       "avatar": "A",
//       "color": Color(0xFF00B894),
//     },
//     {
//       "name": "Rohit Verma",
//       "roll": "03",
//       "isPresent": true,
//       "avatar": "R",
//       "color": Color(0xFFFF6B6B),
//     },
//     {
//       "name": "Pooja Sharma",
//       "roll": "04",
//       "isPresent": true,
//       "avatar": "P",
//       "color": Color(0xFFFFA502),
//     },
//     {
//       "name": "Aman Gupta",
//       "roll": "05",
//       "isPresent": false,
//       "avatar": "A",
//       "color": Color(0xFF0984E3),
//     },
//     {
//       "name": "Priya Patel",
//       "roll": "06",
//       "isPresent": true,
//       "avatar": "P",
//       "color": Color(0xFFE84393),
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   int get presentCount =>
//       students.where((s) => s["isPresent"] == true).length;
//   int get absentCount => students.where((s) => s["isPresent"] == false).length;
//   double get attendancePercentage =>
//       (presentCount / students.length) * 100;
//
//   void _toggleAttendance(int index) {
//     setState(() {
//       students[index]["isPresent"] = !students[index]["isPresent"];
//     });
//   }
//
//   void _markAllPresent() {
//     setState(() {
//       for (var student in students) {
//         student["isPresent"] = true;
//       }
//     });
//   }
//
//   void _markAllAbsent() {
//     setState(() {
//       for (var student in students) {
//         student["isPresent"] = false;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppColor.lightBlueColor,
//                       AppColor.lightBlueColor.withOpacity(0.8),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColor.lightBlueColor.withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText.customText(
//                               "Attendance",
//                               size: 26,
//                               weight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(height: 4),
//                             AppText.customText(
//                               "Class 5 - Section A",
//                               size: 14,
//                               color: Colors.white.withOpacity(0.9),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.calendar_today_rounded,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.check_circle_rounded,
//                             label: "Present",
//                             value: "$presentCount",
//                             color: Colors.green,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.cancel_rounded,
//                             label: "Absent",
//                             value: "$absentCount",
//                             color: Colors.red,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.percent_rounded,
//                             label: "Rate",
//                             value: "${attendancePercentage.toStringAsFixed(0)}%",
//                             color: Colors.amber,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Quick Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildActionButton(
//                             label: "Mark All Present",
//                             icon: Icons.done_all_rounded,
//                             onTap: _markAllPresent,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildActionButton(
//                             label: "Mark All Absent",
//                             icon: Icons.close_rounded,
//                             onTap: _markAllAbsent,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Students List Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppText.customText(
//                       "Students (${students.length})",
//                       size: 18,
//                       weight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.sort_rounded,
//                             size: 16,
//                             color: Colors.grey[700],
//                           ),
//                           const SizedBox(width: 4),
//                           AppText.customText(
//                             "Sort",
//                             size: 12,
//                             color: Colors.grey[700]!,
//                             weight: FontWeight.w600,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Students List
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: List.generate(
//                     students.length,
//                         (index) => _buildAnimatedCard(index, students[index]),
//                   ),
//                 ),
//               ),
//
//               // const SizedBox(height: 100), // Space for submit button
//             ],
//           ),
//         ),
//
//         // Fixed Submit Button at Bottom
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child:Padding(
//               padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.001),
//               child: AppButton(
//                 title: "Submit Attendance",
//                 icon: Icons.save_rounded,
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text(
//                         "Attendance submitted successfully!",
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       backgroundColor: Colors.green,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Container(
//             //   width: double.infinity,
//             //   height: 56,
//             //   decoration: BoxDecoration(
//             //     gradient: LinearGradient(
//             //       colors: [
//             //         AppColor.lightBlueColor,
//             //         AppColor.lightBlueColor.withOpacity(0.8),
//             //       ],
//             //     ),
//             //     borderRadius: BorderRadius.circular(16),
//             //     boxShadow: [
//             //       BoxShadow(
//             //         color: AppColor.lightBlueColor.withOpacity(0.4),
//             //         blurRadius: 20,
//             //         offset: const Offset(0, 8),
//             //       ),
//             //     ],
//             //   ),
//             //   child: Material(
//             //     color: Colors.transparent,
//             //     child: InkWell(
//             //       borderRadius: BorderRadius.circular(16),
//             //       onTap: () {
//             //         // Submit attendance
//             //         ScaffoldMessenger.of(context).showSnackBar(
//             //           SnackBar(
//             //             content: const Text(
//             //               "Attendance submitted successfully!",
//             //               style: TextStyle(fontWeight: FontWeight.w600),
//             //             ),
//             //             backgroundColor: Colors.green,
//             //             behavior: SnackBarBehavior.floating,
//             //             shape: RoundedRectangleBorder(
//             //               borderRadius: BorderRadius.circular(12),
//             //             ),
//             //           ),
//             //         );
//             //       },
//             //       child: Center(
//             //         child: Row(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           children: [
//             //             const Icon(
//             //               Icons.save_rounded,
//             //               color: Colors.white,
//             //               size: 24,
//             //             ),
//             //             const SizedBox(width: 10),
//             //             AppText.customText(
//             //               "Submit Attendance",
//             //               size: 18,
//             //               weight: FontWeight.bold,
//             //               color: Colors.white,
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white, size: 26),
//           const SizedBox(height: 6),
//           AppText.customText(
//             value,
//             size: 20,
//             weight: FontWeight.bold,
//             color: Colors.white,
//           ),
//           AppText.customText(
//             label,
//             size: 11,
//             color: Colors.white.withOpacity(0.9),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required String label,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: Colors.white, size: 18),
//               const SizedBox(width: 6),
//               AppText.customText(
//                 label,
//                 size: 13,
//                 color: Colors.white,
//                 weight: FontWeight.w600,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard(int index, Map<String, dynamic> student) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         final delay = index * 0.08;
//         final animationValue = Curves.easeOut.transform(
//           (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
//         );
//
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - animationValue)),
//           child: Opacity(
//             opacity: animationValue,
//             child: child,
//           ),
//         );
//       },
//       child: _studentCard(
//         name: student["name"],
//         roll: student["roll"],
//         avatar: student["avatar"],
//         isPresent: student["isPresent"],
//         color: student["color"],
//         onTap: () => _toggleAttendance(index),
//       ),
//     );
//   }
//
//   Widget _studentCard({
//     required String name,
//     required String roll,
//     required String avatar,
//     required bool isPresent,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isPresent
//               ? Colors.green.withOpacity(0.3)
//               : Colors.red.withOpacity(0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: (isPresent ? Colors.green : Colors.red).withOpacity(0.15),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(18),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Avatar with gradient
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         color,
//                         color.withOpacity(0.7),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: AppText.customText(
//                       avatar,
//                       size: 24,
//                       weight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 14),
//
//                 // Student Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(
//                         name,
//                         size: 16,
//                         weight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.badge_rounded,
//                             size: 14,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(width: 4),
//                           AppText.customText(
//                             "Roll No: $roll",
//                             size: 13,
//                             color: Colors.grey[600]!,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Status Toggle Button
//                 GestureDetector(
//                   onTap: onTap,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: isPresent
//                             ? [Colors.green, Colors.green.shade400]
//                             : [Colors.red, Colors.red.shade400],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: (isPresent ? Colors.green : Colors.red)
//                               .withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           isPresent
//                               ? Icons.check_circle_rounded
//                               : Icons.cancel_rounded,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 6),
//                         AppText.customText(
//                           isPresent ? "Present" : "Absent",
//                           size: 13,
//                           weight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }