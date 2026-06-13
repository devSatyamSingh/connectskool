// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/admin_management/school_student_detail_screen.dart';
// import 'package:school_pro/view_model/school_view_model/academic_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/delete_student_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/edit_student_view_model.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
// import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
// import '../repo/school_repo/all_sections_repo.dart';
// import '../res/app_button.dart';
// import '../utils/utils.dart';
// import '../view_model/school_view_model/add_student_view_model.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:url_launcher/url_launcher.dart';
// import '../view_model/school_view_model/fees_head_management_view_model.dart';
// import '../model/school_model/academic_model.dart';
// import 'add_student_screen.dart';
//
// class AllStudentList extends StatefulWidget {
//   const AllStudentList({super.key});
//
//   @override
//   State<AllStudentList> createState() => _AllStudentListState();
// }
//
// class _AllStudentListState extends State<AllStudentList>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final ImagePicker _picker = ImagePicker();
//
//   final _classes = ValueNotifier<List<Map<String, dynamic>>>([]);
//   final _sections = ValueNotifier<List<Map<String, dynamic>>>([]);
//   final _selectedClassId = ValueNotifier<String>("");
//   final _selectedSectionId = ValueNotifier<String>("");
//
//   bool _sectionsLoading = false;
//   List<int> selectedFeeHeads = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AllStudentListVieModel>(context, listen: false)
//           .allStudentListApi(context);
//       Provider.of<FeesHeadManagementViewModel>(context, listen: false)
//           .feesHeadManagementApi(context);
//
//       // ── Academic years fetch ──
//       Provider.of<AcademicViewModel>(context, listen: false)
//           .academicApi(context);
//
//       final classesVm =
//       Provider.of<AllClassesViewModel>(context, listen: false);
//       classesVm.allClassesApi(context);
//
//       classesVm.addListener(() {
//         final classData = classesVm.allClassesModel?.data ?? [];
//         if (classData.isNotEmpty && _classes.value.isEmpty) {
//           _classes.value = classData
//               .map((e) => {
//             "class_id": e.classId.toString(),
//             "class_name": e.className ?? "",
//           })
//               .toList();
//         }
//       });
//     });
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _onRefresh() async {
//     _animationController.reset();
//     await Provider.of<AllStudentListVieModel>(context, listen: false)
//         .allStudentListApi(context);
//     _animationController.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AllStudentListVieModel>(context);
//     final students = viewModel.allStudentListModel?.data ?? [];
//
//     final filteredStudents = students.where((s) {
//       final selectedClassName = _classes.value
//           .firstWhere(
//             (c) =>
//         c["class_id"].toString() ==
//             _selectedClassId.value.toString(),
//         orElse: () => <String, String>{},
//       )["class_name"] ??
//           "";
//       final classMatch = _selectedClassId.value.isEmpty ||
//           (s.className ?? "") == selectedClassName;
//
//       final selectedSectionName = _sections.value
//           .firstWhere(
//             (sec) =>
//         sec["section_id"].toString() == _selectedSectionId.value,
//         orElse: () => {},
//       )["section_name"] ??
//           "";
//       final sectionMatch = _selectedSectionId.value.isEmpty ||
//           (s.sectionName ?? "") == selectedSectionName;
//
//       return classMatch && sectionMatch;
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: AppColor.pageBgColor,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   backgroundColor: AppColor.lightBlueColor,
//       //   onPressed: () => _openStudentSheet(),
//       //   icon: Icon(Icons.add_rounded, color: AppColor.white),
//       //   label: const Text(
//       //     'Add Student',
//       //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       //   ),
//       // ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColor.lightBlueColor,
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddStudentPage()),
//         ),
//         icon: Icon(Icons.add_rounded, color: AppColor.white),
//         label: const Text(
//           'Add Student',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Column(
//         children: [
//           // ── Header ──
//           Container(
//             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//             decoration: BoxDecoration(
//               gradient: AppColor.primaryGradient,
//               borderRadius:
//               const BorderRadius.vertical(bottom: Radius.circular(28)),
//               boxShadow: [
//                 BoxShadow(
//                     color: AppColor.blueShadow,
//                     blurRadius: 18,
//                     offset: const Offset(0, 10)),
//               ],
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         color: AppColor.glassWhite, shape: BoxShape.circle),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white, size: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: AppText.customText("All Students",
//                       size: 19, weight: FontWeight.bold, color: Colors.white),
//                 ),
//                 AppText.customText("${students.length}",
//                     size: 16, weight: FontWeight.w600, color: Colors.white70),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // ── Class & Section Filter ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ValueListenableBuilder<List<Map<String, dynamic>>>(
//                     valueListenable: _classes,
//                     builder: (_, list, __) {
//                       return ValueListenableBuilder<String>(
//                         valueListenable: _selectedClassId,
//                         builder: (_, classVal, __) {
//                           return _buildFilterDropdown(
//                             label: "Class",
//                             value: classVal.isEmpty ? null : classVal,
//                             items: list
//                                 .map((e) => DropdownMenuItem<String>(
//                               value: e["class_id"],
//                               child: Text(e["class_name"]),
//                             ))
//                                 .toList(),
//                             onChanged: (val) async {
//                               _selectedClassId.value = val ?? "";
//                               _selectedSectionId.value = "";
//                               _sections.value = [];
//
//                               if (val != null) {
//                                 setState(() => _sectionsLoading = true);
//                                 final repo = AllSectionsRepository();
//                                 final response =
//                                 await repo.allSectionsApi(val);
//                                 setState(() => _sectionsLoading = false);
//
//                                 if (response["success"] == true) {
//                                   _sections.value =
//                                   List<Map<String, dynamic>>.from(
//                                       response["data"]);
//                                 } else {
//                                   _sections.value = [];
//                                 }
//                               } else {
//                                 setState(() => _sectionsLoading = false);
//                                 _sections.value = [];
//                               }
//                               setState(() {});
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: ValueListenableBuilder<List<Map<String, dynamic>>>(
//                     valueListenable: _sections,
//                     builder: (_, list, __) {
//                       return ValueListenableBuilder<String>(
//                         valueListenable: _selectedSectionId,
//                         builder: (_, secVal, __) {
//                           if (_sectionsLoading) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 14),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border:
//                                 Border.all(color: Colors.grey.shade200),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: AppColor.cardShadow,
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 3))
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 18,
//                                     height: 18,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: AppColor.lightBlueColor,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text("Loading...",
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           color: Colors.grey.shade500)),
//                                 ],
//                               ),
//                             );
//                           }
//
//                           final classSelected =
//                               _selectedClassId.value.isNotEmpty;
//                           final noSections = classSelected && list.isEmpty;
//
//                           if (noSections) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 14),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                     color: Colors.orange.shade200),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: AppColor.cardShadow,
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 3))
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.info_outline_rounded,
//                                       size: 18,
//                                       color: Colors.orange.shade400),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     "No Section",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.orange.shade700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//
//                           return _buildFilterDropdown(
//                             label: "Section",
//                             value: secVal.isEmpty ? null : secVal,
//                             items: list
//                                 .map((e) => DropdownMenuItem<String>(
//                               value: e["section_id"].toString(),
//                               child: Text(e["section_name"]),
//                             ))
//                                 .toList(),
//                             onChanged: (val) {
//                               setState(() {
//                                 _selectedSectionId.value = val ?? "";
//                               });
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           Expanded(
//             child: viewModel.loading
//                 ? _studentShimmer()
//                 : filteredStudents.isEmpty
//                 ? RefreshIndicator(
//               color: AppColor.lightBlueColor,
//               onRefresh: _onRefresh,
//               child: ListView(
//                 children: [
//                   SizedBox(
//                     height:
//                     MediaQuery.of(context).size.height * 0.5,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.school_outlined,
//                             size: 80,
//                             color: Colors.grey.shade300),
//                         const SizedBox(height: 16),
//                         Text("No Students Found",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey.shade500)),
//                         const SizedBox(height: 8),
//                         Text("Pull down to refresh",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade400)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : RefreshIndicator(
//               color: AppColor.lightBlueColor,
//               onRefresh: _onRefresh,
//               child: ListView.builder(
//                 padding:
//                 const EdgeInsets.fromLTRB(18, 8, 18, 20),
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 itemCount: filteredStudents.length,
//                 itemBuilder: (context, index) {
//                   final s = filteredStudents[index];
//                   final isMale =
//                       s.gender?.toLowerCase() == "male";
//                   return _animatedStudentCard(index, {
//                     "id": s.studentId,
//                     "name": s.name ?? "",
//                     "email": s.userEmail ?? "",
//                     "admission": s.admissionNo ?? "",
//                     "class": s.className ?? "",
//                     "section": s.sectionName ?? "",
//                     "class_id": s.classId?.toString() ?? "",
//                     "section_id":
//                     s.sectionId?.toString() ?? "",
//                     "gender": s.gender != null
//                         ? "${s.gender![0].toUpperCase()}${s.gender!.substring(1)}"
//                         : "Male",
//                     "roll_no": s.rollNo?.toString() ?? "",
//                     "dob": s.dob != null
//                         ? s.dob!.contains("T")
//                         ? s.dob!.split("T")[0]
//                         : s.dob!
//                         : "",
//                     "mobile_number": s.mobileNumber ?? "",
//                     "father_name": s.fatherName ?? "",
//                     "mother_name": s.motherName ?? "",
//                     "address": s.address ?? "",
//                     "religion": s.religion ?? "",
//                     "academic_year": s.academicYear ?? "",
//                     "passed_out":
//                     s.passedOut?.toString() ?? "",
//                     "transfer": s.transfer?.toString() ?? "",
//                     "blood_group": s.bloodGroup ?? "",
//                     "category": s.category ?? "",
//                     "aadhar_number": s.aadharNumber ?? "",
//                     "father_occupation":
//                     s.fatherOccupation ?? "",
//                     "father_mobile": s.fatherMobile ?? "",
//                     "mother_occupation":
//                     s.motherOccupation ?? "",
//                     "mother_mobile": s.motherMobile ?? "",
//                     "guardian_name": s.guardianName ?? "",
//                     "emergency_contact_number":
//                     s.emergencyContactNumber ?? "",
//                     "city": s.city ?? "",
//                     "state": s.state ?? "",
//                     "pincode": s.pincode ?? "",
//                     "selected_fee_heads": "",
//                     "student_photo_url":
//                     s.studentPhotoUrl ?? "",
//                     "aadhar_card_url": s.aadharCardUrl ?? "",
//                     "father_photo_url":
//                     s.fatherPhotoUrl ?? "",
//                     "mother_photo_url":
//                     s.motherPhotoUrl ?? "",
//                     "color": isMale
//                         ? AppColor.maleColor
//                         : AppColor.femaleColor,
//                     "gradient": isMale
//                         ? [AppColor.maleColor, AppColor.maleLight]
//                         : [
//                       AppColor.femaleColor,
//                       AppColor.femaleLight
//                     ],
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required Function(String?) onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 6,
//               offset: const Offset(0, 3))
//         ],
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           isExpanded: true,
//           hint: Text(label, style: const TextStyle(fontSize: 13)),
//           value: value,
//           items: items,
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
//
//   Widget _studentShimmer() {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
//       itemCount: 6,
//       itemBuilder: (_, __) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           height: 110,
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: AppColor.cardWhite,
//             borderRadius: BorderRadius.circular(22),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _animatedStudentCard(int index, Map<String, dynamic> data) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         final delay = index * 0.08;
//         final value = Curves.easeOut.transform(
//           (_animationController.value - delay).clamp(0.0, 1.0) / (1 - delay),
//         );
//         return Transform.translate(
//           offset: Offset(0, 25 * (1 - value)),
//           child: Opacity(opacity: value, child: child),
//         );
//       },
//       child: _studentCard(data),
//     );
//   }
//
//   Widget _studentCard(Map<String, dynamic> s) {
//     final w = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               SchoolStudentDetailScreen(
//                   studentId: s["id"],
//                 className: s["class"],
//                 sectionName: s["section"],
//               ),
//         ),
//       ),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: AppColor.cardWhite,
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColor.cardShadow,
//                 blurRadius: 14,
//                 offset: const Offset(0, 6))
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(w * 0.015),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: s["gradient"]),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(Icons.person_rounded,
//                     color: Colors.white, size: 30),
//               ),
//               SizedBox(width: w * 0.035),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText.customText(s["name"],
//                         size: 17, weight: FontWeight.bold),
//                     const SizedBox(height: 6),
//                     AppText.customText(s["email"],
//                         size: 13, color: AppColor.softGreyText),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         AppText.customText("Adm: ${s["admission"]}",
//                             size: 11, color: AppColor.softGreyText),
//                         SizedBox(width: w * 0.01),
//                         AppText.customText(s["gender"],
//                             size: 11, color: AppColor.softGreyText),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     AppText.customText(s["class"],
//                         size: 13,
//                         color: AppColor.lightBlueColor,
//                         weight: FontWeight.w600),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => _openStudentSheet(student: s),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: AppColor.primaryLight,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.edit_note_rounded,
//                           color: AppColor.lightBlueColor, size: 20),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   GestureDetector(
//                     onTap: () async {
//                       bool confirmed = await _showDeleteDialog();
//                       if (confirmed) {
//                         Provider.of<DeleteStudentViewModel>(context,
//                             listen: false)
//                             .deleteStudentApi(s["id"], context);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: AppColor.error.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(Icons.delete_outline_rounded,
//                           color: AppColor.error, size: 20),
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
//
//   Future<bool> _showDeleteDialog() async {
//     return await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 height: 70,
//                 width: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.delete_outline,
//                     color: Colors.red, size: 35),
//               ),
//               const SizedBox(height: 15),
//               const Text("Delete Student",
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               const Text(
//                 "Are you sure you want to delete this student?",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       style: OutlinedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text("Cancel"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text("Delete"),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     ) ??
//         false;
//   }
//
//   Future<void> _pickImage(
//       ValueNotifier imageNotifier, Function setState) async {
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Select Image Source'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.blue),
//               title: const Text('Camera'),
//               onTap: () => Navigator.pop(context, ImageSource.camera),
//             ),
//             ListTile(
//               leading:
//               const Icon(Icons.photo_library, color: Colors.green),
//               title: const Text('Gallery'),
//               onTap: () => Navigator.pop(context, ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     if (source != null) {
//       final XFile? image = await _picker.pickImage(
//           source: source,
//           maxWidth: 1080,
//           maxHeight: 1080,
//           imageQuality: 85);
//       if (image != null) {
//         setState(() => imageNotifier.value = File(image.path));
//       }
//     }
//   }
//
//   // ════════════════════════════════════════════════════════
//   //  OPEN STUDENT SHEET
//   // ════════════════════════════════════════════════════════
//   void _openStudentSheet({Map<String, dynamic>? student}) {
//     final isEdit = student != null;
//     final classes = ValueNotifier<List<Map<String, dynamic>>>([]);
//     final sections = ValueNotifier<List<Map<String, dynamic>>>([]);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Classes load karo
//       final classesVm =
//       Provider.of<AllClassesViewModel>(context, listen: false);
//       final classData = classesVm.allClassesModel?.data ?? [];
//       classes.value = classData
//           .map((e) => {
//         "class_id": e.classId.toString(),
//         "class_name": e.className ?? "",
//       })
//           .toList();
//
//       // Edit mode mein sections load karo
//       if (isEdit &&
//           student?["class_id"] != null &&
//           student!["class_id"].toString().isNotEmpty) {
//         final repo = AllSectionsRepository();
//         repo.allSectionsApi(student["class_id"].toString()).then((response) {
//           if (response["success"] == true) {
//             sections.value =
//             List<Map<String, dynamic>>.from(response["data"]);
//           }
//         });
//       }
//     });
//
//     final nameCtrl = TextEditingController(text: student?["name"] ?? "");
//     final emailCtrl = TextEditingController(text: student?["email"] ?? "");
//     final passwordCtrl = TextEditingController();
//     final admissionCtrl =
//     TextEditingController(text: student?["admission"] ?? "");
//     final rollNoCtrl =
//     TextEditingController(text: student?["roll_no"] ?? "");
//     final dobCtrl = TextEditingController(text: student?["dob"] ?? "");
//     final mobileCtrl =
//     TextEditingController(text: student?["mobile_number"] ?? "");
//     final fatherNameCtrl =
//     TextEditingController(text: student?["father_name"] ?? "");
//     final motherNameCtrl =
//     TextEditingController(text: student?["mother_name"] ?? "");
//     final addressCtrl =
//     TextEditingController(text: student?["address"] ?? "");
//     final religionCtrl =
//     TextEditingController(text: student?["religion"] ?? "");
//     final passedOutCtrl =
//     TextEditingController(text: student?["passed_out"] ?? "");
//     final transferCtrl =
//     TextEditingController(text: student?["transfer"] ?? "");
//     final aadharNumberCtrl =
//     TextEditingController(text: student?["aadhar_number"] ?? "");
//     final fatherOccupationCtrl =
//     TextEditingController(text: student?["father_occupation"] ?? "");
//     final fatherMobileCtrl =
//     TextEditingController(text: student?["father_mobile"] ?? "");
//     final motherOccupationCtrl =
//     TextEditingController(text: student?["mother_occupation"] ?? "");
//     final motherMobileCtrl =
//     TextEditingController(text: student?["mother_mobile"] ?? "");
//     final guardianNameCtrl =
//     TextEditingController(text: student?["guardian_name"] ?? "");
//     final emergencyContactCtrl = TextEditingController(
//         text: student?["emergency_contact_number"] ?? "");
//     final cityCtrl = TextEditingController(text: student?["city"] ?? "");
//     final stateCtrl = TextEditingController(text: student?["state"] ?? "");
//     final pincodeCtrl =
//     TextEditingController(text: student?["pincode"] ?? "");
//
//     // ── Academic year ValueNotifier (TextEditingController hataya) ──
//     final academicYear =
//     ValueNotifier<String>(student?["academic_year"] ?? "");
//
//     final gender = ValueNotifier<String>(student?["gender"] ?? "Male");
//     final classId = ValueNotifier<String>(student?["class_id"] ?? "");
//     final sectionId = ValueNotifier<String>(student?["section_id"] ?? "");
//     final bloodGroup = ValueNotifier<String>(student?["blood_group"] ?? "");
//     final category = ValueNotifier<String>(student?["category"] ?? "");
// // Yeh line dobCtrl ke paas add karo
//     final passwordVisible = ValueNotifier<bool>(false);
//     List<String> selectedFeeHeadsList =
//     student?["selected_fee_heads"] is List
//         ? List<String>.from(student!["selected_fee_heads"])
//         : (student?["selected_fee_heads"] as String?)
//         ?.split(',')
//         .where((e) => e.isNotEmpty)
//         .toList() ??
//         [];
//
//     final studentPhoto = ValueNotifier<dynamic>(null);
//     final aadharCard = ValueNotifier<dynamic>(null);
//     final fatherPhoto = ValueNotifier<dynamic>(null);
//     final motherPhoto = ValueNotifier<dynamic>(null);
//
//     final existingStudentPhotoUrl =
//         student?["student_photo_url"]?.toString() ?? "";
//     final existingAadharCardUrl =
//         student?["aadhar_card_url"]?.toString() ?? "";
//     final existingFatherPhotoUrl =
//         student?["father_photo_url"]?.toString() ?? "";
//     final existingMotherPhotoUrl =
//         student?["mother_photo_url"]?.toString() ?? "";
//
//     showModalBottomSheet(
//       backgroundColor: AppColor.pageBgColor,
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 18,
//           right: 18,
//           top: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: SingleChildScrollView(
//           child: StatefulBuilder(
//             builder: (ctx, setState) => Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     isEdit ? "Edit Student" : "Add Student",
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Basic Information"),
//                 const SizedBox(height: 12),
//                 _buildTextField(nameCtrl, "Full Name", Icons.person),
//                 const SizedBox(height: 12),
//                 _buildTextField(emailCtrl, "Email", Icons.email),
//                 const SizedBox(height: 12),
//                 if (!isEdit)
//                   ValueListenableBuilder<bool>(
//                     valueListenable: passwordVisible,
//                     builder: (_, isVisible, __) => TextField(
//                       controller: passwordCtrl,
//                       obscureText: !isVisible,
//                       decoration: InputDecoration(
//                         hintText: "Password",
//                         prefixIcon: Icon(Icons.lock, color: AppColor.lightBlueColor),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             isVisible ? Icons.visibility : Icons.visibility_off,
//                             color: AppColor.lightBlueColor,
//                           ),
//                           onPressed: () => passwordVisible.value = !passwordVisible.value,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.grey.shade200)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2)),
//                       ),
//                     ),
//                   ),
//                 if (!isEdit) const SizedBox(height: 12),
//                 // if (!isEdit)
//                 //   _buildTextField(passwordCtrl, "Password", Icons.lock,
//                 //       isPassword: true),
//                 if (!isEdit) const SizedBox(height: 12),
//
//                 // ValueListenableBuilder<String>(
//                 //   valueListenable: gender,
//                 //   builder: (_, val, __) => Row(
//                 //     children: [
//                 //       const Text("Gender: ",
//                 //           style: TextStyle(
//                 //               fontSize: 15, fontWeight: FontWeight.w500)),
//                 //       const SizedBox(width: 10),
//                 //       Expanded(
//                 //         child: ChoiceChip(
//                 //           label: const Text("Male"),
//                 //           selected: val == "Male",
//                 //           onSelected: (_) =>
//                 //               setState(() => gender.value = "Male"),
//                 //           selectedColor:
//                 //           AppColor.maleColor.withOpacity(0.3),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(width: 8),
//                 //       Expanded(
//                 //         child: ChoiceChip(
//                 //           label: const Text("Female"),
//                 //           selected: val == "Female",
//                 //           onSelected: (_) =>
//                 //               setState(() => gender.value = "Female"),
//                 //           selectedColor:
//                 //           AppColor.femaleColor.withOpacity(0.3),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 ValueListenableBuilder<String>(
//                   valueListenable: gender,
//                   builder: (_, val, __) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Gender: ",
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ChoiceChip(
//                               label: const Text("Male"),
//                               selected: val == "Male",
//                               onSelected: (_) => setState(() => gender.value = "Male"),
//                               selectedColor: AppColor.maleColor.withOpacity(0.3),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: ChoiceChip(
//                               label: const Text("Female"),
//                               selected: val == "Female",
//                               onSelected: (_) => setState(() => gender.value = "Female"),
//                               selectedColor: AppColor.femaleColor.withOpacity(0.3),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: ChoiceChip(
//                               label: const Text("Other"),
//                               selected: val == "Other",
//                               onSelected: (_) => setState(() => gender.value = "Other"),
//                               selectedColor: Colors.purple.withOpacity(0.2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Academic Information"),
//                 const SizedBox(height: 12),
//
//                 // ── Academic Year Dropdown ──────────────────────────
//                 Consumer<AcademicViewModel>(
//                   builder: (context, vm, _) {
//                     if (vm.loading) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                         child: Center(
//                             child: CircularProgressIndicator(
//                                 strokeWidth: 2)),
//                       );
//                     }
//
//                     final years = vm.years;
//
//                     // Current year auto-select karo agar value empty hai
//                     if (academicYear.value.isEmpty &&
//                         vm.currentYear != null) {
//                       Future.microtask(() => academicYear.value =
//                           vm.currentYear!.yearName ?? "");
//                     }
//
//                     return ValueListenableBuilder<String>(
//                       valueListenable: academicYear,
//                       builder: (_, val, __) => Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border:
//                           Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             isExpanded: true,
//                             hint: Row(
//                               children: [
//                                 Icon(Icons.calendar_today,
//                                     color: AppColor.lightBlueColor,
//                                     size: 20),
//                                 const SizedBox(width: 12),
//                                 const Text("Academic Year"),
//                               ],
//                             ),
//                             value: val.isEmpty ? null : val,
//                             items: years
//                                 .map(
//                                   (y) => DropdownMenuItem<String>(
//                                 value: y.yearName,
//                                 child: Row(
//                                   children: [
//                                     Text(y.yearName ?? ""),
//                                     if (y.isCurrent == 1) ...[
//                                       const SizedBox(width: 8),
//                                       Container(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color:
//                                           Colors.green.shade100,
//                                           borderRadius:
//                                           BorderRadius.circular(
//                                               6),
//                                         ),
//                                         child: Text(
//                                           "Current",
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors
//                                                 .green.shade700,
//                                             fontWeight:
//                                             FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             )
//                                 .toList(),
//                             onChanged: (v) => setState(
//                                     () => academicYear.value = v ?? ""),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 // const SizedBox(height: 12),
//                 //
//                 // _buildTextField(admissionCtrl, "Admission No.",
//                 //     Icons.confirmation_number),
//                 const SizedBox(height: 12),
//                 _buildTextField(rollNoCtrl, "Roll No.",
//                     Icons.format_list_numbered),
//                 const SizedBox(height: 12),
//
//                 ValueListenableBuilder<List<Map<String, dynamic>>>(
//                   valueListenable: classes,
//                   builder: (_, list, __) => _buildDropdown(
//                     label: "Class",
//                     value: classId.value,
//                     items: list
//                         .map((e) =>
//                     "${e["class_id"]}|${e["class_name"]}")
//                         .toList(),
//                     onChanged: (val) async {
//                       if (val == null) return;
//                       classId.value = val.split("|")[0];
//                       sectionId.value = "";
//                       final repo = AllSectionsRepository();
//                       final response =
//                       await repo.allSectionsApi(classId.value);
//                       if (response["success"] == true) {
//                         sections.value =
//                         List<Map<String, dynamic>>.from(
//                             response["data"]);
//                       } else {
//                         sections.value = [];
//                       }
//                       setState(() {});
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 ValueListenableBuilder<List<Map<String, dynamic>>>(
//                   valueListenable: sections,
//                   builder: (_, list, __) {
//                     final classSelected = classId.value.isNotEmpty;
//                     final noSections = classSelected && list.isEmpty;
//
//                     if (noSections) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 14),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                               color: Colors.orange.shade200),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.info_outline_rounded,
//                                 size: 20,
//                                 color: Colors.orange.shade400),
//                             const SizedBox(width: 10),
//                             Text(
//                               "No Section available for this class",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.orange.shade700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     return _buildDropdown(
//                       label: "Section",
//                       value: sectionId.value,
//                       items: list
//                           .map((e) =>
//                       "${e["section_id"]}|${e["section_name"]}")
//                           .toList(),
//                       onChanged: (val) {
//                         if (val == null) return;
//                         setState(
//                                 () => sectionId.value = val.split("|")[0]);
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Personal Information"),
//                 const SizedBox(height: 12),
//                 InkWell(
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() => dobCtrl.text =
//                       "${picked.day}/${picked.month}/${picked.year}");
//                     }
//                   },
//                   child: AbsorbPointer(
//                     child: _buildTextField(dobCtrl,
//                         "Date of Birth (DD/MM/YYYY)", Icons.cake),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   mobileCtrl,
//                   "Mobile Number",
//                   Icons.phone,
//                   keyboardType: TextInputType.phone,
//                   maxLength: 10,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     religionCtrl, "Religion", Icons.temple_hindu),
//                 // const SizedBox(height: 12),
//                 // _buildTextField(addressCtrl, "Address", Icons.home,
//                 //     maxLines: 3),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Parent Information"),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     fatherNameCtrl, "Father's Name", Icons.person),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     motherNameCtrl, "Mother's Name", Icons.person),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Additional Information"),
//                 const SizedBox(height: 12),
//
//                 ValueListenableBuilder<String>(
//                   valueListenable: bloodGroup,
//                   builder: (_, val, __) => Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         isExpanded: true,
//                         hint: Row(
//                           children: [
//                             Icon(Icons.bloodtype,
//                                 color: AppColor.lightBlueColor,
//                                 size: 20),
//                             const SizedBox(width: 12),
//                             const Text("Blood Group"),
//                           ],
//                         ),
//                         value: val.isEmpty ? null : val,
//                         items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
//                             .map((g) =>
//                             DropdownMenuItem(value: g, child: Text(g)))
//                             .toList(),
//                         onChanged: (v) =>
//                             setState(() => bloodGroup.value = v ?? ""),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 ValueListenableBuilder<String>(
//                   valueListenable: category,
//                   builder: (_, val, __) => Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         isExpanded: true,
//                         hint: Row(
//                           children: [
//                             Icon(Icons.category,
//                                 color: AppColor.lightBlueColor,
//                                 size: 20),
//                             const SizedBox(width: 12),
//                             const Text("Category"),
//                           ],
//                         ),
//                         value: val.isEmpty ? null : val,
//                         items: [
//                           "General",
//                           "OBC",
//                           "SC",
//                           "ST",
//                           "EWS",
//                           "Other"
//                         ]
//                             .map((c) =>
//                             DropdownMenuItem(value: c, child: Text(c)))
//                             .toList(),
//                         onChanged: (v) =>
//                             setState(() => category.value = v ?? ""),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 _buildTextField(aadharNumberCtrl, "Aadhar Number",
//                     Icons.credit_card,
//                     keyboardType: TextInputType.number),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Parent Extra Details"),
//                 const SizedBox(height: 12),
//                 _buildTextField(fatherOccupationCtrl,
//                     "Father's Occupation", Icons.work),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     fatherMobileCtrl, "Father's Mobile", Icons.phone,
//                     keyboardType: TextInputType.phone, maxLength: 10),
//                 const SizedBox(height: 12),
//                 _buildTextField(motherOccupationCtrl,
//                     "Mother's Occupation", Icons.work),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     motherMobileCtrl, "Mother's Mobile", Icons.phone,
//                     keyboardType: TextInputType.phone, maxLength: 10),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     guardianNameCtrl, "Guardian Name", Icons.person),
//                 const SizedBox(height: 12),
//                 _buildTextField(emergencyContactCtrl,
//                     "Emergency Contact", Icons.emergency,
//                     keyboardType: TextInputType.phone, maxLength: 10),
//                 const SizedBox(height: 20),
//                 _sectionHeader("Address Details"),
//                 const SizedBox(height: 12),
//                 _buildTextField(addressCtrl, "Address", Icons.home,
//                     maxLines: 3),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                     cityCtrl, "City", Icons.location_city),
//                 // _sectionHeader("Address Details"),
//                 // const SizedBox(height: 12),
//                 // _buildTextField(
//                 //     cityCtrl, "City", Icons.location_city),
//                 const SizedBox(height: 12),
//                 _buildTextField(stateCtrl, "State", Icons.map),
//                 const SizedBox(height: 12),
//                 _buildTextField(pincodeCtrl, "Pincode", Icons.pin_drop,
//                     keyboardType: TextInputType.number),
//                 const SizedBox(height: 20),
//
//                 _sectionHeader("Upload Documents"),
//                 const SizedBox(height: 12),
//                 _buildImagePickerWithPreview(
//                   label: "Student Photo",
//                   icon: Icons.portrait,
//                   imageNotifier: studentPhoto,
//                   existingUrl: existingStudentPhotoUrl,
//                   setState: setState,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildImagePickerWithPreview(
//                   label: "Aadhar Card",
//                   icon: Icons.credit_card,
//                   imageNotifier: aadharCard,
//                   existingUrl: existingAadharCardUrl,
//                   setState: setState,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildImagePickerWithPreview(
//                   label: "Father's Photo",
//                   icon: Icons.person,
//                   imageNotifier: fatherPhoto,
//                   existingUrl: existingFatherPhotoUrl,
//                   setState: setState,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildImagePickerWithPreview(
//                   label: "Mother's Photo",
//                   icon: Icons.person,
//                   imageNotifier: motherPhoto,
//                   existingUrl: existingMotherPhotoUrl,
//                   setState: setState,
//                 ),
//                 const SizedBox(height: 20),
//
//                 // _sectionHeader("Fee Heads"),
//                 if (!isEdit) ...[
//                   _sectionHeader("Fee Heads"),
//                   const SizedBox(height: 12),
//                   Consumer<FeesHeadManagementViewModel>(
//                     builder: (context, vm, child) {
//                       if (vm.loading) {
//                         return const Center(
//                             child: CircularProgressIndicator());
//                       }
//                       final feeHeads =
//                           vm.feesHeadManagementModel?.data?.feeHeads ?? [];
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: feeHeads.length,
//                         itemBuilder: (context, index) {
//                           final fee = feeHeads[index];
//                           final feeIdStr = fee.feeHeadId.toString();
//                           return CheckboxListTile(
//                             title: Text(fee.headName ?? ""),
//                             value:
//                             selectedFeeHeadsList.contains(feeIdStr),
//                             onChanged: (value) {
//                               setState(() {
//                                 if (value == true) {
//                                   if (!selectedFeeHeadsList
//                                       .contains(feeIdStr)) {
//                                     selectedFeeHeadsList.add(feeIdStr);
//                                   }
//                                 } else {
//                                   selectedFeeHeadsList.remove(feeIdStr);
//                                 }
//                               });
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//                 // const SizedBox(height: 12),
//                 // Consumer<FeesHeadManagementViewModel>(
//                 //   builder: (context, vm, child) {
//                 //     if (vm.loading) {
//                 //       return const Center(
//                 //           child: CircularProgressIndicator());
//                 //     }
//                 //     final feeHeads =
//                 //         vm.feesHeadManagementModel?.data?.feeHeads ?? [];
//                 //     return ListView.builder(
//                 //       shrinkWrap: true,
//                 //       physics: const NeverScrollableScrollPhysics(),
//                 //       itemCount: feeHeads.length,
//                 //       itemBuilder: (context, index) {
//                 //         final fee = feeHeads[index];
//                 //         final feeIdStr = fee.feeHeadId.toString();
//                 //         return CheckboxListTile(
//                 //           title: Text(fee.headName ?? ""),
//                 //           value:
//                 //           selectedFeeHeadsList.contains(feeIdStr),
//                 //           onChanged: (value) {
//                 //             setState(() {
//                 //               if (value == true) {
//                 //                 if (!selectedFeeHeadsList
//                 //                     .contains(feeIdStr)) {
//                 //                   selectedFeeHeadsList.add(feeIdStr);
//                 //                 }
//                 //               } else {
//                 //                 selectedFeeHeadsList.remove(feeIdStr);
//                 //               }
//                 //             });
//                 //           },
//                 //         );
//                 //       },
//                 //     );
//                 //   },
//                 // ),
//                 const SizedBox(height: 30),
//
//                 AppButton(
//                   title: isEdit ? "Update Student" : "Add Student",
//                   onTap: () {
//                     if (_validateForm(
//                       nameCtrl,
//                       emailCtrl,
//                       passwordCtrl,
//                       // admissionCtrl,
//                       classId,
//                       sectionId,
//                       dobCtrl,
//                       mobileCtrl,
//                       fatherNameCtrl,
//                       motherNameCtrl,
//                       isEdit,
//                       context,
//                     )) {
//                       if (isEdit) {
//                         Provider.of<EditStudentViewModel>(context,
//                             listen: false)
//                             .editStudentApi(
//                           context: context,
//                           studentId: student!["id"].toString(),
//                           name: nameCtrl.text.trim().isEmpty
//                               ? student["name"] ?? ""
//                               : nameCtrl.text.trim(),
//                           email: emailCtrl.text.trim().isEmpty
//                               ? student["email"] ?? ""
//                               : emailCtrl.text.trim(),
//                           admission_no:
//                           admissionCtrl.text.trim().isEmpty
//                               ? student["admission"] ?? ""
//                               : admissionCtrl.text.trim(),
//                           gender: gender.value,
//                           class_id: classId.value.isEmpty
//                               ? (student["class_id"] ?? "")
//                               : classId.value,
//                           section_id: sectionId.value.isEmpty
//                               ? (student["section_id"] ?? "")
//                               : sectionId.value,
//                           password: '',
//                           dob: dobCtrl.text.trim().isEmpty
//                               ? student["dob"] ?? ""
//                               : dobCtrl.text.trim(),
//                           mobileNumber: mobileCtrl.text.trim().isEmpty
//                               ? student["mobile_number"] ?? ""
//                               : mobileCtrl.text.trim(),
//                           fatherName:
//                           fatherNameCtrl.text.trim().isEmpty
//                               ? student["father_name"] ?? ""
//                               : fatherNameCtrl.text.trim(),
//                           motherName:
//                           motherNameCtrl.text.trim().isEmpty
//                               ? student["mother_name"] ?? ""
//                               : motherNameCtrl.text.trim(),
//                           address: addressCtrl.text.trim().isEmpty
//                               ? student["address"] ?? ""
//                               : addressCtrl.text.trim(),
//                           religion: religionCtrl.text.trim().isEmpty
//                               ? student["religion"] ?? ""
//                               : religionCtrl.text.trim(),
//                           // ✅ academicYearCtrl → academicYear.value
//                           academicYear: academicYear.value.isEmpty
//                               ? student["academic_year"] ?? ""
//                               : academicYear.value,
//                           passedOut: passedOutCtrl.text.trim().isEmpty
//                               ? student["passed_out"] ?? ""
//                               : passedOutCtrl.text.trim(),
//                           transfer: transferCtrl.text.trim().isEmpty
//                               ? student["transfer"] ?? ""
//                               : transferCtrl.text.trim(),
//                           bloodGroup: bloodGroup.value.isEmpty
//                               ? (student["blood_group"] ?? "")
//                               : bloodGroup.value,
//                           category: category.value.isEmpty
//                               ? (student["category"] ?? "")
//                               : category.value,
//                           aadharNumber:
//                           aadharNumberCtrl.text.trim().isEmpty
//                               ? student["aadhar_number"] ?? ""
//                               : aadharNumberCtrl.text.trim(),
//                           fatherOccupation:
//                           fatherOccupationCtrl.text.trim().isEmpty
//                               ? student["father_occupation"] ?? ""
//                               : fatherOccupationCtrl.text.trim(),
//                           fatherMobile:
//                           fatherMobileCtrl.text.trim().isEmpty
//                               ? student["father_mobile"] ?? ""
//                               : fatherMobileCtrl.text.trim(),
//                           motherOccupation:
//                           motherOccupationCtrl.text.trim().isEmpty
//                               ? student["mother_occupation"] ?? ""
//                               : motherOccupationCtrl.text.trim(),
//                           motherMobile:
//                           motherMobileCtrl.text.trim().isEmpty
//                               ? student["mother_mobile"] ?? ""
//                               : motherMobileCtrl.text.trim(),
//                           guardianName:
//                           guardianNameCtrl.text.trim().isEmpty
//                               ? student["guardian_name"] ?? ""
//                               : guardianNameCtrl.text.trim(),
//                           emergencyContactNumber:
//                           emergencyContactCtrl.text.trim().isEmpty
//                               ? student[
//                           "emergency_contact_number"] ??
//                               ""
//                               : emergencyContactCtrl.text.trim(),
//                           city: cityCtrl.text.trim().isEmpty
//                               ? student["city"] ?? ""
//                               : cityCtrl.text.trim(),
//                           state: stateCtrl.text.trim().isEmpty
//                               ? student["state"] ?? ""
//                               : stateCtrl.text.trim(),
//                           pincode: pincodeCtrl.text.trim().isEmpty
//                               ? student["pincode"] ?? ""
//                               : pincodeCtrl.text.trim(),
//                           roll_no: rollNoCtrl.text.trim().isEmpty
//                               ? student["roll_no"] ?? ""
//                               : rollNoCtrl.text.trim(),
//                           studentPhoto: studentPhoto.value,
//                           aadharCard: aadharCard.value,
//                           fatherPhoto: fatherPhoto.value,
//                           motherPhoto: motherPhoto.value,
//                         );
//                       } else {
//                         Provider.of<AddStudentViewModel>(context,
//                             listen: false)
//                             .addStudentApi(
//                           name: nameCtrl.text.trim(),
//                           email: emailCtrl.text.trim(),
//                           password: passwordCtrl.text.trim(),
//                           class_id: classId.value,
//                           section_id: sectionId.value,
//                           admission_no: admissionCtrl.text.trim(),
//                           gender: gender.value,
//                           // ✅ academicYearCtrl → academicYear.value
//                           academic_year: academicYear.value,
//                           roll_no: rollNoCtrl.text.trim(),
//                           dob: dobCtrl.text.trim(),
//                           mobile_number: mobileCtrl.text.trim(),
//                           father_name: fatherNameCtrl.text.trim(),
//                           mother_name: motherNameCtrl.text.trim(),
//                           address: addressCtrl.text.trim(),
//                           religion: religionCtrl.text.trim(),
//                           selected_fee_heads:
//                           selectedFeeHeadsList.join(','),
//                           student_photo: studentPhoto.value,
//                           aadharCard: aadharCard.value,
//                           father_photo: fatherPhoto.value,
//                           mother_photo: motherPhoto.value,
//                           passed_out: passedOutCtrl.text.trim(),
//                           transfer: transferCtrl.text.trim(),
//                           blood_group: bloodGroup.value,
//                           category: category.value,
//                           aadhar_number: aadharNumberCtrl.text.trim(),
//                           father_occupation:
//                           fatherOccupationCtrl.text.trim(),
//                           father_mobile: fatherMobileCtrl.text.trim(),
//                           mother_occupation:
//                           motherOccupationCtrl.text.trim(),
//                           mother_mobile: motherMobileCtrl.text.trim(),
//                           guardian_name: guardianNameCtrl.text.trim(),
//                           emergency_contact_number:
//                           emergencyContactCtrl.text.trim(),
//                           city: cityCtrl.text.trim(),
//                           state: stateCtrl.text.trim(),
//                           pincode: pincodeCtrl.text.trim(),
//                           context: context,
//                         );
//                       }
//
//                       Future.delayed(const Duration(milliseconds: 300),
//                               () {
//                             if (context.mounted) {
//                               Provider.of<AllStudentListVieModel>(context,
//                                   listen: false)
//                                   .allStudentListApi(context);
//                             }
//                           });
//                       Navigator.pop(ctx);
//                     }
//                   },
//                   height: 52,
//                   radius: 16,
//                   gradient: AppColor.primaryGradient,
//                   textColor: Colors.white,
//                   icon: isEdit ? Icons.edit : Icons.add_rounded,
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ════════════════════════════════════════════════════════
//   //  IMAGE PICKER WITH EXISTING URL PREVIEW
//   // ════════════════════════════════════════════════════════
//   Widget _buildImagePickerWithPreview({
//     required String label,
//     required IconData icon,
//     required ValueNotifier imageNotifier,
//     required String existingUrl,
//     required Function setState,
//   }) {
//     final hasExisting = existingUrl.isNotEmpty && existingUrl != "null";
//
//     return ValueListenableBuilder(
//       valueListenable: imageNotifier,
//       builder: (context, value, child) {
//         final File? newFile = value as File?;
//         final bool showExisting = hasExisting && newFile == null;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               onTap: () => _pickImage(imageNotifier, setState),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: (newFile != null || showExisting)
//                         ? Colors.green.shade300
//                         : Colors.grey.shade200,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(icon, color: AppColor.lightBlueColor),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         newFile != null
//                             ? "$label Selected ✓"
//                             : showExisting
//                             ? "$label (uploaded) • Tap to change"
//                             : "Upload $label",
//                         style: TextStyle(
//                           color: (newFile != null || showExisting)
//                               ? Colors.green
//                               : Colors.grey,
//                           fontWeight:
//                           (newFile != null || showExisting)
//                               ? FontWeight.w600
//                               : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       (newFile != null || showExisting)
//                           ? Icons.check_circle
//                           : Icons.upload_file,
//                       color: (newFile != null || showExisting)
//                           ? Colors.green
//                           : Colors.grey,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (newFile != null) ...[
//               const SizedBox(height: 8),
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(newFile,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: InkWell(
//                       onTap: () =>
//                           setState(() => imageNotifier.value = null),
//                       child: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: const BoxDecoration(
//                             color: Colors.red, shape: BoxShape.circle),
//                         child: const Icon(Icons.close,
//                             color: Colors.white, size: 18),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ] else if (showExisting) ...[
//               const SizedBox(height: 8),
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       existingUrl,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (_, child, progress) =>
//                       progress == null
//                           ? child
//                           : Container(
//                         height: 150,
//                         color: Colors.grey[200],
//                         child: const Center(
//                             child: CircularProgressIndicator(
//                                 strokeWidth: 2)),
//                       ),
//                       errorBuilder: (_, __, ___) => Container(
//                         height: 150,
//                         color: Colors.grey[200],
//                         child: const Center(
//                             child: Icon(Icons.broken_image_rounded,
//                                 color: Colors.grey)),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text("Current",
//                           style: TextStyle(
//                               color: Colors.white, fontSize: 11)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
//
//   // ─── Helper Widgets ───────────────────────────────────────
//   Widget _sectionHeader(String title) => Text(
//     title,
//     style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: AppColor.lightBlueColor),
//   );
//
//   Widget _buildTextField(
//       TextEditingController ctrl,
//       String hint,
//       IconData icon, {
//         bool isPassword = false,
//         int maxLines = 1,
//         TextInputType keyboardType = TextInputType.text,
//         int? maxLength,
//       }) {
//     return TextField(
//       controller: ctrl,
//       obscureText: isPassword,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       inputFormatters: maxLength != null
//           ? [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(maxLength),
//       ]
//           : null,
//       maxLength: maxLength,
//       buildCounter: maxLength != null
//           ? (context,
//           {required currentLength,
//             required isFocused,
//             maxLength}) =>
//           Text(
//             "$currentLength/$maxLength",
//             style:
//             TextStyle(fontSize: 11, color: Colors.grey.shade500),
//           )
//           : null,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//             BorderSide(color: AppColor.lightBlueColor, width: 2)),
//       ),
//     );
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           isExpanded: true,
//           hint: Text(label),
//           value: value.isEmpty ? null : value,
//           items: items.map((String item) {
//             final parts = item.split("|");
//             return DropdownMenuItem<String>(
//                 value: parts[0], child: Text(parts[1]));
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
//
//   bool _validateForm(
//       TextEditingController nameCtrl,
//       TextEditingController emailCtrl,
//       TextEditingController passwordCtrl,
//       // TextEditingController admissionCtrl,
//       ValueNotifier<String> classId,
//       ValueNotifier<String> sectionId,
//       TextEditingController dobCtrl,
//       TextEditingController mobileCtrl,
//       TextEditingController fatherNameCtrl,
//       TextEditingController motherNameCtrl,
//       bool isEdit,
//       BuildContext context,
//       )
//   {
//     if (isEdit) return true;
//     if (nameCtrl.text.trim().isEmpty) {
//       Utils.show("Enter student name", context);
//       return false;
//     }
//     if (emailCtrl.text.trim().isEmpty) {
//       Utils.show("Enter email", context);
//       return false;
//     }
//     if (passwordCtrl.text.trim().isEmpty) {
//       Utils.show("Enter password", context);
//       return false;
//     }
//     if (classId.value.isEmpty) {
//       Utils.show("Select class", context);
//       return false;
//     }
//     if (dobCtrl.text.trim().isEmpty) {
//       Utils.show("Select DOB", context);
//       return false;
//     }
//     if (mobileCtrl.text.trim().isEmpty) {
//       Utils.show("Enter mobile number", context);
//       return false;
//     }
//     if (mobileCtrl.text.trim().length < 10) {
//       Utils.show("Enter valid 10-digit mobile number", context);
//       return false;
//     }
//     if (fatherNameCtrl.text.trim().isEmpty) {
//       Utils.show("Enter father name", context);
//       return false;
//     }
//     if (motherNameCtrl.text.trim().isEmpty) {
//       Utils.show("Enter mother name", context);
//       return false;
//     }
//     return true;
//   }
// }
//
// // ════════════════════════════════════════════════════════
// //  FULL-SCREEN IMAGE VIEWER
// // ════════════════════════════════════════════════════════
// class _ImageViewerScreen extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//
//   const _ImageViewerScreen({
//     required this.imageUrl,
//     required this.title,
//   });
//
//   @override
//   State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
// }
//
// class _ImageViewerScreenState extends State<_ImageViewerScreen> {
//   final TransformationController _transformController =
//   TransformationController();
//
//   @override
//   void dispose() {
//     _transformController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         title: Text(widget.title,
//             style:
//             const TextStyle(fontSize: 16, color: Colors.white)),
//         actions: [
//           IconButton(
//             onPressed: () =>
//             _transformController.value = Matrix4.identity(),
//             icon: const Icon(Icons.fit_screen_rounded,
//                 color: Colors.white),
//             tooltip: 'Reset Zoom',
//           ),
//           IconButton(
//             onPressed: () async {
//               await launchUrl(Uri.parse(widget.imageUrl),
//                   mode: LaunchMode.externalApplication);
//             },
//             icon: const Icon(Icons.open_in_new_rounded,
//                 color: Colors.white),
//           ),
//         ],
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           transformationController: _transformController,
//           minScale: 0.5,
//           maxScale: 5.0,
//           child: Image.network(
//             widget.imageUrl,
//             fit: BoxFit.contain,
//             loadingBuilder: (_, child, progress) {
//               if (progress == null) return child;
//               return const Center(
//                   child: CircularProgressIndicator(
//                       color: Colors.white));
//             },
//             errorBuilder: (_, __, ___) => const Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.broken_image_rounded,
//                     size: 60, color: Colors.white54),
//                 SizedBox(height: 12),
//                 Text('Could not load image',
//                     style: TextStyle(color: Colors.white54)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/school_student_detail_screen.dart';
import 'package:school_pro/view_model/school_view_model/academic_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_student_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import '../repo/school_repo/all_sections_repo.dart';
import '../res/app_button.dart';
import '../utils/permission_error_message.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/add_student_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../view_model/school_view_model/fees_head_management_view_model.dart';
import '../model/school_model/academic_model.dart';
import 'add_student_screen.dart';

class AllStudentList extends StatefulWidget {
  const AllStudentList({super.key});

  @override
  State<AllStudentList> createState() => _AllStudentListState();
}

class _AllStudentListState extends State<AllStudentList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ImagePicker _picker = ImagePicker();

  final _classes = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _sections = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _selectedClassId = ValueNotifier<String>("");
  final _selectedSectionId = ValueNotifier<String>("");

  bool _sectionsLoading = false;
  List<int> selectedFeeHeads = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllStudentListVieModel>(context, listen: false)
          .allStudentListApi(context);
      Provider.of<FeesHeadManagementViewModel>(context, listen: false)
          .feesHeadManagementApi(context);

      Provider.of<AcademicViewModel>(context, listen: false)
          .academicApi(context);

      final classesVm =
      Provider.of<AllClassesViewModel>(context, listen: false);
      classesVm.allClassesApi(context);

      classesVm.addListener(() {
        final classData = classesVm.allClassesModel?.data ?? [];
        if (classData.isNotEmpty && _classes.value.isEmpty) {
          _classes.value = classData
              .map((e) => {
            "class_id": e.classId.toString(),
            "class_name": e.className ?? "",
          })
              .toList();
        }
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _animationController.reset();
    await Provider.of<AllStudentListVieModel>(context, listen: false)
        .allStudentListApi(context);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllStudentListVieModel>(context);
    final students = viewModel.allStudentListModel?.data ?? [];

    final filteredStudents = students.where((s) {
      final selectedClassName = _classes.value
          .firstWhere(
            (c) =>
        c["class_id"].toString() ==
            _selectedClassId.value.toString(),
        orElse: () => <String, String>{},
      )["class_name"] ??
          "";
      final classMatch = _selectedClassId.value.isEmpty ||
          (s.className ?? "") == selectedClassName;

      final selectedSectionName = _sections.value
          .firstWhere(
            (sec) =>
        sec["section_id"].toString() == _selectedSectionId.value,
        orElse: () => {},
      )["section_name"] ??
          "";
      final sectionMatch = _selectedSectionId.value.isEmpty ||
          (s.sectionName ?? "") == selectedSectionName;

      return classMatch && sectionMatch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        onPressed: () {

          if (!PermissionGuard.check(
            context,
            PermissionKeys.addStudent,
            "Add Student",
          )) {
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddStudentPage(),
            ),
          );
        },
        icon: Icon(Icons.add_rounded, color: AppColor.white),
        label: const Text(
          'Add Student',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: AppColor.blueShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
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
                  child: AppText.customText("All Students",
                      size: 19, weight: FontWeight.bold, color: Colors.white),
                ),
                AppText.customText("${students.length}",
                    size: 16, weight: FontWeight.w600, color: Colors.white70),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Class & Section Filter ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _classes,
                    builder: (_, list, __) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _selectedClassId,
                        builder: (_, classVal, __) {
                          return _buildFilterDropdown(
                            label: "Class",
                            value: classVal.isEmpty ? null : classVal,
                            items: list
                                .map((e) => DropdownMenuItem<String>(
                              value: e["class_id"],
                              child: Text(e["class_name"]),
                            ))
                                .toList(),
                            onChanged: (val) async {
                              _selectedClassId.value = val ?? "";
                              _selectedSectionId.value = "";
                              _sections.value = [];

                              if (val != null) {
                                setState(() => _sectionsLoading = true);
                                final repo = AllSectionsRepository();
                                final response =
                                await repo.allSectionsApi(val);
                                setState(() => _sectionsLoading = false);

                                if (response["success"] == true) {
                                  _sections.value =
                                  List<Map<String, dynamic>>.from(
                                      response["data"]);
                                } else {
                                  _sections.value = [];
                                }
                              } else {
                                setState(() => _sectionsLoading = false);
                                _sections.value = [];
                              }
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _sections,
                    builder: (_, list, __) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _selectedSectionId,
                        builder: (_, secVal, __) {
                          if (_sectionsLoading) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.cardShadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3))
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.lightBlueColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Loading...",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                            );
                          }

                          final classSelected =
                              _selectedClassId.value.isNotEmpty;
                          final noSections = classSelected && list.isEmpty;

                          if (noSections) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.orange.shade200),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.cardShadow,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3))
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      size: 18,
                                      color: Colors.orange.shade400),
                                  const SizedBox(width: 8),
                                  Text(
                                    "No Section",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return _buildFilterDropdown(
                            label: "Section",
                            value: secVal.isEmpty ? null : secVal,
                            items: list
                                .map((e) => DropdownMenuItem<String>(
                              value: e["section_id"].toString(),
                              child: Text(e["section_name"]),
                            ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedSectionId.value = val ?? "";
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: viewModel.loading
                ? _studentShimmer()
                : filteredStudents.isEmpty
                ? RefreshIndicator(
              color: AppColor.lightBlueColor,
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_outlined,
                            size: 80,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text("No Students Found",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500)),
                        const SizedBox(height: 8),
                        Text("Pull down to refresh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              color: AppColor.lightBlueColor,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding:
                const EdgeInsets.fromLTRB(18, 8, 18, 20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final s = filteredStudents[index];
                  final isMale =
                      s.gender?.toLowerCase() == "male";
                  return _animatedStudentCard(index, {
                    "id": s.studentId,
                    "name": s.name ?? "",
                    "email": s.userEmail ?? "",
                    "admission": s.admissionNo ?? "",
                    "class": s.className ?? "",
                    "section": s.sectionName ?? "",
                    "class_id": s.classId?.toString() ?? "",
                    "section_id":
                    s.sectionId?.toString() ?? "",
                    "gender": s.gender != null
                        ? "${s.gender![0].toUpperCase()}${s.gender!.substring(1)}"
                        : "Male",
                    "roll_no": s.rollNo?.toString() ?? "",
                    "dob": s.dob != null
                        ? s.dob!.contains("T")
                        ? s.dob!.split("T")[0]
                        : s.dob!
                        : "",
                    "mobile_number": s.mobileNumber ?? "",
                    "father_name": s.fatherName ?? "",
                    "mother_name": s.motherName ?? "",
                    "address": s.address ?? "",
                    "religion": s.religion ?? "",
                    "academic_year": s.academicYear ?? "",
                    "passed_out":
                    s.passedOut?.toString() ?? "",
                    "transfer": s.transfer?.toString() ?? "",
                    "blood_group": s.bloodGroup ?? "",
                    "category": s.category ?? "",
                    "aadhar_number": s.aadharNumber ?? "",
                    "father_occupation":
                    s.fatherOccupation ?? "",
                    "father_mobile": s.fatherMobile ?? "",
                    "mother_occupation":
                    s.motherOccupation ?? "",
                    "mother_mobile": s.motherMobile ?? "",
                    "guardian_name": s.guardianName ?? "",
                    "emergency_contact_number":
                    s.emergencyContactNumber ?? "",
                    "city": s.city ?? "",
                    "state": s.state ?? "",
                    "pincode": s.pincode ?? "",
                    "selected_fee_heads": "",
                    "student_photo_url":
                    s.studentPhotoUrl ?? "",
                    "aadhar_card_url": s.aadharCardUrl ?? "",
                    "father_photo_url":
                    s.fatherPhotoUrl ?? "",
                    "mother_photo_url":
                    s.motherPhotoUrl ?? "",
                    "color": isMale
                        ? AppColor.maleColor
                        : AppColor.femaleColor,
                    "gradient": isMale
                        ? [AppColor.maleColor, AppColor.maleLight]
                        : [
                      AppColor.femaleColor,
                      AppColor.femaleLight
                    ],
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(label, style: const TextStyle(fontSize: 13)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _studentShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 110,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColor.cardWhite,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _animatedStudentCard(int index, Map<String, dynamic> data) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 25 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _studentCard(data),
    );
  }

  Widget _studentCard(Map<String, dynamic> s) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!PermissionExtensions.canAccess(
            PermissionKeys.viewOneStudentProfile)) {
          Utils.show("You don't have permission", context);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchoolStudentDetailScreen(
              studentId: s["id"],
              className: s["class"],
              sectionName: s["section"],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.cardWhite,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 14,
                offset: const Offset(0, 6))
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.015),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: s["gradient"]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 30),
              ),
              SizedBox(width: w * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(s["name"],
                        size: 17, weight: FontWeight.bold),
                    const SizedBox(height: 6),
                    AppText.customText(s["email"],
                        size: 13, color: AppColor.softGreyText),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        AppText.customText("Adm: ${s["admission"]}",
                            size: 11, color: AppColor.softGreyText),
                        SizedBox(width: w * 0.01),
                        AppText.customText(s["gender"],
                            size: 11, color: AppColor.softGreyText),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText.customText(s["class"],
                        size: 13,
                        color: AppColor.lightBlueColor,
                        weight: FontWeight.w600),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!PermissionGuard.check(context, PermissionKeys.editStudent, "Edit Student")) {
                        return;
                      }
                      _openStudentSheet(student: s);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.edit_note_rounded,
                          color: AppColor.lightBlueColor, size: 20),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {

                      if (!PermissionGuard.check(
                        context,
                        PermissionKeys.deleteStudent,
                        "Delete Student",
                      )) {
                        return;
                      }

                      bool confirmed = await _showDeleteDialog();

                      if (confirmed) {
                        Provider.of<DeleteStudentViewModel>(
                          context,
                          listen: false,
                        ).deleteStudentApi(
                          s["id"],
                          context,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.delete_outline_rounded,
                          color: AppColor.error, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 35),
              ),
              const SizedBox(height: 15),
              const Text("Delete Student",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to delete this student?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ) ??
        false;
  }

  Future<void> _pickImage(
      ValueNotifier imageNotifier, Function setState) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading:
              const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 85);
      if (image != null) {
        setState(() => imageNotifier.value = File(image.path));
      }
    }
  }

  // ════════════════════════════════════════════════════════
  //  OPEN STUDENT SHEET
  // ════════════════════════════════════════════════════════
  void _openStudentSheet({Map<String, dynamic>? student}) {
    final isEdit = student != null;
    final classes = ValueNotifier<List<Map<String, dynamic>>>([]);
    final sections = ValueNotifier<List<Map<String, dynamic>>>([]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classesVm =
      Provider.of<AllClassesViewModel>(context, listen: false);
      final classData = classesVm.allClassesModel?.data ?? [];
      classes.value = classData
          .map((e) => {
        "class_id": e.classId.toString(),
        "class_name": e.className ?? "",
      })
          .toList();

      if (isEdit &&
          student?["class_id"] != null &&
          student!["class_id"].toString().isNotEmpty) {
        final repo = AllSectionsRepository();
        repo.allSectionsApi(student["class_id"].toString()).then((response) {
          if (response["success"] == true) {
            sections.value =
            List<Map<String, dynamic>>.from(response["data"]);
          }
        });
      }
    });

    final nameCtrl = TextEditingController(text: student?["name"] ?? "");
    final emailCtrl = TextEditingController(text: student?["email"] ?? "");
    final passwordCtrl = TextEditingController(); // always empty — admin sets new password
    final admissionCtrl =
    TextEditingController(text: student?["admission"] ?? "");
    final rollNoCtrl =
    TextEditingController(text: student?["roll_no"] ?? "");
    final dobCtrl = TextEditingController(text: student?["dob"] ?? "");
    final mobileCtrl =
    TextEditingController(text: student?["mobile_number"] ?? "");
    final fatherNameCtrl =
    TextEditingController(text: student?["father_name"] ?? "");
    final motherNameCtrl =
    TextEditingController(text: student?["mother_name"] ?? "");
    final addressCtrl =
    TextEditingController(text: student?["address"] ?? "");
    final religionCtrl =
    TextEditingController(text: student?["religion"] ?? "");
    final passedOutCtrl =
    TextEditingController(text: student?["passed_out"] ?? "");
    final transferCtrl =
    TextEditingController(text: student?["transfer"] ?? "");
    final aadharNumberCtrl =
    TextEditingController(text: student?["aadhar_number"] ?? "");
    final fatherOccupationCtrl =
    TextEditingController(text: student?["father_occupation"] ?? "");
    final fatherMobileCtrl =
    TextEditingController(text: student?["father_mobile"] ?? "");
    final motherOccupationCtrl =
    TextEditingController(text: student?["mother_occupation"] ?? "");
    final motherMobileCtrl =
    TextEditingController(text: student?["mother_mobile"] ?? "");
    final guardianNameCtrl =
    TextEditingController(text: student?["guardian_name"] ?? "");
    final emergencyContactCtrl = TextEditingController(
        text: student?["emergency_contact_number"] ?? "");
    final cityCtrl = TextEditingController(text: student?["city"] ?? "");
    final stateCtrl = TextEditingController(text: student?["state"] ?? "");
    final pincodeCtrl =
    TextEditingController(text: student?["pincode"] ?? "");

    final academicYear =
    ValueNotifier<String>(student?["academic_year"] ?? "");
    final gender = ValueNotifier<String>(student?["gender"] ?? "Male");
    final classId = ValueNotifier<String>(student?["class_id"] ?? "");
    final sectionId = ValueNotifier<String>(student?["section_id"] ?? "");
    final bloodGroup = ValueNotifier<String>(student?["blood_group"] ?? "");
    final category = ValueNotifier<String>(student?["category"] ?? "");

    // ── Password visibility notifiers (separate for add & edit) ──
    final passwordVisible = ValueNotifier<bool>(false);
    final editPasswordVisible = ValueNotifier<bool>(false);

    // ── Edit mode: toggle to show/hide password change section ──
    final showChangePassword = ValueNotifier<bool>(false);

    List<String> selectedFeeHeadsList =
    student?["selected_fee_heads"] is List
        ? List<String>.from(student!["selected_fee_heads"])
        : (student?["selected_fee_heads"] as String?)
        ?.split(',')
        .where((e) => e.isNotEmpty)
        .toList() ??
        [];

    final studentPhoto = ValueNotifier<dynamic>(null);
    final aadharCard = ValueNotifier<dynamic>(null);
    final fatherPhoto = ValueNotifier<dynamic>(null);
    final motherPhoto = ValueNotifier<dynamic>(null);

    final existingStudentPhotoUrl =
        student?["student_photo_url"]?.toString() ?? "";
    final existingAadharCardUrl =
        student?["aadhar_card_url"]?.toString() ?? "";
    final existingFatherPhotoUrl =
        student?["father_photo_url"]?.toString() ?? "";
    final existingMotherPhotoUrl =
        student?["mother_photo_url"]?.toString() ?? "";

    showModalBottomSheet(
      backgroundColor: AppColor.pageBgColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (ctx, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEdit ? "Edit Student" : "Add Student",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                _sectionHeader("Basic Information"),
                const SizedBox(height: 12),
                _buildTextField(nameCtrl, "Full Name", Icons.person),
                const SizedBox(height: 12),
                _buildTextField(emailCtrl, "Email", Icons.email),
                const SizedBox(height: 12),

                // ══════════════════════════════════════════════════
                //  PASSWORD — Add mode: always visible
                //              Edit mode: collapsible change section
                // ══════════════════════════════════════════════════
                if (!isEdit) ...[
                  // ── Add mode password ──
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordVisible,
                    builder: (_, isVisible, __) => TextField(
                      controller: passwordCtrl,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock,
                            color: AppColor.lightBlueColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColor.lightBlueColor,
                          ),
                          onPressed: () =>
                          passwordVisible.value = !passwordVisible.value,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColor.lightBlueColor, width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  // ── Edit mode: Change Password toggle ──
                  ValueListenableBuilder<bool>(
                    valueListenable: showChangePassword,
                    builder: (_, show, __) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Toggle button
                        GestureDetector(
                          onTap: () {
                            showChangePassword.value = !show;
                            if (!show) passwordCtrl.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: show
                                  ? AppColor.lightBlueColor.withOpacity(0.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: show
                                    ? AppColor.lightBlueColor
                                    : Colors.grey.shade200,
                                width: show ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_reset_rounded,
                                  color: show
                                      ? AppColor.lightBlueColor
                                      : Colors.grey.shade500,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    show
                                        ? "Cancel password change"
                                        : "Change Password",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: show
                                          ? AppColor.lightBlueColor
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  show
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: show
                                      ? AppColor.lightBlueColor
                                      : Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ── New password field (shown when toggled) ──
                        if (show) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border:
                              Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 16, color: Colors.amber.shade700),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Enter new password for this student. Leave blank to keep existing password.",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.amber.shade800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: editPasswordVisible,
                            builder: (_, isVisible, __) => TextField(
                              controller: passwordCtrl,
                              obscureText: !isVisible,
                              decoration: InputDecoration(
                                hintText: "New Password",
                                prefixIcon: Icon(Icons.lock_outline_rounded,
                                    color: AppColor.lightBlueColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColor.lightBlueColor,
                                  ),
                                  onPressed: () =>
                                  editPasswordVisible.value =
                                  !editPasswordVisible.value,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: AppColor.lightBlueColor,
                                        width: 2)),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],

                // ── Gender ──
                ValueListenableBuilder<String>(
                  valueListenable: gender,
                  builder: (_, val, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Gender: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Male"),
                              selected: val == "Male",
                              onSelected: (_) =>
                                  setState(() => gender.value = "Male"),
                              selectedColor:
                              AppColor.maleColor.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Female"),
                              selected: val == "Female",
                              onSelected: (_) =>
                                  setState(() => gender.value = "Female"),
                              selectedColor:
                              AppColor.femaleColor.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Other"),
                              selected: val == "Other",
                              onSelected: (_) =>
                                  setState(() => gender.value = "Other"),
                              selectedColor: Colors.purple.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _sectionHeader("Academic Information"),
                const SizedBox(height: 12),

                // ── Academic Year Dropdown ──
                Consumer<AcademicViewModel>(
                  builder: (context, vm, _) {
                    if (vm.loading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }

                    final years = vm.years;

                    if (academicYear.value.isEmpty && vm.currentYear != null) {
                      Future.microtask(() => academicYear.value =
                          vm.currentYear!.yearName ?? "");
                    }

                    return ValueListenableBuilder<String>(
                      valueListenable: academicYear,
                      builder: (_, val, __) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: AppColor.lightBlueColor, size: 20),
                                const SizedBox(width: 12),
                                const Text("Academic Year"),
                              ],
                            ),
                            value: val.isEmpty ? null : val,
                            items: years
                                .map(
                                  (y) => DropdownMenuItem<String>(
                                value: y.yearName,
                                child: Row(
                                  children: [
                                    Text(y.yearName ?? ""),
                                    if (y.isCurrent == 1) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Current",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => academicYear.value = v ?? ""),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                    rollNoCtrl, "Roll No.", Icons.format_list_numbered),
                const SizedBox(height: 12),

                ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: classes,
                  builder: (_, list, __) => _buildDropdown(
                    label: "Class",
                    value: classId.value,
                    items: list
                        .map((e) => "${e["class_id"]}|${e["class_name"]}")
                        .toList(),
                    onChanged: (val) async {
                      if (val == null) return;
                      classId.value = val.split("|")[0];
                      sectionId.value = "";
                      final repo = AllSectionsRepository();
                      final response =
                      await repo.allSectionsApi(classId.value);
                      if (response["success"] == true) {
                        sections.value = List<Map<String, dynamic>>.from(
                            response["data"]);
                      } else {
                        sections.value = [];
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 12),

                ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: sections,
                  builder: (_, list, __) {
                    final classSelected = classId.value.isNotEmpty;
                    final noSections = classSelected && list.isEmpty;

                    if (noSections) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border:
                          Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 20, color: Colors.orange.shade400),
                            const SizedBox(width: 10),
                            Text(
                              "No Section available for this class",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildDropdown(
                      label: "Section",
                      value: sectionId.value,
                      items: list
                          .map((e) =>
                      "${e["section_id"]}|${e["section_name"]}")
                          .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() => sectionId.value = val.split("|")[0]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                _sectionHeader("Personal Information"),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => dobCtrl.text =
                      "${picked.day}/${picked.month}/${picked.year}");
                    }
                  },
                  child: AbsorbPointer(
                    child: _buildTextField(
                        dobCtrl, "Date of Birth (DD/MM/YYYY)", Icons.cake),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  mobileCtrl,
                  "Mobile Number",
                  Icons.phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                    religionCtrl, "Religion", Icons.temple_hindu),
                const SizedBox(height: 20),

                _sectionHeader("Parent Information"),
                const SizedBox(height: 12),
                _buildTextField(
                    fatherNameCtrl, "Father's Name", Icons.person),
                const SizedBox(height: 12),
                _buildTextField(
                    motherNameCtrl, "Mother's Name", Icons.person),
                const SizedBox(height: 20),

                _sectionHeader("Additional Information"),
                const SizedBox(height: 12),

                ValueListenableBuilder<String>(
                  valueListenable: bloodGroup,
                  builder: (_, val, __) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(Icons.bloodtype,
                                color: AppColor.lightBlueColor, size: 20),
                            const SizedBox(width: 12),
                            const Text("Blood Group"),
                          ],
                        ),
                        value: val.isEmpty ? null : val,
                        items: [
                          "A+",
                          "A-",
                          "B+",
                          "B-",
                          "AB+",
                          "AB-",
                          "O+",
                          "O-"
                        ]
                            .map((g) =>
                            DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => bloodGroup.value = v ?? ""),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ValueListenableBuilder<String>(
                  valueListenable: category,
                  builder: (_, val, __) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(Icons.category,
                                color: AppColor.lightBlueColor, size: 20),
                            const SizedBox(width: 12),
                            const Text("Category"),
                          ],
                        ),
                        value: val.isEmpty ? null : val,
                        items: [
                          "General",
                          "OBC",
                          "SC",
                          "ST",
                          "EWS",
                          "Other"
                        ]
                            .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => category.value = v ?? ""),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(aadharNumberCtrl, "Aadhar Number",
                    Icons.credit_card,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),

                _sectionHeader("Parent Extra Details"),
                const SizedBox(height: 12),
                _buildTextField(fatherOccupationCtrl,
                    "Father's Occupation", Icons.work),
                const SizedBox(height: 12),
                _buildTextField(
                    fatherMobileCtrl, "Father's Mobile", Icons.phone,
                    keyboardType: TextInputType.phone, maxLength: 10),
                const SizedBox(height: 12),
                _buildTextField(motherOccupationCtrl,
                    "Mother's Occupation", Icons.work),
                const SizedBox(height: 12),
                _buildTextField(
                    motherMobileCtrl, "Mother's Mobile", Icons.phone,
                    keyboardType: TextInputType.phone, maxLength: 10),
                const SizedBox(height: 12),
                _buildTextField(
                    guardianNameCtrl, "Guardian Name", Icons.person),
                const SizedBox(height: 12),
                _buildTextField(emergencyContactCtrl,
                    "Emergency Contact", Icons.emergency,
                    keyboardType: TextInputType.phone, maxLength: 10),
                const SizedBox(height: 20),

                _sectionHeader("Address Details"),
                const SizedBox(height: 12),
                _buildTextField(addressCtrl, "Address", Icons.home,
                    maxLines: 3),
                const SizedBox(height: 12),
                _buildTextField(cityCtrl, "City", Icons.location_city),
                const SizedBox(height: 12),
                _buildTextField(stateCtrl, "State", Icons.map),
                const SizedBox(height: 12),
                _buildTextField(pincodeCtrl, "Pincode", Icons.pin_drop,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),

                _sectionHeader("Upload Documents"),
                const SizedBox(height: 12),
                _buildImagePickerWithPreview(
                  label: "Student Photo",
                  icon: Icons.portrait,
                  imageNotifier: studentPhoto,
                  existingUrl: existingStudentPhotoUrl,
                  setState: setState,
                ),
                const SizedBox(height: 12),
                _buildImagePickerWithPreview(
                  label: "Aadhar Card",
                  icon: Icons.credit_card,
                  imageNotifier: aadharCard,
                  existingUrl: existingAadharCardUrl,
                  setState: setState,
                ),
                const SizedBox(height: 12),
                _buildImagePickerWithPreview(
                  label: "Father's Photo",
                  icon: Icons.person,
                  imageNotifier: fatherPhoto,
                  existingUrl: existingFatherPhotoUrl,
                  setState: setState,
                ),
                const SizedBox(height: 12),
                _buildImagePickerWithPreview(
                  label: "Mother's Photo",
                  icon: Icons.person,
                  imageNotifier: motherPhoto,
                  existingUrl: existingMotherPhotoUrl,
                  setState: setState,
                ),
                const SizedBox(height: 20),

                if (!isEdit) ...[
                  _sectionHeader("Fee Heads"),
                  const SizedBox(height: 12),
                  Consumer<FeesHeadManagementViewModel>(
                    builder: (context, vm, child) {
                      if (vm.loading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      final feeHeads =
                          vm.feesHeadManagementModel?.data?.feeHeads ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feeHeads.length,
                        itemBuilder: (context, index) {
                          final fee = feeHeads[index];
                          final feeIdStr = fee.feeHeadId.toString();
                          return CheckboxListTile(
                            title: Text(fee.headName ?? ""),
                            value:
                            selectedFeeHeadsList.contains(feeIdStr),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  if (!selectedFeeHeadsList
                                      .contains(feeIdStr)) {
                                    selectedFeeHeadsList.add(feeIdStr);
                                  }
                                } else {
                                  selectedFeeHeadsList.remove(feeIdStr);
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],

                const SizedBox(height: 30),

                AppButton(
                  title: isEdit ? "Update Student" : "Add Student",
                  onTap: () {
                    if (_validateForm(
                      nameCtrl,
                      emailCtrl,
                      passwordCtrl,
                      classId,
                      sectionId,
                      dobCtrl,
                      mobileCtrl,
                      fatherNameCtrl,
                      motherNameCtrl,
                      isEdit,
                      context,
                    )) {
                      if (isEdit) {
                        Provider.of<EditStudentViewModel>(context,
                            listen: false)
                            .editStudentApi(
                          context: context,
                          studentId: student!["id"].toString(),
                          name: nameCtrl.text.trim().isEmpty
                              ? student["name"] ?? ""
                              : nameCtrl.text.trim(),
                          email: emailCtrl.text.trim().isEmpty
                              ? student["email"] ?? ""
                              : emailCtrl.text.trim(),
                          admission_no: admissionCtrl.text.trim().isEmpty
                              ? student["admission"] ?? ""
                              : admissionCtrl.text.trim(),
                          gender: gender.value,
                          class_id: classId.value.isEmpty
                              ? (student["class_id"] ?? "")
                              : classId.value,
                          section_id: sectionId.value.isEmpty
                              ? (student["section_id"] ?? "")
                              : sectionId.value,
                          // ✅ Password: only send if admin entered a new one
                          password: passwordCtrl.text.trim(),
                          dob: dobCtrl.text.trim().isEmpty
                              ? student["dob"] ?? ""
                              : dobCtrl.text.trim(),
                          mobileNumber: mobileCtrl.text.trim().isEmpty
                              ? student["mobile_number"] ?? ""
                              : mobileCtrl.text.trim(),
                          fatherName: fatherNameCtrl.text.trim().isEmpty
                              ? student["father_name"] ?? ""
                              : fatherNameCtrl.text.trim(),
                          motherName: motherNameCtrl.text.trim().isEmpty
                              ? student["mother_name"] ?? ""
                              : motherNameCtrl.text.trim(),
                          address: addressCtrl.text.trim().isEmpty
                              ? student["address"] ?? ""
                              : addressCtrl.text.trim(),
                          religion: religionCtrl.text.trim().isEmpty
                              ? student["religion"] ?? ""
                              : religionCtrl.text.trim(),
                          academicYear: academicYear.value.isEmpty
                              ? student["academic_year"] ?? ""
                              : academicYear.value,
                          passedOut: passedOutCtrl.text.trim().isEmpty
                              ? student["passed_out"] ?? ""
                              : passedOutCtrl.text.trim(),
                          transfer: transferCtrl.text.trim().isEmpty
                              ? student["transfer"] ?? ""
                              : transferCtrl.text.trim(),
                          bloodGroup: bloodGroup.value.isEmpty
                              ? (student["blood_group"] ?? "")
                              : bloodGroup.value,
                          category: category.value.isEmpty
                              ? (student["category"] ?? "")
                              : category.value,
                          aadharNumber: aadharNumberCtrl.text.trim().isEmpty
                              ? student["aadhar_number"] ?? ""
                              : aadharNumberCtrl.text.trim(),
                          fatherOccupation:
                          fatherOccupationCtrl.text.trim().isEmpty
                              ? student["father_occupation"] ?? ""
                              : fatherOccupationCtrl.text.trim(),
                          fatherMobile:
                          fatherMobileCtrl.text.trim().isEmpty
                              ? student["father_mobile"] ?? ""
                              : fatherMobileCtrl.text.trim(),
                          motherOccupation:
                          motherOccupationCtrl.text.trim().isEmpty
                              ? student["mother_occupation"] ?? ""
                              : motherOccupationCtrl.text.trim(),
                          motherMobile:
                          motherMobileCtrl.text.trim().isEmpty
                              ? student["mother_mobile"] ?? ""
                              : motherMobileCtrl.text.trim(),
                          guardianName:
                          guardianNameCtrl.text.trim().isEmpty
                              ? student["guardian_name"] ?? ""
                              : guardianNameCtrl.text.trim(),
                          emergencyContactNumber:
                          emergencyContactCtrl.text.trim().isEmpty
                              ? student["emergency_contact_number"] ?? ""
                              : emergencyContactCtrl.text.trim(),
                          city: cityCtrl.text.trim().isEmpty
                              ? student["city"] ?? ""
                              : cityCtrl.text.trim(),
                          state: stateCtrl.text.trim().isEmpty
                              ? student["state"] ?? ""
                              : stateCtrl.text.trim(),
                          pincode: pincodeCtrl.text.trim().isEmpty
                              ? student["pincode"] ?? ""
                              : pincodeCtrl.text.trim(),
                          roll_no: rollNoCtrl.text.trim().isEmpty
                              ? student["roll_no"] ?? ""
                              : rollNoCtrl.text.trim(),
                          studentPhoto: studentPhoto.value,
                          aadharCard: aadharCard.value,
                          fatherPhoto: fatherPhoto.value,
                          motherPhoto: motherPhoto.value,
                        );
                      } else {
                        Provider.of<AddStudentViewModel>(context,
                            listen: false)
                            .addStudentApi(
                          name: nameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          password: passwordCtrl.text.trim(),
                          class_id: classId.value,
                          section_id: sectionId.value,
                          admission_no: admissionCtrl.text.trim(),
                          gender: gender.value,
                          academic_year: academicYear.value,
                          roll_no: rollNoCtrl.text.trim(),
                          dob: dobCtrl.text.trim(),
                          mobile_number: mobileCtrl.text.trim(),
                          father_name: fatherNameCtrl.text.trim(),
                          mother_name: motherNameCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          religion: religionCtrl.text.trim(),
                          selected_fee_heads:
                          selectedFeeHeadsList.join(','),
                          student_photo: studentPhoto.value,
                          aadharCard: aadharCard.value,
                          father_photo: fatherPhoto.value,
                          mother_photo: motherPhoto.value,
                          passed_out: passedOutCtrl.text.trim(),
                          transfer: transferCtrl.text.trim(),
                          blood_group: bloodGroup.value,
                          category: category.value,
                          aadhar_number: aadharNumberCtrl.text.trim(),
                          father_occupation:
                          fatherOccupationCtrl.text.trim(),
                          father_mobile: fatherMobileCtrl.text.trim(),
                          mother_occupation:
                          motherOccupationCtrl.text.trim(),
                          mother_mobile: motherMobileCtrl.text.trim(),
                          guardian_name: guardianNameCtrl.text.trim(),
                          emergency_contact_number:
                          emergencyContactCtrl.text.trim(),
                          city: cityCtrl.text.trim(),
                          state: stateCtrl.text.trim(),
                          pincode: pincodeCtrl.text.trim(),
                          context: context,
                        );
                      }

                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (context.mounted) {
                          Provider.of<AllStudentListVieModel>(context,
                              listen: false)
                              .allStudentListApi(context);
                        }
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  height: 52,
                  radius: 16,
                  gradient: AppColor.primaryGradient,
                  textColor: Colors.white,
                  icon: isEdit ? Icons.edit : Icons.add_rounded,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  IMAGE PICKER WITH EXISTING URL PREVIEW
  // ════════════════════════════════════════════════════════
  Widget _buildImagePickerWithPreview({
    required String label,
    required IconData icon,
    required ValueNotifier imageNotifier,
    required String existingUrl,
    required Function setState,
  }) {
    final hasExisting = existingUrl.isNotEmpty && existingUrl != "null";

    return ValueListenableBuilder(
      valueListenable: imageNotifier,
      builder: (context, value, child) {
        final File? newFile = value as File?;
        final bool showExisting = hasExisting && newFile == null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _pickImage(imageNotifier, setState),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (newFile != null || showExisting)
                        ? Colors.green.shade300
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: AppColor.lightBlueColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        newFile != null
                            ? "$label Selected ✓"
                            : showExisting
                            ? "$label (uploaded) • Tap to change"
                            : "Upload $label",
                        style: TextStyle(
                          color: (newFile != null || showExisting)
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: (newFile != null || showExisting)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      (newFile != null || showExisting)
                          ? Icons.check_circle
                          : Icons.upload_file,
                      color: (newFile != null || showExisting)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (newFile != null) ...[
              const SizedBox(height: 8),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(newFile,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () =>
                          setState(() => imageNotifier.value = null),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (showExisting) ...[
              const SizedBox(height: 8),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      existingUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) =>
                      progress == null
                          ? child
                          : Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2)),
                      ),
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                            child: Icon(Icons.broken_image_rounded,
                                color: Colors.grey)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("Current",
                          style:
                          TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────
  Widget _sectionHeader(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.lightBlueColor),
  );

  Widget _buildTextField(
      TextEditingController ctrl,
      String hint,
      IconData icon, {
        bool isPassword = false,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        int? maxLength,
      }) {
    return TextField(
      controller: ctrl,
      obscureText: isPassword,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: maxLength != null
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ]
          : null,
      maxLength: maxLength,
      buildCounter: maxLength != null
          ? (context,
          {required currentLength,
            required isFocused,
            maxLength}) =>
          Text(
            "$currentLength/$maxLength",
            style:
            TextStyle(fontSize: 11, color: Colors.grey.shade500),
          )
          : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: AppColor.lightBlueColor, width: 2)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(label),
          value: value.isEmpty ? null : value,
          items: items.map((String item) {
            final parts = item.split("|");
            return DropdownMenuItem<String>(
                value: parts[0], child: Text(parts[1]));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  bool _validateForm(
      TextEditingController nameCtrl,
      TextEditingController emailCtrl,
      TextEditingController passwordCtrl,
      ValueNotifier<String> classId,
      ValueNotifier<String> sectionId,
      TextEditingController dobCtrl,
      TextEditingController mobileCtrl,
      TextEditingController fatherNameCtrl,
      TextEditingController motherNameCtrl,
      bool isEdit,
      BuildContext context,
      ) {
    if (isEdit) return true;
    if (nameCtrl.text.trim().isEmpty) {
      Utils.show("Enter student name", context);
      return false;
    }
    if (emailCtrl.text.trim().isEmpty) {
      Utils.show("Enter email", context);
      return false;
    }
    if (passwordCtrl.text.trim().isEmpty) {
      Utils.show("Enter password", context);
      return false;
    }
    if (classId.value.isEmpty) {
      Utils.show("Select class", context);
      return false;
    }
    if (dobCtrl.text.trim().isEmpty) {
      Utils.show("Select DOB", context);
      return false;
    }
    if (mobileCtrl.text.trim().isEmpty) {
      Utils.show("Enter mobile number", context);
      return false;
    }
    if (mobileCtrl.text.trim().length < 10) {
      Utils.show("Enter valid 10-digit mobile number", context);
      return false;
    }
    if (fatherNameCtrl.text.trim().isEmpty) {
      Utils.show("Enter father name", context);
      return false;
    }
    if (motherNameCtrl.text.trim().isEmpty) {
      Utils.show("Enter mother name", context);
      return false;
    }
    return true;
  }
}

// ════════════════════════════════════════════════════════
//  FULL-SCREEN IMAGE VIEWER
// ════════════════════════════════════════════════════════
class _ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final String title;

  const _ImageViewerScreen({
    required this.imageUrl,
    required this.title,
  });

  @override
  State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<_ImageViewerScreen> {
  final TransformationController _transformController =
  TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () =>
            _transformController.value = Matrix4.identity(),
            icon: const Icon(Icons.fit_screen_rounded, color: Colors.white),
            tooltip: 'Reset Zoom',
          ),
          IconButton(
            onPressed: () async {
              await launchUrl(Uri.parse(widget.imageUrl),
                  mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformController,
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(
                  child:
                  CircularProgressIndicator(color: Colors.white));
            },
            errorBuilder: (_, __, ___) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_rounded,
                    size: 60, color: Colors.white54),
                SizedBox(height: 12),
                Text('Could not load image',
                    style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}