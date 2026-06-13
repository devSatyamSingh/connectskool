// // // // import 'package:flutter/material.dart';
// // // // import 'package:intl/intl.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
// // // // import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
// // // //
// // // // import '../../res/app_color.dart';
// // // // import '../../res/const_text.dart';
// // // // import '../../view_model/accountant_attendance_view_model/accountant_attendance_view_model.dart';
// // // // import '../../view_model/accountant_attendance_view_model/create_accountant_attendance_view_model.dart';
// // // // import '../view_model/teacher_view_model/create_teacher_attendance_view_model.dart';
// // // //
// // // // class TeacherAttendanceScreen extends StatefulWidget {
// // // //   const TeacherAttendanceScreen({super.key});
// // // //
// // // //   @override
// // // //   State<TeacherAttendanceScreen> createState() =>
// // // //       _TeacherAttendanceScreenState();
// // // // }
// // // //
// // // // class _TeacherAttendanceScreenState
// // // //     extends State<TeacherAttendanceScreen> {
// // // //
// // // //   // ── Dynamic date ──
// // // //   DateTime _selectedDate = DateTime.now();
// // // //
// // // //   // ── Create form state ──
// // // //   String? _createStatus;   // P | A | L
// // // //   final _remarksCtrl = TextEditingController();
// // // //
// // // //   // ── Formatted for API ──
// // // //   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
// // // //
// // // //   // ── Formatted for display ──
// // // //   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
// // // //   String? _selectedTeacherId;
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     Future.microtask(() {
// // // //       context.read<TeacherAttendanceViewModel>().getTeacherAttendance(_apiDate);
// // // //     });
// // // //   }
// // // //   String capitalizeFirst(String text) {
// // // //     if (text.isEmpty) return text;
// // // //     return text[0].toUpperCase() + text.substring(1);
// // // //   }
// // // //   @override
// // // //   void dispose() {
// // // //     _remarksCtrl.dispose();
// // // //     super.dispose();
// // // //   }
// // // //   // Future<void> _pickDate() async {
// // // //   //   final picked = await showDatePicker(
// // // //   //     context: context,
// // // //   //     initialDate: _selectedDate,
// // // //   //     firstDate: DateTime(2020),
// // // //   //     lastDate: DateTime.now(),
// // // //   //     builder: (c, child) => Theme(
// // // //   //       data: Theme.of(c).copyWith(
// // // //   //         colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
// // // //   //       ),
// // // //   //       child: child!,
// // // //   //     ),
// // // //   //   );
// // // //   //   if (picked != null && picked != _selectedDate) {
// // // //   //     setState(() => _selectedDate = picked);
// // // //   //     context.read<AccountantAttendanceViewModel>().getAccountantAttendance(_apiDate);
// // // //   //   }
// // // //   // }
// // // //   Future<void> _pickDate() async {
// // // //     final picked = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: _selectedDate,
// // // //       firstDate: DateTime(2020),
// // // //       lastDate: DateTime.now(),
// // // //     );
// // // //
// // // //     if (picked != null && picked != _selectedDate) {
// // // //       setState(() => _selectedDate = picked);
// // // //
// // // //       /// ✅ CORRECT VIEWMODEL
// // // //       context
// // // //           .read<TeacherAttendanceViewModel>()
// // // //           .getTeacherAttendance(_apiDate);
// // // //     }
// // // //   }
// // // //   String _statusText(String? s) {
// // // //     switch (s) {
// // // //       case 'P': return 'Present';
// // // //       case 'A': return 'Absent';
// // // //       case 'L': return 'Leave';
// // // //       default:  return 'Unknown';
// // // //     }
// // // //   }
// // // //
// // // //   Color _statusColor(String? s) {
// // // //     switch (s) {
// // // //       case 'P': case 'Present': return Colors.green;
// // // //       case 'A': case 'Absent':  return Colors.red;
// // // //       case 'L': case 'Leave':   return Colors.orange;
// // // //       default:                  return Colors.grey;
// // // //     }
// // // //   }
// // // //
// // // //   IconData _statusIcon(String? s) {
// // // //     switch (s) {
// // // //       case 'P': return Icons.check_circle_rounded;
// // // //       case 'A': return Icons.cancel_rounded;
// // // //       case 'L': return Icons.event_busy_rounded;
// // // //       default:  return Icons.help_outline_rounded;
// // // //     }
// // // //   }
// // // //   void _showCreateBottomSheet() {
// // // //
// // // //     _createStatus = null;
// // // //     _selectedTeacherId = null;
// // // //     _remarksCtrl.clear();
// // // //
// // // //     final allTeachers = Provider.of<AllTeachersListVieModel>(
// // // //       context,
// // // //       listen: false,
// // // //     ).allTeachersListModel;
// // // //
// // // //     final teachers = allTeachers?.data ?? [];
// // // //
// // // //     showModalBottomSheet(
// // // //       context: context,
// // // //       isScrollControlled: true,
// // // //       backgroundColor: Colors.transparent,
// // // //       builder: (_) => SafeArea(
// // // //         child: StatefulBuilder(
// // // //           builder: (ctx, setSheet) => Padding(
// // // //             padding: EdgeInsets.only(
// // // //               bottom: MediaQuery.of(ctx).viewInsets.bottom,
// // // //             ),
// // // //             child: Container(
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColor.cardWhite,
// // // //                 borderRadius: const BorderRadius.vertical(
// // // //                   top: Radius.circular(28),
// // // //                 ),
// // // //               ),
// // // //               child: Column(
// // // //                 mainAxisSize: MainAxisSize.min,
// // // //                 children: [
// // // //
// // // //                   /// Handle
// // // //                   Container(
// // // //                     margin: const EdgeInsets.only(top: 12),
// // // //                     width: 40,
// // // //                     height: 4,
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.grey.shade300,
// // // //                       borderRadius: BorderRadius.circular(10),
// // // //                     ),
// // // //                   ),
// // // //
// // // //                   /// Header
// // // //                   Container(
// // // //                     margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// // // //                     padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 16,
// // // //                       vertical: 14,
// // // //                     ),
// // // //                     decoration: BoxDecoration(
// // // //                       gradient: AppColor.primaryGradient,
// // // //                       borderRadius: BorderRadius.circular(18),
// // // //                     ),
// // // //                     child: Row(
// // // //                       children: [
// // // //                         const Icon(Icons.school,
// // // //                             color: Colors.white, size: 20),
// // // //                         const SizedBox(width: 12),
// // // //
// // // //                         Expanded(
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               AppText.customText(
// // // //                                 'Mark Teacher Attendance',
// // // //                                 size: 16,
// // // //                                 weight: FontWeight.bold,
// // // //                                 color: Colors.white,
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //
// // // //                         GestureDetector(
// // // //                           onTap: () => Navigator.pop(ctx),
// // // //                           child: const Icon(Icons.close,
// // // //                               color: Colors.white),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //
// // // //                   Padding(
// // // //                     padding: const EdgeInsets.all(20),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //
// // // //                         /// Teacher Dropdown
// // // //                         AppText.customText(
// // // //                           'Teacher',
// // // //                           size: 14,
// // // //                           weight: FontWeight.w600,
// // // //                         ),
// // // //                         const SizedBox(height: 8),
// // // //
// // // //                         Container(
// // // //                           padding: const EdgeInsets.symmetric(horizontal: 12),
// // // //                           decoration: BoxDecoration(
// // // //                             color: AppColor.pageBgColor,
// // // //                             borderRadius: BorderRadius.circular(14),
// // // //                           ),
// // // //                           child: DropdownButtonHideUnderline(
// // // //                             child: DropdownButton<String>(
// // // //                               value: _selectedTeacherId,
// // // //                               isExpanded: true,
// // // //                               hint: const Text("Select Teacher"),
// // // //                               items: teachers.map((staff) {
// // // //                                 return DropdownMenuItem<String>(
// // // //                                   value: staff.teacherId.toString(),
// // // //                                   child: Text(staff.name ?? ''),
// // // //                                 );
// // // //                               }).toList(),
// // // //                               onChanged: (v) =>
// // // //                                   setSheet(() => _selectedTeacherId = v),
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //
// // // //                         const SizedBox(height: 20),
// // // //
// // // //                         /// Date Picker
// // // //                         AppText.customText(
// // // //                           'Attendance Date',
// // // //                           size: 14,
// // // //                           weight: FontWeight.w600,
// // // //                         ),
// // // //                         const SizedBox(height: 8),
// // // //
// // // //                         GestureDetector(
// // // //                           onTap: () async {
// // // //
// // // //                             final selected = await showDatePicker(
// // // //                               context: context,
// // // //                               initialDate: DateTime.now(),
// // // //                               firstDate: DateTime(2020),
// // // //                               lastDate: DateTime(2100),
// // // //                             );
// // // //
// // // //                             if (selected != null) {
// // // //                               setSheet(() {
// // // //
// // // //                                 _selectedDate = selected;
// // // //
// // // //                                 // _selectedDate = selected;   // ✅ bas ye hi enough hai
// // // //
// // // //                               });
// // // //                             }
// // // //                           },
// // // //                           child: Container(
// // // //                             padding: const EdgeInsets.symmetric(
// // // //                               horizontal: 12,
// // // //                               vertical: 14,
// // // //                             ),
// // // //                             decoration: BoxDecoration(
// // // //                               color: AppColor.pageBgColor,
// // // //                               borderRadius: BorderRadius.circular(14),
// // // //                             ),
// // // //                             child: Row(
// // // //                               children: [
// // // //                                 const Icon(Icons.calendar_today, size: 16),
// // // //                                 const SizedBox(width: 10),
// // // //                                 Text(
// // // //                                   _selectedDate == null
// // // //                                       ? "Select Date"
// // // //                                       : _apiDate,
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //
// // // //                         const SizedBox(height: 20),
// // // //
// // // //                         /// Status
// // // //                         AppText.customText(
// // // //                           'Status',
// // // //                           size: 14,
// // // //                           weight: FontWeight.w600,
// // // //                         ),
// // // //                         const SizedBox(height: 12),
// // // //
// // // //                         Row(
// // // //                           children: [
// // // //                             _statusOption('P', 'Present', Colors.green, setSheet),
// // // //                             const SizedBox(width: 10),
// // // //                             _statusOption('A', 'Absent', Colors.red, setSheet),
// // // //                             const SizedBox(width: 10),
// // // //                             _statusOption('L', 'Leave', Colors.orange, setSheet),
// // // //                           ],
// // // //                         ),
// // // //
// // // //                         const SizedBox(height: 20),
// // // //
// // // //                         /// Remarks
// // // //                         TextField(
// // // //                           controller: _remarksCtrl,
// // // //                           maxLines: 3,
// // // //                           decoration: InputDecoration(
// // // //                             hintText: 'Remarks...',
// // // //                             filled: true,
// // // //                             fillColor: AppColor.pageBgColor,
// // // //                             border: OutlineInputBorder(
// // // //                               borderRadius: BorderRadius.circular(14),
// // // //                               borderSide: BorderSide.none,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //
// // // //                         const SizedBox(height: 24),
// // // //
// // // //                         /// Submit Button
// // // //                         Consumer<CreateTeacherAttendanceViewModel>(
// // // //                           builder: (context, createVm, _) {
// // // //
// // // //                             final canSubmit =
// // // //                                 _selectedTeacherId != null &&
// // // //                                     _createStatus != null &&
// // // //                                     _apiDate.isNotEmpty;
// // // //
// // // //                             return SizedBox(
// // // //                               width: double.infinity,
// // // //                               height: 50,
// // // //                               child: ElevatedButton.icon(
// // // //                                 onPressed: (!canSubmit || createVm.loading)
// // // //                                     ? null
// // // //                                     : () async {
// // // //
// // // //                                   final success =
// // // //                                   await Provider.of<
// // // //                                       CreateTeacherAttendanceViewModel>(
// // // //                                       context,
// // // //                                       listen: false)
// // // //                                       .createTeacherAttendanceApi(
// // // //                                     int.parse(_selectedTeacherId!),
// // // //                                     _apiDate,
// // // //                                     _createStatus!,
// // // //                                     _remarksCtrl.text.trim(),
// // // //                                     context,
// // // //                                   );
// // // //
// // // //                                   if (success) {
// // // //
// // // //                                     Navigator.pop(context);
// // // //
// // // //                                     Provider.of<TeacherAttendanceViewModel>(
// // // //                                         context,
// // // //                                         listen: false)
// // // //                                         .getTeacherAttendance(_apiDate);
// // // //                                   }
// // // //                                 },
// // // //                                 icon: createVm.loading
// // // //                                     ? const SizedBox(
// // // //                                   width: 18,
// // // //                                   height: 18,
// // // //                                   child: CircularProgressIndicator(
// // // //                                     color: Colors.white,
// // // //                                     strokeWidth: 2,
// // // //                                   ),
// // // //                                 )
// // // //                                     : const Icon(Icons.check_rounded,
// // // //                                     color: Colors.white),
// // // //                                 label: Text(
// // // //                                   createVm.loading
// // // //                                       ? 'Saving...'
// // // //                                       : 'Save Attendance',
// // // //                                 ),
// // // //                                 style: ElevatedButton.styleFrom(
// // // //                                   backgroundColor: canSubmit
// // // //                                       ? AppColor.lightBlueColor
// // // //                                       : Colors.grey.shade300,
// // // //                                   shape: RoundedRectangleBorder(
// // // //                                     borderRadius: BorderRadius.circular(14),
// // // //                                   ),
// // // //                                   elevation: 0,
// // // //                                 ),
// // // //                               ),
// // // //                             );
// // // //                           },
// // // //                         ),
// // // //
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // // //   void _showCreateBottomSheet() {
// // // // //     _createStatus          = null;
// // // // //     _selectedAccountantId  = null;   // ✅ reset
// // // // //     _remarksCtrl.clear();
// // // // //
// // // // //     showModalBottomSheet(
// // // // //       context: context,
// // // // //       isScrollControlled: true,
// // // // //       backgroundColor: Colors.transparent,
// // // // //       builder: (_) => SafeArea(
// // // // //         child: StatefulBuilder(
// // // // //           builder: (ctx, setSheet) => Padding(
// // // // //             padding: EdgeInsets.only(
// // // // //                 bottom: MediaQuery.of(ctx).viewInsets.bottom),
// // // // //             child: Container(
// // // // //               decoration: BoxDecoration(
// // // // //                 color: AppColor.cardWhite,
// // // // //                 borderRadius:
// // // // //                 const BorderRadius.vertical(top: Radius.circular(28)),
// // // // //               ),
// // // // //               child: Column(
// // // // //                 mainAxisSize: MainAxisSize.min,
// // // // //                 children: [
// // // // //
// // // // //                   // ── Handle bar ──
// // // // //                   Center(
// // // // //                     child: Container(
// // // // //                       margin: const EdgeInsets.only(top: 12),
// // // // //                       width: 40,
// // // // //                       height: 4,
// // // // //                       decoration: BoxDecoration(
// // // // //                         color: Colors.grey.shade300,
// // // // //                         borderRadius: BorderRadius.circular(10),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //
// // // // //                   // ── Gradient header ──
// // // // //                   Container(
// // // // //                     margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// // // // //                     padding: const EdgeInsets.symmetric(
// // // // //                         horizontal: 16, vertical: 14),
// // // // //                     decoration: BoxDecoration(
// // // // //                       gradient: AppColor.primaryGradient,
// // // // //                       borderRadius: BorderRadius.circular(18),
// // // // //                     ),
// // // // //                     child: Row(
// // // // //                       children: [
// // // // //                         Container(
// // // // //                           padding: const EdgeInsets.all(8),
// // // // //                           decoration: BoxDecoration(
// // // // //                             color: Colors.white.withOpacity(0.2),
// // // // //                             borderRadius: BorderRadius.circular(10),
// // // // //                           ),
// // // // //                           child: const Icon(Icons.add_task_rounded,
// // // // //                               color: Colors.white, size: 20),
// // // // //                         ),
// // // // //                         const SizedBox(width: 12),
// // // // //                         Expanded(
// // // // //                           child: Column(
// // // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                             children: [
// // // // //                               AppText.customText('Mark Attendance',
// // // // //                                   size: 16,
// // // // //                                   weight: FontWeight.bold,
// // // // //                                   color: Colors.white),
// // // // //                               AppText.customText(_displayDate,
// // // // //                                   size: 12, color: Colors.white70),
// // // // //                             ],
// // // // //                           ),
// // // // //                         ),
// // // // //                         GestureDetector(
// // // // //                           onTap: () => Navigator.pop(ctx),
// // // // //                           child: Container(
// // // // //                             padding: const EdgeInsets.all(6),
// // // // //                             decoration: BoxDecoration(
// // // // //                               color: Colors.white.withOpacity(0.2),
// // // // //                               shape: BoxShape.circle,
// // // // //                             ),
// // // // //                             child: const Icon(Icons.close_rounded,
// // // // //                                 color: Colors.white, size: 18),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                   ),
// // // // // //                   Padding(
// // // // // //                     padding: const EdgeInsets.all(20),
// // // // // //                     child: Column(
// // // // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                       children: [
// // // // // //
// // // // // //                         // ── Accountant dropdown ──
// // // // // //                         AppText.customText('Accountant',
// // // // // //                             size: 14, weight: FontWeight.w600),
// // // // // //                         const SizedBox(height: 8),
// // // // // //                         Consumer<TeacherAttendanceViewModel>(
// // // // // //                           builder: (context, vm, _) {
// // // // // //                             // Build unique accountant list from loaded attendance
// // // // // //                             final accountants = vm.attendanceList;
// // // // // //
// // // // // //                             return Container(
// // // // // //                               padding: const EdgeInsets.symmetric(
// // // // // //                                   horizontal: 12),
// // // // // //                               decoration: BoxDecoration(
// // // // // //                                 color: AppColor.pageBgColor,
// // // // // //                                 borderRadius: BorderRadius.circular(14),
// // // // // //                                 border: Border.all(
// // // // // //                                   color: _selectedAccountantId != null
// // // // // //                                       ? AppColor.lightBlueColor
// // // // // //                                       .withOpacity(0.5)
// // // // // //                                       : Colors.transparent,
// // // // // //                                   width: 1.5,
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                               child: DropdownButtonHideUnderline(
// // // // // //                                 child: DropdownButton<String>(
// // // // // //                                   value: _selectedAccountantId,
// // // // // //                                   isExpanded: true,
// // // // // //                                   icon: Icon(
// // // // // //                                       Icons.keyboard_arrow_down_rounded,
// // // // // //                                       color: AppColor.lightBlueColor),
// // // // // //                                   hint: Row(
// // // // // //                                     children: [
// // // // // //                                       Icon(Icons.person_outline_rounded,
// // // // // //                                           size: 16,
// // // // // //                                           color: AppColor.softGreyText),
// // // // // //                                       const SizedBox(width: 8),
// // // // // //                                       Text('Select Accountant',
// // // // // //                                           style: TextStyle(
// // // // // //                                               color: AppColor.softGreyText,
// // // // // //                                               fontSize: 13)),
// // // // // //                                     ],
// // // // // //                                   ),
// // // // // //                                   items: accountants.map((staff) {
// // // // // //                                     return DropdownMenuItem<String>(
// // // // // //                                       value: staff.accountantId.toString(),
// // // // // //                                       child: Row(
// // // // // //                                         children: [
// // // // // //                                           CircleAvatar(
// // // // // //                                             radius: 14,
// // // // // //                                             backgroundColor: AppColor
// // // // // //                                                 .lightBlueColor
// // // // // //                                                 .withOpacity(0.12),
// // // // // //                                             child: Text(
// // // // // //                                               staff.accountantName?[0]
// // // // // //                                                   .toUpperCase() ??
// // // // // //                                                   '?',
// // // // // //                                               style: TextStyle(
// // // // // //                                                 fontSize: 11,
// // // // // //                                                 fontWeight: FontWeight.bold,
// // // // // //                                                 color:
// // // // // //                                                 AppColor.lightBlueColor,
// // // // // //                                               ),
// // // // // //                                             ),
// // // // // //                                           ),
// // // // // //                                           const SizedBox(width: 10),
// // // // // //                                           Text(
// // // // // //                                             staff.accountantName ?? '',
// // // // // //                                             style: const TextStyle(
// // // // // //                                                 fontSize: 13,
// // // // // //                                                 fontWeight: FontWeight.w500),
// // // // // //                                           ),
// // // // // //                                         ],
// // // // // //                                       ),
// // // // // //                                     );
// // // // // //                                   }).toList(),
// // // // // //                                   onChanged: (v) => setSheet(
// // // // // //                                           () => _selectedAccountantId = v),
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                             );
// // // // // //                           },
// // // // // //                         ),
// // // // // //
// // // // // //                         const SizedBox(height: 20),
// // // // // //
// // // // // //                         // ── Status label ──
// // // // // //                         AppText.customText('Status',
// // // // // //                             size: 14, weight: FontWeight.w600),
// // // // // //                         const SizedBox(height: 12),
// // // // // //
// // // // // //                         // ── Status selector ──
// // // // // //                         Row(
// // // // // //                           children: [
// // // // // //                             _statusOption(
// // // // // //                                 'P', 'Present', Colors.green, setSheet),
// // // // // //                             const SizedBox(width: 10),
// // // // // //                             _statusOption(
// // // // // //                                 'A', 'Absent', Colors.red, setSheet),
// // // // // //                             const SizedBox(width: 10),
// // // // // //                             _statusOption(
// // // // // //                                 'L', 'Leave', Colors.orange, setSheet),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //
// // // // // //                         const SizedBox(height: 20),
// // // // // //
// // // // // //                         // ── Remarks ──
// // // // // //                         AppText.customText('Remarks (Optional)',
// // // // // //                             size: 14, weight: FontWeight.w600),
// // // // // //                         const SizedBox(height: 8),
// // // // // //                         TextField(
// // // // // //                           controller: _remarksCtrl,
// // // // // //                           maxLines: 3,
// // // // // //                           decoration: InputDecoration(
// // // // // //                             hintText: 'Add a note...',
// // // // // //                             hintStyle: TextStyle(
// // // // // //                                 color: AppColor.softGreyText, fontSize: 13),
// // // // // //                             filled: true,
// // // // // //                             fillColor: AppColor.pageBgColor,
// // // // // //                             prefixIcon: const Padding(
// // // // // //                               padding: EdgeInsets.only(
// // // // // //                                   left: 12, right: 8, top: 12),
// // // // // //                               child:
// // // // // //                               Icon(Icons.notes_rounded, size: 18),
// // // // // //                             ),
// // // // // //                             prefixIconConstraints: const BoxConstraints(
// // // // // //                                 minWidth: 0, minHeight: 0),
// // // // // //                             border: OutlineInputBorder(
// // // // // //                               borderRadius: BorderRadius.circular(14),
// // // // // //                               borderSide: BorderSide.none,
// // // // // //                             ),
// // // // // //                             contentPadding: const EdgeInsets.all(14),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //
// // // // // //                         const SizedBox(height: 24),
// // // // // //
// // // // // //                         // ── Submit button ──
// // // // // //                         // Consumer<CreateAccountantAttendanceViewModel>(
// // // // // //                         //   builder: (context, createVm, _) {
// // // // // //                         //     final canSubmit = _selectedAccountantId != null &&
// // // // // //                         //         _createStatus != null;
// // // // // //                         //
// // // // // //                         //     return SizedBox(
// // // // // //                         //       width: double.infinity,
// // // // // //                         //       height: 50,
// // // // // //                         //       child: ElevatedButton.icon(
// // // // // //                         //         onPressed: (!canSubmit || createVm.loading)
// // // // // //                         //             ? null
// // // // // //                         //             : () async {
// // // // // //                         //           // ✅ API CALL
// // // // // //                         //           final success = await Provider.of<
// // // // // //                         //               CreateAccountantAttendanceViewModel>(
// // // // // //                         //               context,
// // // // // //                         //               listen: false)
// // // // // //                         //               .createAccountantAttendanceApi(
// // // // // //                         //             int.parse(_selectedAccountantId!),
// // // // // //                         //             _apiDate,            // yyyy-MM-dd
// // // // // //                         //             _createStatus!,      // P | A | L
// // // // // //                         //             _remarksCtrl.text.trim(),
// // // // // //                         //             context,
// // // // // //                         //           );
// // // // // //                         //
// // // // // //                         //           if (success) {
// // // // // //                         //             // Refresh list after marking
// // // // // //                         //             Provider.of<AccountantAttendanceViewModel>(
// // // // // //                         //                 context,
// // // // // //                         //                 listen: false)
// // // // // //                         //                 .getAccountantAttendance(
// // // // // //                         //                 _apiDate);
// // // // // //                         //           }
// // // // // //                         //         },
// // // // // //                         //         icon: createVm.loading
// // // // // //                         //             ? const SizedBox(
// // // // // //                         //           width: 18,
// // // // // //                         //           height: 18,
// // // // // //                         //           child: CircularProgressIndicator(
// // // // // //                         //               color: Colors.white,
// // // // // //                         //               strokeWidth: 2),
// // // // // //                         //         )
// // // // // //                         //             : const Icon(Icons.check_rounded,
// // // // // //                         //             color: Colors.white),
// // // // // //                         //         label: Text(
// // // // // //                         //           createVm.loading
// // // // // //                         //               ? 'Saving...'
// // // // // //                         //               : 'Save Attendance',
// // // // // //                         //           style: const TextStyle(
// // // // // //                         //               fontSize: 15,
// // // // // //                         //               fontWeight: FontWeight.bold,
// // // // // //                         //               color: Colors.white),
// // // // // //                         //         ),
// // // // // //                         //         style: ElevatedButton.styleFrom(
// // // // // //                         //           backgroundColor: canSubmit
// // // // // //                         //               ? AppColor.lightBlueColor
// // // // // //                         //               : Colors.grey.shade300,
// // // // // //                         //           shape: RoundedRectangleBorder(
// // // // // //                         //               borderRadius:
// // // // // //                         //               BorderRadius.circular(14)),
// // // // // //                         //           elevation: 0,
// // // // // //                         //         ),
// // // // // //                         //       ),
// // // // // //                         //     );
// // // // // //                         //   },
// // // // // //                         // ),
// // // // // // // ── Submit button ──
// // // // // //                         Consumer<CreateAccountantAttendanceViewModel>(
// // // // // //                           builder: (context, createVm, _) {
// // // // // //                             final canSubmit =
// // // // // //                                 _selectedAccountantId != null && _createStatus != null;
// // // // // //
// // // // // //                             return SizedBox(
// // // // // //                               width: double.infinity,
// // // // // //                               height: 50,
// // // // // //                               child: ElevatedButton.icon(
// // // // // //                                 onPressed: (!canSubmit || createVm.loading)
// // // // // //                                     ? null
// // // // // //                                     : () async {
// // // // // //
// // // // // //                                   final success = await Provider.of<
// // // // // //                                       CreateAccountantAttendanceViewModel>(
// // // // // //                                       context,
// // // // // //                                       listen: false)
// // // // // //                                       .createAccountantAttendanceApi(
// // // // // //                                     int.parse(_selectedAccountantId!),
// // // // // //                                     _apiDate,            // yyyy-MM-dd
// // // // // //                                     _createStatus!,      // P | A | L
// // // // // //                                     _remarksCtrl.text.trim(),
// // // // // //                                     context,
// // // // // //                                   );
// // // // // //
// // // // // //                                   if (success) {
// // // // // //
// // // // // //                                     /// ✅ Close BottomSheet
// // // // // //                                     Navigator.pop(context);
// // // // // //
// // // // // //                                     /// ✅ Refresh Attendance List
// // // // // //                                     Provider.of<AccountantAttendanceViewModel>(
// // // // // //                                         context,
// // // // // //                                         listen: false)
// // // // // //                                         .getAccountantAttendance(_apiDate);
// // // // // //
// // // // // //                                     /// ✅ Success Message
// // // // // //                                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                                       const SnackBar(
// // // // // //                                         content: Text("Attendance Created Successfully"),
// // // // // //                                         backgroundColor: Colors.green,
// // // // // //                                       ),
// // // // // //                                     );
// // // // // //                                   }
// // // // // //                                 },
// // // // // //                                 icon: createVm.loading
// // // // // //                                     ? const SizedBox(
// // // // // //                                   width: 18,
// // // // // //                                   height: 18,
// // // // // //                                   child: CircularProgressIndicator(
// // // // // //                                       color: Colors.white,
// // // // // //                                       strokeWidth: 2),
// // // // // //                                 )
// // // // // //                                     : const Icon(Icons.check_rounded,
// // // // // //                                     color: Colors.white),
// // // // // //                                 label: Text(
// // // // // //                                   createVm.loading
// // // // // //                                       ? 'Saving...'
// // // // // //                                       : 'Save Attendance',
// // // // // //                                   style: const TextStyle(
// // // // // //                                       fontSize: 15,
// // // // // //                                       fontWeight: FontWeight.bold,
// // // // // //                                       color: Colors.white),
// // // // // //                                 ),
// // // // // //                                 style: ElevatedButton.styleFrom(
// // // // // //                                   backgroundColor: canSubmit
// // // // // //                                       ? AppColor.lightBlueColor
// // // // // //                                       : Colors.grey.shade300,
// // // // // //                                   shape: RoundedRectangleBorder(
// // // // // //                                       borderRadius: BorderRadius.circular(14)),
// // // // // //                                   elevation: 0,
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                             );
// // // // // //                           },
// // // // // //                         ),
// // // // // //                         const SizedBox(height: 8),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // //   Widget _statusOption(
// // // //       String value, String label, Color color, StateSetter setSheet) {
// // // //     final selected = _createStatus == value;
// // // //     return Expanded(
// // // //       child: GestureDetector(
// // // //         onTap: () => setSheet(() => _createStatus = value),
// // // //         child: AnimatedContainer(
// // // //           duration: const Duration(milliseconds: 200),
// // // //           padding: const EdgeInsets.symmetric(vertical: 14),
// // // //           decoration: BoxDecoration(
// // // //             color: selected ? color.withOpacity(0.15) : AppColor.pageBgColor,
// // // //             borderRadius: BorderRadius.circular(14),
// // // //             border: Border.all(
// // // //               color: selected ? color : Colors.transparent,
// // // //               width: 2,
// // // //             ),
// // // //           ),
// // // //           child: Column(
// // // //             children: [
// // // //               Icon(_statusIcon(value),
// // // //                   color: selected ? color : AppColor.softGreyText, size: 26),
// // // //               const SizedBox(height: 6),
// // // //               Text(
// // // //                 label,
// // // //                 style: TextStyle(
// // // //                   fontSize: 12,
// // // //                   fontWeight: FontWeight.w600,
// // // //                   color: selected ? color : AppColor.softGreyText,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: AppColor.screenBg,
// // // //
// // // //       // ── FAB ──
// // // //       floatingActionButton: FloatingActionButton.extended(
// // // //         onPressed: _showCreateBottomSheet,
// // // //         backgroundColor: AppColor.lightBlueColor,
// // // //         icon: const Icon(Icons.add_rounded, color: Colors.white),
// // // //         label: const Text('Mark Attendance',
// // // //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// // // //       ),
// // // //
// // // //       body: Column(
// // // //         children: [
// // // //
// // // //           // ─── HEADER ───────────────────────────────
// // // //           Container(
// // // //             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
// // // //             decoration: BoxDecoration(
// // // //               gradient: AppColor.primaryGradient,
// // // //               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                     color: AppColor.blueShadow,
// // // //                     blurRadius: 18,
// // // //                     offset: const Offset(0, 10)),
// // // //               ],
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 Row(
// // // //                   children: [
// // // //                     InkWell(
// // // //                       onTap: () => Navigator.pop(context),
// // // //                       child: Container(
// // // //                         padding: const EdgeInsets.all(10),
// // // //                         decoration: BoxDecoration(
// // // //                             color: AppColor.glassWhite, shape: BoxShape.circle),
// // // //                         child: const Icon(Icons.arrow_back_ios_new_rounded,
// // // //                             color: Colors.white, size: 20),
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 12),
// // // //                     Expanded(
// // // //                       child: AppText.customText('Teacher Attendance',
// // // //                           size: 19, weight: FontWeight.bold, color: Colors.white),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //
// // // //                 const SizedBox(height: 16),
// // // //
// // // //                 // ── Dynamic Date Selector ──
// // // //                 GestureDetector(
// // // //                   onTap: _pickDate,
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.symmetric(
// // // //                         horizontal: 16, vertical: 12),
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.white.withOpacity(0.15),
// // // //                       borderRadius: BorderRadius.circular(16),
// // // //                       border: Border.all(
// // // //                           color: Colors.white.withOpacity(0.3), width: 1),
// // // //                     ),
// // // //                     child: Row(
// // // //                       children: [
// // // //                         Container(
// // // //                           padding: const EdgeInsets.all(8),
// // // //                           decoration: BoxDecoration(
// // // //                             color: Colors.white.withOpacity(0.2),
// // // //                             borderRadius: BorderRadius.circular(10),
// // // //                           ),
// // // //                           child: const Icon(Icons.calendar_month_rounded,
// // // //                               color: Colors.white, size: 18),
// // // //                         ),
// // // //                         const SizedBox(width: 12),
// // // //                         Expanded(
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               AppText.customText('Selected Date',
// // // //                                   size: 11, color: Colors.white70),
// // // //                               AppText.customText(_displayDate,
// // // //                                   size: 15,
// // // //                                   weight: FontWeight.bold,
// // // //                                   color: Colors.white),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                         Container(
// // // //                           padding: const EdgeInsets.symmetric(
// // // //                               horizontal: 10, vertical: 5),
// // // //                           decoration: BoxDecoration(
// // // //                             color: Colors.white.withOpacity(0.2),
// // // //                             borderRadius: BorderRadius.circular(20),
// // // //                           ),
// // // //                           child: Row(
// // // //                             children: [
// // // //                               const Icon(Icons.edit_calendar_rounded,
// // // //                                   color: Colors.white, size: 13),
// // // //                               const SizedBox(width: 4),
// // // //                               AppText.customText('Change',
// // // //                                   size: 11, color: Colors.white),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           // ─── BODY ─────────────────────────────────
// // // //           Expanded(
// // // //             child: Consumer<TeacherAttendanceViewModel>(
// // // //               builder: (context, vm, _) {
// // // //
// // // //                 if (vm.loading) {
// // // //                   return Center(
// // // //                     child: CircularProgressIndicator(
// // // //                         color: AppColor.lightBlueColor),
// // // //                   );
// // // //                 }
// // // //
// // // //                 if (vm.attendanceList.isEmpty) {
// // // //                   return Center(
// // // //                     child: Column(
// // // //                       mainAxisAlignment: MainAxisAlignment.center,
// // // //                       children: [
// // // //                         Icon(Icons.event_busy_rounded,
// // // //                             size: 72,
// // // //                             color: AppColor.lightBlueColor.withOpacity(0.3)),
// // // //                         const SizedBox(height: 16),
// // // //                         AppText.customText('No Attendance Found',
// // // //                             size: 16, weight: FontWeight.bold),
// // // //                         const SizedBox(height: 6),
// // // //                         AppText.customText('No records for $_displayDate',
// // // //                             size: 13, color: AppColor.softGreyText),
// // // //                       ],
// // // //                     ),
// // // //                   );
// // // //                 }
// // // //
// // // //                 final presentCount = vm.attendanceList.where((e) => e.status == 'P').length;
// // // //                 final absentCount  = vm.attendanceList.where((e) => e.status == 'A').length;
// // // //                 final leaveCount   = vm.attendanceList.where((e) => e.status == 'L').length;
// // // //
// // // //                 return SingleChildScrollView(
// // // //                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
// // // //                   child: Column(
// // // //                     children: [
// // // //
// // // //                       // ── Summary cards ──
// // // //                       Row(
// // // //                         children: [
// // // //                           _summaryCard('Present', presentCount.toString(), Colors.green),
// // // //                           const SizedBox(width: 10),
// // // //                           _summaryCard('Absent', absentCount.toString(), Colors.red),
// // // //                           const SizedBox(width: 10),
// // // //                           _summaryCard('Leave', leaveCount.toString(), Colors.orange),
// // // //                         ],
// // // //                       ),
// // // //
// // // //                       const SizedBox(height: 20),
// // // //
// // // //                       // ── Attendance list ──
// // // //                       ListView.builder(
// // // //                         itemCount: vm.attendanceList.length,
// // // //                         shrinkWrap: true,
// // // //                         physics: const NeverScrollableScrollPhysics(),
// // // //                         // itemBuilder: (context, index) {
// // // //                         //   final staff      = vm.attendanceList[index];
// // // //                         //   final statusText = _statusText(staff.status);
// // // //                         //   final color      = _statusColor(staff.status);
// // // //                         //
// // // //                         //   return Container(
// // // //                         //     margin: const EdgeInsets.only(bottom: 12),
// // // //                         //     padding: const EdgeInsets.all(14),
// // // //                         //     decoration: BoxDecoration(
// // // //                         //       color: Colors.white,
// // // //                         //       borderRadius: BorderRadius.circular(16),
// // // //                         //       boxShadow: [
// // // //                         //         BoxShadow(
// // // //                         //             color: AppColor.cardShadow,
// // // //                         //             blurRadius: 8,
// // // //                         //             offset: const Offset(0, 4)),
// // // //                         //       ],
// // // //                         //     ),
// // // //                         //     child: Row(
// // // //                         //       children: [
// // // //                         //         // Avatar
// // // //                         //         Container(
// // // //                         //           width: 46,
// // // //                         //           height: 46,
// // // //                         //           decoration: BoxDecoration(
// // // //                         //             color: color.withOpacity(0.12),
// // // //                         //             shape: BoxShape.circle,
// // // //                         //           ),
// // // //                         //           child: Center(
// // // //                         //             child: Text(
// // // //                         //               staff.accountantName?[0].toUpperCase() ?? '?',
// // // //                         //               style: TextStyle(
// // // //                         //                   fontSize: 16,
// // // //                         //                   fontWeight: FontWeight.bold,
// // // //                         //                   color: color),
// // // //                         //             ),
// // // //                         //           ),
// // // //                         //         ),
// // // //                         //         const SizedBox(width: 12),
// // // //                         //
// // // //                         //         // Name + remarks
// // // //                         //         Expanded(
// // // //                         //           child: Column(
// // // //                         //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                         //             children: [
// // // //                         //               AppText.customText(
// // // //                         //                   staff.accountantName ?? '',
// // // //                         //                   size: 14,
// // // //                         //                   weight: FontWeight.bold),
// // // //                         //               if (staff.remarks != null &&
// // // //                         //                   staff.remarks!.isNotEmpty) ...[
// // // //                         //                 const SizedBox(height: 3),
// // // //                         //                 AppText.customText(
// // // //                         //                     staff.remarks!,
// // // //                         //                     size: 12,
// // // //                         //                     color: AppColor.softGreyText),
// // // //                         //               ],
// // // //                         //             ],
// // // //                         //           ),
// // // //                         //         ),
// // // //                         //
// // // //                         //         // Status badge
// // // //                         //         Container(
// // // //                         //           padding: const EdgeInsets.symmetric(
// // // //                         //               horizontal: 12, vertical: 6),
// // // //                         //           decoration: BoxDecoration(
// // // //                         //             color: color.withOpacity(0.12),
// // // //                         //             borderRadius: BorderRadius.circular(20),
// // // //                         //           ),
// // // //                         //           child: Row(
// // // //                         //             mainAxisSize: MainAxisSize.min,
// // // //                         //             children: [
// // // //                         //               Icon(_statusIcon(staff.status),
// // // //                         //                   color: color, size: 13),
// // // //                         //               const SizedBox(width: 4),
// // // //                         //               Text(statusText,
// // // //                         //                   style: TextStyle(
// // // //                         //                       color: color,
// // // //                         //                       fontWeight: FontWeight.w600,
// // // //                         //                       fontSize: 12)),
// // // //                         //             ],
// // // //                         //           ),
// // // //                         //         ),
// // // //                         //       ],
// // // //                         //     ),
// // // //                         //   );
// // // //                         // },
// // // //                         itemBuilder: (context, index) {
// // // //                           final staff      = vm.attendanceList[index];
// // // //                           final statusText = _statusText(staff.status);
// // // //                           final color      = _statusColor(staff.status);
// // // //
// // // //                           return Container(
// // // //                             margin: const EdgeInsets.only(bottom: 12),
// // // //                             padding: const EdgeInsets.all(14),
// // // //                             decoration: BoxDecoration(
// // // //                               color: Colors.white,
// // // //                               borderRadius: BorderRadius.circular(16),
// // // //                               boxShadow: [
// // // //                                 BoxShadow(
// // // //                                   color: AppColor.cardShadow,
// // // //                                   blurRadius: 8,
// // // //                                   offset: const Offset(0, 4),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                             child: Row(
// // // //                               children: [
// // // //
// // // //                                 /// Avatar
// // // //                                 Container(
// // // //                                   width: 46,
// // // //                                   height: 46,
// // // //                                   decoration: BoxDecoration(
// // // //                                     color: color.withOpacity(0.12),
// // // //                                     shape: BoxShape.circle,
// // // //                                   ),
// // // //                                   child: Center(
// // // //                                     child: AppText.customText(
// // // //                                       (staff.teacherName != null &&
// // // //                                           staff.teacherName!.isNotEmpty)
// // // //                                           ? staff.teacherName![0].toUpperCase()
// // // //                                           : '?',
// // // //                                       size: 16,
// // // //                                       weight: FontWeight.bold,
// // // //                                       color: color,
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //
// // // //                                 const SizedBox(width: 12),
// // // //
// // // //                                 /// Name + Remarks
// // // //                                 Expanded(
// // // //                                   child: Column(
// // // //                                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                                     children: [
// // // //                                       AppText.customText(
// // // //                                         capitalizeFirst(staff.teacherName ?? ''),
// // // //                                         size: 14,
// // // //                                         weight: FontWeight.bold,
// // // //                                       ),
// // // //
// // // //                                       if ((staff.remarks ?? '').trim().isNotEmpty) ...[
// // // //                                         const SizedBox(height: 3),
// // // //                                         AppText.customText(
// // // //                                           staff.remarks!,
// // // //                                           size: 12,
// // // //                                           color: AppColor.softGreyText,
// // // //                                         ),
// // // //                                       ],
// // // //                                     ],
// // // //                                   ),
// // // //                                 ),
// // // //
// // // //                                 /// Status badge
// // // //                                 Container(
// // // //                                   padding:
// // // //                                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                                   decoration: BoxDecoration(
// // // //                                     color: color.withOpacity(0.12),
// // // //                                     borderRadius: BorderRadius.circular(20),
// // // //                                   ),
// // // //                                   child: Row(
// // // //                                     mainAxisSize: MainAxisSize.min,
// // // //                                     children: [
// // // //                                       Icon(
// // // //                                         _statusIcon(staff.status),
// // // //                                         color: color,
// // // //                                         size: 13,
// // // //                                       ),
// // // //                                       const SizedBox(width: 4),
// // // //                                       AppText.customText(
// // // //                                         statusText,
// // // //                                         size: 12,
// // // //                                         weight: FontWeight.w600,
// // // //                                         color: color,
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           );
// // // //                         },                      ),
// // // //                     ],
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _summaryCard(String title, String count, Color color) {
// // // //     return Expanded(
// // // //       child: Container(
// // // //         padding: const EdgeInsets.symmetric(vertical: 16),
// // // //         decoration: BoxDecoration(
// // // //           color: color.withOpacity(0.1),
// // // //           borderRadius: BorderRadius.circular(16),
// // // //           border: Border.all(color: color.withOpacity(0.2)),
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Icon(_statusIcon(title[0] == 'P' ? 'P' : title[0] == 'A' ? 'A' : 'L'),
// // // //                 color: color, size: 22),
// // // //             const SizedBox(height: 6),
// // // //             Text(count,
// // // //                 style: TextStyle(
// // // //                     fontSize: 20, fontWeight: FontWeight.bold, color: color)),
// // // //             const SizedBox(height: 2),
// // // //             Text(title,
// // // //                 style: TextStyle(
// // // //                     fontSize: 11,
// // // //                     fontWeight: FontWeight.w500,
// // // //                     color: color.withOpacity(0.8))),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
// // // import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
// // // import '../../res/app_color.dart';
// // // import '../../res/const_text.dart';
// // // import '../view_model/teacher_view_model/create_teacher_attendance_view_model.dart';
// // //
// // // class _TeacherRow {
// // //   final String id;
// // //   final String name;
// // //   String? attendanceStatus;
// // //   bool alreadyMarked;
// // //   String? markedStatus;
// // //   final TextEditingController remarksCtrl;
// // //
// // //   _TeacherRow({
// // //     required this.id,
// // //     required this.name,
// // //     this.attendanceStatus,
// // //     this.alreadyMarked = false,
// // //     this.markedStatus,
// // //   }) : remarksCtrl = TextEditingController();
// // //
// // //   void dispose() => remarksCtrl.dispose();
// // // }
// // //
// // // class TeacherAttendanceScreen extends StatefulWidget {
// // //   const TeacherAttendanceScreen({super.key});
// // //
// // //   @override
// // //   State<TeacherAttendanceScreen> createState() =>
// // //       _TeacherAttendanceScreenState();
// // // }
// // //
// // // class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
// // //   DateTime _selectedDate = DateTime.now();
// // //   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
// // //   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
// // //
// // //   List<_TeacherRow> _rows = [];
// // //   bool _saving = false;
// // //   bool _loadingRows = false;
// // //
// // //   static const _statuses = [
// // //     {'code': 'P', 'full': 'Present'},
// // //     {'code': 'A', 'full': 'Absent'},
// // //     {'code': 'L', 'full': 'Leave'},
// // //     {'code': 'H', 'full': 'Half Day'},
// // //     {'code': 'OL', 'full': 'On Leave'},
// // //   ];
// // //
// // //   Color _statusColor(String? s) {
// // //     switch (s) {
// // //       case 'P':  return const Color(0xFF22C55E);
// // //       case 'A':  return const Color(0xFFEF4444);
// // //       case 'L':  return const Color(0xFFF59E0B);
// // //       case 'H':  return const Color(0xFFA855F7);
// // //       case 'OL': return const Color(0xFF3B82F6);
// // //       default:   return Colors.grey;
// // //     }
// // //   }
// // //
// // //   IconData _statusIcon(String? s) {
// // //     switch (s) {
// // //       case 'P':  return Icons.check_circle_rounded;
// // //       case 'A':  return Icons.cancel_rounded;
// // //       case 'L':  return Icons.event_busy_rounded;
// // //       case 'H':  return Icons.av_timer_rounded;
// // //       case 'OL': return Icons.medical_services_rounded;
// // //       default:   return Icons.help_outline_rounded;
// // //     }
// // //   }
// // //
// // //   String _statusLabel(String? s) {
// // //     switch (s) {
// // //       case 'P':  return 'Present';
// // //       case 'A':  return 'Absent';
// // //       case 'L':  return 'Leave';
// // //       case 'H':  return 'Half Day';
// // //       case 'OL': return 'On Leave';
// // //       default:   return s ?? '';
// // //     }
// // //   }
// // //
// // //   String _cap(String t) =>
// // //       t.isEmpty ? t : t[0].toUpperCase() + t.substring(1);
// // //
// // //   // ─────────────────────────────────────────────
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// // //       await Provider.of<AllTeachersListVieModel>(context, listen: false)
// // //           .allTeachersListApi(context);
// // //       await _fetchAndBuildRows();
// // //     });
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     for (final r in _rows) r.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   Future<void> _fetchAndBuildRows() async {
// // //     setState(() => _loadingRows = true);
// // //
// // //     // Fetch existing attendance for this date
// // //     await context
// // //         .read<TeacherAttendanceViewModel>()
// // //         .getTeacherAttendance(_apiDate);
// // //
// // //     final attVm =
// // //     Provider.of<TeacherAttendanceViewModel>(context, listen: false);
// // //     final markedList = attVm.attendanceList;
// // //
// // //     // teacherId → status
// // //     final Map<String, String> markedMap = {
// // //       for (final r in markedList)
// // //         if (r.teacherId != null) r.teacherId.toString(): r.status ?? '',
// // //     };
// // //
// // //     final allTeachers =
// // //         Provider.of<AllTeachersListVieModel>(context, listen: false)
// // //             .allTeachersListModel
// // //             ?.data ?? [];
// // //
// // //     for (final r in _rows) r.dispose();
// // //
// // //     setState(() {
// // //       _rows = allTeachers.map((t) {
// // //         final id = t.teacherId.toString();
// // //         final already = markedMap.containsKey(id);
// // //         return _TeacherRow(
// // //           id: id,
// // //           name: t.name ?? '',
// // //           alreadyMarked: already,
// // //           markedStatus: markedMap[id],
// // //           attendanceStatus: already ? markedMap[id] : null,
// // //         );
// // //       }).toList();
// // //       _loadingRows = false;
// // //     });
// // //   }
// // //
// // //   Future<void> _pickDate() async {
// // //     final picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: _selectedDate,
// // //       firstDate: DateTime(2020),
// // //       lastDate: DateTime.now(),
// // //       builder: (c, child) => Theme(
// // //         data: Theme.of(c).copyWith(
// // //           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
// // //         ),
// // //         child: child!,
// // //       ),
// // //     );
// // //     if (picked != null && picked != _selectedDate) {
// // //       setState(() => _selectedDate = picked);
// // //       await _fetchAndBuildRows();
// // //     }
// // //   }
// // //
// // //   void _markAllPresent() {
// // //     setState(() {
// // //       for (final r in _rows) {
// // //         if (!r.alreadyMarked) r.attendanceStatus = 'P';
// // //       }
// // //     });
// // //   }
// // //
// // //   // Future<void> _saveAll() async {
// // //   //   final pending = _rows.where((r) => !r.alreadyMarked).toList();
// // //   //
// // //   //   if (pending.isEmpty) {
// // //   //     _snack('Sabki attendance already mark ho chuki hai',
// // //   //         Colors.blue, Icons.info_rounded);
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   final incomplete = pending.where((r) => r.attendanceStatus == null);
// // //   //   if (incomplete.isNotEmpty) {
// // //   //     _snack('${incomplete.length} teacher(s) ka status select karo',
// // //   //         Colors.orange, Icons.warning_rounded);
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   setState(() => _saving = true);
// // //   //
// // //   //   int successCount = 0;
// // //   //   final createVm =
// // //   //   Provider.of<CreateTeacherAttendanceViewModel>(context, listen: false);
// // //   //
// // //   //   for (final row in pending) {
// // //   //     final ok = await createVm.createTeacherAttendanceApi(
// // //   //       int.parse(row.id),
// // //   //       _apiDate,
// // //   //       row.attendanceStatus!,
// // //   //       row.remarksCtrl.text.trim(),
// // //   //       context,
// // //   //     );
// // //   //     if (ok) {
// // //   //       successCount++;
// // //   //       setState(() {
// // //   //         row.alreadyMarked = true;
// // //   //         row.markedStatus = row.attendanceStatus;
// // //   //       });
// // //   //     }
// // //   //   }
// // //   //
// // //   //   setState(() => _saving = false);
// // //   //   if (!mounted) return;
// // //   //   _snack('$successCount/${pending.length} attendance save ho gayi',
// // //   //       Colors.green, Icons.check_circle_rounded);
// // //   // }
// // //   Future<void> _saveAll() async {
// // //     final pending = _rows.where((r) => !r.alreadyMarked).toList();
// // //
// // //     if (pending.isEmpty) {
// // //       _snack(
// // //         'Attendance has already been marked for all teachers.',
// // //         Colors.blue,
// // //         Icons.info_rounded,
// // //       );
// // //       return;
// // //     }
// // //
// // //     final incomplete =
// // //     pending.where((r) => r.attendanceStatus == null).toList();
// // //
// // //     if (incomplete.isNotEmpty) {
// // //       _snack(
// // //         '${incomplete.length} teacher(s) attendance status is not selected.',
// // //         Colors.orange,
// // //         Icons.warning_rounded,
// // //       );
// // //       return;
// // //     }
// // //
// // //     setState(() => _saving = true);
// // //
// // //     int successCount = 0;
// // //     final createVm =
// // //     Provider.of<CreateTeacherAttendanceViewModel>(context, listen: false);
// // //
// // //     for (final row in pending) {
// // //       final ok = await createVm.createTeacherAttendanceApi(
// // //         int.parse(row.id),
// // //         _apiDate,
// // //         row.attendanceStatus!,
// // //         row.remarksCtrl.text.trim(),
// // //         context,
// // //       );
// // //
// // //       if (ok) {
// // //         successCount++;
// // //         setState(() {
// // //           row.alreadyMarked = true;
// // //           row.markedStatus = row.attendanceStatus;
// // //         });
// // //       }
// // //     }
// // //
// // //     setState(() => _saving = false);
// // //     if (!mounted) return;
// // //
// // //     // _snack(
// // //     //   '$successCount out of ${pending.length} teacher(s) attendance saved successfully.',
// // //     //   Colors.green,
// // //     //   Icons.check_circle_rounded,
// // //     // );
// // //   }
// // //   void _snack(String msg, Color color, IconData icon) {
// // //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// // //       content: Row(children: [
// // //         Icon(icon, color: Colors.white, size: 18),
// // //         const SizedBox(width: 8),
// // //         Expanded(child: Text(msg)),
// // //       ]),
// // //       backgroundColor: color,
// // //       behavior: SnackBarBehavior.floating,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //     ));
// // //   }
// // //
// // //   // ─────────────────────────────────────────────
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final hasPending = _rows.any((r) => !r.alreadyMarked);
// // //
// // //     return Scaffold(
// // //       backgroundColor: AppColor.screenBg,
// // //       body: Column(children: [
// // //         _buildHeader(),
// // //         Expanded(child: _buildBody()),
// // //       ]),
// // //       floatingActionButton: hasPending
// // //           ? Container(
// // //         width: double.infinity,
// // //         margin: const EdgeInsets.symmetric(horizontal: 16),
// // //         child:
// // //         Row(children: [
// // //           // FloatingActionButton(
// // //           //   heroTag: 'mark_all_p',
// // //           //   onPressed: _saving ? null : _markAllPresent,
// // //           //   backgroundColor: const Color(0xFF22C55E),
// // //           //   tooltip: 'Mark All Present',
// // //           //   child: const Icon(Icons.done_all_rounded, color: Colors.white),
// // //           // ),
// // //           // const SizedBox(width: 12),
// // //           Expanded(
// // //             child: FloatingActionButton.extended(
// // //               heroTag: 'save_all_btn',
// // //               onPressed: _saving ? null : _saveAll,
// // //               backgroundColor: AppColor.lightBlueColor,
// // //               elevation: 4,
// // //               icon: _saving
// // //                   ? const SizedBox(
// // //                   width: 18, height: 18,
// // //                   child: CircularProgressIndicator(
// // //                       color: Colors.white, strokeWidth: 2))
// // //                   : const Icon(Icons.save_rounded, color: Colors.white),
// // //               label: Text(
// // //                 _saving ? 'Saving...' : 'Save All Attendance',
// // //                 style: const TextStyle(
// // //                     color: Colors.white,
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 15),
// // //               ),
// // //             ),
// // //           ),
// // //         ]),
// // //       )
// // //           : null,
// // //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// // //     );
// // //   }
// // //
// // //   // ── HEADER ──
// // //   Widget _buildHeader() {
// // //     return Container(
// // //       padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
// // //       decoration: BoxDecoration(
// // //         gradient: AppColor.primaryGradient,
// // //         borderRadius:
// // //         const BorderRadius.vertical(bottom: Radius.circular(28)),
// // //         boxShadow: [
// // //           BoxShadow(
// // //               color: AppColor.blueShadow,
// // //               blurRadius: 18,
// // //               offset: const Offset(0, 10))
// // //         ],
// // //       ),
// // //       child: Column(children: [
// // //         Row(children: [
// // //           InkWell(
// // //             onTap: () => Navigator.pop(context),
// // //             child: Container(
// // //               padding: const EdgeInsets.all(10),
// // //               decoration: BoxDecoration(
// // //                   color: AppColor.glassWhite, shape: BoxShape.circle),
// // //               child: const Icon(Icons.arrow_back_ios_new_rounded,
// // //                   color: Colors.white, size: 20),
// // //             ),
// // //           ),
// // //           const SizedBox(width: 12),
// // //           Expanded(
// // //             child: AppText.customText('Teacher Attendance',
// // //                 size: 19, weight: FontWeight.bold, color: Colors.white),
// // //           ),
// // //         ]),
// // //         const SizedBox(height: 16),
// // //
// // //         // Date picker
// // //         GestureDetector(
// // //           onTap: _pickDate,
// // //           child: Container(
// // //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white.withOpacity(0.15),
// // //               borderRadius: BorderRadius.circular(16),
// // //               border: Border.all(color: Colors.white.withOpacity(0.3)),
// // //             ),
// // //             child: Row(children: [
// // //               Container(
// // //                 padding: const EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                     color: Colors.white.withOpacity(0.2),
// // //                     borderRadius: BorderRadius.circular(10)),
// // //                 child: const Icon(Icons.calendar_month_rounded,
// // //                     color: Colors.white, size: 18),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               Expanded(
// // //                 child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       AppText.customText('Selected Date',
// // //                           size: 11, color: Colors.white70),
// // //                       AppText.customText(_displayDate,
// // //                           size: 15, weight: FontWeight.bold, color: Colors.white),
// // //                     ]),
// // //               ),
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(
// // //                     horizontal: 10, vertical: 5),
// // //                 decoration: BoxDecoration(
// // //                     color: Colors.white.withOpacity(0.2),
// // //                     borderRadius: BorderRadius.circular(20)),
// // //                 child: Row(children: [
// // //                   const Icon(Icons.edit_calendar_rounded,
// // //                       color: Colors.white, size: 13),
// // //                   const SizedBox(width: 4),
// // //                   AppText.customText('Change', size: 11, color: Colors.white),
// // //                 ]),
// // //               ),
// // //             ]),
// // //           ),
// // //         ),
// // //
// // //         const SizedBox(height: 14),
// // //
// // //         // Status legend
// // //         SingleChildScrollView(
// // //           scrollDirection: Axis.horizontal,
// // //           child: Row(
// // //             children: _statuses.map((s) {
// // //               final color = _statusColor(s['code']);
// // //               return Container(
// // //                 margin: const EdgeInsets.only(right: 8),
// // //                 padding: const EdgeInsets.symmetric(
// // //                     horizontal: 10, vertical: 5),
// // //                 decoration: BoxDecoration(
// // //                   color: color.withOpacity(0.2),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   border: Border.all(color: color.withOpacity(0.5)),
// // //                 ),
// // //                 child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //                   Container(
// // //                       width: 8, height: 8,
// // //                       decoration: BoxDecoration(
// // //                           color: color, shape: BoxShape.circle)),
// // //                   const SizedBox(width: 5),
// // //                   Text('${s['code']} = ${s['full']}',
// // //                       style: const TextStyle(
// // //                           color: Colors.white,
// // //                           fontSize: 11,
// // //                           fontWeight: FontWeight.w500)),
// // //                 ]),
// // //               );
// // //             }).toList(),
// // //           ),
// // //         ),
// // //       ]),
// // //     );
// // //   }
// // //
// // //   // ── BODY ──
// // //   Widget _buildBody() {
// // //     if (_loadingRows) {
// // //       return Center(
// // //           child:
// // //           CircularProgressIndicator(color: AppColor.lightBlueColor));
// // //     }
// // //
// // //     if (_rows.isEmpty) {
// // //       return Center(
// // //         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// // //           Icon(Icons.people_outline_rounded,
// // //               size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
// // //           const SizedBox(height: 16),
// // //           AppText.customText('No Teachers Found',
// // //               size: 16, weight: FontWeight.bold),
// // //         ]),
// // //       );
// // //     }
// // //
// // //     final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
// // //     final pendingCount = _rows.length - alreadyCount;
// // //
// // //     return Column(children: [
// // //       Padding(
// // //         padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
// // //         child: Row(children: [
// // //           if (alreadyCount > 0) ...[
// // //             _countPill('$alreadyCount Already Marked', Colors.green,
// // //                 Icons.check_circle_rounded),
// // //             const SizedBox(width: 8),
// // //           ],
// // //           if (pendingCount > 0)
// // //             _countPill('$pendingCount Pending', Colors.orange,
// // //                 Icons.pending_rounded),
// // //           const Spacer(),
// // //           Text('Total: ${_rows.length}',
// // //               style: TextStyle(
// // //                   fontSize: 12,
// // //                   color: AppColor.softGreyText,
// // //                   fontWeight: FontWeight.w500)),
// // //         ]),
// // //       ),
// // //       Expanded(
// // //         child: ListView.builder(
// // //           padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
// // //           itemCount: _rows.length,
// // //           itemBuilder: (_, i) => _buildTeacherCard(_rows[i]),
// // //         ),
// // //       ),
// // //     ]);
// // //   }
// // //
// // //   // ── Single teacher card ──
// // //   Widget _buildTeacherCard(_TeacherRow row) {
// // //     if (!row.alreadyMarked && row.attendanceStatus == null) {
// // //       row.attendanceStatus = _statuses.first['code']; // Default selection
// // //     }
// // //     return StatefulBuilder(builder: (context, setRow) {
// // //       final isLocked = row.alreadyMarked;
// // //       final borderColor = isLocked
// // //           ? _statusColor(row.markedStatus).withOpacity(0.4)
// // //           : (row.attendanceStatus != null
// // //           ? _statusColor(row.attendanceStatus).withOpacity(0.3)
// // //           : Colors.grey.shade200);
// // //
// // //       return Container(
// // //         margin: const EdgeInsets.only(bottom: 12),
// // //         decoration: BoxDecoration(
// // //           color: isLocked
// // //               ? _statusColor(row.markedStatus).withOpacity(0.03)
// // //               : Colors.white,
// // //           borderRadius: BorderRadius.circular(16),
// // //           border: Border.all(color: borderColor, width: 1.5),
// // //           boxShadow: [
// // //             BoxShadow(
// // //                 color: AppColor.cardShadow,
// // //                 blurRadius: 6,
// // //                 offset: const Offset(0, 3))
// // //           ],
// // //         ),
// // //         child: Column(children: [
// // //           // ── Top row ──
// // //           Padding(
// // //             padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
// // //             child: Row(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   // Avatar
// // //                   Container(
// // //                     width: 40, height: 40,
// // //                     decoration: BoxDecoration(
// // //                       color: isLocked
// // //                           ? _statusColor(row.markedStatus).withOpacity(0.12)
// // //                           : AppColor.lightBlueColor.withOpacity(0.12),
// // //                       shape: BoxShape.circle,
// // //                     ),
// // //                     child: Center(
// // //                       child: Text(
// // //                         row.name.isNotEmpty ? row.name[0].toUpperCase() : '?',
// // //                         style: TextStyle(
// // //                             fontSize: 15,
// // //                             fontWeight: FontWeight.bold,
// // //                             color: isLocked
// // //                                 ? _statusColor(row.markedStatus)
// // //                                 : AppColor.lightBlueColor),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 10),
// // //
// // //                   // Name
// // //                   Expanded(
// // //                     child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(_cap(row.name),
// // //                               style: const TextStyle(
// // //                                   fontSize: 13, fontWeight: FontWeight.bold)),
// // //                           const SizedBox(height: 2),
// // //                           Text('ID: ${row.id}',
// // //                               style: TextStyle(
// // //                                   fontSize: 11, color: AppColor.softGreyText)),
// // //                         ]),
// // //                   ),
// // //
// // //                   // Already marked badge
// // //                   if (isLocked)
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 8, vertical: 4),
// // //                       decoration: BoxDecoration(
// // //                         color: _statusColor(row.markedStatus).withOpacity(0.12),
// // //                         borderRadius: BorderRadius.circular(20),
// // //                         border: Border.all(
// // //                             color: _statusColor(row.markedStatus)
// // //                                 .withOpacity(0.4)),
// // //                       ),
// // //                       child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //                         Icon(Icons.lock_rounded,
// // //                             size: 10,
// // //                             color: _statusColor(row.markedStatus)),
// // //                         const SizedBox(width: 3),
// // //                         Text(
// // //                           '${_statusLabel(row.markedStatus)} • Marked',
// // //                           style: TextStyle(
// // //                               fontSize: 10,
// // //                               fontWeight: FontWeight.w600,
// // //                               color: _statusColor(row.markedStatus)),
// // //                         ),
// // //                       ]),
// // //                     ),
// // //                 ]),
// // //           ),
// // //
// // //           Divider(height: 1, color: Colors.grey.shade100),
// // //
// // //           // ── Status chips ──
// // //           Padding(
// // //             padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
// // //             child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   AppText.customText('ATTENDANCE STATUS',
// // //                       size: 10,
// // //                       weight: FontWeight.bold,
// // //                       color: AppColor.softGreyText),
// // //                   const SizedBox(height: 8),
// // //                   Row(
// // //                     children: _statuses.map((s) {
// // //                       final code = s['code']!;
// // //                       final selected = row.attendanceStatus == code;
// // //                       final color = _statusColor(code);
// // //                       return Expanded(
// // //                         child: GestureDetector(
// // //                           onTap: isLocked
// // //                               ? null
// // //                               : () => setRow(() => row.attendanceStatus =
// // //                           selected ? null : code),
// // //                           child: AnimatedContainer(
// // //                             duration: const Duration(milliseconds: 180),
// // //                             margin: const EdgeInsets.only(right: 5),
// // //                             padding: const EdgeInsets.symmetric(vertical: 8),
// // //                             decoration: BoxDecoration(
// // //                               color: selected
// // //                                   ? color.withOpacity(0.15)
// // //                                   : (isLocked
// // //                                   ? Colors.grey.shade100
// // //                                   : Colors.grey.shade50),
// // //                               borderRadius: BorderRadius.circular(10),
// // //                               border: Border.all(
// // //                                   color:
// // //                                   selected ? color : Colors.grey.shade200,
// // //                                   width: selected ? 1.5 : 1),
// // //                             ),
// // //                             child: Column(
// // //                                 mainAxisSize: MainAxisSize.min,
// // //                                 children: [
// // //                                   Container(
// // //                                     width: 14, height: 14,
// // //                                     decoration: BoxDecoration(
// // //                                       shape: BoxShape.circle,
// // //                                       border: Border.all(
// // //                                           color: selected
// // //                                               ? color
// // //                                               : Colors.grey.shade400,
// // //                                           width: 1.5),
// // //                                     ),
// // //                                     child: selected
// // //                                         ? Center(
// // //                                         child: Container(
// // //                                             width: 7, height: 7,
// // //                                             decoration: BoxDecoration(
// // //                                                 shape: BoxShape.circle,
// // //                                                 color: color)))
// // //                                         : null,
// // //                                   ),
// // //                                   const SizedBox(height: 4),
// // //                                   Text(code,
// // //                                       style: TextStyle(
// // //                                           fontSize: 10,
// // //                                           fontWeight: FontWeight.bold,
// // //                                           color: selected
// // //                                               ? color
// // //                                               : (isLocked
// // //                                               ? Colors.grey.shade400
// // //                                               : AppColor.softGreyText))),
// // //                                 ]),
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                 ]),
// // //           ),
// // //
// // //           // ── Remarks ──
// // //           Padding(
// // //             padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
// // //             child: TextField(
// // //               controller: row.remarksCtrl,
// // //               enabled: !isLocked,
// // //               style: const TextStyle(fontSize: 12),
// // //               decoration: InputDecoration(
// // //                 isDense: true,
// // //                 hintText: isLocked
// // //                     ? 'Attendance already marked'
// // //                     : 'Enter remarks...',
// // //                 hintStyle: TextStyle(
// // //                     color: isLocked
// // //                         ? _statusColor(row.markedStatus).withOpacity(0.6)
// // //                         : AppColor.softGreyText,
// // //                     fontSize: 12),
// // //                 filled: true,
// // //                 fillColor: isLocked
// // //                     ? _statusColor(row.markedStatus).withOpacity(0.04)
// // //                     : Colors.grey.shade50,
// // //                 contentPadding: const EdgeInsets.symmetric(
// // //                     horizontal: 12, vertical: 10),
// // //                 prefixIcon: isLocked
// // //                     ? Icon(Icons.lock_rounded,
// // //                     size: 14, color: _statusColor(row.markedStatus))
// // //                     : null,
// // //                 border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                     borderSide: BorderSide(color: Colors.grey.shade200)),
// // //                 enabledBorder: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                     borderSide: BorderSide(color: Colors.grey.shade200)),
// // //                 disabledBorder: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                     borderSide: BorderSide(
// // //                         color: _statusColor(row.markedStatus)
// // //                             .withOpacity(0.2))),
// // //                 focusedBorder: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                     borderSide: BorderSide(
// // //                         color: AppColor.lightBlueColor, width: 1.5)),
// // //               ),
// // //             ),
// // //           ),
// // //         ]),
// // //       );
// // //     });
// // //   }
// // //
// // //   Widget _countPill(String label, Color color, IconData icon) => Container(
// // //     padding:
// // //     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // //     decoration: BoxDecoration(
// // //       color: color.withOpacity(0.1),
// // //       borderRadius: BorderRadius.circular(20),
// // //       border: Border.all(color: color.withOpacity(0.3)),
// // //     ),
// // //     child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //       Icon(icon, size: 13, color: color),
// // //       const SizedBox(width: 4),
// // //       Text(label,
// // //           style: TextStyle(
// // //               color: color,
// // //               fontSize: 12,
// // //               fontWeight: FontWeight.w600)),
// // //     ]),
// // //   );
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
// // import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
// // import '../../res/app_color.dart';
// // import '../../res/const_text.dart';
// // import '../view_model/school_view_model/update_teacher_attendance_view_model.dart';
// // import '../view_model/teacher_view_model/create_teacher_attendance_view_model.dart';
// //
// // // ─────────────────────────────────────────────────────────────────────────────
// // // Model
// // // ─────────────────────────────────────────────────────────────────────────────
// // // class _TeacherRow {
// // //   final String id;
// // //   final String name;
// // //   String? attendanceStatus;
// // //   bool alreadyMarked;
// // //   bool isEditing; // ← NEW: unlocked for edit
// // //   String? markedStatus;
// // //   final TextEditingController remarksCtrl;
// // //
// // //   _TeacherRow({
// // //     required this.id,
// // //     required this.name,
// // //     this.attendanceStatus,
// // //     this.alreadyMarked = false,
// // //     this.isEditing = false,
// // //     this.markedStatus,
// // //   }) : remarksCtrl = TextEditingController();
// // //
// // //   void dispose() => remarksCtrl.dispose();
// // // }
// // class _TeacherRow {
// //   final String id;
// //   final String name;
// //   String? attendanceStatus;
// //   bool alreadyMarked;
// //   bool isEditing;
// //   String? markedStatus;
// //   String? attendanceId;                    // ✅ add
// //   final TextEditingController remarksCtrl;
// //
// //   _TeacherRow({
// //     required this.id,
// //     required this.name,
// //     this.attendanceStatus,
// //     this.alreadyMarked = false,
// //     this.isEditing = false,
// //     this.markedStatus,
// //     this.attendanceId,                     // ✅ add
// //   }) : remarksCtrl = TextEditingController();
// //
// //   void dispose() => remarksCtrl.dispose();
// // }
// // // ─────────────────────────────────────────────────────────────────────────────
// // // Screen
// // // ─────────────────────────────────────────────────────────────────────────────
// // class TeacherAttendanceScreen extends StatefulWidget {
// //   const TeacherAttendanceScreen({super.key});
// //
// //   @override
// //   State<TeacherAttendanceScreen> createState() =>
// //       _TeacherAttendanceScreenState();
// // }
// //
// // class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
// //   DateTime _selectedDate = DateTime.now();
// //   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
// //   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
// //
// //   List<_TeacherRow> _rows = [];
// //   bool _saving = false;
// //   bool _loadingRows = false;
// //
// //   static const _statuses = [
// //     {'code': 'P', 'full': 'Present'},
// //     {'code': 'A', 'full': 'Absent'},
// //     {'code': 'L', 'full': 'Leave'},
// //     {'code': 'H', 'full': 'Half Day'},
// //     {'code': 'OL', 'full': 'On Leave'},
// //   ];
// //
// //   // ── Helpers ───────────────────────────────────────────────────────────────
// //   Color _statusColor(String? s) {
// //     switch (s) {
// //       case 'P':
// //         return const Color(0xFF22C55E);
// //       case 'A':
// //         return const Color(0xFFEF4444);
// //       case 'L':
// //         return const Color(0xFFF59E0B);
// //       case 'H':
// //         return const Color(0xFFA855F7);
// //       case 'OL':
// //         return const Color(0xFF3B82F6);
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   IconData _statusIcon(String? s) {
// //     switch (s) {
// //       case 'P':
// //         return Icons.check_circle_rounded;
// //       case 'A':
// //         return Icons.cancel_rounded;
// //       case 'L':
// //         return Icons.event_busy_rounded;
// //       case 'H':
// //         return Icons.av_timer_rounded;
// //       case 'OL':
// //         return Icons.medical_services_rounded;
// //       default:
// //         return Icons.help_outline_rounded;
// //     }
// //   }
// //
// //   String _statusLabel(String? s) {
// //     switch (s) {
// //       case 'P':
// //         return 'Present';
// //       case 'A':
// //         return 'Absent';
// //       case 'L':
// //         return 'Leave';
// //       case 'H':
// //         return 'Half Day';
// //       case 'OL':
// //         return 'On Leave';
// //       default:
// //         return s ?? '';
// //     }
// //   }
// //
// //   String _cap(String t) =>
// //       t.isEmpty ? t : t[0].toUpperCase() + t.substring(1);
// //
// //   // ── Lifecycle ─────────────────────────────────────────────────────────────
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await Provider.of<AllTeachersListVieModel>(context, listen: false)
// //           .allTeachersListApi(context);
// //       await _fetchAndBuildRows();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     for (final r in _rows) r.dispose();
// //     super.dispose();
// //   }
// //
// //   // ── Fetch + build rows ────────────────────────────────────────────────────
// //   // Future<void> _fetchAndBuildRows() async {
// //   //   setState(() => _loadingRows = true);
// //   //
// //   //   await context
// //   //       .read<TeacherAttendanceViewModel>()
// //   //       .getTeacherAttendance(_apiDate);
// //   //
// //   //   final attVm =
// //   //   Provider.of<TeacherAttendanceViewModel>(context, listen: false);
// //   //   final markedList = attVm.attendanceList;
// //   //
// //   //   final Map<String, String> markedMap = {
// //   //     for (final r in markedList)
// //   //       if (r.teacherId != null) r.teacherId.toString(): r.status ?? '',
// //   //   };
// //   //
// //   //   final allTeachers =
// //   //       Provider.of<AllTeachersListVieModel>(context, listen: false)
// //   //           .allTeachersListModel
// //   //           ?.data ??
// //   //           [];
// //   //
// //   //   for (final r in _rows) r.dispose();
// //   //
// //   //   setState(() {
// //   //     _rows = allTeachers.map((t) {
// //   //       final id = t.teacherId.toString();
// //   //       final already = markedMap.containsKey(id);
// //   //       return _TeacherRow(
// //   //         id: id,
// //   //         name: t.name ?? '',
// //   //         alreadyMarked: already,
// //   //         isEditing: false,
// //   //         markedStatus: markedMap[id],
// //   //         attendanceStatus: already ? markedMap[id] : null,
// //   //       );
// //   //     }).toList();
// //   //     _loadingRows = false;
// //   //   });
// //   // }
// //   Future<void> _fetchAndBuildRows() async {
// //     setState(() => _loadingRows = true);
// //
// //     await context
// //         .read<TeacherAttendanceViewModel>()
// //         .getTeacherAttendance(_apiDate);
// //
// //     final attVm = Provider.of<TeacherAttendanceViewModel>(context, listen: false);
// //     final markedList = attVm.attendanceList;
// //
// //     // ✅ attendanceId bhi capture karo
// //     final Map<String, Map<String, String>> markedMap = {
// //       for (final r in markedList)
// //         if (r.teacherId != null)
// //           r.teacherId.toString(): {
// //             'status'      : r.status ?? '',
// //             'attendanceId': r.attendanceId?.toString() ?? '', // ← apne model ka field name
// //           },
// //     };
// //
// //     final allTeachers =
// //         Provider.of<AllTeachersListVieModel>(context, listen: false)
// //             .allTeachersListModel
// //             ?.data ?? [];
// //
// //     for (final r in _rows) r.dispose();
// //
// //     setState(() {
// //       _rows = allTeachers.map((t) {
// //         final id      = t.teacherId.toString();
// //         final already = markedMap.containsKey(id);
// //         return _TeacherRow(
// //           id              : id,
// //           name            : t.name ?? '',
// //           alreadyMarked   : already,
// //           isEditing       : false,
// //           markedStatus    : already ? markedMap[id]!['status'] : null,
// //           attendanceStatus: already ? markedMap[id]!['status'] : null,
// //           attendanceId    : already ? markedMap[id]!['attendanceId'] : null, // ✅
// //         );
// //       }).toList();
// //       _loadingRows = false;
// //     });
// //   }
// //   // ── Pull-to-refresh ───────────────────────────────────────────────────────
// //   Future<void> _onRefresh() async {
// //     for (final r in _rows) r.dispose();
// //     setState(() => _rows = []);
// //     await Provider.of<AllTeachersListVieModel>(context, listen: false)
// //         .allTeachersListApi(context);
// //     await _fetchAndBuildRows();
// //   }
// //
// //   // ── Date picker ───────────────────────────────────────────────────────────
// //   Future<void> _pickDate() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime.now(),
// //       builder: (c, child) => Theme(
// //         data: Theme.of(c).copyWith(
// //           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
// //         ),
// //         child: child!,
// //       ),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() => _selectedDate = picked);
// //       await _fetchAndBuildRows();
// //     }
// //   }
// //
// //   // ── Mark all present ──────────────────────────────────────────────────────
// //   void _markAllPresent() {
// //     setState(() {
// //       for (final r in _rows) {
// //         if (!r.alreadyMarked) r.attendanceStatus = 'P';
// //       }
// //     });
// //   }
// //
// //   // ── Save NEW attendance ───────────────────────────────────────────────────
// //   Future<void> _saveAll() async {
// //     final pending = _rows.where((r) => !r.alreadyMarked).toList();
// //
// //     if (pending.isEmpty) {
// //       _snack('Attendance has already been marked for all teachers.',
// //           Colors.blue, Icons.info_rounded);
// //       return;
// //     }
// //
// //     final incomplete =
// //     pending.where((r) => r.attendanceStatus == null).toList();
// //     if (incomplete.isNotEmpty) {
// //       _snack(
// //           '${incomplete.length} teacher(s) attendance status is not selected.',
// //           Colors.orange,
// //           Icons.warning_rounded);
// //       return;
// //     }
// //
// //     setState(() => _saving = true);
// //
// //     int successCount = 0;
// //     final createVm = Provider.of<CreateTeacherAttendanceViewModel>(
// //         context,
// //         listen: false);
// //
// //     for (final row in pending) {
// //       final ok = await createVm.createTeacherAttendanceApi(
// //         int.parse(row.id),
// //         _apiDate,
// //         row.attendanceStatus!,
// //         row.remarksCtrl.text.trim(),
// //         context,
// //       );
// //       if (ok) {
// //         successCount++;
// //         setState(() {
// //           row.alreadyMarked = true;
// //           row.isEditing = false;
// //           row.markedStatus = row.attendanceStatus;
// //         });
// //       }
// //     }
// //
// //     setState(() => _saving = false);
// //     if (!mounted) return;
// //
// //     if (successCount > 0) {
// //       _snack(
// //           '$successCount out of ${pending.length} teacher(s) saved successfully.',
// //           Colors.green,
// //           Icons.check_circle_rounded);
// //     }
// //   }
// //
// //   // ── Update EXISTING attendance (edit flow) ────────────────────────────────
// //   Future<void> _updateAttendance(_TeacherRow row, StateSetter setRow) async {
// //     if (row.attendanceStatus == null) {
// //       _snack('Please select a status before saving.',
// //           Colors.orange, Icons.warning_rounded);
// //       return;
// //     }
// //
// //     if (row.attendanceId == null || row.attendanceId!.isEmpty) {
// //       _snack('Attendance ID not found. Please refresh and try again.',
// //           Colors.red, Icons.error_rounded);
// //       return;
// //     }
// //
// //     setState(() => _saving = true);
// //
// //     final ok = await Provider.of<UpdateTeacherAttendanceViewModel>(
// //       context,
// //       listen: false,
// //     ).updateTeacherAttendanceApi(
// //       int.parse(row.attendanceId!),   // attendance_id
// //       row.attendanceStatus!,          // status
// //       row.remarksCtrl.text.trim(),    // remarks
// //       context,
// //     );
// //
// //     setState(() => _saving = false);
// //
// //     if (ok) {
// //       setRow(() {
// //         row.alreadyMarked = true;
// //         row.isEditing     = false;
// //         row.markedStatus  = row.attendanceStatus;
// //       });
// //       if (mounted) {
// //         _snack('Attendance updated successfully.',
// //             Colors.green, Icons.check_circle_rounded);
// //       }
// //     }
// //   }
// //   // Future<void> _updateAttendance(
// //   //     _TeacherRow row, StateSetter setRow) async
// //   // {
// //   //   if (row.attendanceStatus == null) {
// //   //     _snack('Please select a status before saving.', Colors.orange,
// //   //         Icons.warning_rounded);
// //   //     return;
// //   //   }
// //   //
// //   //   setState(() => _saving = true);
// //   //
// //   //   // NOTE: swap createTeacherAttendanceApi with your update VM method
// //   //   // (e.g. updateTeacherAttendanceApi) if your backend uses PUT/PATCH.
// //   //   final createVm = Provider.of<CreateTeacherAttendanceViewModel>(
// //   //       context,
// //   //       listen: false);
// //   //
// //   //   final ok = await createVm.createTeacherAttendanceApi(
// //   //     int.parse(row.id),
// //   //     _apiDate,
// //   //     row.attendanceStatus!,
// //   //     row.remarksCtrl.text.trim(),
// //   //     context,
// //   //   );
// //   //
// //   //   setState(() => _saving = false);
// //   //
// //   //   if (ok) {
// //   //     setRow(() {
// //   //       row.alreadyMarked = true;
// //   //       row.isEditing = false;
// //   //       row.markedStatus = row.attendanceStatus;
// //   //     });
// //   //     if (mounted) {
// //   //       _snack('Attendance updated successfully.', Colors.green,
// //   //           Icons.check_circle_rounded);
// //   //     }
// //   //   }
// //   // }
// //
// //   // ── Snack helper ──────────────────────────────────────────────────────────
// //   void _snack(String msg, Color color, IconData icon) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //       content: Row(children: [
// //         Icon(icon, color: Colors.white, size: 18),
// //         const SizedBox(width: 8),
// //         Expanded(child: Text(msg)),
// //       ]),
// //       backgroundColor: color,
// //       behavior: SnackBarBehavior.floating,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //     ));
// //   }
// //
// //   // ─────────────────────────────────────────────────────────────────────────
// //   // BUILD
// //   // ─────────────────────────────────────────────────────────────────────────
// //   @override
// //   Widget build(BuildContext context) {
// //     final hasPending = _rows.any((r) => !r.alreadyMarked);
// //
// //     return Scaffold(
// //       backgroundColor: AppColor.screenBg,
// //       body: Column(children: [
// //         _buildHeader(),
// //         Expanded(child: _buildBody()),
// //       ]),
// //       floatingActionButton: hasPending
// //           ? Container(
// //         width: double.infinity,
// //         margin: const EdgeInsets.symmetric(horizontal: 16),
// //         child: FloatingActionButton.extended(
// //           heroTag: 'save_all_btn',
// //           onPressed: _saving ? null : _saveAll,
// //           backgroundColor: AppColor.lightBlueColor,
// //           elevation: 4,
// //           icon: _saving
// //               ? const SizedBox(
// //               width: 18,
// //               height: 18,
// //               child: CircularProgressIndicator(
// //                   color: Colors.white, strokeWidth: 2))
// //               : const Icon(Icons.save_rounded, color: Colors.white),
// //           label: Text(
// //             _saving ? 'Saving...' : 'Save All Attendance',
// //             style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 15),
// //           ),
// //         ),
// //       )
// //           : null,
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// //     );
// //   }
// //
// //   // ── HEADER ────────────────────────────────────────────────────────────────
// //   Widget _buildHeader() {
// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
// //       decoration: BoxDecoration(
// //         gradient: AppColor.primaryGradient,
// //         borderRadius:
// //         const BorderRadius.vertical(bottom: Radius.circular(28)),
// //         boxShadow: [
// //           BoxShadow(
// //               color: AppColor.blueShadow,
// //               blurRadius: 18,
// //               offset: const Offset(0, 10))
// //         ],
// //       ),
// //       child: Column(children: [
// //         Row(children: [
// //           InkWell(
// //             onTap: () => Navigator.pop(context),
// //             child: Container(
// //               padding: const EdgeInsets.all(10),
// //               decoration: BoxDecoration(
// //                   color: AppColor.glassWhite, shape: BoxShape.circle),
// //               child: const Icon(Icons.arrow_back_ios_new_rounded,
// //                   color: Colors.white, size: 20),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: AppText.customText('Teacher Attendance',
// //                 size: 19,
// //                 weight: FontWeight.bold,
// //                 color: Colors.white),
// //           ),
// //         ]),
// //         const SizedBox(height: 16),
// //
// //         // Date picker
// //         GestureDetector(
// //           onTap: _pickDate,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(
// //                 horizontal: 16, vertical: 12),
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.15),
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: Colors.white.withOpacity(0.3)),
// //             ),
// //             child: Row(children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(10)),
// //                 child: const Icon(Icons.calendar_month_rounded,
// //                     color: Colors.white, size: 18),
// //               ),
// //               const SizedBox(width: 12),
// //               Expanded(
// //                 child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       AppText.customText('Selected Date',
// //                           size: 11, color: Colors.white70),
// //                       AppText.customText(_displayDate,
// //                           size: 15,
// //                           weight: FontWeight.bold,
// //                           color: Colors.white),
// //                     ]),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(
// //                     horizontal: 10, vertical: 5),
// //                 decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(20)),
// //                 child: Row(children: [
// //                   const Icon(Icons.edit_calendar_rounded,
// //                       color: Colors.white, size: 13),
// //                   const SizedBox(width: 4),
// //                   AppText.customText('Change',
// //                       size: 11, color: Colors.white),
// //                 ]),
// //               ),
// //             ]),
// //           ),
// //         ),
// //
// //         const SizedBox(height: 14),
// //
// //         // Status legend
// //         SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: Row(
// //             children: _statuses.map((s) {
// //               final color = _statusColor(s['code']);
// //               return Container(
// //                 margin: const EdgeInsets.only(right: 8),
// //                 padding: const EdgeInsets.symmetric(
// //                     horizontal: 10, vertical: 5),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(20),
// //                   border: Border.all(color: color.withOpacity(0.5)),
// //                 ),
// //                 child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                   Container(
// //                       width: 8,
// //                       height: 8,
// //                       decoration: BoxDecoration(
// //                           color: color, shape: BoxShape.circle)),
// //                   const SizedBox(width: 5),
// //                   Text('${s['code']} = ${s['full']}',
// //                       style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.w500)),
// //                 ]),
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// //
// //   // ── BODY ──────────────────────────────────────────────────────────────────
// //   Widget _buildBody() {
// //     if (_loadingRows) {
// //       return Center(
// //           child: CircularProgressIndicator(
// //               color: AppColor.lightBlueColor));
// //     }
// //
// //     if (_rows.isEmpty) {
// //       return Center(
// //         child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.people_outline_rounded,
// //                   size: 72,
// //                   color: AppColor.lightBlueColor.withOpacity(0.3)),
// //               const SizedBox(height: 16),
// //               AppText.customText('No Teachers Found',
// //                   size: 16, weight: FontWeight.bold),
// //             ]),
// //       );
// //     }
// //
// //     final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
// //     final pendingCount = _rows.length - alreadyCount;
// //
// //     return Column(children: [
// //       Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
// //         child: Row(children: [
// //           if (alreadyCount > 0) ...[
// //             _countPill('$alreadyCount Already Marked', Colors.green,
// //                 Icons.check_circle_rounded),
// //             const SizedBox(width: 8),
// //           ],
// //           if (pendingCount > 0)
// //             _countPill('$pendingCount Pending', Colors.orange,
// //                 Icons.pending_rounded),
// //           const Spacer(),
// //           Text('Total: ${_rows.length}',
// //               style: TextStyle(
// //                   fontSize: 12,
// //                   color: AppColor.softGreyText,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ),
// //       Expanded(
// //         child: RefreshIndicator(
// //           onRefresh: _onRefresh,
// //           color: AppColor.lightBlueColor,
// //           backgroundColor: Colors.white,
// //           strokeWidth: 2.5,
// //           child: ListView.builder(
// //             padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
// //             itemCount: _rows.length,
// //             itemBuilder: (_, i) => _buildTeacherCard(_rows[i]),
// //           ),
// //         ),
// //       ),
// //     ]);
// //   }
// //
// //   // ── Single teacher card ───────────────────────────────────────────────────
// //   Widget _buildTeacherCard(_TeacherRow row) {
// //     if (!row.alreadyMarked && row.attendanceStatus == null) {
// //       row.attendanceStatus = _statuses.first['code'];
// //     }
// //
// //     return StatefulBuilder(builder: (context, setRow) {
// //       // isLocked = marked AND not currently being edited
// //       final isLocked = row.alreadyMarked && !row.isEditing;
// //
// //       final borderColor = row.isEditing
// //           ? AppColor.lightBlueColor.withOpacity(0.5)
// //           : isLocked
// //           ? _statusColor(row.markedStatus).withOpacity(0.4)
// //           : (row.attendanceStatus != null
// //           ? _statusColor(row.attendanceStatus).withOpacity(0.3)
// //           : Colors.grey.shade200);
// //
// //       return Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         decoration: BoxDecoration(
// //           color: row.isEditing
// //               ? AppColor.lightBlueColor.withOpacity(0.02)
// //               : isLocked
// //               ? _statusColor(row.markedStatus).withOpacity(0.03)
// //               : Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: borderColor, width: 1.5),
// //           boxShadow: [
// //             BoxShadow(
// //                 color: AppColor.cardShadow,
// //                 blurRadius: 6,
// //                 offset: const Offset(0, 3))
// //           ],
// //         ),
// //         child: Column(children: [
// //           // ── Top row ───────────────────────────────────────────────
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
// //             child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Avatar
// //                   Container(
// //                     width: 40,
// //                     height: 40,
// //                     decoration: BoxDecoration(
// //                       color: row.isEditing
// //                           ? AppColor.lightBlueColor.withOpacity(0.15)
// //                           : isLocked
// //                           ? _statusColor(row.markedStatus)
// //                           .withOpacity(0.12)
// //                           : AppColor.lightBlueColor.withOpacity(0.12),
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         row.name.isNotEmpty
// //                             ? row.name[0].toUpperCase()
// //                             : '?',
// //                         style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: FontWeight.bold,
// //                             color: row.isEditing
// //                                 ? AppColor.lightBlueColor
// //                                 : isLocked
// //                                 ? _statusColor(row.markedStatus)
// //                                 : AppColor.lightBlueColor),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //
// //                   // Name + ID
// //                   Expanded(
// //                     child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(_cap(row.name),
// //                               style: const TextStyle(
// //                                   fontSize: 13,
// //                                   fontWeight: FontWeight.bold)),
// //                           const SizedBox(height: 2),
// //                           Text('ID: ${row.id}',
// //                               style: TextStyle(
// //                                   fontSize: 11,
// //                                   color: AppColor.softGreyText)),
// //                         ]),
// //                   ),
// //
// //                   // ── RIGHT-SIDE BADGES ──────────────────────────────
// //                   Column(
// //                       crossAxisAlignment: CrossAxisAlignment.end,
// //                       children: [
// //                         // Already marked: status badge + Edit button
// //                         if (isLocked) ...[
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: _statusColor(row.markedStatus)
// //                                   .withOpacity(0.12),
// //                               borderRadius: BorderRadius.circular(20),
// //                               border: Border.all(
// //                                   color: _statusColor(row.markedStatus)
// //                                       .withOpacity(0.4)),
// //                             ),
// //                             child: Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Icon(Icons.lock_rounded,
// //                                       size: 10,
// //                                       color: _statusColor(
// //                                           row.markedStatus)),
// //                                   const SizedBox(width: 3),
// //                                   Text(
// //                                     '${_statusLabel(row.markedStatus)} • Marked',
// //                                     style: TextStyle(
// //                                         fontSize: 10,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: _statusColor(
// //                                             row.markedStatus)),
// //                                   ),
// //                                 ]),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           // ── EDIT BUTTON ──
// //                           GestureDetector(
// //                             onTap: () =>
// //                                 setRow(() => row.isEditing = true),
// //                             child: Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 4),
// //                               decoration: BoxDecoration(
// //                                 color: AppColor.lightBlueColor
// //                                     .withOpacity(0.1),
// //                                 borderRadius:
// //                                 BorderRadius.circular(20),
// //                                 border: Border.all(
// //                                     color: AppColor.lightBlueColor
// //                                         .withOpacity(0.4)),
// //                               ),
// //                               child: Row(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     Icon(Icons.edit_rounded,
// //                                         size: 10,
// //                                         color: AppColor.lightBlueColor),
// //                                     const SizedBox(width: 3),
// //                                     Text('Edit',
// //                                         style: TextStyle(
// //                                             color:
// //                                             AppColor.lightBlueColor,
// //                                             fontSize: 10,
// //                                             fontWeight:
// //                                             FontWeight.w600)),
// //                                   ]),
// //                             ),
// //                           ),
// //                         ],
// //
// //                         // Editing mode: badge + Cancel button
// //                         if (row.isEditing) ...[
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: AppColor.lightBlueColor
// //                                   .withOpacity(0.12),
// //                               borderRadius:
// //                               BorderRadius.circular(20),
// //                               border: Border.all(
// //                                   color: AppColor.lightBlueColor
// //                                       .withOpacity(0.4)),
// //                             ),
// //                             child: Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Icon(Icons.edit_rounded,
// //                                       size: 10,
// //                                       color: AppColor.lightBlueColor),
// //                                   const SizedBox(width: 3),
// //                                   Text('Editing',
// //                                       style: TextStyle(
// //                                           color: AppColor.lightBlueColor,
// //                                           fontSize: 10,
// //                                           fontWeight: FontWeight.w600)),
// //                                 ]),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           // Cancel button
// //                           GestureDetector(
// //                             onTap: () =>
// //                                 setRow(() => row.isEditing = false),
// //                             child: Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 4),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.red.withOpacity(0.1),
// //                                 borderRadius:
// //                                 BorderRadius.circular(20),
// //                                 border: Border.all(
// //                                     color:
// //                                     Colors.red.withOpacity(0.4)),
// //                               ),
// //                               child: Row(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: const [
// //                                     Icon(Icons.close_rounded,
// //                                         size: 10, color: Colors.red),
// //                                     SizedBox(width: 3),
// //                                     Text('Cancel',
// //                                         style: TextStyle(
// //                                             color: Colors.red,
// //                                             fontSize: 10,
// //                                             fontWeight:
// //                                             FontWeight.w600)),
// //                                   ]),
// //                             ),
// //                           ),
// //                         ],
// //                       ]),
// //                 ]),
// //           ),
// //
// //           Divider(height: 1, color: Colors.grey.shade100),
// //
// //           // ── Status chips ───────────────────────────────────────────
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
// //             child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(children: [
// //                     AppText.customText('ATTENDANCE STATUS',
// //                         size: 10,
// //                         weight: FontWeight.bold,
// //                         color: AppColor.softGreyText),
// //                     if (row.isEditing) ...[
// //                       const SizedBox(width: 6),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 6, vertical: 2),
// //                         decoration: BoxDecoration(
// //                           color: AppColor.lightBlueColor
// //                               .withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: Text('Edit Mode',
// //                             style: TextStyle(
// //                                 color: AppColor.lightBlueColor,
// //                                 fontSize: 9,
// //                                 fontWeight: FontWeight.w600)),
// //                       ),
// //                     ],
// //                   ]),
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: _statuses.map((s) {
// //                       final code = s['code']!;
// //                       final selected = row.attendanceStatus == code;
// //                       final color = _statusColor(code);
// //                       return Expanded(
// //                         child: GestureDetector(
// //                           onTap: isLocked
// //                               ? null
// //                               : () => setRow(() =>
// //                           row.attendanceStatus =
// //                           selected ? null : code),
// //                           child: AnimatedContainer(
// //                             duration: const Duration(milliseconds: 180),
// //                             margin: const EdgeInsets.only(right: 5),
// //                             padding: const EdgeInsets.symmetric(
// //                                 vertical: 8),
// //                             decoration: BoxDecoration(
// //                               color: selected
// //                                   ? color.withOpacity(0.15)
// //                                   : (isLocked
// //                                   ? Colors.grey.shade100
// //                                   : Colors.grey.shade50),
// //                               borderRadius: BorderRadius.circular(10),
// //                               border: Border.all(
// //                                   color: selected
// //                                       ? color
// //                                       : Colors.grey.shade200,
// //                                   width: selected ? 1.5 : 1),
// //                             ),
// //                             child: Column(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Container(
// //                                     width: 14,
// //                                     height: 14,
// //                                     decoration: BoxDecoration(
// //                                       shape: BoxShape.circle,
// //                                       border: Border.all(
// //                                           color: selected
// //                                               ? color
// //                                               : Colors.grey.shade400,
// //                                           width: 1.5),
// //                                     ),
// //                                     child: selected
// //                                         ? Center(
// //                                         child: Container(
// //                                             width: 7,
// //                                             height: 7,
// //                                             decoration:
// //                                             BoxDecoration(
// //                                                 shape: BoxShape
// //                                                     .circle,
// //                                                 color: color)))
// //                                         : null,
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(code,
// //                                       style: TextStyle(
// //                                           fontSize: 10,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: selected
// //                                               ? color
// //                                               : (isLocked
// //                                               ? Colors.grey.shade400
// //                                               : AppColor
// //                                               .softGreyText))),
// //                                 ]),
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ]),
// //           ),
// //
// //           // ── Remarks ────────────────────────────────────────────────
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
// //             child: TextField(
// //               controller: row.remarksCtrl,
// //               enabled: !isLocked,
// //               style: const TextStyle(fontSize: 12),
// //               decoration: InputDecoration(
// //                 isDense: true,
// //                 hintText: isLocked
// //                     ? 'Attendance already marked'
// //                     : row.isEditing
// //                     ? 'Update remarks...'
// //                     : 'Enter remarks...',
// //                 hintStyle: TextStyle(
// //                     color: isLocked
// //                         ? _statusColor(row.markedStatus).withOpacity(0.6)
// //                         : AppColor.softGreyText,
// //                     fontSize: 12),
// //                 filled: true,
// //                 fillColor: row.isEditing
// //                     ? AppColor.lightBlueColor.withOpacity(0.04)
// //                     : isLocked
// //                     ? _statusColor(row.markedStatus).withOpacity(0.04)
// //                     : Colors.grey.shade50,
// //                 contentPadding: const EdgeInsets.symmetric(
// //                     horizontal: 12, vertical: 10),
// //                 prefixIcon: isLocked
// //                     ? Icon(Icons.lock_rounded,
// //                     size: 14,
// //                     color: _statusColor(row.markedStatus))
// //                     : row.isEditing
// //                     ? Icon(Icons.edit_note_rounded,
// //                     size: 14, color: AppColor.lightBlueColor)
// //                     : null,
// //                 border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                     borderSide:
// //                     BorderSide(color: Colors.grey.shade200)),
// //                 enabledBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                     borderSide: BorderSide(
// //                         color: row.isEditing
// //                             ? AppColor.lightBlueColor.withOpacity(0.3)
// //                             : Colors.grey.shade200)),
// //                 disabledBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                     borderSide: BorderSide(
// //                         color: _statusColor(row.markedStatus)
// //                             .withOpacity(0.2))),
// //                 focusedBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                     borderSide: BorderSide(
// //                         color: AppColor.lightBlueColor, width: 1.5)),
// //               ),
// //             ),
// //           ),
// //
// //           // ── UPDATE SAVE BUTTON (edit mode only) ────────────────────
// //           if (row.isEditing)
// //             Padding(
// //               padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 height: 44,
// //                 child: ElevatedButton.icon(
// //                   onPressed: _saving
// //                       ? null
// //                       : () => _updateAttendance(row, setRow),
// //                   icon: _saving
// //                       ? const SizedBox(
// //                       width: 16,
// //                       height: 16,
// //                       child: CircularProgressIndicator(
// //                           color: Colors.white, strokeWidth: 2))
// //                       : const Icon(Icons.save_rounded,
// //                       color: Colors.white, size: 18),
// //                   label: Text(
// //                     _saving ? 'Saving...' : 'Update Attendance',
// //                     style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 13),
// //                   ),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: AppColor.lightBlueColor,
// //                     shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10)),
// //                     elevation: 0,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //         ]),
// //       );
// //     });
// //   }
// //
// //   // ── Count pill helper ─────────────────────────────────────────────────────
// //   Widget _countPill(String label, Color color, IconData icon) =>
// //       Container(
// //         padding:
// //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //         decoration: BoxDecoration(
// //           color: color.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(color: color.withOpacity(0.3)),
// //         ),
// //         child: Row(mainAxisSize: MainAxisSize.min, children: [
// //           Icon(icon, size: 13, color: color),
// //           const SizedBox(width: 4),
// //           Text(label,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w600)),
// //         ]),
// //       );
// // }
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
// import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
// import '../../res/app_color.dart';
// import '../../res/const_text.dart';
// import '../view_model/school_view_model/update_teacher_attendance_view_model.dart';
// import '../view_model/teacher_view_model/create_teacher_attendance_view_model.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Row Model
// // ─────────────────────────────────────────────────────────────────────────────
// class _TeacherRow {
//   final String id;
//   final String name;
//   final String qualification;
//   final String activeStatus;
//   String? attendanceStatus;
//   String? attendanceId;
//   bool alreadyMarked;
//   bool isEditing;
//   final TextEditingController remarksCtrl;
//
//   _TeacherRow({
//     required this.id,
//     required this.name,
//     required this.qualification,
//     required this.activeStatus,
//     this.attendanceStatus,
//     this.attendanceId,
//     this.alreadyMarked = false,
//     this.isEditing = false,
//   }) : remarksCtrl = TextEditingController();
//
//   void dispose() => remarksCtrl.dispose();
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Screen
// // ─────────────────────────────────────────────────────────────────────────────
// class TeacherAttendanceScreen extends StatefulWidget {
//   const TeacherAttendanceScreen({super.key});
//
//   @override
//   State<TeacherAttendanceScreen> createState() =>
//       _TeacherAttendanceScreenState();
// }
//
// class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
//   DateTime _selectedDate = DateTime.now();
//   List<_TeacherRow> _rows = [];
//   bool _saving = false;
//   bool _loading = false;
//
//   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
//   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
//
//   static const _statuses = [
//     {'code': 'P', 'full': 'Present'},
//     {'code': 'A', 'full': 'Absent'},
//     {'code': 'L', 'full': 'Leave'},
//     {'code': 'H', 'full': 'Half Day'},
//     {'code': 'OL', 'full': 'On Leave'},
//   ];
//
//   // ── Color / label helpers ──────────────────────────────────────────────────
//   Color _statusColor(String? code) {
//     switch (code) {
//       case 'P':  return const Color(0xFF22C55E);
//       case 'A':  return const Color(0xFFEF4444);
//       case 'L':  return const Color(0xFFF59E0B);
//       case 'H':  return const Color(0xFF3B82F6);
//       case 'OL': return const Color(0xFFA855F7);
//       default:   return Colors.grey;
//     }
//   }
//
//   String _statusLabel(String? code) {
//     switch (code) {
//       case 'P':  return 'Present';
//       case 'A':  return 'Absent';
//       case 'L':  return 'Leave';
//       case 'H':  return 'Half Day';
//       case 'OL': return 'On Leave';
//       default:   return code ?? '';
//     }
//   }
//
//   // ── Lifecycle ─────────────────────────────────────────────────────────────
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
//   }
//
//   @override
//   void dispose() {
//     for (final r in _rows) r.dispose();
//     super.dispose();
//   }
//
//   // ── MAIN LOAD — teachers + attendance ek saath ────────────────────────────
//   // ✅ FIX: Pehle teachers fetch karo, rows banao, PHIR attendance apply karo
//   // Pehle wali problem: _buildRows() Consumer mein tha, _fetchAndApplyExisting()
//   // initState mein call hoti thi jab _rows still empty thi — isliye koi
//   // alreadyMarked nahi hota tha aur sab create API call hoti thi update ki jagah.
//   Future<void> _loadAll() async {
//     setState(() => _loading = true);
//
//     // Step 1: Teacher list fetch karo
//     await Provider.of<AllTeachersListVieModel>(context, listen: false)
//         .allTeachersListApi(context);
//
//     final teachers =
//         Provider.of<AllTeachersListVieModel>(context, listen: false)
//             .allTeachersListModel
//             ?.data ?? [];
//
//     // Step 2: Rows banao teachers se
//     for (final r in _rows) r.dispose();
//     _rows = teachers.map((t) => _TeacherRow(
//       id: t.teacherId.toString(),
//       name: t.name ?? '',
//       qualification: t.qualification ?? '',
//       activeStatus: (t.status == 1) ? 'Active' : 'Inactive',
//     )).toList();
//
//     // Step 3: Attendance fetch karo aur rows mein apply karo
//     await _applyExistingAttendance();
//
//     setState(() => _loading = false);
//   }
//
//   // ── Attendance fetch karke rows mein apply karo ───────────────────────────
//   Future<void> _applyExistingAttendance() async {
//     await context
//         .read<TeacherAttendanceViewModel>()
//         .getTeacherAttendance(_apiDate);
//
//     final existing = Provider.of<TeacherAttendanceViewModel>(
//       context,
//       listen: false,
//     ).attendanceList;
//
//     if (kDebugMode) {
//       for (final r in existing) {
//         debugPrint(
//           '👉 teacherId: ${r.teacherId}'
//               ' | attendanceId: ${r.attendanceId}'
//               ' | status: ${r.status}',
//         );
//       }
//     }
//
//     // teacherId → { status, attendanceId }
//     final Map<String, Map<String, String>> markedMap = {
//       for (final r in existing)
//         if (r.teacherId != null)
//           r.teacherId.toString(): {
//             'status': r.status ?? '',
//             'attendanceId': r.attendanceId?.toString() ?? '',
//           },
//     };
//
//     setState(() {
//       for (final row in _rows) {
//         if (markedMap.containsKey(row.id)) {
//           row.alreadyMarked    = true;
//           row.isEditing        = false;
//           row.attendanceStatus = markedMap[row.id]!['status'];
//           row.attendanceId     = markedMap[row.id]!['attendanceId'];
//           if (kDebugMode) {
//             debugPrint(
//               '✅ Marked: ${row.name} | attId: ${row.attendanceId} | status: ${row.attendanceStatus}',
//             );
//           }
//         } else {
//           row.alreadyMarked = false;
//           row.isEditing     = false;
//           row.attendanceId  = null;
//         }
//       }
//     });
//   }
//
//   // ── Pull-to-refresh ───────────────────────────────────────────────────────
//   Future<void> _onRefresh() async => _loadAll();
//
//   // ── Date picker ───────────────────────────────────────────────────────────
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (c, child) => Theme(
//         data: Theme.of(c).copyWith(
//           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _loading = true;
//       });
//       await _applyExistingAttendance();
//       setState(() => _loading = false);
//     }
//   }
//
//   // ── Mark all present ──────────────────────────────────────────────────────
//   void _markAllPresent() {
//     setState(() {
//       for (final r in _rows) {
//         if (!r.alreadyMarked) r.attendanceStatus = 'P';
//       }
//     });
//   }
//
//   // ── Save NEW attendance ───────────────────────────────────────────────────
//   Future<void> _saveAll() async {
//     final pending = _rows.where((r) => !r.alreadyMarked).toList();
//
//     if (pending.isEmpty) {
//       _snack('Attendance has already been marked for all teachers.',
//           Colors.blue, Icons.info_rounded);
//       return;
//     }
//
//     final incomplete = pending.where((r) => r.attendanceStatus == null);
//     if (incomplete.isNotEmpty) {
//       _snack(
//         '${incomplete.length} teacher(s) attendance status is not selected.',
//         Colors.orange, Icons.warning_rounded,
//       );
//       return;
//     }
//
//     setState(() => _saving = true);
//     int successCount = 0;
//
//     final createVm = Provider.of<CreateTeacherAttendanceViewModel>(
//         context, listen: false);
//
//     for (final row in pending) {
//       final ok = await createVm.createTeacherAttendanceApi(
//         int.parse(row.id),
//         _apiDate,
//         row.attendanceStatus!,
//         row.remarksCtrl.text.trim(),
//         context,
//       );
//       if (ok) {
//         successCount++;
//         setState(() {
//           row.alreadyMarked = true;
//           row.isEditing     = false;
//         });
//       }
//     }
//
//     setState(() => _saving = false);
//     if (!mounted) return;
//
//     if (successCount > 0) {
//       _snack(
//         '$successCount out of ${pending.length} teacher(s) saved successfully.',
//         Colors.green, Icons.check_circle_rounded,
//       );
//       // ✅ Save ke baad attendance IDs lene ke liye re-fetch karo
//       await _applyExistingAttendance();
//     }
//   }
//
//   // ── Update EXISTING attendance ────────────────────────────────────────────
//   Future<void> _updateAttendance(_TeacherRow row, StateSetter setRow) async {
//     if (row.attendanceStatus == null) {
//       _snack('Please select a status before saving.',
//           Colors.orange, Icons.warning_rounded);
//       return;
//     }
//
//     if (row.attendanceId == null || row.attendanceId!.isEmpty) {
//       _snack('Attendance ID not found. Please refresh and try again.',
//           Colors.red, Icons.error_rounded);
//       return;
//     }
//
//     setState(() => _saving = true);
//
//     if (kDebugMode) {
//       debugPrint(
//         '🔄 Update call 👉 attendanceId: ${row.attendanceId}'
//             ' | status: ${row.attendanceStatus}'
//             ' | remarks: ${row.remarksCtrl.text.trim()}',
//       );
//     }
//
//     final ok = await Provider.of<UpdateTeacherAttendanceViewModel>(
//       context, listen: false,
//     ).updateTeacherAttendanceApi(
//       int.parse(row.attendanceId!),
//       row.attendanceStatus!,
//       row.remarksCtrl.text.trim(),
//       context,
//     );
//
//     setState(() => _saving = false);
//
//     if (ok) {
//       setRow(() {
//         row.alreadyMarked = true;
//         row.isEditing     = false;
//       });
//       if (mounted) {
//         _snack('Attendance updated successfully.',
//             Colors.green, Icons.check_circle_rounded);
//       }
//     }
//   }
//
//   // ── Snack helper ──────────────────────────────────────────────────────────
//   void _snack(String msg, Color color, IconData icon) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [
//         Icon(icon, color: Colors.white, size: 18),
//         const SizedBox(width: 8),
//         Expanded(child: Text(msg)),
//       ]),
//       backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ));
//   }
//
//   // ─────────────────────────────────────────────────────────────────────────
//   // BUILD
//   // ─────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
//     final pendingCount = _rows.length - alreadyCount;
//     final hasPending   = _rows.any((r) => !r.alreadyMarked);
//
//     return Scaffold(
//       backgroundColor: AppColor.screenBg,
//       body: Column(children: [
//         _buildHeader(),
//         Expanded(child: _buildBody(alreadyCount, pendingCount)),
//       ]),
//
//       // ── FABs ─────────────────────────────────────────────────────────────
//       floatingActionButton: (!_loading && hasPending)
//           ? Container(
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(children: [
//           FloatingActionButton(
//             heroTag: 'mark_all_p',
//             onPressed: _saving ? null : _markAllPresent,
//             backgroundColor: const Color(0xFF22C55E),
//             tooltip: 'Mark All Present',
//             child: const Icon(Icons.done_all_rounded, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: FloatingActionButton.extended(
//               heroTag: 'save_all_btn',
//               onPressed: _saving ? null : _saveAll,
//               backgroundColor: AppColor.lightBlueColor,
//               elevation: 4,
//               icon: _saving
//                   ? const SizedBox(
//                   width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2))
//                   : const Icon(Icons.save_rounded, color: Colors.white),
//               label: Text(
//                 _saving ? 'Saving...' : 'Save All Attendance',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15),
//               ),
//             ),
//           ),
//         ]),
//       )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   // ── HEADER ────────────────────────────────────────────────────────────────
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//       decoration: BoxDecoration(
//         gradient: AppColor.primaryGradient,
//         borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
//         boxShadow: [BoxShadow(
//             color: AppColor.blueShadow,
//             blurRadius: 18,
//             offset: const Offset(0, 10))],
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           InkWell(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   color: AppColor.glassWhite, shape: BoxShape.circle),
//               child: const Icon(Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white, size: 20),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: AppText.customText('Teacher Attendance',
//                 size: 19, weight: FontWeight.bold, color: Colors.white),
//           ),
//         ]),
//
//         const SizedBox(height: 16),
//
//         GestureDetector(
//           onTap: _pickDate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white.withOpacity(0.3)),
//             ),
//             child: Row(children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: const Icon(Icons.calendar_month_rounded,
//                     color: Colors.white, size: 18),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText('Selected Date',
//                           size: 11, color: Colors.white70),
//                       AppText.customText(_displayDate,
//                           size: 15, weight: FontWeight.bold, color: Colors.white),
//                     ]),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Row(children: [
//                   const Icon(Icons.edit_calendar_rounded,
//                       color: Colors.white, size: 13),
//                   const SizedBox(width: 4),
//                   AppText.customText('Change', size: 11, color: Colors.white),
//                 ]),
//               ),
//             ]),
//           ),
//         ),
//
//         const SizedBox(height: 14),
//
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: _statuses.map((s) {
//               final color = _statusColor(s['code']);
//               return Container(
//                 margin: const EdgeInsets.only(right: 8),
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: color.withOpacity(0.5)),
//                 ),
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Container(
//                       width: 8, height: 8,
//                       decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//                   const SizedBox(width: 5),
//                   Text('${s['code']} = ${s['full']}',
//                       style: const TextStyle(
//                           color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
//                 ]),
//               );
//             }).toList(),
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── BODY ──────────────────────────────────────────────────────────────────
//   Widget _buildBody(int alreadyCount, int pendingCount) {
//     if (_loading) {
//       return Center(
//           child: CircularProgressIndicator(color: AppColor.lightBlueColor));
//     }
//
//     if (_rows.isEmpty) {
//       return Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(Icons.people_outline_rounded,
//               size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
//           const SizedBox(height: 16),
//           AppText.customText('No Teachers Found',
//               size: 16, weight: FontWeight.bold),
//         ]),
//       );
//     }
//
//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
//         child: Row(children: [
//           if (alreadyCount > 0) ...[
//             _countPill('$alreadyCount Already Marked', Colors.green,
//                 Icons.check_circle_rounded),
//             const SizedBox(width: 8),
//           ],
//           if (pendingCount > 0)
//             _countPill('$pendingCount Pending', Colors.orange, Icons.pending_rounded),
//           const Spacer(),
//           Text('Total: ${_rows.length}',
//               style: TextStyle(
//                   fontSize: 12,
//                   color: AppColor.softGreyText,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       ),
//       Expanded(
//         child: RefreshIndicator(
//           onRefresh: _onRefresh,
//           color: AppColor.lightBlueColor,
//           backgroundColor: Colors.white,
//           strokeWidth: 2.5,
//           child: ListView.builder(
//             padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
//             itemCount: _rows.length,
//             itemBuilder: (_, i) => _buildRow(_rows[i]),
//           ),
//         ),
//       ),
//     ]);
//   }
//
//   // ── Single attendance row card ─────────────────────────────────────────────
//   Widget _buildRow(_TeacherRow row) {
//     if (!row.alreadyMarked && row.attendanceStatus == null) {
//       row.attendanceStatus = _statuses.first['code'];
//     }
//
//     return StatefulBuilder(builder: (context, setRow) {
//       final isLocked = row.alreadyMarked && !row.isEditing;
//
//       final borderColor = row.isEditing
//           ? AppColor.lightBlueColor.withOpacity(0.5)
//           : isLocked
//           ? Colors.green.withOpacity(0.4)
//           : (row.attendanceStatus != null
//           ? _statusColor(row.attendanceStatus).withOpacity(0.3)
//           : Colors.grey.shade200);
//
//       return Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: row.isEditing
//               ? AppColor.lightBlueColor.withOpacity(0.02)
//               : isLocked
//               ? Colors.green.withOpacity(0.03)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor, width: 1.5),
//           boxShadow: [BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 6,
//               offset: const Offset(0, 3))],
//         ),
//         child: Column(children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
//             child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               // Avatar
//               Container(
//                 width: 38, height: 38,
//                 decoration: BoxDecoration(
//                   color: row.isEditing
//                       ? AppColor.lightBlueColor.withOpacity(0.15)
//                       : isLocked
//                       ? Colors.green.withOpacity(0.12)
//                       : AppColor.lightBlueColor.withOpacity(0.12),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     row.name.isNotEmpty ? row.name[0].toUpperCase() : '?',
//                     style: TextStyle(
//                       fontSize: 15, fontWeight: FontWeight.bold,
//                       color: row.isEditing
//                           ? AppColor.lightBlueColor
//                           : isLocked ? Colors.green : AppColor.lightBlueColor,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//
//               // Name + ID
//               Expanded(
//                 flex: 3,
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   AppText.customText(
//                     row.name.isNotEmpty
//                         ? row.name[0].toUpperCase() + row.name.substring(1)
//                         : '',
//                     size: 13, weight: FontWeight.bold,
//                   ),
//                   const SizedBox(height: 2),
//                   AppText.customText('ID: ${row.id}',
//                       size: 11, color: AppColor.softGreyText),
//                 ]),
//               ),
//
//               // Qualification
//               Expanded(
//                 flex: 2,
//                 child: AppText.customText(row.qualification,
//                     size: 12, color: AppColor.softGreyText),
//               ),
//
//               // Right badges
//               Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//                 _pill(row.activeStatus, Colors.green),
//
//                 if (isLocked) ...[
//                   const SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _statusColor(row.attendanceStatus).withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: _statusColor(row.attendanceStatus).withOpacity(0.4)),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.lock_rounded,
//                           size: 10, color: _statusColor(row.attendanceStatus)),
//                       const SizedBox(width: 3),
//                       Text(
//                         '${_statusLabel(row.attendanceStatus)} • Marked',
//                         style: TextStyle(
//                             color: _statusColor(row.attendanceStatus),
//                             fontSize: 10, fontWeight: FontWeight.w600),
//                       ),
//                     ]),
//                   ),
//                   const SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () => setRow(() => row.isEditing = true),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColor.lightBlueColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: AppColor.lightBlueColor.withOpacity(0.4)),
//                       ),
//                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                         Icon(Icons.edit_rounded,
//                             size: 10, color: AppColor.lightBlueColor),
//                         const SizedBox(width: 3),
//                         Text('Edit',
//                             style: TextStyle(
//                                 color: AppColor.lightBlueColor,
//                                 fontSize: 10, fontWeight: FontWeight.w600)),
//                       ]),
//                     ),
//                   ),
//                 ],
//
//                 if (row.isEditing) ...[
//                   const SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppColor.lightBlueColor.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: AppColor.lightBlueColor.withOpacity(0.4)),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.edit_rounded,
//                           size: 10, color: AppColor.lightBlueColor),
//                       const SizedBox(width: 3),
//                       Text('Editing',
//                           style: TextStyle(
//                               color: AppColor.lightBlueColor,
//                               fontSize: 10, fontWeight: FontWeight.w600)),
//                     ]),
//                   ),
//                   const SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () => setRow(() => row.isEditing = false),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.red.withOpacity(0.4)),
//                       ),
//                       child: Row(mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Icon(Icons.close_rounded, size: 10, color: Colors.red),
//                             SizedBox(width: 3),
//                             Text('Cancel',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 10, fontWeight: FontWeight.w600)),
//                           ]),
//                     ),
//                   ),
//                 ],
//               ]),
//             ]),
//           ),
//
//           Divider(height: 1, color: Colors.grey.shade100),
//
//           // Status chips
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(children: [
//                 AppText.customText('ATTENDANCE STATUS',
//                     size: 10, weight: FontWeight.bold, color: AppColor.softGreyText),
//                 if (row.isEditing) ...[
//                   const SizedBox(width: 6),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: AppColor.lightBlueColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text('Edit Mode',
//                         style: TextStyle(
//                             color: AppColor.lightBlueColor,
//                             fontSize: 9, fontWeight: FontWeight.w600)),
//                   ),
//                 ],
//               ]),
//               const SizedBox(height: 8),
//               Row(
//                 children: _statuses.map((s) {
//                   final code     = s['code']!;
//                   final selected = row.attendanceStatus == code;
//                   final color    = _statusColor(code);
//                   return Expanded(
//                     child: GestureDetector(
//                       onTap: isLocked
//                           ? null
//                           : () => setRow(() =>
//                       row.attendanceStatus = selected ? null : code),
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 180),
//                         margin: const EdgeInsets.only(right: 6),
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         decoration: BoxDecoration(
//                           color: selected
//                               ? color.withOpacity(0.15)
//                               : (isLocked ? Colors.grey.shade100 : Colors.grey.shade50),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                               color: selected ? color : Colors.grey.shade200,
//                               width: selected ? 1.5 : 1),
//                         ),
//                         child: Column(mainAxisSize: MainAxisSize.min, children: [
//                           Container(
//                             width: 14, height: 14,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                   color: selected ? color : Colors.grey.shade400,
//                                   width: 1.5),
//                             ),
//                             child: selected
//                                 ? Center(child: Container(
//                                 width: 7, height: 7,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle, color: color)))
//                                 : null,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(code,
//                               style: TextStyle(
//                                   fontSize: 11, fontWeight: FontWeight.bold,
//                                   color: selected
//                                       ? color
//                                       : (isLocked
//                                       ? Colors.grey.shade400
//                                       : AppColor.softGreyText))),
//                         ]),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ]),
//           ),
//
//           // Remarks
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
//             child: TextField(
//               controller: row.remarksCtrl,
//               enabled: !isLocked,
//               style: const TextStyle(fontSize: 12),
//               decoration: InputDecoration(
//                 isDense: true,
//                 hintText: isLocked
//                     ? 'Attendance already marked'
//                     : row.isEditing ? 'Update remarks...' : 'Enter remarks...',
//                 hintStyle: TextStyle(
//                     color: isLocked
//                         ? Colors.green.withOpacity(0.6)
//                         : AppColor.softGreyText,
//                     fontSize: 12),
//                 filled: true,
//                 fillColor: row.isEditing
//                     ? AppColor.lightBlueColor.withOpacity(0.04)
//                     : isLocked ? Colors.green.withOpacity(0.05) : Colors.grey.shade50,
//                 contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 prefixIcon: isLocked
//                     ? const Icon(Icons.lock_rounded, size: 14, color: Colors.green)
//                     : row.isEditing
//                     ? Icon(Icons.edit_note_rounded,
//                     size: 14, color: AppColor.lightBlueColor)
//                     : null,
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade200)),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                         color: row.isEditing
//                             ? AppColor.lightBlueColor.withOpacity(0.3)
//                             : Colors.grey.shade200)),
//                 disabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.green.withOpacity(0.2))),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: AppColor.lightBlueColor, width: 1.5)),
//               ),
//             ),
//           ),
//
//           // Update button
//           if (row.isEditing)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 44,
//                 child: ElevatedButton.icon(
//                   onPressed: _saving ? null : () => _updateAttendance(row, setRow),
//                   icon: _saving
//                       ? const SizedBox(
//                       width: 16, height: 16,
//                       child: CircularProgressIndicator(
//                           color: Colors.white, strokeWidth: 2))
//                       : const Icon(Icons.save_rounded, color: Colors.white, size: 18),
//                   label: Text(
//                     _saving ? 'Saving...' : 'Update Attendance',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.lightBlueColor,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//             ),
//         ]),
//       );
//     });
//   }
//
//   // ── Helpers ───────────────────────────────────────────────────────────────
//   Widget _pill(String label, Color color) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20)),
//     child: Text(label,
//         style: TextStyle(
//             color: color, fontSize: 11, fontWeight: FontWeight.w600)),
//   );
//
//   Widget _countPill(String label, Color color, IconData icon) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: color.withOpacity(0.3)),
//     ),
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       Icon(icon, size: 13, color: color),
//       const SizedBox(width: 4),
//       Text(label,
//           style: TextStyle(
//               color: color, fontSize: 12, fontWeight: FontWeight.w600)),
//     ]),
//   );
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../utils/permission_error_message.dart';
import '../utils/permission_keys.dart';
import '../view_model/school_view_model/update_teacher_attendance_view_model.dart';
import '../view_model/teacher_view_model/create_teacher_attendance_view_model.dart';

// Row Model
class _TeacherRow {
  final String id;
  final String name;
  final String qualification;
  final String activeStatus;
  String? attendanceStatus;
  String? attendanceId;
  bool alreadyMarked;
  bool isEditing;
  final TextEditingController remarksCtrl;

  _TeacherRow({
    required this.id,
    required this.name,
    required this.qualification,
    required this.activeStatus,
    this.attendanceStatus,
    this.attendanceId,
    this.alreadyMarked = false,
    this.isEditing = false,
  }) : remarksCtrl = TextEditingController();

  void dispose() => remarksCtrl.dispose();
}

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  List<_TeacherRow> _rows = [];
  bool _saving = false;
  bool _loading = false;

  String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
  String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);

  static const _statuses = [
    {'code': 'P', 'full': 'Present'},
    {'code': 'A', 'full': 'Absent'},
    {'code': 'L', 'full': 'Leave'},
    {'code': 'H', 'full': 'Half Day'},
    {'code': 'OL', 'full': 'On Leave'},
  ];

  // ── Color / label helpers ──────────────────────────────────────────────────
  Color _statusColor(String? code) {
    switch (code) {
      case 'P':  return const Color(0xFF22C55E);
      case 'A':  return const Color(0xFFEF4444);
      case 'L':  return const Color(0xFFF59E0B);
      case 'H':  return const Color(0xFF3B82F6);
      case 'OL': return const Color(0xFFA855F7);
      default:   return Colors.grey;
    }
  }

  String _statusLabel(String? code) {
    switch (code) {
      case 'P':  return 'Present';
      case 'A':  return 'Absent';
      case 'L':  return 'Leave';
      case 'H':  return 'Half Day';
      case 'OL': return 'On Leave';
      default:   return code ?? '';
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  @override
  void dispose() {
    for (final r in _rows) r.dispose();
    super.dispose();
  }

  // ── MAIN LOAD — teachers + attendance ─────────────────────────────────────
  Future<void> _loadAll() async {
    setState(() => _loading = true);

    // Step 1: Teacher list fetch karo
    await Provider.of<AllTeachersListVieModel>(context, listen: false)
        .allTeachersListApi(context);

    final teachers =
        Provider.of<AllTeachersListVieModel>(context, listen: false)
            .allTeachersListModel
            ?.data ?? [];

    // Step 2: Rows banao
    for (final r in _rows) r.dispose();
    _rows = teachers.map((t) => _TeacherRow(
      id: t.teacherId.toString(),
      name: t.name ?? '',
      qualification: t.qualification ?? '',
      activeStatus: (t.status == 1) ? 'Active' : 'Inactive',
    )).toList();

    // Step 3: Attendance fetch karo aur rows mein apply karo
    await _applyExistingAttendance();

    setState(() => _loading = false);
  }


  Future<void> _applyExistingAttendance() async {
    await context
        .read<TeacherAttendanceViewModel>()
        .getTeacherAttendance(_apiDate, context);

    final existing = Provider.of<TeacherAttendanceViewModel>(
      context,
      listen: false,
    ).attendanceList;

    if (kDebugMode) {
      debugPrint('📋 Total existing records: ${existing.length}');
      for (final r in existing) {
        // ✅ FIX LOG: dono possible field print karo taaki pata chale kaunsa hai
        debugPrint(
          '👉 teacherId=${r.teacherId}'
              ' | attendanceId=${r.attendanceId}'   // ← agar ye null aata hai
              ' | status=${r.status}',              //   to neeche wala try karo
        );
      }
    }

    // ✅ FIX: attendanceId mapping — accountant ke bilkul same pattern
    final Map<String, Map<String, String>> markedMap = {
      for (final r in existing)
        if (r.teacherId != null)
          r.teacherId.toString(): {
            'status'      : r.status ?? '',
            // ── IMPORTANT ──────────────────────────────────────────────────
            // Agar debug log mein attendanceId null aa raha hai to:
            //   Option A (agar model mein field 'id' hai):
            //     'attendanceId': r.id?.toString() ?? '',
            //   Option B (agar field 'attendanceId' hai — current):
            //     'attendanceId': r.attendanceId?.toString() ?? '',
            // ──────────────────────────────────────────────────────────────
            'attendanceId': r.attendanceId?.toString() ?? '',
          },
    };

    setState(() {
      for (final row in _rows) {
        if (markedMap.containsKey(row.id)) {
          row.alreadyMarked    = true;
          row.isEditing        = false;
          row.attendanceStatus = markedMap[row.id]!['status'];
          row.attendanceId     = markedMap[row.id]!['attendanceId'];

          if (kDebugMode) {
            debugPrint(
              '✅ Row set: ${row.name}'
                  ' | attId=${row.attendanceId}'
                  ' | status=${row.attendanceStatus}',
            );
          }
        } else {
          row.alreadyMarked    = false;
          row.isEditing        = false;
          row.attendanceId     = null;
          row.attendanceStatus = null;
        }
      }
    });
  }

  // ── Pull-to-refresh ───────────────────────────────────────────────────────
  Future<void> _onRefresh() async => _loadAll();

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loading = true;
      });
      await _applyExistingAttendance();
      setState(() => _loading = false);
    }
  }

  // ── Mark all present ──────────────────────────────────────────────────────
  void _markAllPresent() {
    setState(() {
      for (final r in _rows) {
        if (!r.alreadyMarked) r.attendanceStatus = 'P';
      }
    });
  }

  // ── Save NEW attendance ───────────────────────────────────────────────────
  Future<void> _saveAll() async {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.markTeacherAttendance,
      "Mark Teacher Attendance",
    )) {
      return;
    }
    final pending = _rows.where((r) => !r.alreadyMarked).toList();

    if (pending.isEmpty) {
      _snack('Attendance has already been marked for all teachers.',
          Colors.blue, Icons.info_rounded);
      return;
    }

    final incomplete = pending.where((r) => r.attendanceStatus == null);
    if (incomplete.isNotEmpty) {
      _snack(
        '${incomplete.length} teacher(s) attendance status is not selected.',
        Colors.orange, Icons.warning_rounded,
      );
      return;
    }

    setState(() => _saving = true);
    int successCount = 0;

    final createVm = Provider.of<CreateTeacherAttendanceViewModel>(
        context, listen: false);

    for (final row in pending) {
      final ok = await createVm.createTeacherAttendanceApi(
        int.parse(row.id),
        _apiDate,
        row.attendanceStatus!,
        row.remarksCtrl.text.trim(),
        context,
      );
      if (ok) {
        successCount++;
        setState(() {
          row.alreadyMarked = true;
          row.isEditing     = false;
        });
      }
    }

    setState(() => _saving = false);
    if (!mounted) return;

    if (successCount > 0) {
      _snack(
        '$successCount out of ${pending.length} teacher(s) saved successfully.',
        Colors.green, Icons.check_circle_rounded,
      );
      // ✅ Save ke baad attendance IDs update karo
      await _applyExistingAttendance();
    }
  }

  // ── Update EXISTING attendance ────────────────────────────────────────────
  Future<void> _updateAttendance(_TeacherRow row, StateSetter setRow) async {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.markTeacherAttendance,
      "Update Teacher Attendance",
    )) {
      return;
    }
    if (row.attendanceStatus == null) {
      _snack('Please select a status before saving.',
          Colors.orange, Icons.warning_rounded);
      return;
    }

    // ✅ FIX: attendanceId null/empty check — accountant screen jesa
    if (row.attendanceId == null || row.attendanceId!.isEmpty) {
      _snack(
        'Attendance ID not found. Please refresh and try again.',
        Colors.red, Icons.error_rounded,
      );
      if (kDebugMode) {
        debugPrint(
          '❌ _updateAttendance: attendanceId is null/empty'
              ' for teacher ${row.name} (id=${row.id})',
        );
      }
      return;
    }

    setState(() => _saving = true);

    if (kDebugMode) {
      debugPrint(
        '🔄 Update → attendanceId=${row.attendanceId}'
            ' | status=${row.attendanceStatus}'
            ' | remarks=${row.remarksCtrl.text.trim()}',
      );
    }

    // ✅ FIX: UpdateTeacherAttendanceViewModel use — accountant ke same
    final ok = await Provider.of<UpdateTeacherAttendanceViewModel>(
      context, listen: false,
    ).updateTeacherAttendanceApi(
      int.parse(row.attendanceId!),      // attendance PK
      row.attendanceStatus!,             // status
      row.remarksCtrl.text.trim(),       // remarks
      context,
    );

    setState(() => _saving = false);

    if (ok) {
      setRow(() {
        row.alreadyMarked = true;
        row.isEditing     = false;
      });
      if (mounted) {
        _snack('Attendance updated successfully.',
            Colors.green, Icons.check_circle_rounded);
      }
    }
  }

  // ── Snack helper ──────────────────────────────────────────────────────────
  void _snack(String msg, Color color, IconData icon) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
    final pendingCount = _rows.length - alreadyCount;
    final hasPending   = _rows.any((r) => !r.alreadyMarked);

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(children: [
        _buildHeader(),
        Expanded(child: _buildBody(alreadyCount, pendingCount)),
      ]),

      // ── FABs ─────────────────────────────────────────────────────────────
      floatingActionButton: (!_loading && hasPending)
          ? Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          FloatingActionButton(
            heroTag: 'mark_all_p',
            onPressed: _saving ? null : _markAllPresent,
            backgroundColor: const Color(0xFF22C55E),
            tooltip: 'Mark All Present',
            child: const Icon(Icons.done_all_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FloatingActionButton.extended(
              heroTag: 'save_all_btn',
              onPressed: _saving ? null : _saveAll,
              backgroundColor: AppColor.lightBlueColor,
              elevation: 4,
              icon: _saving
                  ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save_rounded, color: Colors.white),
              label: Text(
                _saving ? 'Saving...' : 'Save All Attendance',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ]),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [BoxShadow(
            color: AppColor.blueShadow,
            blurRadius: 18,
            offset: const Offset(0, 10))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColor.glassWhite, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.customText('Teacher Attendance',
                size: 19, weight: FontWeight.bold, color: Colors.white),
          ),
        ]),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText('Selected Date',
                          size: 11, color: Colors.white70),
                      AppText.customText(_displayDate,
                          size: 15, weight: FontWeight.bold, color: Colors.white),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  const Icon(Icons.edit_calendar_rounded,
                      color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  AppText.customText('Change', size: 11, color: Colors.white),
                ]),
              ),
            ]),
          ),
        ),

        const SizedBox(height: 14),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _statuses.map((s) {
              final color = _statusColor(s['code']);
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 8, height: 8,
                      decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('${s['code']} = ${s['full']}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ]),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  // ── BODY ──────────────────────────────────────────────────────────────────
  Widget _buildBody(int alreadyCount, int pendingCount) {
    if (_loading) {
      return Center(
          child:
          CircularProgressIndicator(color: AppColor.lightBlueColor));
    }

    if (_rows.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.people_outline_rounded,
              size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          AppText.customText('No Teachers Found',
              size: 16, weight: FontWeight.bold),
        ]),
      );
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Row(children: [
          if (alreadyCount > 0) ...[
            _countPill('$alreadyCount Already Marked', Colors.green,
                Icons.check_circle_rounded),
            const SizedBox(width: 8),
          ],
          if (pendingCount > 0)
            _countPill(
                '$pendingCount Pending', Colors.orange, Icons.pending_rounded),
          const Spacer(),
          Text('Total: ${_rows.length}',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColor.softGreyText,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColor.lightBlueColor,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
            itemCount: _rows.length,
            itemBuilder: (_, i) => _buildRow(_rows[i]),
          ),
        ),
      ),
    ]);
  }

  // ── Single attendance row card ─────────────────────────────────────────────
  Widget _buildRow(_TeacherRow row) {
    if (!row.alreadyMarked && row.attendanceStatus == null) {
      row.attendanceStatus = _statuses.first['code'];
    }

    return StatefulBuilder(builder: (context, setRow) {
      final isLocked = row.alreadyMarked && !row.isEditing;

      final borderColor = row.isEditing
          ? AppColor.lightBlueColor.withOpacity(0.5)
          : isLocked
          ? Colors.green.withOpacity(0.4)
          : (row.attendanceStatus != null
          ? _statusColor(row.attendanceStatus).withOpacity(0.3)
          : Colors.grey.shade200);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: row.isEditing
              ? AppColor.lightBlueColor.withOpacity(0.02)
              : isLocked
              ? Colors.green.withOpacity(0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child:
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: row.isEditing
                      ? AppColor.lightBlueColor.withOpacity(0.15)
                      : isLocked
                      ? Colors.green.withOpacity(0.12)
                      : AppColor.lightBlueColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    row.name.isNotEmpty ? row.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: row.isEditing
                          ? AppColor.lightBlueColor
                          : isLocked
                          ? Colors.green
                          : AppColor.lightBlueColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Name + ID
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        row.name.isNotEmpty
                            ? row.name[0].toUpperCase() +
                            row.name.substring(1)
                            : '',
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 2),
                      AppText.customText('ID: ${row.id}',
                          size: 11, color: AppColor.softGreyText),
                    ]),
              ),

              // Qualification
              Expanded(
                flex: 2,
                child: AppText.customText(row.qualification,
                    size: 12, color: AppColor.softGreyText),
              ),

              // Right badges
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                _pill(row.activeStatus, Colors.green),

                if (isLocked) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(row.attendanceStatus)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _statusColor(row.attendanceStatus)
                              .withOpacity(0.4)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.lock_rounded,
                          size: 10,
                          color: _statusColor(row.attendanceStatus)),
                      const SizedBox(width: 3),
                      Text(
                        '${_statusLabel(row.attendanceStatus)} • Marked',
                        style: TextStyle(
                            color: _statusColor(row.attendanceStatus),
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setRow(() => row.isEditing = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.lightBlueColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                            AppColor.lightBlueColor.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.edit_rounded,
                            size: 10, color: AppColor.lightBlueColor),
                        const SizedBox(width: 3),
                        Text('Edit',
                            style: TextStyle(
                                color: AppColor.lightBlueColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ],

                if (row.isEditing) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                      AppColor.lightBlueColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                          AppColor.lightBlueColor.withOpacity(0.4)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.edit_rounded,
                          size: 10, color: AppColor.lightBlueColor),
                      const SizedBox(width: 3),
                      Text('Editing',
                          style: TextStyle(
                              color: AppColor.lightBlueColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setRow(() => row.isEditing = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.red.withOpacity(0.4)),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.close_rounded,
                                size: 10, color: Colors.red),
                            SizedBox(width: 3),
                            Text('Cancel',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                  ),
                ],
              ]),
            ]),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          // Status chips
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    AppText.customText('ATTENDANCE STATUS',
                        size: 10,
                        weight: FontWeight.bold,
                        color: AppColor.softGreyText),
                    if (row.isEditing) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.lightBlueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Edit Mode',
                            style: TextStyle(
                                color: AppColor.lightBlueColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: _statuses.map((s) {
                      final code     = s['code']!;
                      final selected = row.attendanceStatus == code;
                      final color    = _statusColor(code);
                      return Expanded(
                        child: GestureDetector(
                          onTap: isLocked
                              ? null
                              : () => setRow(() =>
                          row.attendanceStatus =
                          selected ? null : code),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 6),
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withOpacity(0.15)
                                  : (isLocked
                                  ? Colors.grey.shade100
                                  : Colors.grey.shade50),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: selected
                                      ? color
                                      : Colors.grey.shade200,
                                  width: selected ? 1.5 : 1),
                            ),
                            child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: selected
                                          ? color
                                          : Colors.grey.shade400,
                                      width: 1.5),
                                ),
                                child: selected
                                    ? Center(
                                    child: Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color)))
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(code,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? color
                                          : (isLocked
                                          ? Colors.grey.shade400
                                          : AppColor.softGreyText))),
                            ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
          ),

          // Remarks
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
            child: TextField(
              controller: row.remarksCtrl,
              enabled: !isLocked,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                hintText: isLocked
                    ? 'Attendance already marked'
                    : row.isEditing
                    ? 'Update remarks...'
                    : 'Enter remarks...',
                hintStyle: TextStyle(
                    color: isLocked
                        ? Colors.green.withOpacity(0.6)
                        : AppColor.softGreyText,
                    fontSize: 12),
                filled: true,
                fillColor: row.isEditing
                    ? AppColor.lightBlueColor.withOpacity(0.04)
                    : isLocked
                    ? Colors.green.withOpacity(0.05)
                    : Colors.grey.shade50,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                prefixIcon: isLocked
                    ? const Icon(Icons.lock_rounded,
                    size: 14, color: Colors.green)
                    : row.isEditing
                    ? Icon(Icons.edit_note_rounded,
                    size: 14, color: AppColor.lightBlueColor)
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: row.isEditing
                            ? AppColor.lightBlueColor.withOpacity(0.3)
                            : Colors.grey.shade200)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.2))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: AppColor.lightBlueColor, width: 1.5)),
              ),
            ),
          ),

          // ✅ FIX: Update button — accountant ke bilkul same
          if (row.isEditing)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed:
                  _saving ? null : () => _updateAttendance(row, setRow),
                  icon: _saving
                      ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_rounded,
                      color: Colors.white, size: 18),
                  label: Text(
                    _saving ? 'Saving...' : 'Update Attendance',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.lightBlueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
        ]),
      );
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _pill(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600)),
  );

  Widget _countPill(String label, Color color, IconData icon) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    ]),
  );
}