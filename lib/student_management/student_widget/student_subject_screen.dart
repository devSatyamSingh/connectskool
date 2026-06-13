// import 'package:flutter/material.dart';
//
// import '../../res/app_color.dart';
// import '../../res/const_text.dart';
//
// class StudentSubjectScreen extends StatefulWidget {
//   const StudentSubjectScreen({super.key});
//
//   @override
//   State<StudentSubjectScreen> createState() => _StudentSubjectScreenState();
// }
//
// class _StudentSubjectScreenState extends State<StudentSubjectScreen> {
//   String selectedFilter = 'All';
//
//   // Sample subjects data
//   final List<Map<String, dynamic>> subjects = [
//     {
//       'name': 'Mathematics',
//       'teacher': 'Dr. Sarah Johnson',
//       'code': 'MATH-101',
//       'credits': 4,
//       'schedule': 'Mon, Wed, Fri - 9:00 AM',
//       'room': 'Room 204',
//       'progress': 85.0,
//       'attendance': 92.0,
//       'assignments': 8,
//       'pendingAssignments': 2,
//       'grade': 'A',
//       'color': const Color(0xFF6366F1),
//       'icon': Icons.calculate,
//     },
//     {
//       'name': 'Physics',
//       'teacher': 'Prof. Michael Chen',
//       'code': 'PHY-201',
//       'credits': 4,
//       'schedule': 'Tue, Thu - 11:00 AM',
//       'room': 'Lab 301',
//       'progress': 78.0,
//       'attendance': 88.0,
//       'assignments': 6,
//       'pendingAssignments': 1,
//       'grade': 'B+',
//       'color': const Color(0xFF8B5CF6),
//       'icon': Icons.science,
//     },
//     {
//       'name': 'English Literature',
//       'teacher': 'Ms. Emma Williams',
//       'code': 'ENG-102',
//       'credits': 3,
//       'schedule': 'Mon, Wed - 2:00 PM',
//       'room': 'Room 105',
//       'progress': 90.0,
//       'attendance': 95.0,
//       'assignments': 5,
//       'pendingAssignments': 0,
//       'grade': 'A+',
//       'color': const Color(0xFF10B981),
//       'icon': Icons.menu_book,
//     },
//     {
//       'name': 'Computer Science',
//       'teacher': 'Dr. James Anderson',
//       'code': 'CS-301',
//       'credits': 4,
//       'schedule': 'Tue, Thu - 9:00 AM',
//       'room': 'Lab 402',
//       'progress': 82.0,
//       'attendance': 90.0,
//       'assignments': 10,
//       'pendingAssignments': 3,
//       'grade': 'A',
//       'color': const Color(0xFF3B82F6),
//       'icon': Icons.computer,
//     },
//     {
//       'name': 'Chemistry',
//       'teacher': 'Dr. Lisa Martinez',
//       'code': 'CHEM-201',
//       'credits': 4,
//       'schedule': 'Mon, Wed, Fri - 11:00 AM',
//       'room': 'Lab 205',
//       'progress': 75.0,
//       'attendance': 85.0,
//       'assignments': 7,
//       'pendingAssignments': 2,
//       'grade': 'B',
//       'color': const Color(0xFFEC4899),
//       'icon': Icons.biotech,
//     },
//     {
//       'name': 'History',
//       'teacher': 'Prof. Robert Taylor',
//       'code': 'HIST-101',
//       'credits': 3,
//       'schedule': 'Tue, Thu - 2:00 PM',
//       'room': 'Room 108',
//       'progress': 88.0,
//       'attendance': 93.0,
//       'assignments': 4,
//       'pendingAssignments': 1,
//       'grade': 'A',
//       'color': const Color(0xFFF59E0B),
//       'icon': Icons.library_books,
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredSubjects = _getFilteredSubjects();
//     final stats = _calculateStats();
//
//     return Scaffold(
//       backgroundColor: AppColor.bg,
//       body: CustomScrollView(
//         slivers: [
//           // App Bar
//           SliverAppBar(
//             expandedHeight: 120,
//             floating: false,
//             pinned: true,
//             backgroundColor: AppColor.primary,
//             flexibleSpace: FlexibleSpaceBar(
//               title: AppText.customText(
//                 'My Subjects',
//                 color: Colors.white,
//                 size: 20,
//                 weight: FontWeight.w600,
//               ),
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: AppColor.primaryGradient,
//                 ),
//               ),
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.search, color: Colors.white),
//                 onPressed: () {
//                   // Search functionality
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.filter_list, color: Colors.white),
//                 onPressed: () {
//                   _showFilterDialog();
//                 },
//               ),
//             ],
//           ),
//
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const SizedBox(height: 16),
//
//                 // Overall Stats Card
//                 _buildOverallStatsCard(stats),
//
//                 const SizedBox(height: 16),
//
//                 // Quick Stats
//                 _buildQuickStats(stats),
//
//                 const SizedBox(height: 16),
//
//                 // Filter Chips
//                 _buildFilterChips(),
//
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//
//           // Subjects List
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                   if (index >= filteredSubjects.length) return null;
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: _buildSubjectCard(filteredSubjects[index]),
//                   );
//                 },
//                 childCount: filteredSubjects.length,
//               ),
//             ),
//           ),
//
//           const SliverToBoxAdapter(
//             child: SizedBox(height: 24),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOverallStatsCard(Map<String, dynamic> stats) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColor.primary, AppColor.darkBlueColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.blueShadow,
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           AppText.customText(
//             'Academic Overview',
//             color: Colors.white.withOpacity(0.9),
//             size: 14,
//             weight: FontWeight.w500,
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildOverviewItem(
//                 'Total\nSubjects',
//                 stats['total'].toString(),
//                 Icons.school,
//               ),
//               Container(
//                 height: 60,
//                 width: 1,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               _buildOverviewItem(
//                 'Avg\nGrade',
//                 stats['avgGrade'],
//                 Icons.grade,
//               ),
//               Container(
//                 height: 60,
//                 width: 1,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               _buildOverviewItem(
//                 'Total\nCredits',
//                 stats['credits'].toString(),
//                 Icons.workspace_premium,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOverviewItem(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 28),
//         const SizedBox(height: 8),
//         AppText.customText(
//           value,
//           color: Colors.white,
//           size: 24,
//           weight: FontWeight.w700,
//         ),
//         const SizedBox(height: 4),
//         AppText.customText(
//           label,
//           color: Colors.white.withOpacity(0.9),
//           size: 11,
//           weight: FontWeight.w500,
//           // textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQuickStats(Map<String, dynamic> stats) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStatCard(
//               'Avg Progress',
//               '${stats['avgProgress'].toStringAsFixed(0)}%',
//               Icons.trending_up,
//               AppColor.success,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildStatCard(
//               'Avg Attendance',
//               '${stats['avgAttendance'].toStringAsFixed(0)}%',
//               Icons.check_circle,
//               AppColor.primary,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildStatCard(
//               'Pending Tasks',
//               stats['pending'].toString(),
//               Icons.assignment_late,
//               const Color(0xFFF59E0B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       decoration: BoxDecoration(
//         color: AppColor.card,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.cardShadow,
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           AppText.customText(
//             value,
//             size: 20,
//             weight: FontWeight.w700,
//             color: AppColor.text,
//           ),
//           const SizedBox(height: 2),
//           AppText.customText(
//             label,
//             size: 10,
//             weight: FontWeight.w500,
//             color: AppColor.sub,
//             // textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterChips() {
//     return SizedBox(
//       height: 45,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         children: [
//           _buildFilterChip('All', Icons.grid_view),
//           _buildFilterChip('High Priority', Icons.priority_high),
//           _buildFilterChip('In Progress', Icons.access_time),
//           _buildFilterChip('Completed', Icons.check_circle_outline),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterChip(String label, IconData icon) {
//     final isSelected = selectedFilter == label;
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: FilterChip(
//         selected: isSelected,
//         label: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isSelected ? Colors.white : AppColor.primary,
//             ),
//             const SizedBox(width: 6),
//             AppText.customText(
//               label,
//               size: 13,
//               weight: FontWeight.w600,
//               color: isSelected ? Colors.white : AppColor.primary,
//             ),
//           ],
//         ),
//         backgroundColor: AppColor.card,
//         selectedColor: AppColor.primary,
//         checkmarkColor: Colors.white,
//         onSelected: (value) {
//           setState(() {
//             selectedFilter = label;
//           });
//         },
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: isSelected ? AppColor.primary : AppColor.border,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubjectCard(Map<String, dynamic> subject) {
//     return GestureDetector(
//       onTap: () {
//         _showSubjectDetails(subject);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColor.card,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with icon and grade
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     subject['color'],
//                     subject['color'].withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       subject['icon'],
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppText.customText(
//                           subject['name'],
//                           color: Colors.white,
//                           size: 18,
//                           weight: FontWeight.w700,
//                         ),
//                         const SizedBox(height: 4),
//                         AppText.customText(
//                           subject['code'],
//                           color: Colors.white.withOpacity(0.9),
//                           size: 12,
//                           weight: FontWeight.w500,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: AppText.customText(
//                       subject['grade'],
//                       color: subject['color'],
//                       size: 18,
//                       weight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Body content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Teacher and credits
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.person,
//                         size: 16,
//                         color: AppColor.sub,
//                       ),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: AppText.customText(
//                           subject['teacher'],
//                           size: 13,
//                           weight: FontWeight.w600,
//                           color: AppColor.text,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: subject['color'].withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: AppText.customText(
//                           '${subject['credits']} Credits',
//                           size: 11,
//                           weight: FontWeight.w600,
//                           color: subject['color'],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.schedule,
//                         size: 16,
//                         color: AppColor.sub,
//                       ),
//                       const SizedBox(width: 6),
//                       AppText.customText(
//                         subject['schedule'],
//                         size: 12,
//                         weight: FontWeight.w500,
//                         color: AppColor.sub,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//
//                   // Room
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: AppColor.sub,
//                       ),
//                       const SizedBox(width: 6),
//                       AppText.customText(
//                         subject['room'],
//                         size: 12,
//                         weight: FontWeight.w500,
//                         color: AppColor.sub,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Progress bar
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText.customText(
//                             'Course Progress',
//                             size: 12,
//                             weight: FontWeight.w600,
//                             color: AppColor.text,
//                           ),
//                           AppText.customText(
//                             '${subject['progress'].toStringAsFixed(0)}%',
//                             size: 12,
//                             weight: FontWeight.w700,
//                             color: subject['color'],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: LinearProgressIndicator(
//                           value: subject['progress'] / 100,
//                           backgroundColor: AppColor.border,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             subject['color'],
//                           ),
//                           minHeight: 8,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Stats row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildSubjectStat(
//                           Icons.assignment,
//                           '${subject['assignments']} Tasks',
//                           AppColor.primary,
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildSubjectStat(
//                           Icons.pending_actions,
//                           '${subject['pendingAssignments']} Pending',
//                           const Color(0xFFF59E0B),
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildSubjectStat(
//                           Icons.check_circle,
//                           '${subject['attendance'].toStringAsFixed(0)}% Attend',
//                           AppColor.success,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubjectStat(IconData icon, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 4),
//           Flexible(
//             child: AppText.customText(
//               label,
//               size: 10,
//               weight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Map<String, dynamic>> _getFilteredSubjects() {
//     if (selectedFilter == 'All') {
//       return subjects;
//     } else if (selectedFilter == 'High Priority') {
//       return subjects.where((s) => s['pendingAssignments'] > 1).toList();
//     } else if (selectedFilter == 'In Progress') {
//       return subjects.where((s) => s['progress'] < 90).toList();
//     } else if (selectedFilter == 'Completed') {
//       return subjects.where((s) => s['progress'] >= 90).toList();
//     }
//     return subjects;
//   }
//
//   Map<String, dynamic> _calculateStats() {
//     final total = subjects.length;
//     final credits = subjects.fold(0, (sum, s) => sum + (s['credits'] as int));
//     final avgProgress = subjects.fold(0.0, (sum, s) => sum + s['progress']) / total;
//     final avgAttendance = subjects.fold(0.0, (sum, s) => sum + s['attendance']) / total;
//     final pending = subjects.fold(0, (sum, s) => sum + (s['pendingAssignments'] as int));
//
//     // Calculate average grade
//     final gradePoints = {
//       'A+': 4.0, 'A': 4.0, 'A-': 3.7,
//       'B+': 3.3, 'B': 3.0, 'B-': 2.7,
//       'C+': 2.3, 'C': 2.0, 'C-': 1.7,
//       'D': 1.0, 'F': 0.0,
//     };
//
//     final avgGPA = subjects.fold(0.0, (sum, s) => sum + (gradePoints[s['grade']] ?? 0.0)) / total;
//     String avgGrade = 'A';
//     if (avgGPA >= 3.7) avgGrade = 'A';
//     else if (avgGPA >= 3.3) avgGrade = 'A-';
//     else if (avgGPA >= 3.0) avgGrade = 'B+';
//     else if (avgGPA >= 2.7) avgGrade = 'B';
//     else avgGrade = 'B-';
//
//     return {
//       'total': total,
//       'credits': credits,
//       'avgProgress': avgProgress,
//       'avgAttendance': avgAttendance,
//       'pending': pending,
//       'avgGrade': avgGrade,
//     };
//   }
//
//   void _showSubjectDetails(Map<String, dynamic> subject) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.75,
//         decoration: const BoxDecoration(
//           color: AppColor.card,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColor.border,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       subject['color'],
//                       subject['color'].withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Icon(
//                         subject['icon'],
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText.customText(
//                             subject['name'],
//                             color: Colors.white,
//                             size: 20,
//                             weight: FontWeight.w700,
//                           ),
//                           const SizedBox(height: 4),
//                           AppText.customText(
//                             subject['teacher'],
//                             color: Colors.white.withOpacity(0.9),
//                             size: 14,
//                             weight: FontWeight.w500,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Details
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDetailRow('Subject Code', subject['code']),
//                       _buildDetailRow('Credits', '${subject['credits']}'),
//                       _buildDetailRow('Schedule', subject['schedule']),
//                       _buildDetailRow('Room', subject['room']),
//                       _buildDetailRow('Current Grade', subject['grade']),
//                       _buildDetailRow('Attendance', '${subject['attendance'].toStringAsFixed(0)}%'),
//                       _buildDetailRow('Course Progress', '${subject['progress'].toStringAsFixed(0)}%'),
//                       _buildDetailRow('Total Assignments', '${subject['assignments']}'),
//                       _buildDetailRow('Pending Assignments', '${subject['pendingAssignments']}'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Action buttons
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: subject['color'],
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: AppText.customText(
//                           'View Details',
//                           size: 15,
//                           weight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           AppText.customText(
//             label,
//             size: 14,
//             weight: FontWeight.w500,
//             color: AppColor.sub,
//           ),
//           AppText.customText(
//             value,
//             size: 14,
//             weight: FontWeight.w600,
//             color: AppColor.text,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: AppText.customText(
//           'Filter Subjects',
//           size: 18,
//           weight: FontWeight.w600,
//           color: AppColor.text,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildFilterOption('All Subjects', selectedFilter == 'All'),
//             _buildFilterOption('High Priority', selectedFilter == 'High Priority'),
//             _buildFilterOption('In Progress', selectedFilter == 'In Progress'),
//             _buildFilterOption('Completed', selectedFilter == 'Completed'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: AppText.customText(
//               'Cancel',
//               size: 14,
//               weight: FontWeight.w600,
//               color: AppColor.sub,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: AppText.customText(
//               'Apply',
//               size: 14,
//               weight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterOption(String title, bool selected) {
//     return ListTile(
//       title: AppText.customText(
//         title,
//         size: 14,
//         weight: FontWeight.w500,
//         color: AppColor.text,
//       ),
//       leading: Radio<bool>(
//         value: selected,
//         groupValue: true,
//         onChanged: (value) {
//           setState(() {
//             if (title == 'All Subjects') selectedFilter = 'All';
//             else selectedFilter = title;
//           });
//           Navigator.pop(context);
//         },
//         activeColor: AppColor.primary,
//       ),
//     );
//   }
// }