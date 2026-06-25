// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
// // import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
// // import 'package:school_pro/view_model/student_view_model/create_student_attendance_view_model.dart';
// // import '../../repo/school_repo/all_sections_repo.dart';
// // import '../../res/app_color.dart';
// // import '../../res/const_text.dart';
// // import '../../view_model/school_view_model/all_student_attendance_view_model.dart';
// //
// // class AllStudentAdminAttendanceScreen extends StatefulWidget {
// //   const AllStudentAdminAttendanceScreen({super.key});
// //
// //   @override
// //   State<AllStudentAdminAttendanceScreen> createState() =>
// //       _AllStudentAdminAttendanceScreenState();
// // }
// //
// // class _AllStudentAdminAttendanceScreenState
// //     extends State<AllStudentAdminAttendanceScreen> {
// //   // ── Date ──
// //   DateTime _selectedDate = DateTime.now();
// //   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
// //   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
// //
// //   // ── Header filter (view attendance) ──
// //   String _selectedClassId = '';
// //   String _selectedSectionId = '';
// //   List<Map<String, dynamic>> _classes = [];
// //   List<Map<String, dynamic>> _sections = [];
// //   List<String> _selectedStudentIds = [];
// //   // ── Bottom sheet state ──
// //   String? _createStatus; // P | A | L | H | OL
// //   String? _selectedStudentId;
// //   final _remarksCtrl = TextEditingController();
// //
// //   // ── Sheet class/section ──
// //   String _sheetClassId = '';
// //   String _sheetSectionId = '';
// //   List<Map<String, dynamic>> _sheetSections = [];
// //   late AllClassesViewModel _classesVm;
// //   // ── All 5 status options ──
// //   static const List<Map<String, dynamic>> _statusOptions = [
// //     {'value': 'P', 'label': 'Present', 'color': Colors.green},
// //     {'value': 'A', 'label': 'Absent', 'color': Colors.red},
// //     {'value': 'L', 'label': 'Leave', 'color': Colors.orange},
// //     {'value': 'H', 'label': 'Half Day', 'color': Colors.purple},
// //     {'value': 'OL', 'label': 'On Leave', 'color': Colors.blue},
// //   ];
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _classesVm = Provider.of<AllClassesViewModel>(context, listen: false);
// //
// //       _classesVm.allClassesApi(context);
// //       _classesVm.addListener(_onClassesLoaded);
// //
// //       Provider.of<AllStudentListVieModel>(
// //         context,
// //         listen: false,
// //       ).allStudentListApi(context);
// //     });
// //   }
// //
// //   void _onClassesLoaded() {
// //     if (!mounted) return;
// //
// //     final data = _classesVm.allClassesModel?.data ?? [];
// //
// //     if (data.isNotEmpty && _classes.isEmpty) {
// //       setState(() {
// //         _classes = data
// //             .map(
// //               (e) => {
// //                 'class_id': e.classId.toString(),
// //                 'class_name': e.className ?? '',
// //               },
// //             )
// //             .toList();
// //       });
// //     }
// //   }
// //   @override
// //   void dispose() {
// //     _remarksCtrl.dispose();
// //     _classesVm.removeListener(_onClassesLoaded);
// //     super.dispose();
// //   }
// //
// //   void _fetchAttendance() {
// //     if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) return;
// //     Provider.of<AllStudentAdminAttendanceViewModel>(
// //       context,
// //       listen: false,
// //     ).getAttendance(
// //       classId: int.parse(_selectedClassId),
// //       sectionId: int.parse(_selectedSectionId),
// //       date: _apiDate,
// //       context: context,
// //     );
// //   }
// //
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
// //       _fetchAttendance();
// //     }
// //   }
// //
// //   Future<void> _onClassChanged(String? classId) async {
// //     setState(() {
// //       _selectedClassId = classId ?? '';
// //       _selectedSectionId = '';
// //       _sections = [];
// //     });
// //     if (classId == null || classId.isEmpty) return;
// //     try {
// //       final repo = AllSectionsRepository();
// //       final response = await repo.allSectionsApi(classId);
// //       if (response['success'] == true) {
// //         setState(() {
// //           _sections = List<Map<String, dynamic>>.from(response['data']);
// //         });
// //       }
// //     } catch (_) {}
// //   }
// //
// //   void _onSectionChanged(String? sectionId) {
// //     setState(() => _selectedSectionId = sectionId ?? '');
// //     _fetchAttendance();
// //   }
// //
// //   String _formatTime(String? markedAt) {
// //     if (markedAt == null) return '';
// //     try {
// //       final dt = DateTime.parse(markedAt).toLocal();
// //       return DateFormat('hh:mm a').format(dt);
// //     } catch (_) {
// //       return '';
// //     }
// //   }
// //   String _getStatusLabel(String? s) {
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
// //         return 'Unknown';
// //     }
// //   }
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
// //   Color _statusColor(String? s) {
// //     switch (s) {
// //       case 'P':
// //         return Colors.green;
// //       case 'A':
// //         return Colors.red;
// //       case 'L':
// //         return Colors.orange;
// //       case 'H':
// //         return Colors.purple;
// //       case 'OL':
// //         return Colors.blue;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   // ── Header filter dropdown (white style for gradient header) ──
// //   Widget _buildFilterDropdown({
// //     required String label,
// //     required String? value,
// //     required List<DropdownMenuItem<String>> items,
// //     required void Function(String?) onChanged,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.15),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: value != null
// //               ? Colors.white.withOpacity(0.6)
// //               : Colors.white.withOpacity(0.3),
// //           width: 1.5,
// //         ),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           isExpanded: true,
// //           dropdownColor: Colors.white,
// //           hint: Text(
// //             label,
// //             style: TextStyle(
// //               color: Colors.white.withOpacity(0.8),
// //               fontSize: 13,
// //             ),
// //           ),
// //           value: value,
// //           icon: const Icon(
// //             Icons.keyboard_arrow_down_rounded,
// //             color: Colors.white,
// //           ),
// //           items: items,
// //           onChanged: onChanged,
// //           selectedItemBuilder: (context) => items
// //               .map(
// //                 (item) => Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text(
// //                     (item.child as Text).data ?? '',
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 13,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               )
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ── Sheet dropdown (light style) ──
// //   Widget _buildSheetDropdown({
// //     required String hint,
// //     required String? value,
// //     required List<DropdownMenuItem<String>> items,
// //     required void Function(String?) onChanged,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: AppColor.pageBgColor,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(
// //           color: value != null
// //               ? AppColor.lightBlueColor.withOpacity(0.5)
// //               : Colors.grey.shade300,
// //           width: 1.5,
// //         ),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: value,
// //           isExpanded: true,
// //           icon: Icon(
// //             Icons.keyboard_arrow_down_rounded,
// //             color: AppColor.lightBlueColor,
// //           ),
// //           hint: Row(
// //             children: [
// //               Icon(
// //                 Icons.person_outline_rounded,
// //                 size: 16,
// //                 color: AppColor.softGreyText,
// //               ),
// //               const SizedBox(width: 8),
// //               Text(
// //                 hint,
// //                 style: TextStyle(color: AppColor.softGreyText, fontSize: 13),
// //               ),
// //             ],
// //           ),
// //           items: items,
// //           onChanged: onChanged,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ── Status chip (2 per row layout) ──
// //   Widget _statusOption(
// //     String value,
// //     String label,
// //     Color color,
// //     StateSetter setSheet,
// //   ) {
// //     final selected = _createStatus == value;
// //     return GestureDetector(
// //       onTap: () => setSheet(() => _createStatus = value),
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
// //         decoration: BoxDecoration(
// //           color: selected ? color.withOpacity(0.15) : AppColor.pageBgColor,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: selected ? color : Colors.grey.shade300,
// //             width: 2,
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               _statusIcon(value),
// //               color: selected ? color : AppColor.softGreyText,
// //               size: 18,
// //             ),
// //             const SizedBox(width: 6),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: selected ? color : AppColor.softGreyText,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ── BOTTOM SHEET ──
// //   void _showCreateBottomSheet() {
// //     _createStatus = null;
// //     _selectedStudentId = null;
// //     _sheetClassId = '';
// //     _sheetSectionId = '';
// //     _sheetSections = [];
// //     _remarksCtrl.clear();
// //
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (_) => SafeArea(
// //         child: StatefulBuilder(
// //           builder: (ctx, setSheet) => Padding(
// //             padding: EdgeInsets.only(
// //               bottom: MediaQuery.of(ctx).viewInsets.bottom,
// //             ),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: AppColor.cardWhite,
// //                 borderRadius: const BorderRadius.vertical(
// //                   top: Radius.circular(28),
// //                 ),
// //               ),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     // Handle bar
// //                     Center(
// //                       child: Container(
// //                         margin: const EdgeInsets.only(top: 12),
// //                         width: 40,
// //                         height: 4,
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey.shade300,
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //
// //                     // Gradient header
// //                     Container(
// //                       margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 14,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         gradient: AppColor.primaryGradient,
// //                         borderRadius: BorderRadius.circular(18),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Container(
// //                             padding: const EdgeInsets.all(8),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white.withOpacity(0.2),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: const Icon(
// //                               Icons.add_task_rounded,
// //                               color: Colors.white,
// //                               size: 20,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 12),
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 AppText.customText(
// //                                   'Create Attendance',
// //                                   size: 16,
// //                                   weight: FontWeight.bold,
// //                                   color: Colors.white,
// //                                 ),
// //                                 AppText.customText(
// //                                   _displayDate,
// //                                   size: 12,
// //                                   color: Colors.white70,
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           GestureDetector(
// //                             onTap: () => Navigator.pop(ctx),
// //                             child: Container(
// //                               padding: const EdgeInsets.all(6),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.2),
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: const Icon(
// //                                 Icons.close_rounded,
// //                                 color: Colors.white,
// //                                 size: 18,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                     Padding(
// //                       padding: const EdgeInsets.all(20),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // ── Class ──
// //                           AppText.customText(
// //                             'Class',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           _buildSheetDropdown(
// //                             hint: 'Select Class',
// //                             value: _sheetClassId.isEmpty ? null : _sheetClassId,
// //                             items: _classes
// //                                 .map(
// //                                   (e) => DropdownMenuItem<String>(
// //                                     value: e['class_id'] as String,
// //                                     child: Text(e['class_name'] as String),
// //                                   ),
// //                                 )
// //                                 .toList(),
// //                             onChanged: (val) async {
// //                               setSheet(() {
// //                                 _sheetClassId = val ?? '';
// //                                 _sheetSectionId = '';
// //                                 _sheetSections = [];
// //                                 _selectedStudentId = null;
// //                               });
// //                               if (val != null && val.isNotEmpty) {
// //                                 final repo = AllSectionsRepository();
// //                                 final res = await repo.allSectionsApi(val);
// //                                 if (res['success'] == true) {
// //                                   setSheet(() {
// //                                     _sheetSections =
// //                                         List<Map<String, dynamic>>.from(
// //                                           res['data'],
// //                                         );
// //                                   });
// //                                 }
// //                               }
// //                             },
// //                           ),
// //
// //                           const SizedBox(height: 16),
// //
// //                           // ── Section ──
// //                           AppText.customText(
// //                             'Section',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           _buildSheetDropdown(
// //                             hint: 'Select Section',
// //                             value: _sheetSectionId.isEmpty
// //                                 ? null
// //                                 : _sheetSectionId,
// //                             items: _sheetSections
// //                                 .map(
// //                                   (e) => DropdownMenuItem<String>(
// //                                     value: e['section_id'].toString(),
// //                                     child: Text(
// //                                       e['section_name']?.toString() ?? '',
// //                                     ),
// //                                   ),
// //                                 )
// //                                 .toList(),
// //                             onChanged: (val) =>
// //                                 setSheet(() => _sheetSectionId = val ?? ''),
// //                           ),
// //
// //                           const SizedBox(height: 16),
// //
// //                           // ── Student ──
// //                           AppText.customText(
// //                             'Student',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Consumer<AllStudentListVieModel>(
// //                             builder: (context, vm, _) {
// //                               final allStudents = vm.allStudentListModel?.data ?? [];
// //
// //                               final filtered = allStudents.where((s) {
// //                                 final cm = _sheetClassId.isEmpty || s.classId.toString() == _sheetClassId;
// //                                 final sm = _sheetSectionId.isEmpty || s.sectionId.toString() == _sheetSectionId;
// //                                 return cm && sm;
// //                               }).toList();
// //
// //                               return Container(
// //                                 height: 200,
// //                                 decoration: BoxDecoration(
// //                                   color: AppColor.pageBgColor,
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 child: ListView.builder(
// //                                   itemCount: filtered.length,
// //                                   itemBuilder: (context, index) {
// //                                     final s = filtered[index];
// //                                     final id = s.studentId.toString();
// //
// //                                     return CheckboxListTile(
// //                                       value: _selectedStudentIds.contains(id),
// //                                       onChanged: (val) {
// //                                         setSheet(() {
// //                                           if (val == true) {
// //                                             _selectedStudentIds.add(id);
// //                                           } else {
// //                                             _selectedStudentIds.remove(id);
// //                                           }
// //                                         });
// //                                       },
// //                                       title: Text(s.name ?? ''),
// //                                     );
// //                                   },
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           const SizedBox(height: 20),
// //
// //                           // ── Date Picker ──
// //                           AppText.customText(
// //                             'Attendance Date',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           GestureDetector(
// //                             onTap: () async {
// //                               final selected = await showDatePicker(
// //                                 context: context,
// //                                 initialDate: _selectedDate,
// //                                 firstDate: DateTime(2020),
// //                                 lastDate: DateTime(2100),
// //                               );
// //                               if (selected != null) {
// //                                 setSheet(() => _selectedDate = selected);
// //                               }
// //                             },
// //                             child: Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 12,
// //                                 vertical: 14,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: AppColor.pageBgColor,
// //                                 borderRadius: BorderRadius.circular(14),
// //                                 border: Border.all(color: Colors.grey.shade300),
// //                               ),
// //                               child: Row(
// //                                 children: [
// //                                   Icon(
// //                                     Icons.calendar_today,
// //                                     size: 16,
// //                                     color: AppColor.softGreyText,
// //                                   ),
// //                                   const SizedBox(width: 10),
// //                                   Text(
// //                                     _displayDate,
// //                                     style: TextStyle(
// //                                       color: AppColor.softGreyText,
// //                                       fontSize: 13,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //
// //                           const SizedBox(height: 20),
// //
// //                           // ── Status — 5 options in 2 rows (3 + 2) ──
// //                           AppText.customText(
// //                             'Status',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 12),
// //
// //                           // Row 1: P | A | L
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: _statusOption(
// //                                   'P',
// //                                   'Present',
// //                                   Colors.green,
// //                                   setSheet,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: _statusOption(
// //                                   'A',
// //                                   'Absent',
// //                                   Colors.red,
// //                                   setSheet,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: _statusOption(
// //                                   'L',
// //                                   'Leave',
// //                                   Colors.orange,
// //                                   setSheet,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                           // Row 2: H | OL
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: _statusOption(
// //                                   'H',
// //                                   'Half Day',
// //                                   Colors.purple,
// //                                   setSheet,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               // Expanded(
// //                               //   child: _statusOption(
// //                               //     'OL',
// //                               //     'On Leave',
// //                               //     Colors.blue,
// //                               //     setSheet,
// //                               //   ),
// //                               // ),
// //                               // Empty spacer to keep alignment
// //                               const Expanded(child: SizedBox()),
// //                             ],
// //                           ),
// //
// //                           const SizedBox(height: 20),
// //
// //                           // ── Remarks ──
// //                           AppText.customText(
// //                             'Remarks (Optional)',
// //                             size: 14,
// //                             weight: FontWeight.w600,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           TextField(
// //                             controller: _remarksCtrl,
// //                             maxLines: 3,
// //                             decoration: InputDecoration(
// //                               hintText: 'Add a note...',
// //                               hintStyle: TextStyle(
// //                                 color: AppColor.softGreyText,
// //                                 fontSize: 13,
// //                               ),
// //                               filled: true,
// //                               fillColor: AppColor.pageBgColor,
// //                               prefixIcon: const Padding(
// //                                 padding: EdgeInsets.only(
// //                                   left: 12,
// //                                   right: 8,
// //                                   top: 12,
// //                                 ),
// //                                 child: Icon(Icons.notes_rounded, size: 18),
// //                               ),
// //                               prefixIconConstraints: const BoxConstraints(
// //                                 minWidth: 0,
// //                                 minHeight: 0,
// //                               ),
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(14),
// //                                 borderSide: BorderSide.none,
// //                               ),
// //                               contentPadding: const EdgeInsets.all(14),
// //                             ),
// //                           ),
// //
// //                           const SizedBox(height: 24),
// //
// //                           // ── Submit ──
// //                           Consumer<CreateStudentAttendanceViewModel>(
// //                             builder: (context, createVm, _) {
// //                               // final canSubmit =
// //                               //     _selectedStudentId != null &&
// //                               //     _createStatus != null &&
// //                               //     _sheetClassId.isNotEmpty &&
// //                               //     _sheetSectionId.isNotEmpty;
// //                               final canSubmit =
// //                                   _selectedStudentIds.isNotEmpty &&
// //                                       _createStatus != null &&
// //                                       _sheetClassId.isNotEmpty &&
// //                                       _sheetSectionId.isNotEmpty;
// //                               return SizedBox(
// //                                 width: double.infinity,
// //                                 height: 50,
// //                                 child: ElevatedButton.icon(
// //                                   onPressed: (!canSubmit || createVm.loading)
// //                                       ? null
// //                                       : () async {
// //                                           final success =
// //                                               await Provider.of<
// //                                                     CreateStudentAttendanceViewModel
// //                                                   >(context, listen: false)
// //                                                   .createStudentAttendanceApi(
// //                                                 classId: int.parse(_sheetClassId),
// //                                                 sectionId: int.parse(_sheetSectionId),
// //                                                 attendanceDate: _apiDate,
// //                                                 students: _selectedStudentIds.map((id) {
// //                                                   return {
// //                                                     'student_id': int.parse(id),
// //                                                     'status': _createStatus!,
// //                                                     'remarks': _remarksCtrl.text.trim(),
// //                                                   };
// //                                                 }).toList(),
// //                                                 context: context,
// //                                               );
// //                                               // createStudentAttendanceApi(
// //                                               //       // ✅ Postman payload match
// //                                               //       classId: int.parse(
// //                                               //         _sheetClassId,
// //                                               //       ),
// //                                               //       sectionId: int.parse(
// //                                               //         _sheetSectionId,
// //                                               //       ),
// //                                               //       attendanceDate: _apiDate,
// //                                               //       students: [
// //                                               //         {
// //                                               //           'student_id': int.parse(
// //                                               //             _selectedStudentId!,
// //                                               //           ),
// //                                               //           'status':
// //                                               //               _createStatus!, // P|A|L|H|OL
// //                                               //           'remarks': _remarksCtrl
// //                                               //               .text
// //                                               //               .trim(),
// //                                               //         },
// //                                               //       ],
// //                                               //       context: context,
// //                                               //     );
// //
// //                                           if (success) {
// //                                             // ignore: use_build_context_synchronously
// //                                             Navigator.pop(context);
// //                                             _fetchAttendance();
// //                                           }
// //                                         },
// //                                   icon: createVm.loading
// //                                       ? const SizedBox(
// //                                           width: 18,
// //                                           height: 18,
// //                                           child: CircularProgressIndicator(
// //                                             color: Colors.white,
// //                                             strokeWidth: 2,
// //                                           ),
// //                                         )
// //                                       : const Icon(
// //                                           Icons.check_rounded,
// //                                           color: Colors.white,
// //                                         ),
// //                                   label: Text(
// //                                     createVm.loading
// //                                         ? 'Saving...'
// //                                         : 'Save Attendance',
// //                                     style: const TextStyle(
// //                                       fontSize: 15,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                   style: ElevatedButton.styleFrom(
// //                                     backgroundColor: canSubmit
// //                                         ? AppColor.lightBlueColor
// //                                         : Colors.grey.shade300,
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(14),
// //                                     ),
// //                                     elevation: 0,
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           const SizedBox(height: 8),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ── BUILD ──
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColor.screenBg,
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: _showCreateBottomSheet,
// //         backgroundColor: AppColor.lightBlueColor,
// //         icon: const Icon(Icons.add_rounded, color: Colors.white),
// //         label: const Text(
// //           'Create Attendance',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           // HEADER
// //           Container(
// //             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
// //             decoration: BoxDecoration(
// //               gradient: AppColor.primaryGradient,
// //               borderRadius: const BorderRadius.vertical(
// //                 bottom: Radius.circular(28),
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: AppColor.blueShadow,
// //                   blurRadius: 18,
// //                   offset: const Offset(0, 10),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     InkWell(
// //                       onTap: () => Navigator.pop(context),
// //                       child: Container(
// //                         padding: const EdgeInsets.all(10),
// //                         decoration: BoxDecoration(
// //                           color: AppColor.glassWhite,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: const Icon(
// //                           Icons.arrow_back_ios_new_rounded,
// //                           color: Colors.white,
// //                           size: 20,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: AppText.customText(
// //                         'Student Attendance',
// //                         size: 19,
// //                         weight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //
// //                 // Class & Section filter
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: _buildFilterDropdown(
// //                         label: 'Class',
// //                         value: _selectedClassId.isEmpty
// //                             ? null
// //                             : _selectedClassId,
// //                         items: _classes
// //                             .map(
// //                               (e) => DropdownMenuItem<String>(
// //                                 value: e['class_id'] as String,
// //                                 child: Text(e['class_name'] as String),
// //                               ),
// //                             )
// //                             .toList(),
// //                         onChanged: _onClassChanged,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: _buildFilterDropdown(
// //                         label: 'Section',
// //                         value: _selectedSectionId.isEmpty
// //                             ? null
// //                             : _selectedSectionId,
// //                         items: _sections
// //                             .map(
// //                               (e) => DropdownMenuItem<String>(
// //                                 value: e['section_id'].toString(),
// //                                 child: Text(
// //                                   e['section_name']?.toString() ?? '',
// //                                 ),
// //                               ),
// //                             )
// //                             .toList(),
// //                         onChanged: _onSectionChanged,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //
// //                 // Date selector
// //                 GestureDetector(
// //                   onTap: _pickDate,
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 12,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.15),
// //                       borderRadius: BorderRadius.circular(16),
// //                       border: Border.all(
// //                         color: Colors.white.withOpacity(0.3),
// //                         width: 1,
// //                       ),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(8),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           child: const Icon(
// //                             Icons.calendar_month_rounded,
// //                             color: Colors.white,
// //                             size: 18,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               AppText.customText(
// //                                 'Selected Date',
// //                                 size: 11,
// //                                 color: Colors.white70,
// //                               ),
// //                               AppText.customText(
// //                                 _displayDate,
// //                                 size: 15,
// //                                 weight: FontWeight.bold,
// //                                 color: Colors.white,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 10,
// //                             vertical: 5,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(
// //                                 Icons.edit_calendar_rounded,
// //                                 color: Colors.white,
// //                                 size: 13,
// //                               ),
// //                               const SizedBox(width: 4),
// //                               AppText.customText(
// //                                 'Change',
// //                                 size: 11,
// //                                 color: Colors.white,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // BODY
// //           Expanded(
// //             child: Consumer<AllStudentAdminAttendanceViewModel>(
// //               builder: (context, vm, _) {
// //                 if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(
// //                           Icons.filter_list_rounded,
// //                           size: 72,
// //                           color: AppColor.lightBlueColor.withOpacity(0.3),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         AppText.customText(
// //                           'Select Class & Section',
// //                           size: 16,
// //                           weight: FontWeight.bold,
// //                         ),
// //                         const SizedBox(height: 6),
// //                         AppText.customText(
// //                           'Choose class and section above to view attendance',
// //                           size: 13,
// //                           color: AppColor.softGreyText,
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }
// //
// //                 if (vm.loading) {
// //                   return Center(
// //                     child: CircularProgressIndicator(
// //                       color: AppColor.lightBlueColor,
// //                     ),
// //                   );
// //                 }
// //
// //                 final students = vm.attendanceModel?.data?.students ?? [];
// //                 final totalStudents =
// //                     vm.attendanceModel?.data?.totalStudents ?? 0;
// //
// //                 if (students.isEmpty) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(
// //                           Icons.event_busy_rounded,
// //                           size: 72,
// //                           color: AppColor.lightBlueColor.withOpacity(0.3),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         AppText.customText(
// //                           'No Attendance Found',
// //                           size: 16,
// //                           weight: FontWeight.bold,
// //                         ),
// //                         const SizedBox(height: 6),
// //                         AppText.customText(
// //                           'No records for $_displayDate',
// //                           size: 13,
// //                           color: AppColor.softGreyText,
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }
// //
// //                 return SingleChildScrollView(
// //                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
// //                   child: Column(
// //                     children: [
// //                       // Summary
// //                       Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           gradient: AppColor.primaryGradient,
// //                           borderRadius: BorderRadius.circular(16),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: AppColor.blueShadow,
// //                               blurRadius: 10,
// //                               offset: const Offset(0, 4),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             Expanded(
// //                               child: _infoTile(
// //                                 'Total',
// //                                 totalStudents.toString(),
// //                                 Icons.group_rounded,
// //                                 Colors.white,
// //                               ),
// //                             ),
// //                             Container(
// //                               width: 1,
// //                               height: 40,
// //                               color: Colors.white.withOpacity(0.3),
// //                             ),
// //                             Expanded(
// //                               child: _infoTile(
// //                                 'Marked',
// //                                 students.length.toString(),
// //                                 Icons.check_circle_rounded,
// //                                 Colors.greenAccent,
// //                               ),
// //                             ),
// //                             Container(
// //                               width: 1,
// //                               height: 40,
// //                               color: Colors.white.withOpacity(0.3),
// //                             ),
// //                             Expanded(
// //                               child: _infoTile(
// //                                 'Date',
// //                                 DateFormat('dd MMM').format(_selectedDate),
// //                                 Icons.calendar_today_rounded,
// //                                 Colors.white70,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       // const SizedBox(height: 20),
// //
// //                       // Student list
// //                       // ListView.builder(
// //                       //   itemCount: students.length,
// //                       //   shrinkWrap: true,
// //                       //   physics: const NeverScrollableScrollPhysics(),
// //                       //   itemBuilder: (context, index) {
// //                       //     final s = students[index];
// //                       //     final name = s.studentName ?? '';
// //                       //     final initials = name.isNotEmpty
// //                       //         ? name[0].toUpperCase()
// //                       //         : '?';
// //                       //     final fullName = name.isNotEmpty
// //                       //         ? name[0].toUpperCase() + name.substring(1)
// //                       //         : '—';
// //                       //     final timeStr = _formatTime(s.markedAt);
// //                       //
// //                       //     return Container(
// //                       //       margin: const EdgeInsets.only(bottom: 12),
// //                       //       padding: const EdgeInsets.all(14),
// //                       //       decoration: BoxDecoration(
// //                       //         color: Colors.white,
// //                       //         borderRadius: BorderRadius.circular(16),
// //                       //         boxShadow: [
// //                       //           BoxShadow(
// //                       //               color: AppColor.cardShadow,
// //                       //               blurRadius: 8,
// //                       //               offset: const Offset(0, 4)),
// //                       //         ],
// //                       //       ),
// //                       //       child: Row(
// //                       //         children: [
// //                       //           Container(
// //                       //             width: 46,
// //                       //             height: 46,
// //                       //             decoration: BoxDecoration(
// //                       //               color: AppColor.lightBlueColor
// //                       //                   .withOpacity(0.12),
// //                       //               shape: BoxShape.circle,
// //                       //             ),
// //                       //             child: Center(
// //                       //               child: AppText.customText(initials,
// //                       //                   size: 16,
// //                       //                   weight: FontWeight.bold,
// //                       //                   color: AppColor.lightBlueColor),
// //                       //             ),
// //                       //           ),
// //                       //           const SizedBox(width: 12),
// //                       //           Expanded(
// //                       //             child: Column(
// //                       //               crossAxisAlignment:
// //                       //               CrossAxisAlignment.start,
// //                       //               children: [
// //                       //                 AppText.customText(fullName,
// //                       //                     size: 14, weight: FontWeight.bold),
// //                       //                 const SizedBox(height: 3),
// //                       //                 AppText.customText(
// //                       //                     'Adm: ${s.admissionNo ?? "—"}',
// //                       //                     size: 12,
// //                       //                     color: AppColor.softGreyText),
// //                       //                 if (s.fatherName != null &&
// //                       //                     s.fatherName!.isNotEmpty) ...[
// //                       //                   const SizedBox(height: 2),
// //                       //                   AppText.customText(
// //                       //                       'Father: ${s.fatherName}',
// //                       //                       size: 12,
// //                       //                       color: AppColor.softGreyText),
// //                       //                 ],
// //                       //               ],
// //                       //             ),
// //                       //           ),
// //                       //           Column(
// //                       //             crossAxisAlignment: CrossAxisAlignment.end,
// //                       //             children: [
// //                       //               Container(
// //                       //                 padding: const EdgeInsets.symmetric(
// //                       //                     horizontal: 12, vertical: 6),
// //                       //                 decoration: BoxDecoration(
// //                       //                   color:
// //                       //                   Colors.green.withOpacity(0.12),
// //                       //                   borderRadius:
// //                       //                   BorderRadius.circular(20),
// //                       //                 ),
// //                       //                 child: Row(
// //                       //                   mainAxisSize: MainAxisSize.min,
// //                       //                   children: [
// //                       //                     const Icon(
// //                       //                         Icons.check_circle_rounded,
// //                       //                         color: Colors.green,
// //                       //                         size: 13),
// //                       //                     const SizedBox(width: 4),
// //                       //                     AppText.customText('Present',
// //                       //                         size: 12,
// //                       //                         weight: FontWeight.w600,
// //                       //                         color: Colors.green),
// //                       //                   ],
// //                       //                 ),
// //                       //               ),
// //                       //               if (timeStr.isNotEmpty) ...[
// //                       //                 const SizedBox(height: 4),
// //                       //                 AppText.customText(timeStr,
// //                       //                     size: 11,
// //                       //                     color: AppColor.softGreyText),
// //                       //               ],
// //                       //             ],
// //                       //           ),
// //                       //         ],
// //                       //       ),
// //                       //     );
// //                       //   },
// //                       // ),
// //                       ListView.builder(
// //                         itemCount: students.length,
// //                         shrinkWrap: true,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         itemBuilder: (context, index) {
// //                           final s = students[index];
// //
// //                           final name = s.studentName ?? '';
// //                           final initials = name.isNotEmpty
// //                               ? name[0].toUpperCase()
// //                               : '?';
// //
// //                           final fullName = name.isNotEmpty
// //                               ? name[0].toUpperCase() + name.substring(1)
// //                               : '—';
// //
// //                           final timeStr = _formatTime(s.markedAt);
// //
// //                           // ✅ STATUS FIX
// //                           final status = s.status?.toUpperCase() ?? '';
// //                           final statusColor = _statusColor(status);
// //                           final statusIcon = _statusIcon(status);
// //
// //                           return Container(
// //                             margin: const EdgeInsets.only(bottom: 12),
// //                             padding: const EdgeInsets.all(14),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(16),
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: AppColor.cardShadow,
// //                                   blurRadius: 8,
// //                                   offset: const Offset(0, 4),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 // Avatar
// //                                 Container(
// //                                   width: 46,
// //                                   height: 46,
// //                                   decoration: BoxDecoration(
// //                                     color: AppColor.lightBlueColor.withOpacity(
// //                                       0.12,
// //                                     ),
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: Center(
// //                                     child: AppText.customText(
// //                                       initials,
// //                                       size: 16,
// //                                       weight: FontWeight.bold,
// //                                       color: AppColor.lightBlueColor,
// //                                     ),
// //                                   ),
// //                                 ),
// //
// //                                 const SizedBox(width: 12),
// //
// //                                 // Name + Info
// //                                 Expanded(
// //                                   child: Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       AppText.customText(
// //                                         fullName,
// //                                         size: 14,
// //                                         weight: FontWeight.bold,
// //                                       ),
// //                                       const SizedBox(height: 3),
// //
// //                                       AppText.customText(
// //                                         'Adm: ${s.admissionNo ?? "—"}',
// //                                         size: 12,
// //                                         color: AppColor.softGreyText,
// //                                       ),
// //
// //                                       if (s.fatherName != null &&
// //                                           s.fatherName!.isNotEmpty) ...[
// //                                         const SizedBox(height: 2),
// //                                         AppText.customText(
// //                                           'Father: ${s.fatherName}',
// //                                           size: 12,
// //                                           color: AppColor.softGreyText,
// //                                         ),
// //                                       ],
// //                                     ],
// //                                   ),
// //                                 ),
// //
// //                                 // ✅ STATUS CHIP (Dynamic)
// //                                 Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.end,
// //                                   children: [
// //                                     Container(
// //                                       padding: const EdgeInsets.symmetric(
// //                                         horizontal: 12,
// //                                         vertical: 6,
// //                                       ),
// //                                       decoration: BoxDecoration(
// //                                         color: statusColor.withOpacity(0.12),
// //                                         borderRadius: BorderRadius.circular(20),
// //                                       ),
// //                                       child: Row(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         children: [
// //                                           Icon(
// //                                             statusIcon,
// //                                             color: statusColor,
// //                                             size: 13,
// //                                           ),
// //                                           const SizedBox(width: 4),
// //                                           AppText.customText(
// //                                             _getStatusLabel(status),
// //                                             size: 12,
// //                                             weight: FontWeight.w600,
// //                                             color: statusColor,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //
// //                                     if (timeStr.isNotEmpty) ...[
// //                                       const SizedBox(height: 4),
// //                                       AppText.customText(
// //                                         timeStr,
// //                                         size: 11,
// //                                         color: AppColor.softGreyText,
// //                                       ),
// //                                     ],
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _infoTile(String label, String value, IconData icon, Color color) {
// //     return Column(
// //       children: [
// //         Icon(icon, color: color, size: 20),
// //         const SizedBox(height: 4),
// //         Text(
// //           value,
// //           style: const TextStyle(
// //             fontSize: 16,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7)),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
// import 'package:school_pro/view_model/student_view_model/create_student_attendance_view_model.dart';
// import '../../repo/school_repo/all_sections_repo.dart';
// import '../../res/app_color.dart';
// import '../../res/const_text.dart';
// import '../../view_model/school_view_model/all_student_attendance_view_model.dart';
//
// class _StudentRow {
//   final String id;
//   final String name;
//   final String admissionNo;
//   final String fatherName;
//   String? attendanceStatus;
//   bool alreadyMarked;
//   String? markedStatus;
//   final TextEditingController remarksCtrl;
//
//   _StudentRow({
//     required this.id,
//     required this.name,
//     required this.admissionNo,
//     required this.fatherName,
//     this.attendanceStatus,
//     this.alreadyMarked = false,
//     this.markedStatus,
//   }) : remarksCtrl = TextEditingController();
//
//   void dispose() => remarksCtrl.dispose();
// }
//
// class AllStudentAdminAttendanceScreen extends StatefulWidget {
//   const AllStudentAdminAttendanceScreen({super.key});
//
//   @override
//   State<AllStudentAdminAttendanceScreen> createState() =>
//       _AllStudentAdminAttendanceScreenState();
// }
//
// class _AllStudentAdminAttendanceScreenState
//     extends State<AllStudentAdminAttendanceScreen> {
//   DateTime _selectedDate = DateTime.now();
//   String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
//   String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);
//
//   String _selectedClassId = '';
//   String _selectedSectionId = '';
//   List<Map<String, dynamic>> _classes = [];
//   List<Map<String, dynamic>> _sections = [];
//
//   List<_StudentRow> _rows = [];
//   bool _saving = false;
//   bool _loadingRows = false;
//
//   late AllClassesViewModel _classesVm;
//
//   static const _statuses = [
//     {'code': 'P', 'full': 'Present'},
//     {'code': 'A', 'full': 'Absent'},
//     {'code': 'L', 'full': 'Leave'},
//     {'code': 'H', 'full': 'Half Day'},
//     {'code': 'OL', 'full': 'On Leave'},
//   ];
//
//   Color _statusColor(String? s) {
//     switch (s) {
//       case 'P':  return const Color(0xFF22C55E);
//       case 'A':  return const Color(0xFFEF4444);
//       case 'L':  return const Color(0xFFF59E0B);
//       case 'H':  return const Color(0xFFA855F7);
//       case 'OL': return const Color(0xFF3B82F6);
//       default:   return Colors.grey;
//     }
//   }
//
//   IconData _statusIcon(String? s) {
//     switch (s) {
//       case 'P':  return Icons.check_circle_rounded;
//       case 'A':  return Icons.cancel_rounded;
//       case 'L':  return Icons.event_busy_rounded;
//       case 'H':  return Icons.av_timer_rounded;
//       case 'OL': return Icons.medical_services_rounded;
//       default:   return Icons.help_outline_rounded;
//     }
//   }
//
//   String _statusLabel(String? s) {
//     switch (s) {
//       case 'P':  return 'Present';
//       case 'A':  return 'Absent';
//       case 'L':  return 'Leave';
//       case 'H':  return 'Half Day';
//       case 'OL': return 'On Leave';
//       default:   return s ?? '';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _classesVm = Provider.of<AllClassesViewModel>(context, listen: false);
//       _classesVm.allClassesApi(context);
//       _classesVm.addListener(_onClassesLoaded);
//       Provider.of<AllStudentListVieModel>(context, listen: false)
//           .allStudentListApi(context);
//     });
//   }
//
//   void _onClassesLoaded() {
//     if (!mounted) return;
//     final data = _classesVm.allClassesModel?.data ?? [];
//     if (data.isNotEmpty && _classes.isEmpty) {
//       setState(() {
//         _classes = data
//             .map((e) => {
//           'class_id': e.classId.toString(),
//           'class_name': e.className ?? '',
//         })
//             .toList();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     for (final r in _rows) r.dispose();
//     _classesVm.removeListener(_onClassesLoaded);
//     super.dispose();
//   }
//
//   Future<void> _buildAndLoadRows() async {
//     if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) return;
//     setState(() => _loadingRows = true);
//
//     await Provider.of<AllStudentAdminAttendanceViewModel>(context, listen: false)
//         .getAttendance(
//       classId: int.parse(_selectedClassId),
//       sectionId: int.parse(_selectedSectionId),
//       date: _apiDate,
//       context: context,
//     );
//
//     final attVm = Provider.of<AllStudentAdminAttendanceViewModel>(context, listen: false);
//     final markedList = attVm.attendanceModel?.data?.students ?? [];
//
//     final Map<String, String> markedMap = {
//       for (final r in markedList)
//         if (r.studentId != null) r.studentId.toString(): r.status ?? '',
//     };
//
//     final allStudents =
//         Provider.of<AllStudentListVieModel>(context, listen: false)
//             .allStudentListModel?.data ?? [];
//
//     final filtered = allStudents.where((s) {
//       return s.classId.toString() == _selectedClassId &&
//           s.sectionId.toString() == _selectedSectionId;
//     }).toList();
//
//     for (final r in _rows) r.dispose();
//
//     setState(() {
//       _rows = filtered.map((s) {
//         final id = s.studentId.toString();
//         final already = markedMap.containsKey(id);
//         return _StudentRow(
//           id: id,
//           name: s.name ?? '',
//           admissionNo: s.admissionNo ?? '',
//           fatherName: s.fatherName ?? '',
//           alreadyMarked: already,
//           markedStatus: markedMap[id],
//           attendanceStatus: already ? markedMap[id] : null,
//         );
//       }).toList();
//       _loadingRows = false;
//     });
//   }
//
//   Future<void> _onClassChanged(String? classId) async {
//     setState(() {
//       _selectedClassId = classId ?? '';
//       _selectedSectionId = '';
//       _sections = [];
//       _rows = [];
//     });
//     if (classId == null || classId.isEmpty) return;
//     try {
//       final res = await AllSectionsRepository().allSectionsApi(classId);
//       if (res['success'] == true) {
//         setState(() => _sections = List<Map<String, dynamic>>.from(res['data']));
//       }
//     } catch (_) {}
//   }
//
//   Future<void> _onSectionChanged(String? sectionId) async {
//     setState(() { _selectedSectionId = sectionId ?? ''; _rows = []; });
//     await _buildAndLoadRows();
//   }
//
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
//       setState(() => _selectedDate = picked);
//       await _buildAndLoadRows();
//     }
//   }
//
//   void _markAllPresent() {
//     setState(() {
//       for (final r in _rows) {
//         if (!r.alreadyMarked) r.attendanceStatus = 'P';
//       }
//     });
//   }
//   Future<void> _saveAll() async {
//     final pending = _rows.where((r) => !r.alreadyMarked).toList();
//
//     if (pending.isEmpty) {
//       _snack(
//         'All students\' attendance has already been marked.',
//         Colors.blue,
//         Icons.info_rounded,
//       );
//       return;
//     }
//
//     final incomplete =
//     pending.where((r) => r.attendanceStatus == null).toList();
//
//     if (incomplete.isNotEmpty) {
//       _snack(
//         '${incomplete.length} student(s) attendance status is not selected.',
//         Colors.orange,
//         Icons.warning_rounded,
//       );
//       return;
//     }
//
//     setState(() => _saving = true);
//
//     final ok = await Provider.of<CreateStudentAttendanceViewModel>(
//       context,
//       listen: false,
//     ).createStudentAttendanceApi(
//       classId: int.parse(_selectedClassId),
//       sectionId: int.parse(_selectedSectionId),
//       attendanceDate: _apiDate,
//       students: pending.map((r) => {
//         'student_id': int.parse(r.id),
//         'status': r.attendanceStatus,
//         'remarks': r.remarksCtrl.text.trim(),
//       }).toList(),
//       context: context,
//     );
//
//     if (ok) {
//       setState(() {
//         for (final r in pending) {
//           r.alreadyMarked = true;
//           r.markedStatus = r.attendanceStatus;
//         }
//       });
//
//       // _snack(
//       //   '${pending.length} student(s) attendance saved successfully.',
//       //   Colors.green,
//       //   Icons.check_circle_rounded,
//       // );
//     }
//
//     setState(() => _saving = false);
//   }
//   // Future<void> _saveAll() async {
//   //   final pending = _rows.where((r) => !r.alreadyMarked).toList();
//   //
//   //   if (pending.isEmpty) {
//   //     _snack('Sabki attendance already mark ho chuki hai', Colors.blue, Icons.info_rounded);
//   //     return;
//   //   }
//   //
//   //   final incomplete = pending.where((r) => r.attendanceStatus == null);
//   //   // if (incomplete.isNotEmpty) {
//   //   //   _snack('${incomplete.length} student(s) ka status select karo', Colors.orange, Icons.warning_rounded);
//   //   //   return;
//   //   // }
//   //
//   //   setState(() => _saving = true);
//   //
//   //   final ok = await Provider.of<CreateStudentAttendanceViewModel>(context, listen: false)
//   //       .createStudentAttendanceApi(
//   //     classId: int.parse(_selectedClassId),
//   //     sectionId: int.parse(_selectedSectionId),
//   //     attendanceDate: _apiDate,
//   //     students: pending.map((r) => {
//   //       'student_id': int.parse(r.id),
//   //       'status': r.attendanceStatus!,
//   //       'remarks': r.remarksCtrl.text.trim(),
//   //     }).toList(),
//   //     context: context,
//   //   );
//   //
//   //   if (ok) {
//   //     setState(() {
//   //       for (final r in pending) {
//   //         r.alreadyMarked = true;
//   //         r.markedStatus = r.attendanceStatus;
//   //       }
//   //     });
//   //     _snack('${pending.length} attendance save ho gayi', Colors.green, Icons.check_circle_rounded);
//   //   }
//   //
//   //   setState(() => _saving = false);
//   // }
//
//   void _snack(String msg, Color color, IconData icon) {
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
//   @override
//   Widget build(BuildContext context) {
//     final hasPending = _rows.any((r) => !r.alreadyMarked);
//     return Scaffold(
//       backgroundColor: AppColor.screenBg,
//       body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
//       floatingActionButton: hasPending
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
//                   ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                   : const Icon(Icons.save_rounded, color: Colors.white),
//               label: Text(_saving ? 'Saving...' : 'Save All Attendance',
//                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
//             ),
//           ),
//         ]),
//       )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//       decoration: BoxDecoration(
//         gradient: AppColor.primaryGradient,
//         borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
//         boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
//       ),
//       child: Column(children: [
//         Row(children: [
//           InkWell(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
//               child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(child: AppText.customText('Student Attendance', size: 19, weight: FontWeight.bold, color: Colors.white)),
//         ]),
//         const SizedBox(height: 16),
//         Row(children: [
//           Expanded(child: _filterDropdown(
//             label: 'Class',
//             value: _selectedClassId.isEmpty ? null : _selectedClassId,
//             items: _classes.map((e) => DropdownMenuItem<String>(value: e['class_id'] as String, child: Text(e['class_name'] as String))).toList(),
//             onChanged: _onClassChanged,
//           )),
//           const SizedBox(width: 12),
//           Expanded(child: _filterDropdown(
//             label: 'Section',
//             value: _selectedSectionId.isEmpty ? null : _selectedSectionId,
//             items: _sections.map((e) => DropdownMenuItem<String>(value: e['section_id'].toString(), child: Text(e['section_name']?.toString() ?? ''))).toList(),
//             onChanged: _onSectionChanged,
//           )),
//         ]),
//         const SizedBox(height: 12),
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
//                 decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                 child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 AppText.customText('Selected Date', size: 11, color: Colors.white70),
//                 AppText.customText(_displayDate, size: 15, weight: FontWeight.bold, color: Colors.white),
//               ])),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
//                 child: Row(children: [
//                   const Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 13),
//                   const SizedBox(width: 4),
//                   AppText.customText('Change', size: 11, color: Colors.white),
//                 ]),
//               ),
//             ]),
//           ),
//         ),
//         const SizedBox(height: 14),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(children: _statuses.map((s) {
//             final color = _statusColor(s['code']);
//             return Container(
//               margin: const EdgeInsets.only(right: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: color.withOpacity(0.5)),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//                 const SizedBox(width: 5),
//                 Text('${s['code']} = ${s['full']}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
//               ]),
//             );
//           }).toList()),
//         ),
//       ]),
//     );
//   }
//
//   Widget _buildBody() {
//     if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) {
//       return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.filter_list_rounded, size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
//         const SizedBox(height: 16),
//         AppText.customText('Select Class & Section', size: 16, weight: FontWeight.bold),
//         const SizedBox(height: 6),
//         AppText.customText('Choose class and section to mark attendance', size: 13, color: AppColor.softGreyText),
//       ]));
//     }
//     if (_loadingRows) {
//       return Center(child: CircularProgressIndicator(color: AppColor.lightBlueColor));
//     }
//     if (_rows.isEmpty) {
//       return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.people_outline_rounded, size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
//         const SizedBox(height: 16),
//         AppText.customText('No Students Found', size: 16, weight: FontWeight.bold),
//       ]));
//     }
//
//     final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
//     final pendingCount = _rows.length - alreadyCount;
//
//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
//         child: Row(children: [
//           if (alreadyCount > 0) ...[
//             _countPill('$alreadyCount Already Marked', Colors.green, Icons.check_circle_rounded),
//             const SizedBox(width: 8),
//           ],
//           if (pendingCount > 0)
//             _countPill('$pendingCount Pending', Colors.orange, Icons.pending_rounded),
//           const Spacer(),
//           Text('Total: ${_rows.length}', style: TextStyle(fontSize: 12, color: AppColor.softGreyText, fontWeight: FontWeight.w500)),
//         ]),
//       ),
//       Expanded(
//         child: ListView.builder(
//           padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
//           itemCount: _rows.length,
//           itemBuilder: (_, i) => _buildStudentCard(_rows[i]),
//         ),
//       ),
//     ]);
//   }
//
//   Widget _buildStudentCard(_StudentRow row) {
//     if (!row.alreadyMarked && row.attendanceStatus == null) {
//       row.attendanceStatus = 'P';
//     }
//     return StatefulBuilder(builder: (context, setRow) {
//       final isLocked = row.alreadyMarked;
//       final borderColor = isLocked
//           ? _statusColor(row.markedStatus).withOpacity(0.4)
//           : (row.attendanceStatus != null
//           ? _statusColor(row.attendanceStatus).withOpacity(0.3)
//           : Colors.grey.shade200);
//
//       return Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: isLocked ? _statusColor(row.markedStatus).withOpacity(0.03) : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor, width: 1.5),
//           boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 6, offset: const Offset(0, 3))],
//         ),
//         child: Column(children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
//             child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Container(
//                 width: 40, height: 40,
//                 decoration: BoxDecoration(
//                   color: isLocked ? _statusColor(row.markedStatus).withOpacity(0.12) : AppColor.lightBlueColor.withOpacity(0.12),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(child: Text(
//                   row.name.isNotEmpty ? row.name[0].toUpperCase() : '?',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
//                       color: isLocked ? _statusColor(row.markedStatus) : AppColor.lightBlueColor),
//                 )),
//               ),
//               const SizedBox(width: 10),
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(
//                   row.name.isNotEmpty ? row.name[0].toUpperCase() + row.name.substring(1) : '—',
//                   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 2),
//                 Text('Adm: ${row.admissionNo}', style: TextStyle(fontSize: 11, color: AppColor.softGreyText)),
//                 if (row.fatherName.isNotEmpty) ...[
//                   const SizedBox(height: 1),
//                   Text('Father: ${row.fatherName}', style: TextStyle(fontSize: 11, color: AppColor.softGreyText)),
//                 ],
//               ])),
//               if (isLocked)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _statusColor(row.markedStatus).withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: _statusColor(row.markedStatus).withOpacity(0.4)),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.lock_rounded, size: 10, color: _statusColor(row.markedStatus)),
//                     const SizedBox(width: 3),
//                     Text('${_statusLabel(row.markedStatus)} • Marked',
//                         style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(row.markedStatus))),
//                   ]),
//                 ),
//             ]),
//           ),
//           Divider(height: 1, color: Colors.grey.shade100),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               AppText.customText('ATTENDANCE STATUS', size: 10, weight: FontWeight.bold, color: AppColor.softGreyText),
//               const SizedBox(height: 8),
//               Row(children: _statuses.map((s) {
//                 final code = s['code']!;
//                 final selected = row.attendanceStatus == code;
//                 final color = _statusColor(code);
//                 return Expanded(child: GestureDetector(
//                   onTap: isLocked ? null : () => setRow(() => row.attendanceStatus = selected ? null : code),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     margin: const EdgeInsets.only(right: 5),
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       color: selected ? color.withOpacity(0.15) : (isLocked ? Colors.grey.shade100 : Colors.grey.shade50),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: selected ? color : Colors.grey.shade200, width: selected ? 1.5 : 1),
//                     ),
//                     child: Column(mainAxisSize: MainAxisSize.min, children: [
//                       Container(
//                         width: 14, height: 14,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: selected ? color : Colors.grey.shade400, width: 1.5),
//                         ),
//                         child: selected ? Center(child: Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: color))) : null,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(code, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
//                           color: selected ? color : (isLocked ? Colors.grey.shade400 : AppColor.softGreyText))),
//                     ]),
//                   ),
//                 ));
//               }).toList()),
//             ]),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
//             child: TextField(
//               controller: row.remarksCtrl,
//               enabled: !isLocked,
//               style: const TextStyle(fontSize: 12),
//               decoration: InputDecoration(
//                 isDense: true,
//                 hintText: isLocked ? 'Attendance already marked' : 'Enter remarks...',
//                 hintStyle: TextStyle(color: isLocked ? _statusColor(row.markedStatus).withOpacity(0.6) : AppColor.softGreyText, fontSize: 12),
//                 filled: true,
//                 fillColor: isLocked ? _statusColor(row.markedStatus).withOpacity(0.04) : Colors.grey.shade50,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 prefixIcon: isLocked ? Icon(Icons.lock_rounded, size: 14, color: _statusColor(row.markedStatus)) : null,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
//                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
//                 disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _statusColor(row.markedStatus).withOpacity(0.2))),
//                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.lightBlueColor, width: 1.5)),
//               ),
//             ),
//           ),
//         ]),
//       );
//     });
//   }
//
//   Widget _filterDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required void Function(String?) onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: value != null ? Colors.white.withOpacity(0.6) : Colors.white.withOpacity(0.3), width: 1.5),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           isExpanded: true,
//           dropdownColor: Colors.white,
//           hint: Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
//           value: value,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
//           items: items,
//           onChanged: onChanged,
//           selectedItemBuilder: (context) => items.map((item) => Align(
//             alignment: Alignment.centerLeft,
//             child: Text((item.child as Text).data ?? '', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
//           )).toList(),
//         ),
//       ),
//     );
//   }
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
//       Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
//     ]),
//   );
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/student_view_model/create_student_attendance_view_model.dart';
import '../../repo/school_repo/section/all_sections_repo.dart';
import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/attendance/all_student_attendance_view_model.dart';
import '../../view_model/school_view_model/attendance/update_student_attendance_view_model.dart';


class _StudentRow {
  final String id;
  final String name;
  final String admissionNo;
  final String fatherName;
  String? attendanceStatus;
  bool alreadyMarked;
  bool isEditing;
  String? markedStatus;
  String? attendanceId; // ← ADD THIS
  final TextEditingController remarksCtrl;

  _StudentRow({
    required this.id,
    required this.name,
    required this.admissionNo,
    required this.fatherName,
    this.attendanceStatus,
    this.alreadyMarked = false,
    this.isEditing = false,
    this.markedStatus,
    this.attendanceId, // ← ADD THIS
  }) : remarksCtrl = TextEditingController();

  void dispose() => remarksCtrl.dispose();
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class AllStudentAdminAttendanceScreen extends StatefulWidget {
  const AllStudentAdminAttendanceScreen({super.key});

  @override
  State<AllStudentAdminAttendanceScreen> createState() =>
      _AllStudentAdminAttendanceScreenState();
}

class _AllStudentAdminAttendanceScreenState
    extends State<AllStudentAdminAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
  String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);

  String _selectedClassId = '';
  String _selectedSectionId = '';
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _sections = [];

  List<_StudentRow> _rows = [];
  bool _saving = false;
  bool _loadingRows = false;

  late AllClassesViewModel _classesVm;

  static const _statuses = [
    {'code': 'P', 'full': 'Present'},
    {'code': 'A', 'full': 'Absent'},
    {'code': 'L', 'full': 'Leave'},
    {'code': 'H', 'full': 'Half Day'},
    {'code': 'OL', 'full': 'On Leave'},
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────
  Color _statusColor(String? s) {
    switch (s) {
      case 'P':
        return const Color(0xFF22C55E);
      case 'A':
        return const Color(0xFFEF4444);
      case 'L':
        return const Color(0xFFF59E0B);
      case 'H':
        return const Color(0xFFA855F7);
      case 'OL':
        return const Color(0xFF3B82F6);
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String? s) {
    switch (s) {
      case 'P':
        return Icons.check_circle_rounded;
      case 'A':
        return Icons.cancel_rounded;
      case 'L':
        return Icons.event_busy_rounded;
      case 'H':
        return Icons.av_timer_rounded;
      case 'OL':
        return Icons.medical_services_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _statusLabel(String? s) {
    switch (s) {
      case 'P':
        return 'Present';
      case 'A':
        return 'Absent';
      case 'L':
        return 'Leave';
      case 'H':
        return 'Half Day';
      case 'OL':
        return 'On Leave';
      default:
        return s ?? '';
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _classesVm = Provider.of<AllClassesViewModel>(context, listen: false);
      _classesVm.allClassesApi(context);
      _classesVm.addListener(_onClassesLoaded);
      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
    });
  }

  void _onClassesLoaded() {
    if (!mounted) return;
    final data = _classesVm.allClassesModel?.data ?? [];
    if (data.isNotEmpty && _classes.isEmpty) {
      setState(() {
        _classes = data
            .map(
              (e) => {
                'class_id': e.classId.toString(),
                'class_name': e.className ?? '',
              },
            )
            .toList();
      });
    }
  }

  @override
  void dispose() {
    for (final r in _rows) r.dispose();
    _classesVm.removeListener(_onClassesLoaded);
    super.dispose();
  }

  // ── Pull-to-refresh ───────────────────────────────────────────────────────
  Future<void> _onRefresh() async {
    if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) return;
    // Reset rows so _buildAndLoadRows rebuilds them fresh
    for (final r in _rows) r.dispose();
    setState(() => _rows = []);
    await _buildAndLoadRows();
  }

  // ── Load rows for selected class + section ────────────────────────────────
  Future<void> _buildAndLoadRows() async {
    if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) return;
    setState(() => _loadingRows = true);

    await Provider.of<AllStudentAdminAttendanceViewModel>(
      context,
      listen: false,
    ).getAttendance(
      classId: int.parse(_selectedClassId),
      sectionId: int.parse(_selectedSectionId),
      date: _apiDate,
      context: context,
    );

    final attVm = Provider.of<AllStudentAdminAttendanceViewModel>(
      context,
      listen: false,
    );
    final markedList = attVm.attendanceModel?.data?.students ?? [];
    // Change this map to also capture the attendance record PK
    final Map<String, Map<String, String>> markedMap = {
      for (final r in markedList)
        if (r.studentId != null)
          r.studentId.toString(): {
            'status': r.status ?? '',
            'attendanceId':
                r.attendanceId?.toString() ??
                '', // ← use your model's PK field name
          },
    };
    // final Map<String, String> markedMap = {
    //   for (final r in markedList)
    //     if (r.studentId != null) r.studentId.toString(): r.status ?? '',
    // };

    final allStudents =
        Provider.of<AllStudentListVieModel>(
          context,
          listen: false,
        ).allStudentListModel?.data ??
        [];

    final filtered = allStudents
        .where(
          (s) =>
              s.classId.toString() == _selectedClassId &&
              s.sectionId.toString() == _selectedSectionId,
        )
        .toList();

    for (final r in _rows) r.dispose();

    setState(() {
      // _rows = filtered.map((s) {
      //   final id = s.studentId.toString();
      //   final already = markedMap.containsKey(id);
      //   return _StudentRow(
      //     id: id,
      //     name: s.name ?? '',
      //     admissionNo: s.admissionNo ?? '',
      //     fatherName: s.fatherName ?? '',
      //     alreadyMarked: already,
      //     isEditing: false,
      //     markedStatus: markedMap[id],
      //     attendanceStatus: already ? markedMap[id] : null,
      //   );
      // }).toList();
      _rows = filtered.map((s) {
        final id = s.studentId.toString();
        final already = markedMap.containsKey(id);
        return _StudentRow(
          id: id,
          name: s.name ?? '',
          admissionNo: s.admissionNo ?? '',
          fatherName: s.fatherName ?? '',
          alreadyMarked: already,
          isEditing: false,
          markedStatus: already ? markedMap[id]!['status'] : null,
          attendanceStatus: already ? markedMap[id]!['status'] : null,
          attendanceId: already
              ? markedMap[id]!['attendanceId']
              : null, // ← ADD THIS
        );
      }).toList();
      _loadingRows = false;
    });
  }

  // ── Filters ───────────────────────────────────────────────────────────────
  Future<void> _onClassChanged(String? classId) async {
    setState(() {
      _selectedClassId = classId ?? '';
      _selectedSectionId = '';
      _sections = [];
      _rows = [];
    });
    if (classId == null || classId.isEmpty) return;
    try {
      final res = await AllSectionsRepository().allSectionsApi(classId);
      if (res['success'] == true) {
        setState(
          () => _sections = List<Map<String, dynamic>>.from(res['data']),
        );
      }
    } catch (_) {}
  }

  Future<void> _onSectionChanged(String? sectionId) async {
    setState(() {
      _selectedSectionId = sectionId ?? '';
      _rows = [];
    });
    await _buildAndLoadRows();
  }

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
      setState(() => _selectedDate = picked);
      await _buildAndLoadRows();
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
    final pending = _rows.where((r) => !r.alreadyMarked).toList();

    if (pending.isEmpty) {
      _snack(
        'All students\' attendance has already been marked.',
        Colors.blue,
        Icons.info_rounded,
      );
      return;
    }

    final incomplete = pending
        .where((r) => r.attendanceStatus == null)
        .toList();
    if (incomplete.isNotEmpty) {
      _snack(
        '${incomplete.length} student(s) attendance status is not selected.',
        Colors.orange,
        Icons.warning_rounded,
      );
      return;
    }

    setState(() => _saving = true);

    final ok =
        await Provider.of<CreateStudentAttendanceViewModel>(
          context,
          listen: false,
        ).createStudentAttendanceApi(
          classId: int.parse(_selectedClassId),
          sectionId: int.parse(_selectedSectionId),
          attendanceDate: _apiDate,
          students: pending
              .map(
                (r) => {
                  'student_id': int.parse(r.id),
                  'status': r.attendanceStatus,
                  'remarks': r.remarksCtrl.text.trim(),
                },
              )
              .toList(),
          context: context,
        );

    if (ok) {
      setState(() {
        for (final r in pending) {
          r.alreadyMarked = true;
          r.isEditing = false;
          r.markedStatus = r.attendanceStatus;
        }
      });
    }

    setState(() => _saving = false);
  }

  // ── Update EXISTING attendance (edit flow) ────────────────────────────────
  Future<void> _updateAttendance(_StudentRow row, StateSetter setRow) async {
    if (row.attendanceStatus == null) {
      _snack(
        'Please select a status before saving.',
        Colors.orange,
        Icons.warning_rounded,
      );
      return;
    }

    if (row.attendanceId == null || row.attendanceId!.isEmpty) {
      _snack(
        'Attendance ID not found. Please refresh and try again.',
        Colors.red,
        Icons.error_rounded,
      );
      return;
    }

    setState(() => _saving = true);

    final ok =
        await Provider.of<UpdateStudentAttendanceViewModel>(
          context,
          listen: false,
        ).updateStudentAttendanceApi(
          int.parse(row.attendanceId!),
          int.parse(row.id), // ✅ student_id
          row.attendanceStatus!,
          row.remarksCtrl.text.trim(),
          _apiDate,
          context,
        );

    setState(() => _saving = false);

    if (ok) {
      setRow(() {
        row.alreadyMarked = true;
        row.isEditing = false;
        row.markedStatus = row.attendanceStatus;
      });
      if (mounted) {
        _snack(
          'Attendance updated successfully.',
          Colors.green,
          Icons.check_circle_rounded,
        );
      }
    }
  }
  // Future<void> _updateAttendance(
  //     _StudentRow row, StateSetter setRow) async
  // {
  //   if (row.attendanceStatus == null) {
  //     _snack('Please select a status before saving.', Colors.orange,
  //         Icons.warning_rounded);
  //     return;
  //   }
  //
  //   setState(() => _saving = true);
  //
  //   // NOTE: swap createStudentAttendanceApi with your update VM method
  //   // (e.g. updateStudentAttendanceApi) if your backend uses PUT/PATCH.
  //   final ok = await Provider.of<CreateStudentAttendanceViewModel>(context,
  //       listen: false)
  //       .createStudentAttendanceApi(
  //     classId: int.parse(_selectedClassId),
  //     sectionId: int.parse(_selectedSectionId),
  //     attendanceDate: _apiDate,
  //     students: [
  //       {
  //         'student_id': int.parse(row.id),
  //         'status': row.attendanceStatus,
  //         'remarks': row.remarksCtrl.text.trim(),
  //       }
  //     ],
  //     context: context,
  //   );
  //
  //   setState(() => _saving = false);
  //
  //   if (ok) {
  //     setRow(() {
  //       row.alreadyMarked = true;
  //       row.isEditing = false;
  //       row.markedStatus = row.attendanceStatus;
  //     });
  //     if (mounted) {
  //       _snack('Attendance updated successfully.', Colors.green,
  //           Icons.check_circle_rounded);
  //     }
  //   }
  // }

  // ── Snack helper ──────────────────────────────────────────────────────────
  void _snack(String msg, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final hasPending = _rows.any((r) => !r.alreadyMarked);
    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: hasPending
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FloatingActionButton(
                    heroTag: 'mark_all_p',
                    onPressed:
                        !PermissionExtensions.canAccess(
                          PermissionKeys.markStudentAttendance,
                        )
                        ? () {
                            Utils.show(
                              "You don't have permission to marks attendance",
                              context,
                            );
                          }
                        : (_saving ? null : _markAllPresent),
                    backgroundColor: const Color(0xFF22C55E),
                    tooltip: 'Mark All Present',
                    child: const Icon(
                      Icons.done_all_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      title: _saving
                          ? "Saving..."
                          : "Save All Attendance",
                      icon: _saving
                          ? null
                          : Icons.save_rounded,
                      height: 56,
                      radius: 16,
                      loading: _saving,
                      onTap: () {
                        if (!PermissionExtensions.canAccess(
                          PermissionKeys.markStudentAttendance,
                        )) {
                          Utils.show(
                            "You don't have permission to marks attendance",
                            context,
                          );
                          return;
                        }

                        _saveAll();
                      },
                    ),
                  ),
                ],
              ),
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
        boxShadow: [
          BoxShadow(
            color: AppColor.blueShadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
                  'Student Attendance',
                  size: 19,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _filterDropdown(
                  label: 'Class',
                  value: _selectedClassId.isEmpty ? null : _selectedClassId,
                  items: _classes
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e['class_id'] as String,
                          child: Text(e['class_name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: _onClassChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _filterDropdown(
                  label: 'Section',
                  value: _selectedSectionId.isEmpty ? null : _selectedSectionId,
                  items: _sections
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e['section_id'].toString(),
                          child: Text(e['section_name']?.toString() ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: _onSectionChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                          'Selected Date',
                          size: 11,
                          color: Colors.white70,
                        ),
                        AppText.customText(
                          _displayDate,
                          size: 15,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_calendar_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        AppText.customText(
                          'Change',
                          size: 11,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${s['code']} = ${s['full']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── BODY ──────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_selectedClassId.isEmpty || _selectedSectionId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 72,
              color: AppColor.lightBlueColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            AppText.customText(
              'Select Class & Section',
              size: 16,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 6),
            AppText.customText(
              'Choose class and section to mark attendance',
              size: 13,
              color: AppColor.softGreyText,
            ),
          ],
        ),
      );
    }
    if (_loadingRows) {
      return Center(
        child: CircularProgressIndicator(color: AppColor.lightBlueColor),
      );
    }
    if (_rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 72,
              color: AppColor.lightBlueColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            AppText.customText(
              'No Students Found',
              size: 16,
              weight: FontWeight.bold,
            ),
          ],
        ),
      );
    }

    final alreadyCount = _rows.where((r) => r.alreadyMarked).length;
    final pendingCount = _rows.length - alreadyCount;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              if (alreadyCount > 0) ...[
                _countPill(
                  '$alreadyCount Already Marked',
                  Colors.green,
                  Icons.check_circle_rounded,
                ),
                const SizedBox(width: 8),
              ],
              if (pendingCount > 0)
                _countPill(
                  '$pendingCount Pending',
                  Colors.orange,
                  Icons.pending_rounded,
                ),
              const Spacer(),
              Text(
                'Total: ${_rows.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.softGreyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
              itemBuilder: (_, i) => _buildStudentCard(_rows[i]),
            ),
          ),
        ),
      ],
    );
  }

  // ── Student card ──────────────────────────────────────────────────────────
  Widget _buildStudentCard(_StudentRow row) {
    if (!row.alreadyMarked && row.attendanceStatus == null) {
      row.attendanceStatus = 'P';
    }

    return StatefulBuilder(
      builder: (context, setRow) {
        // isLocked = marked AND not currently being edited
        final isLocked = row.alreadyMarked && !row.isEditing;

        final borderColor = row.isEditing
            ? AppColor.lightBlueColor.withOpacity(0.5)
            : isLocked
            ? _statusColor(row.markedStatus).withOpacity(0.4)
            : (row.attendanceStatus != null
                  ? _statusColor(row.attendanceStatus).withOpacity(0.3)
                  : Colors.grey.shade200);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: row.isEditing
                ? AppColor.lightBlueColor.withOpacity(0.02)
                : isLocked
                ? _statusColor(row.markedStatus).withOpacity(0.03)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Top: avatar / info / badges ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: row.isEditing
                            ? AppColor.lightBlueColor.withOpacity(0.15)
                            : isLocked
                            ? _statusColor(row.markedStatus).withOpacity(0.12)
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
                                ? _statusColor(row.markedStatus)
                                : AppColor.lightBlueColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Name + admission + father
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.name.isNotEmpty
                                ? row.name[0].toUpperCase() +
                                      row.name.substring(1)
                                : '—',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Adm: ${row.admissionNo}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColor.softGreyText,
                            ),
                          ),
                          if (row.fatherName.isNotEmpty) ...[
                            const SizedBox(height: 1),
                            Text(
                              'Father: ${row.fatherName}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColor.softGreyText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── RIGHT-SIDE BADGES ──────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Already marked: status badge + Edit button
                        if (isLocked) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                row.markedStatus,
                              ).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _statusColor(
                                  row.markedStatus,
                                ).withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_rounded,
                                  size: 10,
                                  color: _statusColor(row.markedStatus),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${_statusLabel(row.markedStatus)} • Marked',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(row.markedStatus),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          // ── EDIT BUTTON ──
                          GestureDetector(
                            onTap: () {
                              if (!PermissionExtensions.canAccess(
                                PermissionKeys.markStudentAttendance,
                              )) {
                                Utils.show(
                                  "You don't have permission to edit attendance",
                                  context,
                                );

                                return;
                              }

                              setRow(() => row.isEditing = true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightBlueColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColor.lightBlueColor.withOpacity(
                                    0.4,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    size: 10,
                                    color: AppColor.lightBlueColor,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppColor.lightBlueColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // Editing mode: badge + Cancel button
                        if (row.isEditing) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightBlueColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColor.lightBlueColor.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 10,
                                  color: AppColor.lightBlueColor,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Editing',
                                  style: TextStyle(
                                    color: AppColor.lightBlueColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => setRow(() {
                              row.isEditing = false;
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.close_rounded,
                                    size: 10,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade100),

              // ── Status chips ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText.customText(
                          'ATTENDANCE STATUS',
                          size: 10,
                          weight: FontWeight.bold,
                          color: AppColor.softGreyText,
                        ),
                        if (row.isEditing) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightBlueColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Edit Mode',
                              style: TextStyle(
                                color: AppColor.lightBlueColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _statuses.map((s) {
                        final code = s['code']!;
                        final selected = row.attendanceStatus == code;
                        final color = _statusColor(code);
                        return Expanded(
                          child: GestureDetector(
                            onTap: isLocked
                                ? null
                                : () => setRow(
                                    () => row.attendanceStatus = selected
                                        ? null
                                        : code,
                                  ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? color
                                            : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: selected
                                        ? Center(
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: color,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    code,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? color
                                          : (isLocked
                                                ? Colors.grey.shade400
                                                : AppColor.softGreyText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // ── Remarks ────────────────────────────────────────────────
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
                          ? _statusColor(row.markedStatus).withOpacity(0.6)
                          : AppColor.softGreyText,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: row.isEditing
                        ? AppColor.lightBlueColor.withOpacity(0.04)
                        : isLocked
                        ? _statusColor(row.markedStatus).withOpacity(0.04)
                        : Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    prefixIcon: isLocked
                        ? Icon(
                            Icons.lock_rounded,
                            size: 14,
                            color: _statusColor(row.markedStatus),
                          )
                        : row.isEditing
                        ? Icon(
                            Icons.edit_note_rounded,
                            size: 14,
                            color: AppColor.lightBlueColor,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: row.isEditing
                            ? AppColor.lightBlueColor.withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _statusColor(row.markedStatus).withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColor.lightBlueColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // ── UPDATE SAVE BUTTON (edit mode only) ────────────────────
              if (row.isEditing)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed:
                          !PermissionExtensions.canAccess(
                            PermissionKeys.markStudentAttendance,
                          )
                          ? () {
                              Utils.show(
                                "You don't have permission to update attendance",
                                context,
                              );
                            }
                          : (_saving
                                ? null
                                : () => _updateAttendance(row, setRow)),
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.save_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                      label: Text(
                        _saving ? 'Saving...' : 'Update Attendance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.lightBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _filterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null
              ? Colors.white.withOpacity(0.6)
              : Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Colors.white,
          hint: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
          items: items,
          onChanged: onChanged,
          selectedItemBuilder: (context) => items
              .map(
                (item) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (item.child as Text).data ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _countPill(String label, Color color, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
