// import 'package:flutter/material.dart';
//
//
// class StudentRecordsScreen extends StatefulWidget {
//   const StudentRecordsScreen({super.key});
//
//   @override
//   State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
// }
//
// class _StudentRecordsScreenState extends State<StudentRecordsScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  CustomScrollView(
//         slivers: [
//           // Animated App Bar with Student Profile
//           SliverAppBar(
//             expandedHeight: 280,
//             floating: false,
//             pinned: true,
//             backgroundColor: const Color(0xFF2E5BFF),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Color(0xFF2E5BFF), Color(0xFF5B8DEF), Color(0xFF8BA4F9)],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 40),
//                       // Student Photo with animated border
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: const LinearGradient(
//                             colors: [Colors.white, Color(0xFFFFD700)],
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: const CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.white,
//                           child: Icon(Icons.person, size: 60, color: Color(0xFF2E5BFF)),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Rahul Kumar',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text(
//                           'Roll No: 2024CS101 • Class 12-A',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Quick Stats Cards
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Quick Stats Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildQuickStatCard(
//                           icon: Icons.emoji_events,
//                           title: 'GPA',
//                           value: '8.9',
//                           color: const Color(0xFFFFB800),
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFFFB800), Color(0xFFFFC947)],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildQuickStatCard(
//                           icon: Icons.check_circle,
//                           title: 'Attendance',
//                           value: '94%',
//                           color: const Color(0xFF00D9A5),
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF00D9A5), Color(0xFF4AEDC4)],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildQuickStatCard(
//                           icon: Icons.assignment_turned_in,
//                           title: 'Assignments',
//                           value: '12/15',
//                           color: const Color(0xFFFF6B9D),
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB8)],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Tab Bar
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelColor: const Color(0xFF2E5BFF),
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: const Color(0xFF2E5BFF),
//                       indicatorWeight: 3,
//                       labelStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                       tabs: const [
//                         Tab(text: 'Academic'),
//                         Tab(text: 'Attendance'),
//                         Tab(text: 'Fees'),
//                         Tab(text: 'More'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Tab Content
//           SliverFillRemaining(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildAcademicTab(),
//                 _buildAttendanceTab(),
//                 _buildFeesTab(),
//                 _buildMoreTab(),
//               ],
//             ),
//           ),
//         ],
//
//     );
//   }
//
//   Widget _buildQuickStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//     required Gradient gradient,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 11,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAcademicTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Subject Marks',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildSubjectCard('Mathematics', 92, Colors.blue),
//           _buildSubjectCard('Physics', 88, Colors.purple),
//           _buildSubjectCard('Chemistry', 85, Colors.green),
//           _buildSubjectCard('English', 90, Colors.orange),
//           _buildSubjectCard('Computer Science', 95, Colors.red),
//           const SizedBox(height: 24),
//
//           // Achievements Section
//           const Text(
//             'Recent Achievements',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildAchievementCard(
//             '🏆 1st Prize - Science Exhibition',
//             'National Level Competition',
//             'Jan 2026',
//           ),
//           _buildAchievementCard(
//             '🥇 Top Scorer - Math Olympiad',
//             'State Level',
//             'Dec 2025',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSubjectCard(String subject, int marks, Color color) {
//     double percentage = marks / 100;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 subject,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '$marks/100',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: percentage,
//               minHeight: 8,
//               backgroundColor: color.withOpacity(0.1),
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAchievementCard(String title, String subtitle, String date) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFFF6E5), Color(0xFFFFE8CC)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             date,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFFFF8800),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttendanceTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Monthly Overview
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF00D9A5), Color(0xFF4AEDC4)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF00D9A5).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   'Overall Attendance',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   '94%',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '188 Present • 12 Absent',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           const Text(
//             'Monthly Breakdown',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildMonthAttendanceCard('January 2026', 22, 1),
//           _buildMonthAttendanceCard('December 2025', 18, 2),
//           _buildMonthAttendanceCard('November 2025', 21, 1),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMonthAttendanceCard(String month, int present, int absent) {
//     int total = present + absent;
//     double percentage = (present / total) * 100;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 month,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               Text(
//                 '${percentage.toStringAsFixed(0)}%',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00D9A5),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _buildAttendanceChip('Present', present, const Color(0xFF00D9A5)),
//               const SizedBox(width: 8),
//               _buildAttendanceChip('Absent', absent, const Color(0xFFFF6B9D)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttendanceChip(String label, int count, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         '$label: $count',
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: color,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeesTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Fee Summary Card
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF6C5CE7), Color(0xFF8E7FF0)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF6C5CE7).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Total Fee',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'PAID',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   '₹85,000',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Academic Year 2025-26',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           const Text(
//             'Payment History',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildFeeCard('Tuition Fee', '₹50,000', 'Paid', '15 Jan 2026'),
//           _buildFeeCard('Laboratory Fee', '₹15,000', 'Paid', '15 Jan 2026'),
//           _buildFeeCard('Library Fee', '₹10,000', 'Paid', '15 Jan 2026'),
//           _buildFeeCard('Sports Fee', '₹10,000', 'Paid', '15 Jan 2026'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeeCard(String title, String amount, String status, String date) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00D9A5).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.check_circle,
//               color: Color(0xFF00D9A5),
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   date,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             amount,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMoreTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Personal Information',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildInfoCard(Icons.phone, 'Phone', '+91 9876543210'),
//           _buildInfoCard(Icons.email, 'Email', 'rahul.kumar@school.edu'),
//           _buildInfoCard(Icons.location_on, 'Address', 'Lucknow, Uttar Pradesh'),
//           _buildInfoCard(Icons.cake, 'Date of Birth', '15 March 2008'),
//           const SizedBox(height: 24),
//
//           const Text(
//             'Parent/Guardian Details',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildInfoCard(Icons.person, 'Father\'s Name', 'Mr. Rajesh Kumar'),
//           _buildInfoCard(Icons.phone, 'Contact', '+91 9876543211'),
//           _buildInfoCard(Icons.person_outline, 'Mother\'s Name', 'Mrs. Priya Kumar'),
//           _buildInfoCard(Icons.phone, 'Contact', '+91 9876543212'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(IconData icon, String label, String value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2E5BFF).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF2E5BFF),
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';

class StudentRecordsPage extends StatefulWidget {
  const StudentRecordsPage({super.key});

  @override
  State<StudentRecordsPage> createState() => _StudentRecordsPageState();
}

class _StudentRecordsPageState extends State<StudentRecordsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;

  // Student Data
  final Map<String, dynamic> studentData = {
    "name": "Rahul Kumar",
    "rollNo": "2024CS101",
    "class": "Class 12-A",
    "photo": null,
    "gpa": 8.9,
    "attendance": 94.0,
    "assignmentsCompleted": 12,
    "totalAssignments": 15,
  };

  // Academic Records
  final List<Map<String, dynamic>> subjects = [
    {"name": "Mathematics", "marks": 92, "total": 100, "color": Color(0xFF6C5CE7)},
    {"name": "Physics", "marks": 88, "total": 100, "color": Color(0xFF00B894)},
    {"name": "Chemistry", "marks": 85, "total": 100, "color": Color(0xFFFF6B6B)},
    {"name": "English", "marks": 90, "total": 100, "color": Color(0xFFFFA502)},
    {"name": "Computer Science", "marks": 95, "total": 100, "color": Color(0xFF0984E3)},
  ];

  // Achievements
  final List<Map<String, String>> achievements = [
    {
      "title": "🏆 1st Prize - Science Exhibition",
      "subtitle": "National Level Competition",
      "date": "Jan 2024",
    },
    {
      "title": "🥇 Top Scorer - Math Olympiad",
      "subtitle": "State Level",
      "date": "Dec 2023",
    },
    {
      "title": "🎖️ Best Student Award",
      "subtitle": "School Annual Function",
      "date": "Nov 2023",
    },
  ];

  // Attendance Records
  final List<Map<String, dynamic>> attendanceRecords = [
    {"month": "January 2024", "present": 22, "absent": 1, "total": 23},
    {"month": "December 2023", "present": 18, "absent": 2, "total": 20},
    {"month": "November 2023", "present": 21, "absent": 1, "total": 22},
    {"month": "October 2023", "present": 20, "absent": 2, "total": 22},
  ];

  // Personal Info
  final Map<String, String> personalInfo = {
    "Phone": "+91 9876543210",
    "Email": "rahul.kumar@school.edu",
    "Address": "Lucknow, Uttar Pradesh",
    "DOB": "15 March 2008",
    "Blood Group": "O+",
  };

  // Parent Info
  final Map<String, String> parentInfo = {
    "Father's Name": "Mr. Rajesh Kumar",
    "Father's Phone": "+91 9876543211",
    "Mother's Name": "Mrs. Priya Kumar",
    "Mother's Phone": "+91 9876543212",
    "Emergency Contact": "+91 9876543213",
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double get averageMarks {
    int total = subjects.fold<int>(0, (sum, subject) => sum + (subject['marks'] as int));
    return total / subjects.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Header Section with Student Profile
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              "Student Records",
                              size: 26,
                              weight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 4),
                            AppText.customText(
                              "Academic Year 2023-24",
                              size: 13,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.lightBlueColor,
                                AppColor.lightBlueColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.lightBlueColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Student Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.lightBlueColor,
                        AppColor.lightBlueColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.lightBlueColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Student Photo
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColor.lightBlueColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              studentData["name"],
                              size: 20,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: AppText.customText(
                                "${studentData['rollNo']} * ${studentData['class']}",
                                size: 12,
                                color: Colors.white,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Quick Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        title: "GPA",
                        value: studentData["gpa"].toString(),
                        icon: Icons.emoji_events_rounded,
                        color: const Color(0xFFFFA502),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildQuickStatCard(
                        title: "Attendance",
                        value: "${studentData['attendance'].toInt()}%",
                        icon: Icons.check_circle_rounded,
                        color: const Color(0xFF00B894),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildQuickStatCard(
                        title: "Tasks",
                        value: "${studentData['assignmentsCompleted']}/${studentData['totalAssignments']}",
                        icon: Icons.assignment_turned_in_rounded,
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColor.lightBlueColor,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: AppColor.lightBlueColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(text: 'Academic'),
                    Tab(text: 'Attendance'),
                    Tab(text: 'Personal'),
                    Tab(text: 'Parent'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAcademicTab(),
                    _buildAttendanceTab(),
                    _buildPersonalTab(),
                    _buildParentTab(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          AppText.customText(
            value,
            size: 18,
            weight: FontWeight.bold,
            color: color,
          ),
          const SizedBox(height: 4),
          AppText.customText(
            title,
            size: 11,
            color: Colors.grey[700]!,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  // Academic Tab
  Widget _buildAcademicTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.customText(
              "Subject Marks",
              size: 18,
              weight: FontWeight.bold,
              color: Colors.black87,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText.customText(
                "Avg: ${averageMarks.toStringAsFixed(1)}%",
                size: 12,
                color: Colors.grey[700]!,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Subject Cards
        ...List.generate(
          subjects.length,
              (index) => _buildAnimatedCard(index, _buildSubjectCard(subjects[index])),
        ),

        const SizedBox(height: 16),

        // Achievements Section
        AppText.customText(
          "Achievements",
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),

        const SizedBox(height: 12),

        ...achievements.map((achievement) => _buildAchievementCard(achievement)),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    double percentage = (subject['marks'] / subject['total']) * 100;
    Color color = subject['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.book_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText.customText(
                      subject['name'],
                      size: 16,
                      weight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppText.customText(
                    "${subject['marks']}/${subject['total']}",
                    size: 13,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            AppText.customText(
              "${percentage.toStringAsFixed(0)}% Score",
              size: 12,
              color: Colors.grey[600]!,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, String> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF6E5), Color(0xFFFFE8CC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFA502).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA502).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText(
                  achievement['title']!,
                  size: 15,
                  weight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 4),
                AppText.customText(
                  achievement['subtitle']!,
                  size: 13,
                  color: Colors.grey[700]!,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA502).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppText.customText(
              achievement['date']!,
              size: 11,
              weight: FontWeight.bold,
              color: const Color(0xFFFFA502),
            ),
          ),
        ],
      ),
    );
  }

  // Attendance Tab
  Widget _buildAttendanceTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Overall Attendance Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B894).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              AppText.customText(
                "Overall Attendance",
                size: 16,
                color: Colors.white.withOpacity(0.9),
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 12),
              AppText.customText(
                "${studentData['attendance'].toInt()}%",
                size: 48,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              AppText.customText(
                "188 Present * 12 Absent",
                size: 13,
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        AppText.customText(
          "Monthly Breakdown",
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),

        const SizedBox(height: 12),

        ...List.generate(
          attendanceRecords.length,
              (index) => _buildAnimatedCard(
            index,
            _buildAttendanceCard(attendanceRecords[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> record) {
    double percentage = (record['present'] / record['total']) * 100;
    Color color = percentage >= 90
        ? const Color(0xFF00B894)
        : percentage >= 75
        ? const Color(0xFFFFA502)
        : const Color(0xFFFF6B6B);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText.customText(
                      record['month'],
                      size: 16,
                      weight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppText.customText(
                    "${percentage.toStringAsFixed(0)}%",
                    size: 13,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildAttendanceChip(
                  "Present",
                  record['present'],
                  const Color(0xFF00B894),
                ),
                const SizedBox(width: 8),
                _buildAttendanceChip(
                  "Absent",
                  record['absent'],
                  const Color(0xFFFF6B6B),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: AppText.customText(
        "$label: $count",
        size: 12,
        weight: FontWeight.w600,
        color: color,
      ),
    );
  }

  // Personal Info Tab
  Widget _buildPersonalTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        AppText.customText(
          "Personal Information",
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 12),
        ...personalInfo.entries.map((entry) => _buildInfoCard(
          entry.key,
          entry.value,
          _getIconForField(entry.key),
          const Color(0xFF6C5CE7),
        )),
      ],
    );
  }

  // Parent Info Tab
  Widget _buildParentTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        AppText.customText(
          "Parent/Guardian Details",
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 12),
        ...parentInfo.entries.map((entry) => _buildInfoCard(
          entry.key,
          entry.value,
          _getIconForField(entry.key),
          const Color(0xFF0984E3),
        )),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(
                    label,
                    size: 12,
                    color: Colors.grey[600]!,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText.customText(
                    value,
                    size: 15,
                    weight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForField(String field) {
    if (field.contains("Phone") || field.contains("Contact")) {
      return Icons.phone_rounded;
    } else if (field.contains("Email")) {
      return Icons.email_rounded;
    } else if (field.contains("Address")) {
      return Icons.location_on_rounded;
    } else if (field.contains("DOB") || field.contains("Birth")) {
      return Icons.cake_rounded;
    } else if (field.contains("Blood")) {
      return Icons.bloodtype_rounded;
    } else if (field.contains("Name")) {
      return Icons.person_rounded;
    } else if (field.contains("Emergency")) {
      return Icons.emergency_rounded;
    }
    return Icons.info_rounded;
  }

  Widget _buildAnimatedCard(int index, Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final delay = index * 0.08;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: child,
          ),
        );
      },
    );
  }
}