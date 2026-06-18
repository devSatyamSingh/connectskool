// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/view_model/school_view_model/all_subjects_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
// import 'package:shimmer/shimmer.dart';
// import '../model/school_model/classes_time_table_model.dart';
// import '../res/app_color.dart';
// import '../res/const_text.dart';
// import '../utils/permission_extensions.dart';
// import '../utils/permission_keys.dart';
// import '../utils/utils.dart';
// import '../view_model/school_view_model/all_classes_view_model.dart';
// import '../view_model/school_view_model/all_scetions_view_model.dart';
// import '../view_model/school_view_model/create_class_time_table_View_model.dart';
// import '../view_model/school_view_model/delete_classes_time_table_view_model.dart';
// import '../view_model/school_view_model/edit_class_time_table_view_model.dart';
// import '../view_model/school_view_model/get_classes_timetable_view_model.dart';
//
// class TeacherSchoolTimetableScreen extends StatefulWidget {
//   const TeacherSchoolTimetableScreen({super.key});
//
//   @override
//   State<TeacherSchoolTimetableScreen> createState() => _TeacherSchoolTimetableScreenState();
// }
//
// class _TeacherSchoolTimetableScreenState extends State<TeacherSchoolTimetableScreen> {
//   String? _selectedClassId;
//   String? _selectedSectionId;
//
//   final _dayOrder = [
//     'Monday', 'Tuesday', 'Wednesday',
//     'Thursday', 'Friday', 'Saturday', 'Sunday'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!PermissionExtensions.canAccess(
//           PermissionKeys.viewTimetable)) {
//
//         Utils.show(
//           "You don't have permission to view timetable",
//           context,
//         );
//
//         Navigator.pop(context);
//         return;
//       }
//       Provider.of<AllClassesViewModel>(context, listen: false)
//           .allClassesApi(context);
//       Provider.of<AllSubjectsVieModel>(context, listen: false)
//           .allSubjectsApi(context);
//       // ✅ Teachers bhi load karo:
//       Provider.of<AllTeachersListVieModel>(context, listen: false)
//           .allTeachersListApi(context);
//     });
//   }
//
//   Future<void> _loadSections(String classId) async {
//     await Provider.of<AllSectionsViewModel>(context, listen: false)
//         .allSectionsApi(context, classId);
//   }
//
//   Future<void> _loadTimetable() async {
//     if (_selectedClassId == null || _selectedSectionId == null) return;
//     await Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
//         .getTimeTable(
//       classId: int.parse(_selectedClassId!),
//       sectionId: int.parse(_selectedSectionId!),
//     );
//   }
//
//   void _showEditSheet(TimeTableData period) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _CreateTimetableSheet(
//         preselectedClassId: _selectedClassId,
//         preselectedSectionId: _selectedSectionId,
//         onSuccess: _loadTimetable,
//         editData: period,
//       ),
//     );
//   }
//   void _confirmDelete(TimeTableData period) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => Dialog(
//         backgroundColor: AppColor.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Top Icon
//               Container(
//                 height: 70,
//                 width: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.delete_outline,
//                   color: Colors.red,
//                   size: 36,
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Title
//               const Text(
//                 "Delete Period",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Description
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: Colors.grey.shade700,
//                     fontSize: 14,
//                     height: 1.5,
//                   ),
//                   children: [
//                     const TextSpan(text: "Are you sure you want to delete "),
//                     TextSpan(
//                       text: "\"${period.subjectName ?? 'this period'}\"",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const TextSpan(text: " from "),
//                     TextSpan(
//                       text: "\"${period.dayOfWeek ?? ''}\"",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const TextSpan(
//                       text: "?\nThis action cannot be undone.",
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(ctx);
//                         _deletePeriod(period);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                       child: const Text(
//                         "Delete",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   // void _confirmDelete(TimeTableData period) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (ctx) => AlertDialog(
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//   //       title: Row(
//   //         children: [
//   //           Container(
//   //             padding: const EdgeInsets.all(8),
//   //             decoration:
//   //             BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
//   //             child: Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 20),
//   //           ),
//   //           const SizedBox(width: 10),
//   //           const Text('Delete Period',
//   //               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//   //         ],
//   //       ),
//   //       content: RichText(
//   //         text: TextSpan(
//   //           style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5),
//   //           children: [
//   //             const TextSpan(text: 'Are you sure you want to delete '),
//   //             TextSpan(
//   //               text: period.subjectName?.toString() ?? 'this period',
//   //               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//   //             ),
//   //             const TextSpan(text: ' from '),
//   //             TextSpan(
//   //               text: period.dayOfWeek?.toString() ?? '',
//   //               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//   //             ),
//   //             const TextSpan(text: '?\n\nThis action cannot be undone.'),
//   //           ],
//   //         ),
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(ctx),
//   //           child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
//   //         ),
//   //         ElevatedButton(
//   //           style: ElevatedButton.styleFrom(
//   //             backgroundColor: Colors.red.shade400,
//   //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //             elevation: 0,
//   //           ),
//   //           onPressed: () {
//   //             Navigator.pop(ctx);
//   //             _deletePeriod(period);
//   //           },
//   //           child: const Text('Delete', style: TextStyle(color: Colors.white)),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Future<void> _deletePeriod(TimeTableData period) async {
//     final success =
//     await Provider.of<DeleteClassesTimeTableViewModel>(context, listen: false)
//         .deleteClassesTimeTableApi(period.timetableId!, context);
//
//     if (success && mounted) {
//       Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
//           .timetableList
//           .removeWhere((e) {
//         final item = e is TimeTableData
//             ? e
//             : TimeTableData.fromJson(Map<String, dynamic>.from(e));
//         return item.timetableId == period.timetableId;
//       });
//       // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//       Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
//           .notifyListeners();
//     }
//   }
//
//   Map<String, List<TimeTableData>> _groupByDay(List<TimeTableData> data) {
//     final Map<String, List<TimeTableData>> grouped = {};
//     for (final item in data) {
//       final day = item.dayOfWeek?.toString() ?? 'Unknown';
//       grouped.putIfAbsent(day, () => []).add(item);
//     }
//     return grouped;
//   }
//
//   Color _dayColor(String day) {
//     const colors = {
//       'Monday': Color(0xFF5C6BC0),
//       'Tuesday': Color(0xFF26A69A),
//       'Wednesday': Color(0xFFEF5350),
//       'Thursday': Color(0xFFFF7043),
//       'Friday': Color(0xFF66BB6A),
//       'Saturday': Color(0xFFAB47BC),
//       'Sunday': Color(0xFF78909C),
//     };
//     return colors[day] ?? AppColor.lightBlueColor;
//   }
//
//   IconData _subjectIcon(String? subject) {
//     final s = subject?.toLowerCase() ?? '';
//     if (s.contains('math')) return Icons.calculate_rounded;
//     if (s.contains('science')) return Icons.science_rounded;
//     if (s.contains('english')) return Icons.menu_book_rounded;
//     if (s.contains('hindi')) return Icons.translate_rounded;
//     if (s.contains('history')) return Icons.history_edu_rounded;
//     if (s.contains('geo')) return Icons.public_rounded;
//     if (s.contains('computer')) return Icons.computer_rounded;
//     if (s.contains('art')) return Icons.palette_rounded;
//     if (s.contains('sport') || s.contains('pe')) return Icons.sports_soccer_rounded;
//     return Icons.class_rounded;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.pageBgColor,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: _showCreateSheet,
//       //   backgroundColor: AppColor.lightBlueColor,
//       //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       //   icon: const Icon(Icons.add_rounded, color: Colors.white),
//       //   label: const Text('Add Period',
//       //       style: TextStyle(
//       //           color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
//       // ),
//       body: Column(
//         children: [
//           // ── Header ──────────────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
//             decoration: BoxDecoration(
//               gradient: AppColor.primaryGradient,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
//               boxShadow: [
//                 BoxShadow(
//                     color: AppColor.blueShadow, blurRadius: 15, offset: const Offset(0, 8)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                             color: AppColor.glassWhite, shape: BoxShape.circle),
//                         child: const Icon(Icons.arrow_back_ios_new_rounded,
//                             color: Colors.white, size: 20),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText.customText('School Timetable',
//                               size: 20, weight: FontWeight.bold, color: Colors.white),
//                           AppText.customText('View class schedule',
//                               size: 12, color: Colors.white70),
//                         ],
//                       ),
//                     ),
//                     // const Icon(Icons.calendar_month_rounded, color: Colors.white),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Consumer<AllClassesViewModel>(
//                         builder: (context, vm, _) {
//                           final classes = vm.allClassesModel?.data ?? [];
//                           return _headerDropdown(
//                             hint: 'Select Class',
//                             value: _selectedClassId,
//                             items: classes
//                                 .map((c) => DropdownMenuItem(
//                               value: c.classId?.toString(),
//                               child: Text(c.className ?? '',
//                                   style: const TextStyle(fontSize: 13)),
//                             ))
//                                 .toList(),
//                             onChanged: (v) {
//                               setState(() {
//                                 _selectedClassId = v;
//                                 _selectedSectionId = null;
//                               });
//                               Provider.of<GetClassesTimeTableViewModel>(
//                                   context, listen: false)
//                                   .timetableList
//                                   .clear();
//                               if (v != null) _loadSections(v);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Consumer<AllSectionsViewModel>(
//                         builder: (context, vm, _) {
//                           final sections = vm.allSectionsModel?.data ?? [];
//                           return _headerDropdown(
//                             hint: 'Select Section',
//                             value: sections.any((s) =>
//                             s.sectionId?.toString() == _selectedSectionId)
//                                 ? _selectedSectionId
//                                 : null,
//                             items: sections
//                                 .map((s) => DropdownMenuItem(
//                               value: s.sectionId?.toString(),
//                               child: Text(s.sectionName ?? '',
//                                   style: const TextStyle(fontSize: 13)),
//                             ))
//                                 .toList(),
//                             onChanged: (v) {
//                               setState(() => _selectedSectionId = v);
//                               if (v != null && _selectedClassId != null) {
//                                 _loadTimetable();
//                               }
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_selectedClassId != null && _selectedSectionId != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child:
//                     Consumer2<AllClassesViewModel, AllSectionsViewModel>(
//                       builder: (context, classVm, secVm, _) {
//                         final className = (classVm.allClassesModel?.data ?? [])
//                             .where((c) => c.classId?.toString() == _selectedClassId)
//                             .map((c) => c.className ?? '')
//                             .firstOrNull ?? '';
//                         final sectionName = (secVm.allSectionsModel?.data ?? [])
//                             .where((s) => s.sectionId?.toString() == _selectedSectionId)
//                             .map((s) => s.sectionName ?? '')
//                             .firstOrNull ?? '';
//                         if (className.isEmpty) return const SizedBox();
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: AppColor.glassWhite,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.info_outline_rounded,
//                                   color: Colors.white70, size: 14),
//                               const SizedBox(width: 6),
//                               AppText.customText(
//                                 '$className  •  Section $sectionName',
//                                 size: 12,
//                                 color: Colors.white,
//                                 weight: FontWeight.w500,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           // ── Body ────────────────────────────────────────────────
//           Expanded(
//             child: Consumer<GetClassesTimeTableViewModel>(
//               builder: (context, vm, _) {
//                 if (_selectedClassId == null || _selectedSectionId == null) {
//                   return _selectFirstState();
//                 }
//                 if (vm.loading) return _shimmer();
//                 final rawList = vm.timetableList;
//                 if (rawList.isEmpty) return _emptyState();
//
//                 final List<TimeTableData> data = rawList
//                     .map((e) => e is TimeTableData
//                     ? e
//                     : TimeTableData.fromJson(Map<String, dynamic>.from(e)))
//                     .toList();
//
//                 final grouped = _groupByDay(data);
//                 final sortedDays =
//                 _dayOrder.where((d) => grouped.containsKey(d)).toList();
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: sortedDays.length,
//                   itemBuilder: (_, i) {
//                     final day = sortedDays[i];
//                     return _dayCard(day, grouped[day]!);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _headerDropdown({
//     required String hint,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required void Function(String?) onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(14)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           hint: Text(hint,
//               style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
//           icon: Icon(Icons.keyboard_arrow_down_rounded,
//               color: AppColor.lightBlueColor, size: 20),
//           items: items,
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
//
//   Widget _dayCard(String day, List<TimeTableData> periods) {
//     final color = _dayColor(day);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: color.withOpacity(0.12),
//               blurRadius: 12,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.08),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: color.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Icon(Icons.today_rounded, color: color, size: 18),
//                 ),
//                 const SizedBox(width: 10),
//                 AppText.customText(day,
//                     size: 15, weight: FontWeight.bold, color: color),
//                 const Spacer(),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: color.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: AppText.customText(
//                     '${periods.length} ${periods.length == 1 ? 'Period' : 'Periods'}',
//                     size: 11,
//                     color: color,
//                     weight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ...periods.asMap().entries.map(
//                   (e) => _periodTile(e.value, color, e.key == periods.length - 1)),
//         ],
//       ),
//     );
//   }
//
//   Widget _periodTile(TimeTableData period, Color color, bool isLast) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 52,
//                 child: Column(children: [
//                   AppText.customText(period.startTime?.toString() ?? '--:--',
//                       size: 12, weight: FontWeight.bold, color: color),
//                   Container(
//                       width: 1,
//                       height: 14,
//                       color: color.withValues(alpha: 0.3),
//                       margin: const EdgeInsets.symmetric(vertical: 2)),
//                   AppText.customText(period.endTime?.toString() ?? '--:--',
//                       size: 10, color: AppColor.softGreyText),
//                 ]),
//               ),
//               const SizedBox(width: 10),
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                     color: color.withValues(alpha:0.1),
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Icon(_subjectIcon(period.subjectName?.toString()),
//                     color: color, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText.customText(
//                         period.subjectName?.toString() ?? 'Subject',
//                         size: 14,
//                         weight: FontWeight.bold),
//                     const SizedBox(height: 3),
//                     Row(children: [
//                       Icon(Icons.person_rounded,
//                           size: 13, color: AppColor.softGreyText),
//                       const SizedBox(width: 4),
//                       Flexible(
//                         child: AppText.customText(
//                             period.teacherName?.toString() ?? '',
//                             size: 12,
//                             color: AppColor.softGreyText),
//                       ),
//                     ]),
//                     const SizedBox(height: 2),
//                     Row(children: [
//                       Icon(Icons.groups_rounded,
//                           size: 13, color: AppColor.softGreyText),
//                       const SizedBox(width: 4),
//                       AppText.customText(
//                           '${period.className ?? ''} - ${period.sectionName ?? ''}',
//                           size: 12,
//                           color: AppColor.softGreyText),
//                     ]),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () => _showEditSheet(period),
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                           color: color.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(9)),
//                       child: Icon(Icons.edit_rounded, color: color, size: 15),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   GestureDetector(
//                     onTap: () => _confirmDelete(period),
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(9)),
//                       child: Icon(Icons.delete_rounded,
//                           color: Colors.red.shade400, size: 15),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (!isLast)
//           Divider(
//               height: 1,
//               indent: 70,
//               endIndent: 16,
//               color: Colors.grey.shade100),
//       ],
//     );
//   }
//
//   Widget _selectFirstState() => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(28),
//           decoration: BoxDecoration(
//               color: AppColor.lightBlueColor.withValues(alpha: 0.06),
//               shape: BoxShape.circle),
//           child: Icon(Icons.touch_app_rounded,
//               size: 60, color: AppColor.lightBlueColor.withValues(alpha: 0.4)),
//         ),
//         const SizedBox(height: 20),
//         AppText.customText('Select Class & Section',
//             size: 18, weight: FontWeight.bold),
//         const SizedBox(height: 8),
//         AppText.customText(
//           'Choose class and section above\nto view the timetable',
//           size: 13,
//           color: AppColor.softGreyText,
//           align: TextAlign.center,
//         ),
//       ],
//     ),
//   );
//
//   Widget _shimmer() => ListView.builder(
//     padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
//     itemCount: 3,
//     itemBuilder: (_, __) => Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         height: 160,
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       ),
//     ),
//   );
//
//   Widget _emptyState() => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(28),
//           decoration: BoxDecoration(
//               color: AppColor.lightBlueColor.withValues(alpha: 0.08),
//               shape: BoxShape.circle),
//           child: Icon(Icons.calendar_today_rounded,
//               size: 60, color: AppColor.lightBlueColor.withValues(alpha: 0.4)),
//         ),
//         const SizedBox(height: 20),
//         AppText.customText('No Timetable Found',
//             size: 18, weight: FontWeight.bold),
//         const SizedBox(height: 8),
//         AppText.customText(
//           'No schedule found for\nthis class & section',
//           size: 13,
//           color: AppColor.softGreyText,
//           align: TextAlign.center,
//         ),
//       ],
//     ),
//   );
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  CREATE / EDIT TIMETABLE BOTTOM SHEET
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _CreateTimetableSheet extends StatefulWidget {
//   final String? preselectedClassId;
//   final String? preselectedSectionId;
//   final VoidCallback onSuccess;
//   final TimeTableData? editData;
//
//   const _CreateTimetableSheet({
//     this.preselectedClassId,
//     this.preselectedSectionId,
//     required this.onSuccess,
//     this.editData,
//   });
//
//   @override
//   State<_CreateTimetableSheet> createState() => _CreateTimetableSheetState();
// }
//
// class _CreateTimetableSheetState extends State<_CreateTimetableSheet> {
//   String? _classId;
//   String? _sectionId;
//   String? _subjectId;  // ✅ subject dropdown value
//   String? _teacherId;  // ✅ teacher dropdown value
//   String? _dayOfWeek;
//   final _startCtrl = TextEditingController();
//   final _endCtrl = TextEditingController();
//   bool _loading = false;
//
//   bool get _isEditMode => widget.editData != null;
//
//   final _days = [
//     'Monday', 'Tuesday', 'Wednesday',
//     'Thursday', 'Friday', 'Saturday', 'Sunday'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _classId = widget.preselectedClassId;
//     _sectionId = widget.preselectedSectionId;
//
//     if (_isEditMode) {
//       final d = widget.editData!;
//       _classId   = d.classId?.toString()   ?? widget.preselectedClassId;
//       _sectionId = d.sectionId?.toString() ?? widget.preselectedSectionId;
//       _subjectId = d.subjectId?.toString();
//       _teacherId = d.teacherId?.toString();
//       _dayOfWeek = d.dayOfWeek?.toString();
//       _startCtrl.text = d.startTime?.toString() ?? '';
//       _endCtrl.text   = d.endTime?.toString()   ?? '';
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final ctx = context;
//       Provider.of<AllClassesViewModel>(ctx, listen: false).allClassesApi(ctx);
//       Provider.of<AllSubjectsVieModel>(ctx, listen: false).allSubjectsApi(ctx);
//       // ✅ Teachers load karo:
//       // Provider.of<AllTeachersViewModel>(ctx, listen: false).allTeachersApi(ctx);
//       if (_classId != null) {
//         Provider.of<AllSectionsViewModel>(ctx, listen: false)
//             .allSectionsApi(ctx, _classId!);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _startCtrl.dispose();
//     _endCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickTime(TextEditingController ctrl) async {
//     final t = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
//         ),
//         child: child!,
//       ),
//     );
//     if (t != null) {
//       final h = t.hour.toString().padLeft(2, '0');
//       final m = t.minute.toString().padLeft(2, '0');
//       setState(() => ctrl.text = '$h:$m:00');
//     }
//   }
//
//   Future<void> _submit() async {
//     if (_classId == null ||
//         _sectionId == null ||
//         _subjectId == null ||
//         _teacherId == null ||
//         _dayOfWeek == null ||
//         _startCtrl.text.isEmpty ||
//         _endCtrl.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('Please fill all fields'),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ));
//       return;
//     }
//
//     setState(() => _loading = true);
//
//     if (_isEditMode) {
//       final success =
//       await Provider.of<EditClassesTimeTableViewModel>(context, listen: false)
//           .editClassTimeTableApi(
//         widget.editData!.timetableId!,
//         int.parse(_classId!),
//         int.parse(_sectionId!),
//         int.parse(_subjectId!),
//         int.parse(_teacherId!),
//         _dayOfWeek!,
//         _startCtrl.text,
//         _endCtrl.text,
//         context,
//       );
//
//       setState(() => _loading = false);
//       if (success && mounted) {
//         Navigator.pop(context);
//         widget.onSuccess();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Row(children: [
//             const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//             const SizedBox(width: 8),
//             const Text('Timetable updated successfully'),
//           ]),
//           backgroundColor: Colors.green.shade500,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ));
//       }
//     } else {
//       final success =
//       await Provider.of<CreateClassTimetableViewModel>(context, listen: false)
//           .createClassTimeTableApi(
//         int.parse(_classId!),
//         int.parse(_sectionId!),
//         int.parse(_subjectId!),
//         int.parse(_teacherId!),
//         _dayOfWeek!,
//         _startCtrl.text,
//         _endCtrl.text,
//         context,
//       );
//
//       setState(() => _loading = false);
//       if (success && mounted) {
//         Navigator.pop(context);
//         widget.onSuccess();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//       child: Container(
//         color: Colors.white,
//         padding:
//         EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Handle bar
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(top: 10, bottom: 20),
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//
//               // Sheet title
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: AppColor.primaryGradient,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                         _isEditMode
//                             ? Icons.edit_calendar_rounded
//                             : Icons.schedule_rounded,
//                         color: Colors.white,
//                         size: 20),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppText.customText(
//                             _isEditMode ? 'Edit Timetable' : 'Add Timetable',
//                             size: 18,
//                             weight: FontWeight.bold),
//                         AppText.customText(
//                             _isEditMode
//                                 ? 'Update period details'
//                                 : 'Fill period details',
//                             size: 12,
//                             color: AppColor.softGreyText),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade100, shape: BoxShape.circle),
//                       child: const Icon(Icons.close_rounded, size: 18),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 22),
//
//               // ── Class & Section ──────────────────────────────────
//               Row(
//                 children: [
//                   Expanded(
//                     child: _label(
//                       'Class *',
//                       Consumer<AllClassesViewModel>(
//                         builder: (ctx, vm, _) => _sheetDrop(
//                           hint: 'Select',
//                           value: _classId,
//                           items: (vm.allClassesModel?.data ?? [])
//                               .map((c) => DropdownMenuItem(
//                             value: c.classId?.toString(),
//                             child: Text(c.className ?? ''),
//                           ))
//                               .toList(),
//                           onChanged: (v) {
//                             setState(() {
//                               _classId = v;
//                               _sectionId = null;
//                             });
//                             if (v != null) {
//                               Provider.of<AllSectionsViewModel>(
//                                   context, listen: false)
//                                   .allSectionsApi(context, v);
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _label(
//                       'Section *',
//                       Consumer<AllSectionsViewModel>(
//                         builder: (ctx, vm, _) {
//                           final sections = vm.allSectionsModel?.data ?? [];
//                           return _sheetDrop(
//                             hint: 'Select',
//                             value: sections.any(
//                                     (s) => s.sectionId?.toString() == _sectionId)
//                                 ? _sectionId
//                                 : null,
//                             items: sections
//                                 .map((s) => DropdownMenuItem(
//                               value: s.sectionId?.toString(),
//                               child: Text(s.sectionName ?? ''),
//                             ))
//                                 .toList(),
//                             onChanged: (v) => setState(() => _sectionId = v),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//
//               // ── Subject Dropdown ✅ ──────────────────────────────
//               _label(
//                 'Subject *',
//                 Consumer<AllSubjectsVieModel>(
//                   builder: (ctx, vm, _) {
//                     final subjects = vm.allSubjectsModel?.data ?? [];
//                     return _sheetDrop(
//                       hint: 'Select Subject',
//                       // ✅ Safe check: agar subjectId list mein nahi toh null pass karo
//                       value: subjects.any(
//                               (s) => s.subjectId.toString() == _subjectId)
//                           ? _subjectId
//                           : null,
//                       items: subjects
//                           .map((s) => DropdownMenuItem(
//                         value: s.subjectId.toString(),
//                         child: Text(s.subjectName ?? ''),
//                       ))
//                           .toList(),
//                       onChanged: (v) => setState(() => _subjectId = v),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 14),
//
//               // ── Teacher Dropdown ✅ ──────────────────────────────
//               // ✅ AllTeachersViewModel apna use karo, same pattern follow karo:
//               _label(
//                 'Teacher *',
//                 Consumer<AllTeachersListVieModel>(
//                   builder: (ctx, vm, _) {
//                     final teachers = vm.allTeachersListModel?.data ?? [];
//                     return _sheetDrop(
//                       hint: 'Select Teacher',
//                       // ✅ Safe check: agar teacherId list mein nahi toh null pass karo
//                       value: teachers.any(
//                               (t) => t.teacherId.toString() == _teacherId)
//                           ? _teacherId
//                           : null,
//                       items: teachers
//                           .map((t) => DropdownMenuItem(
//                         value: t.teacherId.toString(),
//                         child: Text(t.name ?? ''),
//                       ))
//                           .toList(),
//                       onChanged: (v) => setState(() => _teacherId = v),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 14),
//
//               // ── Day of Week ──────────────────────────────────────
//               _label(
//                 'Day of Week *',
//                 _sheetDrop(
//                   hint: 'Select Day',
//                   value: _dayOfWeek,
//                   items: _days
//                       .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//                       .toList(),
//                   onChanged: (v) => setState(() => _dayOfWeek = v),
//                 ),
//               ),
//               const SizedBox(height: 14),
//
//               // ── Start & End Time ────────────────────────────────
//               Row(
//                 children: [
//                   Expanded(
//                     child: _label(
//                         'Start Time *',
//                         _timeField(
//                             _startCtrl, '09:00:00', () => _pickTime(_startCtrl))),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _label(
//                         'End Time *',
//                         _timeField(
//                             _endCtrl, '10:00:00', () => _pickTime(_endCtrl))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 28),
//
//               // ── Submit Button ────────────────────────────────────
//               GestureDetector(
//                 onTap: _loading ? null : _submit,
//                 child: Container(
//                   width: double.infinity,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     gradient: AppColor.primaryGradient,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: _loading
//                         ? []
//                         : [
//                       BoxShadow(
//                         color: AppColor.lightBlueColor.withOpacity(0.3),
//                         blurRadius: 12,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: _loading
//                         ? const SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                           color: Colors.white, strokeWidth: 2),
//                     )
//                         : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                             _isEditMode
//                                 ? Icons.save_rounded
//                                 : Icons.check_circle_rounded,
//                             color: Colors.white,
//                             size: 20),
//                         const SizedBox(width: 8),
//                         AppText.customText(
//                           _isEditMode
//                               ? 'Update Timetable'
//                               : 'Create Timetable',
//                           size: 15,
//                           weight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String text, Widget child) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       AppText.customText(text,
//           size: 12, weight: FontWeight.w600, color: AppColor.softGreyText),
//       const SizedBox(height: 6),
//       child,
//     ],
//   );
//
//   Widget _sheetDrop({
//     required String hint,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required void Function(String?) onChanged,
//   }) =>
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FA),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: value,
//             isExpanded: true,
//             hint: Text(hint,
//                 style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
//             icon: Icon(Icons.keyboard_arrow_down_rounded,
//                 color: AppColor.lightBlueColor, size: 20),
//             items: items,
//             onChanged: onChanged,
//           ),
//         ),
//       );
//
//   Widget _timeField(
//       TextEditingController ctrl,
//       String hint,
//       VoidCallback onTap,
//       ) =>
//       GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF8F9FA),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.access_time_rounded,
//                   color: AppColor.lightBlueColor, size: 18),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   ctrl.text.isEmpty ? hint : ctrl.text,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: ctrl.text.isEmpty
//                         ? Colors.grey.shade400
//                         : Colors.black87,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }