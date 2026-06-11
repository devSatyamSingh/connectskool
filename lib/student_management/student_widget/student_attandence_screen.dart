// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/view_model/student_view_model/student_attendance_view_model.dart';
// import '../../res/app_color.dart';
// import '../../res/const_text.dart';
//
// class StudentAttendanceScreen extends StatefulWidget {
//   const StudentAttendanceScreen({super.key});
//
//   @override
//   State<StudentAttendanceScreen> createState() =>
//       _StudentAttendanceScreenState();
// }
//
// class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
//   DateTime _selectedDate = DateTime.now();
//   DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
//   String _statusFilter = 'All';
//   final String _searchQuery = '';
//   String? _selectedMonth; // null = All months
//   final TextEditingController _searchController = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StudentAttendanceViewModel>(context, listen: false,).studentAttendanceApi(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   String _statusText(String? s) {
//     switch (s) {
//       case 'P': return 'Present';
//       case 'A': return 'Absent';
//       case 'L': return 'Leave';
//       case 'H': return 'Half Day';
//       default:  return 'Unknown';
//     }
//   }
//
//   Color _statusColor(String? s) {
//     switch (s) {
//       case 'P': return const Color(0xFF22C55E);
//       case 'A': return const Color(0xFFEF4444);
//       case 'L': return const Color(0xFFF97316);
//       case 'H': return const Color(0xFF8B5CF6);
//       default:  return Colors.grey;
//     }
//   }
//
//   IconData _statusIcon(String? s) {
//     switch (s) {
//       case 'P': return Icons.check_circle_rounded;
//       case 'A': return Icons.cancel_rounded;
//       case 'L': return Icons.event_busy_rounded;
//       case 'H': return Icons.timelapse_rounded;
//       default:  return Icons.help_outline_rounded;
//     }
//   }
//
//   void _prevMonth() => setState(() {
//     _calendarMonth =
//         DateTime(_calendarMonth.year, _calendarMonth.month - 1);
//   });
//
//   void _nextMonth() => setState(() {
//     _calendarMonth =
//         DateTime(_calendarMonth.year, _calendarMonth.month + 1);
//   });
//
//   /// Returns all day cells (null = empty padding) for the month grid
//   List<DateTime?> _buildCalendarDays() {
//     final first = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
//     final daysInMonth =
//     DateUtils.getDaysInMonth(_calendarMonth.year, _calendarMonth.month);
//     final startWeekday = first.weekday % 7; // Sun=0
//     final cells = <DateTime?>[];
//     for (int i = 0; i < startWeekday; i++) {
//       cells.add(null);
//     }
//     for (int d = 1; d <= daysInMonth; d++) {
//       cells.add(DateTime(_calendarMonth.year, _calendarMonth.month, d));
//     }
//     return cells;
//   }
//
//   bool _isToday(DateTime? d) {
//     if (d == null) return false;
//     final now = DateTime.now();
//     return d.year == now.year && d.month == now.month && d.day == now.day;
//   }
//
//   bool _isSelected(DateTime? d) {
//     if (d == null) return false;
//     return d.year == _selectedDate.year &&
//         d.month == _selectedDate.month &&
//         d.day == _selectedDate.day;
//   }
//
//   // ── Dot colour for a day based on attendance data ───────────────
//   Color? _dotColor(DateTime? d, List dataList) {
//     if (d == null) return null;
//     final match = dataList.where((e) {
//       if (e.attendanceDate == null) return false;
//       try {
//         final parsed = DateTime.parse(e.attendanceDate!);
//         return parsed.year == d.year &&
//             parsed.month == d.month &&
//             parsed.day == d.day;
//       } catch (_) {
//         return false;
//       }
//     }).toList();
//     if (match.isEmpty) return null;
//     return _statusColor(match.first.status);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: Consumer<StudentAttendanceViewModel>(
//               builder: (context, vm, _) {
//                 if (vm.loading) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                             color: AppColor.lightBlueColor),
//                         const SizedBox(height: 14),
//                         AppText.customText('Loading attendance...',
//                             size: 13, color: AppColor.softGreyText),
//                       ],
//                     ),
//                   );
//                 }
//                 final dataList = vm.studentAttendanceModel?.data ?? [];
//
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSummaryStats(dataList),
//                       const SizedBox(height: 16),
//
//                       // ── Calendar ──
//                       _buildCalendar(dataList),
//                       const SizedBox(height: 16),
//
//                       // ── Detailed Logs ──
//                       _buildDetailedLogs(dataList),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 52, 20, 20),
//       decoration: BoxDecoration(
//         gradient: AppColor.primaryGradient,
//         borderRadius:
//         const BorderRadius.vertical(bottom: Radius.circular(30)),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.blueShadow,
//               blurRadius: 20,
//               offset: const Offset(0, 10)),
//         ],
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.15),
//                 shape: BoxShape.circle,
//                 border:
//                 Border.all(color: Colors.white.withValues(alpha: 0.25)),
//               ),
//               child: const Icon(Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white, size: 18),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText.customText('Attendance Overview',
//                     size: 18,
//                     weight: FontWeight.bold,
//                     color: Colors.white),
//                 AppText.customText('Track your presence, absences and leaves',
//                     size: 12, color: Colors.white60),
//               ],
//             ),
//           ),
//           // Export button
//           // Container(
//           //   padding:
//           //   const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           //   decoration: BoxDecoration(
//           //     color: Colors.white,
//           //     borderRadius: BorderRadius.circular(20),
//           //   ),
//           //   child: Row(
//           //     mainAxisSize: MainAxisSize.min,
//           //     children: [
//           //       Icon(Icons.download_rounded,
//           //           size: 14, color: AppColor.lightBlueColor),
//           //       const SizedBox(width: 6),
//           //       Text('Export',
//           //           style: TextStyle(
//           //               fontSize: 12,
//           //               fontWeight: FontWeight.w600,
//           //               color: AppColor.lightBlueColor)),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   // ── SUMMARY STATS ────────────────────────────────────────────────
//   Widget _buildSummaryStats(List dataList) {
//     final total = dataList.length;
//     final presentCount = dataList.where((e) => e.status == 'P').length;
//     final absentCount  = dataList.where((e) => e.status == 'A').length;
//     final leaveCount   = dataList.where((e) => e.status == 'L').length;
//     final rate = total > 0
//         ? (presentCount / total * 100).toStringAsFixed(1)
//         : '0.0';
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Attendance Rate Banner
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: AppColor.primaryGradient,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                   color: AppColor.lightBlueColor.withValues(alpha: 0.3),
//                   blurRadius: 16,
//                   offset: const Offset(0, 6)),
//             ],
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText.customText('Attendance Rate',
//                         size: 12, color: Colors.white70),
//                     const SizedBox(height: 4),
//                     AppText.customText('$rate%',
//                         size: 32,
//                         weight: FontWeight.bold,
//                         color: Colors.white),
//                     const SizedBox(height: 4),
//                     AppText.customText('$total students total',
//                         size: 12, color: Colors.white70),
//                   ],
//                 ),
//               ),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   SizedBox(
//                     width: 72,
//                     height: 72,
//                     child: CircularProgressIndicator(
//                       value: total > 0 ? presentCount / total : 0,
//                       backgroundColor: Colors.white.withValues(alpha: 0.2),
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                           Colors.white),
//                       strokeWidth: 6,
//                     ),
//                   ),
//                   const Icon(Icons.people_rounded,
//                       color: Colors.white, size: 28),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         // 4 summary cards
//         Row(
//           children: [
//             _summaryCard('Present', presentCount.toString(), 'P'),
//             const SizedBox(width: 8),
//             _summaryCard('Absent', absentCount.toString(), 'A'),
//             const SizedBox(width: 8),
//             _summaryCard('Leave', leaveCount.toString(), 'L'),
//             // const SizedBox(width: 8),
//             // _summaryCard('Half', halfCount.toString(), 'H'),
//           ],
//         ),
//
//         const SizedBox(height: 16),
//
//         // Legend
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText.customText('Legend',
//                   size: 12,
//                   weight: FontWeight.bold,
//                   color: AppColor.softGreyText),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   _legendItem('Present', const Color(0xFF22C55E),
//                       ''),
//                   _legendItem(
//                       'Absent', const Color(0xFFEF4444), ''),
//                   _legendItem(
//                       'Leave', const Color(0xFFF97316), ''),
//                   _legendItem('Today', AppColor.lightBlueColor,
//                       ''),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _legendItem(String label, Color color, String desc) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                   width: 8,
//                   height: 8,
//                   decoration:
//                   BoxDecoration(color: color, shape: BoxShape.circle)),
//               const SizedBox(width: 4),
//               Text(label,
//                   style: const TextStyle(
//                       fontSize: 11, fontWeight: FontWeight.w600)),
//             ],
//           ),
//           // const SizedBox(height: 2),
//           // Text(desc,
//           //     style: TextStyle(
//           //         fontSize: 10, color: Colors.grey.shade500)),
//         ],
//       ),
//     );
//   }
//
//   // ── CALENDAR ─────────────────────────────────────────────────────
//   Widget _buildCalendar(List dataList) {
//     final days = _buildCalendarDays();
//     final monthLabel =
//     DateFormat('MMMM yyyy').format(_calendarMonth);
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha: 0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Month header
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText.customText(monthLabel,
//                         size: 16,
//                         weight: FontWeight.bold,
//                         color: const Color(0xFF1E293B)),
//                     AppText.customText('Monthly view',
//                         size: 11, color: AppColor.softGreyText),
//                   ],
//                 ),
//               ),
//               _navBtn(Icons.chevron_left_rounded, _prevMonth),
//               const SizedBox(width: 6),
//               _navBtn(Icons.chevron_right_rounded, _nextMonth),
//             ],
//           ),
//           const SizedBox(height: 14),
//
//           // Day names
//           Row(
//             children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
//                 .map((d) => Expanded(
//               child: Center(
//                 child: Text(d,
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey.shade400)),
//               ),
//             ))
//                 .toList(),
//           ),
//           const SizedBox(height: 6),
//
//           // Day grid
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 7,
//               childAspectRatio: 1,
//             ),
//             itemCount: days.length,
//             itemBuilder: (context, i) {
//               final d = days[i];
//               if (d == null) return const SizedBox();
//               final isToday = _isToday(d);
//               final isSel = _isSelected(d);
//               final dot = _dotColor(d, dataList);
//
//               return GestureDetector(
//                 onTap: () {
//                   setState(() => _selectedDate = d);
//                   Provider.of<StudentAttendanceViewModel>(context,
//                       listen: false)
//                       .studentAttendanceApi(context);
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: isToday
//                             ? AppColor.lightBlueColor
//                             : isSel
//                             ? AppColor.lightBlueColor
//                             .withValues(alpha: 0.15)
//                             : Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${d.day}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: isToday || isSel
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                             color: isToday
//                                 ? Colors.white
//                                 : isSel
//                                 ? AppColor.lightBlueColor
//                                 : const Color(0xFF334155),
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (dot != null)
//                       Container(
//                         margin: const EdgeInsets.only(top: 2),
//                         width: 5,
//                         height: 5,
//                         decoration: BoxDecoration(
//                             color: dot, shape: BoxShape.circle),
//                       )
//                     else
//                       const SizedBox(height: 7),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _navBtn(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: const Color(0xFFF1F5F9),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
//         ),
//         child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
//       ),
//     );
//   }
//
//   // ── DETAILED LOGS ─────────────────────────────────────────────────
//   Widget _buildDetailedLogs(List dataList) {
//     // Apply filters
//     var filtered = dataList.where((e) {
//       final matchStatus = _statusFilter == 'All' ||
//           (_statusFilter == 'Present' && e.status == 'P') ||
//           (_statusFilter == 'Absent'  && e.status == 'A') ||
//           (_statusFilter == 'Leave'   && e.status == 'L');
//           // ||
//           // (_statusFilter == 'Half Day' && e.status == 'H');
//
//       final q = _searchQuery.toLowerCase();
//       final matchSearch = q.isEmpty ||
//           (e.attendanceDate ?? '').toLowerCase().contains(q) ||
//           (e.remarks ?? '').toLowerCase().contains(q) ||
//           _statusText(e.status).toLowerCase().contains(q);
//
//       bool matchMonth = true;
//       if (_selectedMonth != null && e.attendanceDate != null) {
//         try {
//           final parsed = DateTime.parse(e.attendanceDate!).toLocal();
//           final key = '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}';
//           matchMonth = key == _selectedMonth;
//         } catch (_) {
//           matchMonth = false;
//         }
//       }
//
//       return matchStatus && matchSearch && matchMonth;
//     }).toList();
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha: 0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header row
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText.customText('Detailed Logs',
//                         size: 15,
//                         weight: FontWeight.bold,
//                         color: const Color(0xFF1E293B)),
//                     // AppText.customText('\${filtered.length} records found',
//                     //     size: 11, color: AppColor.softGreyText),
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // Search + Status + Month row
//           Row(
//             children: [
//               // Search bar
//               // Expanded(
//               //   child: Container(
//               //     height: 40,
//               //     decoration: BoxDecoration(
//               //       color: const Color(0xFFF8FAFC),
//               //       borderRadius: BorderRadius.circular(12),
//               //       border: Border.all(color: Colors.grey.withOpacity(0.15)),
//               //     ),
//               //     child: TextField(
//               //       controller: _searchController,
//               //       onChanged: (v) => setState(() => _searchQuery = v),
//               //       style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
//               //       decoration: InputDecoration(
//               //         hintText: 'Search date, day, remarks...',
//               //         hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
//               //         prefixIcon: Icon(Icons.search_rounded, size: 18, color: Colors.grey.shade400),
//               //         border: InputBorder.none,
//               //         contentPadding: const EdgeInsets.symmetric(vertical: 10),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(width: 8),
//
//               // Status dropdown
//               _buildStatusDropdown(),
//               const SizedBox(width: 8),
//
//               // Month dropdown
//               _buildMonthDropdown(dataList),
//             ],
//           ),
//           const SizedBox(height: 14),
//
//           if (filtered.isEmpty)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 32),
//                 child: Column(
//                   children: [
//                     Icon(Icons.event_busy_rounded,
//                         size: 40,
//                         color: AppColor.lightBlueColor.withValues(alpha: 0.3)),
//                     const SizedBox(height: 10),
//                     AppText.customText('No records found',
//                         size: 14,
//                         weight: FontWeight.bold,
//                         color: const Color(0xFF1E293B)),
//                     AppText.customText('Try changing filters',
//                         size: 12, color: AppColor.softGreyText),
//                   ],
//                 ),
//               ),
//             )
//           else
//           // Table header
//             Column(
//               children: [
//                 // Column headers
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8FAFC),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 3,
//                           child: _tableHeader('DATE')),
//                       Expanded(
//                           flex: 2,
//                           child: _tableHeader('DAY')),
//                       Expanded(
//                           flex: 2,
//                           child: _tableHeader('STATUS')),
//                       Expanded(
//                           flex: 3,
//                           child: _tableHeader('REMARKS')),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//
//                 // Rows
//                 ...filtered.map((e) {
//                   final color = _statusColor(e.status);
//                   final statusText = _statusText(e.status);
//                   String dayName = '';
//                   String formattedDate = e.attendanceDate ?? '';
//                   try {
//                     final parsed = DateTime.parse(e.attendanceDate ?? '').toLocal();
//                     dayName = DateFormat('EEEE').format(parsed);
//                     formattedDate = DateFormat('MMM dd, yyyy').format(parsed);
//                   } catch (_) {}
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 6),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                           color: Colors.grey.withValues(alpha: 0.1)),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.02),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2)),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Text(formattedDate,
//                               style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1E293B))),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(dayName,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade500)),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: color.withValues(alpha: 0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                   color: color.withValues(alpha: 0.2)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // Container(
//                                 //   width: 6,
//                                 //   height: 6,
//                                 //   decoration: BoxDecoration(
//                                 //       color: color,
//                                 //       shape: BoxShape.circle),
//                                 // ),
//                                 // const SizedBox(width: 4),
//                                 Text(statusText,
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         fontWeight: FontWeight.w600,
//                                         color: color)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               if (e.remarks != null &&
//                                   e.remarks!.isNotEmpty)
//                                 Icon(Icons.access_time_rounded,
//                                     size: 12,
//                                     color: Colors.grey.shade400),
//                               if (e.remarks != null &&
//                                   e.remarks!.isNotEmpty)
//                                 const SizedBox(width: 4),
//                               Flexible(
//                                 child: Text(
//                                   e.remarks != null &&
//                                       e.remarks!.isNotEmpty
//                                       ? e.remarks!
//                                       : '—',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _tableHeader(String text) => Text(text,
//       style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//           color: Colors.grey.shade500,
//           letterSpacing: 0.5));
//
//   // ── SUMMARY CARD ─────────────────────────────────────────────────
//   Widget _summaryCard(String title, String count, String statusKey) {
//     final color = _statusColor(statusKey);
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withValues(alpha: 0.2)),
//           boxShadow: [
//             BoxShadow(
//                 color: color.withValues(alpha: 0.08),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
//               child: Icon(_statusIcon(statusKey), color: color, size: 14),
//             ),
//             const SizedBox(height: 6),
//             Text(count,
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: color)),
//             const SizedBox(height: 2),
//             Text(title,
//                 style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: color.withValues(alpha: 0.8))),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── STATUS DROPDOWN ──────────────────────────────────────────────
//   Widget _buildStatusDropdown() {
//     final options = <String?>['All', 'Present', 'Absent', 'Leave'];
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: _statusFilter,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               size: 18, color: Color(0xFF64748B)),
//           style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF334155)),
//           items: options
//               .map((o) => DropdownMenuItem<String>(
//             value: o!,
//             child: Row(
//               children: [
//                 if (o != 'All') ...[
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: BoxDecoration(
//                       color: _statusColor(
//                           o == 'Present' ? 'P' :
//                           o == 'Absent'  ? 'A' :
//                           o == 'Leave'   ? 'L' : 'H'),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                 ],
//                 Text(o),
//               ],
//             ),
//           ))
//               .toList(),
//           onChanged: (val) => setState(() => _statusFilter = val ?? 'All'),
//         ),
//       ),
//     );
//   }
//
//   // ── MONTH DROPDOWN ───────────────────────────────────────────────
//   Widget _buildMonthDropdown(List dataList) {
//     // Always show all 12 months for current year
//     final currentYear = DateTime.now().year;
//     final monthNames = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December',
//     ];
//     // months as "2026-01", "2026-02" ... "2026-12"
//     final allMonths = List.generate(12, (i) {
//       final m = (i + 1).toString().padLeft(2, '0');
//       return '$currentYear-$m';
//     });
//
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String?>(
//           value: _selectedMonth,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               size: 18, color: Color(0xFF64748B)),
//           style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF334155)),
//           items: [
//             const DropdownMenuItem<String?>(
//               value: null,
//               child: Text('All Months'),
//             ),
//             ...List.generate(12, (i) => DropdownMenuItem<String?>(
//               value: allMonths[i],
//               child: Text(monthNames[i]),
//             )),
//           ],
//           onChanged: (val) => setState(() => _selectedMonth = val),
//         ),
//       ),
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/student_view_model/student_attendance_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String _statusFilter = 'All';
  final String _searchQuery = '';
  String? _selectedMonth;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentAttendanceViewModel>(context, listen: false)
          .studentAttendanceApi(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _statusText(String? s) {
    switch (s) {
      case 'P': return 'Present';
      case 'A': return 'Absent';
      case 'L': return 'Leave';
      case 'H': return 'Half Day';
      default:  return 'Unknown';
    }
  }

  Color _statusColor(String? s) {
    switch (s) {
      case 'P': return const Color(0xFF22C55E);
      case 'A': return const Color(0xFFEF4444);
      case 'L': return const Color(0xFFF97316);
      case 'H': return const Color(0xFF8B5CF6);
      default:  return Colors.grey;
    }
  }

  IconData _statusIcon(String? s) {
    switch (s) {
      case 'P': return Icons.check_circle_rounded;
      case 'A': return Icons.cancel_rounded;
      case 'L': return Icons.event_busy_rounded;
      case 'H': return Icons.timelapse_rounded;
      default:  return Icons.help_outline_rounded;
    }
  }

  void _prevMonth() => setState(() {
    _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1);
  });

  void _nextMonth() => setState(() {
    _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1);
  });

  List<DateTime?> _buildCalendarDays() {
    final first = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    final daysInMonth =
    DateUtils.getDaysInMonth(_calendarMonth.year, _calendarMonth.month);
    final startWeekday = first.weekday % 7;
    final cells = <DateTime?>[];
    for (int i = 0; i < startWeekday; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_calendarMonth.year, _calendarMonth.month, d));
    }
    return cells;
  }

  bool _isToday(DateTime? d) {
    if (d == null) return false;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isSelected(DateTime? d) {
    if (d == null) return false;
    return d.year == _selectedDate.year &&
        d.month == _selectedDate.month &&
        d.day == _selectedDate.day;
  }

  Color? _dotColor(DateTime? d, List dataList) {
    if (d == null) return null;
    final match = dataList.where((e) {
      if (e.attendanceDate == null) return false;
      try {
        final parsed = DateTime.parse(e.attendanceDate!);
        return parsed.year == d.year &&
            parsed.month == d.month &&
            parsed.day == d.day;
      } catch (_) { return false; }
    }).toList();
    if (match.isEmpty) return null;
    return _statusColor(match.first.status);
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF1F5F9),
  //     body: Column(
  //       children: [
  //         _buildHeader(),
  //         Expanded(
  //           child: Consumer<StudentAttendanceViewModel>(
  //             builder: (context, vm, _) {
  //               if (vm.loading) {
  //                 return Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CircularProgressIndicator(color: AppColor.lightBlueColor),
  //                       const SizedBox(height: 14),
  //                       AppText.customText('Loading attendance...',
  //                           size: 13, color: AppColor.softGreyText),
  //                     ],
  //                   ),
  //                 );
  //               }
  //               final dataList = vm.studentAttendanceModel?.data ?? [];
  //
  //               return SingleChildScrollView(
  //                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     _buildSummaryStats(dataList),
  //                     const SizedBox(height: 16),
  //                     _buildCalendar(dataList),
  //                     const SizedBox(height: 16),
  //                     _buildDetailedLogs(dataList),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Consumer<StudentAttendanceViewModel>(
        builder: (context, vm, _) {
          // ✅ Student name pehle record se lo
          final dataList = vm.studentAttendanceModel?.data ?? [];
          final studentName = dataList.isNotEmpty
              ? (dataList.first.studentName ?? 'Student')
              : 'Student';

          return Column(
            children: [
              _buildHeader(studentName), // ✅ name pass karo
              Expanded(
                child: vm.loading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                          color: AppColor.lightBlueColor),
                      const SizedBox(height: 14),
                      AppText.customText('Loading attendance...',
                          size: 13,
                          color: AppColor.softGreyText),
                    ],
                  ),
                )
                    : SingleChildScrollView(
                  padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryStats(dataList),
                      const SizedBox(height: 16),
                      _buildCalendar(dataList),
                      const SizedBox(height: 16),
                      _buildDetailedLogs(dataList),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  // ── HEADER ───────────────────────────────────────────────────────
  Widget _buildHeader(String studentName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 20),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: AppColor.blueShadow,
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText('Attendance Overview',
                    size: 18, weight: FontWeight.bold, color: Colors.white),
                AppText.customText(
                    'Track your presence, absences and leaves',
                    size: 12, color: Colors.white60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SUMMARY STATS ────────────────────────────────────────────────
  Widget _buildSummaryStats(List dataList) {
    final total        = dataList.length;
    final presentCount = dataList.where((e) => e.status == 'P').length;
    final absentCount  = dataList.where((e) => e.status == 'A').length;
    final leaveCount   = dataList.where((e) => e.status == 'L').length;
    final rate = total > 0
        ? (presentCount / total * 100).toStringAsFixed(1)
        : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attendance Rate Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColor.lightBlueColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText('Attendance Rate',
                        size: 12, color: Colors.white70),
                    const SizedBox(height: 4),
                    AppText.customText('$rate%',
                        size: 32,
                        weight: FontWeight.bold,
                        color: Colors.white),
                    const SizedBox(height: 4),
                    AppText.customText('$total records total',
                        size: 12, color: Colors.white70),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: total > 0 ? presentCount / total : 0,
                      backgroundColor:
                      Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white),
                      strokeWidth: 6,
                    ),
                  ),
                  const Icon(Icons.people_rounded,
                      color: Colors.white, size: 28),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 3 summary cards
        Row(
          children: [
            _summaryCard('Present', presentCount.toString(), 'P'),
            const SizedBox(width: 8),
            _summaryCard('Absent', absentCount.toString(), 'A'),
            const SizedBox(width: 8),
            _summaryCard('Leave', leaveCount.toString(), 'L'),
          ],
        ),

        const SizedBox(height: 16),

        // ✅ Fixed Legend — code + full form
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
            Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.customText('Legend',
                  size: 12,
                  weight: FontWeight.bold,
                  color: AppColor.softGreyText),
              const SizedBox(height: 10),
              Row(
                children: [
                  _legendItem('P', 'Present',  const Color(0xFF22C55E)),
                  _legendItem('A', 'Absent',   const Color(0xFFEF4444)),
                  _legendItem('L', 'Leave',    const Color(0xFFF97316)),
                  _legendItem('H', 'Half Day', const Color(0xFF8B5CF6)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Fixed legend item — code circle + full name
  Widget _legendItem(String code, String label, Color color) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── CALENDAR ─────────────────────────────────────────────────────
  Widget _buildCalendar(List dataList) {
    final days = _buildCalendarDays();
    final monthLabel = DateFormat('MMMM yyyy').format(_calendarMonth);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(monthLabel,
                        size: 16,
                        weight: FontWeight.bold,
                        color: const Color(0xFF1E293B)),
                    AppText.customText('Monthly view',
                        size: 11, color: AppColor.softGreyText),
                  ],
                ),
              ),
              _navBtn(Icons.chevron_left_rounded, _prevMonth),
              const SizedBox(width: 6),
              _navBtn(Icons.chevron_right_rounded, _nextMonth),
            ],
          ),
          const SizedBox(height: 14),

          // Day names
          Row(
            children:
            ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                .map((d) => Expanded(
              child: Center(
                child: Text(d,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400)),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 6),

          // Day grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, i) {
              final d = days[i];
              if (d == null) return const SizedBox();
              final isToday = _isToday(d);
              final isSel   = _isSelected(d);
              final dot     = _dotColor(d, dataList);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = d);
                  Provider.of<StudentAttendanceViewModel>(context,
                      listen: false)
                      .studentAttendanceApi(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColor.lightBlueColor
                            : isSel
                            ? AppColor.lightBlueColor
                            .withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday || isSel
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isToday
                                ? Colors.white
                                : isSel
                                ? AppColor.lightBlueColor
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    if (dot != null)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 5,
                        height: 5,
                        decoration:
                        BoxDecoration(color: dot, shape: BoxShape.circle),
                      )
                    else
                      const SizedBox(height: 7),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
      ),
    );
  }

  // ── DETAILED LOGS ─────────────────────────────────────────────────
  Widget _buildDetailedLogs(List dataList) {
    var filtered = dataList.where((e) {
      final matchStatus = _statusFilter == 'All' ||
          (_statusFilter == 'Present' && e.status == 'P') ||
          (_statusFilter == 'Absent'  && e.status == 'A') ||
          (_statusFilter == 'Leave'   && e.status == 'L');

      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          (e.attendanceDate ?? '').toLowerCase().contains(q) ||
          (e.remarks ?? '').toLowerCase().contains(q) ||
          _statusText(e.status).toLowerCase().contains(q);

      bool matchMonth = true;
      if (_selectedMonth != null && e.attendanceDate != null) {
        try {
          final parsed = DateTime.parse(e.attendanceDate!).toLocal();
          final key =
              '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}';
          matchMonth = key == _selectedMonth;
        } catch (_) {
          matchMonth = false;
        }
      }

      return matchStatus && matchSearch && matchMonth;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          AppText.customText('Detailed Logs',
              size: 15,
              weight: FontWeight.bold,
              color: const Color(0xFF1E293B)),

          const SizedBox(height: 12),

          // Filters row
          Row(
            children: [
              _buildStatusDropdown(),
              const SizedBox(width: 8),
              _buildMonthDropdown(dataList),
            ],
          ),
          const SizedBox(height: 14),

          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.event_busy_rounded,
                        size: 40,
                        color: AppColor.lightBlueColor
                            .withValues(alpha: 0.3)),
                    const SizedBox(height: 10),
                    AppText.customText('No records found',
                        size: 14,
                        weight: FontWeight.bold,
                        color: const Color(0xFF1E293B)),
                    AppText.customText('Try changing filters',
                        size: 12, color: AppColor.softGreyText),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _tableHeader('DATE')),
                      Expanded(flex: 2, child: _tableHeader('DAY')),
                      Expanded(flex: 2, child: _tableHeader('STATUS')),
                      Expanded(flex: 3, child: _tableHeader('REMARKS')),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Rows
                ...filtered.map((e) {
                  final color      = _statusColor(e.status);
                  String dayName   = '';
                  String formatted = e.attendanceDate ?? '';
                  try {
                    final parsed =
                    DateTime.parse(e.attendanceDate ?? '').toLocal();
                    dayName   = DateFormat('EEEE').format(parsed);
                    formatted = DateFormat('MMM dd, yyyy').format(parsed);
                  } catch (_) {}

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Date
                        Expanded(
                          flex: 3,
                          child: Text(formatted,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B))),
                        ),

                        // Day
                        Expanded(
                          flex: 2,
                          child: Text(dayName,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500)),
                        ),

                        // ✅ Status — code + full form, no overflow
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: color.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 4),
                                // ✅ Short code — no overflow
                                Text(
                                  e.status ?? '?',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: color),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Remarks
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              if (e.remarks != null &&
                                  e.remarks!.isNotEmpty) ...[
                                Icon(Icons.notes_rounded,
                                    size: 12,
                                    color: Colors.grey.shade400),
                                const SizedBox(width: 4),
                              ],
                              Flexible(
                                child: Text(
                                  (e.remarks != null &&
                                      e.remarks!.isNotEmpty)
                                      ? e.remarks!
                                      : '—',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) => Text(text,
      style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          letterSpacing: 0.5));

  // ── SUMMARY CARD ─────────────────────────────────────────────────
  Widget _summaryCard(String title, String count, String statusKey) {
    final color = _statusColor(statusKey);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle),
              child: Icon(_statusIcon(statusKey), color: color, size: 14),
            ),
            const SizedBox(height: 6),
            Text(count,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(title,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: color.withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }

  // ── STATUS DROPDOWN ──────────────────────────────────────────────
  Widget _buildStatusDropdown() {
    final options = ['All', 'Present', 'Absent', 'Leave'];
    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _statusFilter,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Color(0xFF64748B)),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155)),
            items: options
                .map((o) => DropdownMenuItem<String>(
              value: o,
              child: Row(
                children: [
                  if (o != 'All') ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _statusColor(
                            o == 'Present' ? 'P' :
                            o == 'Absent'  ? 'A' :
                            o == 'Leave'   ? 'L' : 'H'),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(o),
                ],
              ),
            ))
                .toList(),
            onChanged: (val) =>
                setState(() => _statusFilter = val ?? 'All'),
          ),
        ),
      ),
    );
  }

  // ── MONTH DROPDOWN ───────────────────────────────────────────────
  Widget _buildMonthDropdown(List dataList) {
    final currentYear = DateTime.now().year;
    final monthNames = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    final allMonths = List.generate(12, (i) {
      final m = (i + 1).toString().padLeft(2, '0');
      return '$currentYear-$m';
    });

    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _selectedMonth,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Color(0xFF64748B)),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155)),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All Months'),
              ),
              ...List.generate(
                12,
                    (i) => DropdownMenuItem<String?>(
                  value: allMonths[i],
                  child: Text(monthNames[i]),
                ),
              ),
            ],
            onChanged: (val) => setState(() => _selectedMonth = val),
          ),
        ),
      ),
    );
  }
}