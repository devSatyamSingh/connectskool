// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/admin_management/school_accountant_datail_screen.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/app_button.dart';
// import 'package:school_pro/res/const_text.dart';
// import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/all_scetions_view_model.dart';
// import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
// import '../model/school_model/all_accountant_list_model.dart';
// import '../view_model/school_view_model/add_accountant_view_model.dart';
// import '../view_model/school_view_model/delete_accountant_view_model.dart';
// import '../view_model/school_view_model/edit_accountant_view_model.dart';
// import 'add_accountant_screen.dart';
//
// class AllAccountantListScreen extends StatefulWidget {
//   const AllAccountantListScreen({super.key});
//
//   @override
//   State<AllAccountantListScreen> createState() =>
//       _AllAccountantListScreenState();
// }
//
// class _AllAccountantListScreenState extends State<AllAccountantListScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animCtrl;
//   String? selectedClassId;
//   String? selectedSectionId;
//   File? accountantPhoto;
//   File? aadharCard;
//   Future<void> _onRefresh() async {
//     _animCtrl.reset();
//     await Provider.of<AllAccountantListVieModel>(context, listen: false)
//         .allAccountantListApi(context);
//     _animCtrl.forward();
//   }
//   Future<void> pickImage(
//       ImageSource source, bool isAccountantPhoto, StateSetter setSheetState) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: source, imageQuality: 80);
//     if (picked != null) {
//       setSheetState(() {
//         if (isAccountantPhoto) {
//           accountantPhoto = File(picked.path);
//         } else {
//           aadharCard = File(picked.path);
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AllAccountantListVieModel>(context, listen: false)
//           .allAccountantListApi(context);
//       Provider.of<AllClassesViewModel>(context, listen: false)
//           .allClassesApi(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Pull to Refresh ──────────────────────────
//
//   // ── Open Add Sheet ───────────────────────────
//   void _openAddAccountantSheet() {
//     setState(() {
//       selectedClassId = null;
//       selectedSectionId = null;
//       accountantPhoto = null;
//       aadharCard = null;
//     });
//     _openAccountantSheet(existing: null);
//   }
//
//   // ── Open Edit Sheet ──────────────────────────
//   void _openEditAccountantSheet(AccountantData a) {
//     setState(() {
//       selectedClassId = null;
//       selectedSectionId = null;
//       accountantPhoto = null;
//       aadharCard = null;
//     });
//     _openAccountantSheet(existing: a);
//   }
// // ── Image Picker Field (network image support for edit mode) ──
//   Widget _imagePickerField({
//     required String label,
//     required IconData icon,
//     required File? file,
//     required Function(ImageSource) onPickImage,
//     required StateSetter setSheetState,
//     String? existingImageUrl, // <-- ADD THIS PARAM
//   }) {
//     final bool hasLocalFile = file != null;
//     final bool hasNetworkImage =
//         existingImageUrl != null && existingImageUrl.isNotEmpty;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 15, color: AppColor.sub),
//             const SizedBox(width: 6),
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.sub)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: () {
//             showModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.transparent,
//               builder: (_) => SafeArea(
//                 child: Container(
//                   margin: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColor.bg,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height: 8),
//                       Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: AppColor.border,
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ListTile(
//                         leading: const Icon(Icons.camera_alt_outlined),
//                         title: const Text("Take Photo"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           setSheetState(() {});
//                           onPickImage(ImageSource.camera);
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.photo_library_outlined),
//                         title: const Text("Choose from Gallery"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           setSheetState(() {});
//                           onPickImage(ImageSource.gallery);
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             height: 90,
//             decoration: BoxDecoration(
//               color: AppColor.border.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(
//                 color: (hasLocalFile || hasNetworkImage)
//                     ? AppColor.success.withOpacity(0.5)
//                     : AppColor.border,
//                 width: 1.5,
//               ),
//             ),
//             child: hasLocalFile
//             // 1️⃣ Newly picked local file — highest priority
//                 ? ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.file(file, fit: BoxFit.cover),
//                   Positioned(
//                     top: 6,
//                     right: 6,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: AppColor.success,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.check_rounded,
//                           color: Colors.white, size: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : hasNetworkImage
//             // 2️⃣ Existing server image (edit mode)
//                 ? ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     existingImageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder:
//                         (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: AppColor.primary,
//                           value: loadingProgress.expectedTotalBytes !=
//                               null
//                               ? loadingProgress
//                               .cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (_, __, ___) => const Center(
//                       child: Icon(Icons.broken_image_outlined,
//                           size: 32, color: AppColor.sub),
//                     ),
//                   ),
//                   // Tap-to-change overlay
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding:
//                       const EdgeInsets.symmetric(vertical: 5),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.45),
//                         borderRadius: const BorderRadius.vertical(
//                             bottom: Radius.circular(13)),
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.edit_outlined,
//                               color: Colors.white, size: 12),
//                           SizedBox(width: 4),
//                           Text("Tap to change",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 6,
//                     right: 6,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: AppColor.success,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.check_rounded,
//                           color: Colors.white, size: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//             // 3️⃣ No image at all
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.add_photo_alternate_outlined,
//                     size: 28, color: AppColor.sub.withOpacity(0.6)),
//                 const SizedBox(height: 6),
//                 Text("Tap to upload",
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: AppColor.sub.withOpacity(0.7))),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   void _openAccountantSheet({AccountantData? existing}) {
//     final isEdit = existing != null;
//
//     // ── Auto-fill all fields from existing data ──
//     final nameCtrl = TextEditingController(text: existing?.name ?? '');
//     final emailCtrl = TextEditingController(text: existing?.userEmail ?? '');
//     final passwordCtrl = TextEditingController();
//     final qualificationCtrl =
//     TextEditingController(text: existing?.qualification ?? '');
//
//     // experienceYears — convert dynamic to string safely
//     final experienceCtrl = TextEditingController(
//       text: existing?.experienceYears != null
//           ? existing!.experienceYears.toString()
//           : '',
//     );
//
//     // joiningDate — format ISO date to YYYY-MM-DD if present
//     String _prefillDate(dynamic raw) {
//       if (raw == null) return '';
//       try {
//         final d = DateTime.parse(raw.toString());
//         return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
//       } catch (_) {
//         return '';
//       }
//     }
//
//     final joiningDateCtrl =
//     TextEditingController(text: _prefillDate(existing?.joiningDate));
//     final mobileCtrl =
//     TextEditingController(text: existing?.mobileNumber ?? '');
//     final addressCtrl = TextEditingController(text: existing?.address ?? '');
//     final fatherNameCtrl =
//     TextEditingController(text: existing?.fatherName ?? '');
//     final motherNameCtrl =
//     TextEditingController(text: existing?.motherName ?? '');
//
//     bool obscurePassword = true;
//     bool isLoading = false;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (sheetCtx) {
//         return SafeArea(
//           child: StatefulBuilder(
//             builder: (ctx, setSheetState) {
//               final bottom = MediaQuery.of(ctx).viewInsets.bottom;
//
//               Future<void> handleSubmit() async {
//                 // ── ADD MODE VALIDATION ──
//                 if (!isEdit) {
//                   if (nameCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter full name");
//                     return;
//                   }
//                   final email = emailCtrl.text.trim();
//                   if (email.isEmpty) {
//                     _snack(ctx, "Please enter email");
//                     return;
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                       .hasMatch(email)) {
//                     _snack(ctx, "Please enter a valid email");
//                     return;
//                   }
//                   if (passwordCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter password");
//                     return;
//                   }
//                   if (qualificationCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter qualification");
//                     return;
//                   }
//                   if (experienceCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter experience years");
//                     return;
//                   }
//                   if (joiningDateCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter joining date");
//                     return;
//                   }
//                   if (mobileCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter mobile number");
//                     return;
//                   }
//                   if (addressCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter address");
//                     return;
//                   }
//                   if (fatherNameCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter father's name");
//                     return;
//                   }
//                   if (motherNameCtrl.text.trim().isEmpty) {
//                     _snack(ctx, "Please enter mother's name");
//                     return;
//                   }
//                 }
//
//                 setSheetState(() => isLoading = true);
//                 HapticFeedback.mediumImpact();
//
//                 if (isEdit) {
//                   await Provider.of<EditAccountantViewModel>(
//                     context,
//                     listen: false,
//                   ).editAccountantApi(
//                     context: context,
//                     accountantId: existing!.accountantId.toString(),
//                     name: nameCtrl.text.trim().isEmpty
//                         ? (existing.name ?? '')
//                         : nameCtrl.text.trim(),
//                     email: emailCtrl.text.trim().isEmpty
//                         ? (existing.userEmail ?? '')
//                         : emailCtrl.text.trim(),
//                     qualification: qualificationCtrl.text.trim().isEmpty
//                         ? (existing.qualification ?? '')
//                         : qualificationCtrl.text.trim(),
//                     password: passwordCtrl.text.trim(),
//                     experienceYears: experienceCtrl.text.trim().isEmpty
//                         ? (existing.experienceYears?.toString() ?? '') : experienceCtrl.text.trim(),
//                     mobileNumber: mobileCtrl.text.trim().isEmpty
//                         ? (existing.mobileNumber ?? '') : mobileCtrl.text.trim(),
//                     address: addressCtrl.text.trim().isEmpty
//                         ? (existing.address ?? '') : addressCtrl.text.trim(),
//                     fatherName: fatherNameCtrl.text.trim().isEmpty
//                         ? (existing.fatherName ?? '') : fatherNameCtrl.text.trim(),
//                     motherName: motherNameCtrl.text.trim().isEmpty
//                         ? (existing.motherName ?? '') : motherNameCtrl.text.trim(),
//                     accountantPhoto: accountantPhoto,  // ✅ state variable
//                     aadharCard: aadharCard,
//                     // Pass remaining fields to your edit API as needed:
//                     // experienceYears: experienceCtrl.text.trim(),
//                     // mobileNumber: mobileCtrl.text.trim(),
//                     // address: addressCtrl.text.trim(),
//                     // fatherName: fatherNameCtrl.text.trim(),
//                     // motherName: motherNameCtrl.text.trim(),
//                     // joiningDate: joiningDateCtrl.text.trim(),
//                   );
//                 } else {
//                   await Provider.of<AddAccountantViewModel>(
//                     context,
//                     listen: false,
//                   ).addAccountantApi(
//                     context: context,
//                     name: nameCtrl.text.trim(),
//                     user_email: emailCtrl.text.trim(),
//                     password: passwordCtrl.text.trim(),
//                     qualification: qualificationCtrl.text.trim(),
//                     experience_years: experienceCtrl.text.trim(),
//                     mobile_number: mobileCtrl.text.trim(),
//                     address: addressCtrl.text.trim(),
//                     father_name: fatherNameCtrl.text.trim(),
//                     mother_name: motherNameCtrl.text.trim(),
//                     accountant_photo: accountantPhoto,
//                     aadharCard: aadharCard,
//                     dob: "",
//                     joining_date: "",
//                     employment_type: ""
//                   );
//                 }
//
//                 Provider.of<AllAccountantListVieModel>(
//                   context,
//                   listen: false,
//                 ).allAccountantListApi(context);
//
//                 setSheetState(() => isLoading = false);
//                 Navigator.pop(ctx);
//               }
//
//               return Container(
//                 decoration: const BoxDecoration(
//                   color: AppColor.bg,
//                   borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(32)),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 12),
//
//                     // Drag handle
//                     Container(
//                       width: 44,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: AppColor.border,
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//
//                     // ── Header ──
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: isEdit
//                                     ? [AppColor.editGradA, AppColor.editGradB]
//                                     : [AppColor.gradA, AppColor.gradB],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: (isEdit
//                                       ? AppColor.editGradA
//                                       : AppColor.primary)
//                                       .withOpacity(0.35),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               isEdit
//                                   ? Icons.edit_note_rounded
//                                   : Icons.person_add_alt_1_rounded,
//                               color: Colors.white,
//                               size: 22,
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 isEdit ? "Edit Accountant" : "Add Accountant",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: AppColor.text,
//                                   letterSpacing: -0.3,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 isEdit
//                                     ? "Update the details below"
//                                     : "Fill in the details below",
//                                 style: const TextStyle(
//                                     fontSize: 12.5, color: AppColor.sub),
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: () => Navigator.pop(ctx),
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: AppColor.border.withOpacity(0.6),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.close_rounded,
//                                   size: 18, color: AppColor.sub),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Edit info banner
//                     if (isEdit)
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 10),
//                           decoration: BoxDecoration(
//                             color: AppColor.success.withOpacity(0.09),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 color: AppColor.success.withOpacity(0.25)),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.info_outline_rounded,
//                                   size: 16,
//                                   color: AppColor.success.withOpacity(0.8)),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: RichText(
//                                   text: TextSpan(
//                                     style: const TextStyle(
//                                         fontSize: 12.5, color: AppColor.sub),
//                                     children: [
//                                       const TextSpan(text: "Editing: "),
//                                       TextSpan(
//                                         text: existing?.name ?? '',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           color: AppColor.success,
//                                         ),
//                                       ),
//                                       const TextSpan(
//                                           text: "  •  Password optional"),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                     // ── Scrollable Fields ──
//                     Flexible(
//                       child: SingleChildScrollView(
//                         padding:
//                         EdgeInsets.fromLTRB(20, 4, 20, bottom + 24),
//                         child: Column(
//                           children: [
//                             // Section 1 — Account Info
//                             _sectionCard(
//                               index: 1,
//                               icon: Icons.manage_accounts_rounded,
//                               title: "Account Info",
//                               color: AppColor.lightBlueColor,
//                               children: [
//                                 _sheetField(
//                                     nameCtrl,
//                                     "Full Name",
//                                     "e.g. Rahul Sharma",
//                                     Icons.person_outline_rounded),
//                                 const SizedBox(height: 14),
//                                 _sheetField(
//                                     emailCtrl,
//                                     "Email Address",
//                                     "e.g. rahul@school.com",
//                                     Icons.email_outlined,
//                                     keyboard: TextInputType.emailAddress),
//                                 const SizedBox(height: 14),
//                                 _passwordField(
//                                   ctrl: passwordCtrl,
//                                   obscure: obscurePassword,
//                                   isEdit: isEdit,
//                                   onToggle: () => setSheetState(() =>
//                                   obscurePassword = !obscurePassword),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Section 2 — Professional Details
//                             _sectionCard(
//                               index: 2,
//                               icon: Icons.work_outline_rounded,
//                               title: "Professional Details",
//                               color: AppColor.success,
//                               children: [
//                                 _sheetField(
//                                     qualificationCtrl,
//                                     "Qualification",
//                                     "e.g. B.Com, CA",
//                                     Icons.school_outlined),
//                                 const SizedBox(height: 14),
//                                 _sheetField(
//                                   experienceCtrl,
//                                   "Experience (Years)",
//                                   "e.g. 5",
//                                   Icons.timeline_outlined,
//                                   keyboard: TextInputType.number,
//                                   formatters: [FilteringTextInputFormatter.digitsOnly],
//                                 ),
//                                 const SizedBox(height: 14),
//                                 _dateField(joiningDateCtrl, ctx),
//                                 const SizedBox(height: 14),
//
//                                 // ✅ DOB field
//                                 _dobField(dobCtrl, ctx),
//                                 const SizedBox(height: 14),
//
//                                 // ✅ Employment Type chips
//                                 _buildLabel("Employment Type", Icons.badge_outlined),
//                                 const SizedBox(height: 8),
//                                 StatefulBuilder(
//                                   builder: (_, setLocal) => Row(
//                                     children: [
//                                       Expanded(
//                                         child: _empTypeChip(
//                                           label: "Full Time",
//                                           value: "full_time",
//                                           selected: selectedEmploymentType,
//                                           icon: Icons.work_rounded,
//                                           onTap: () => setSheetState(() =>
//                                           selectedEmploymentType = "full_time"),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: _empTypeChip(
//                                           label: "Part Time",
//                                           value: "part_time",
//                                           selected: selectedEmploymentType,
//                                           icon: Icons.work_outline_rounded,
//                                           onTap: () => setSheetState(() =>
//                                           selectedEmploymentType = "part_time"),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             // _sectionCard(
//                             //   index: 2,
//                             //   icon: Icons.work_outline_rounded,
//                             //   title: "Professional Details",
//                             //   color: AppColor.success,
//                             //   children: [
//                             //     _sheetField(
//                             //         qualificationCtrl,
//                             //         "Qualification",
//                             //         "e.g. B.Com, CA",
//                             //         Icons.school_outlined),
//                             //     const SizedBox(height: 14),
//                             //     _sheetField(
//                             //       experienceCtrl,
//                             //       "Experience (Years)",
//                             //       "e.g. 5",
//                             //       Icons.timeline_outlined,
//                             //       keyboard: TextInputType.number,
//                             //       formatters: [
//                             //         FilteringTextInputFormatter.digitsOnly
//                             //       ],
//                             //     ),
//                             //     const SizedBox(height: 14),
//                             //     _dateField(joiningDateCtrl, ctx),
//                             //   ],
//                             // ),
//                             const SizedBox(height: 16),
//
//                             // Section 3 — Personal Info
//                             _sectionCard(
//                               index: 3,
//                               icon: Icons.badge_outlined,
//                               title: "Personal Info",
//                               color: const Color(0xFFF77F00),
//                               children: [
//                                 _sheetField(
//                                   mobileCtrl,
//                                   "Mobile Number",
//                                   "e.g. 9876543210",
//                                   Icons.phone_outlined,
//                                   keyboard: TextInputType.phone,
//                                   formatters: [
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(10),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 14),
//                                 _sheetField(
//                                     addressCtrl,
//                                     "Address",
//                                     "Full residential address",
//                                     Icons.location_on_outlined,
//                                     maxLines: 2),
//                                 const SizedBox(height: 14),
//                                 _sheetField(
//                                     fatherNameCtrl,
//                                     "Father's Name",
//                                     "e.g. Suresh Sharma",
//                                     Icons.family_restroom_outlined),
//                                 const SizedBox(height: 14),
//                                 _sheetField(
//                                     motherNameCtrl,
//                                     "Mother's Name",
//                                     "e.g. Sunita Sharma",
//                                     Icons.woman_outlined),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Section 4 — Documents & Photo
//                             _sectionCard(
//                               index: 4,
//                               icon: Icons.photo_library_outlined,
//                               title: "Documents & Photo",
//                               color: const Color(0xFF7B2FBE),
//                               children: [
//                                 // Section 4 — Documents & Photo ke andar:
//
//                                 _imagePickerField(
//                                   label: "Accountant Photo",
//                                   icon: Icons.person_pin_outlined,
//                                   file: accountantPhoto,
//                                   onPickImage: (source) => pickImage(source, true, setSheetState),
//                                   setSheetState: setSheetState,
//                                   existingImageUrl: existing?.accountantPhotoUrl, // ✅ YEH ADD KARO
//                                 ),
//                                 const SizedBox(height: 14),
//                                 _imagePickerField(
//                                   label: "Aadhar Card",
//                                   icon: Icons.credit_card_outlined,
//                                   file: aadharCard,
//                                   onPickImage: (source) => pickImage(source, false, setSheetState),
//                                   setSheetState: setSheetState,
//                                   existingImageUrl: existing?.aadharCardUrl, // ✅ YEH ADD KARO
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 28),
//
//                             // ── Buttons ──
//                             if (isEdit)
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     flex: 2,
//                                     child: GestureDetector(
//                                       onTap: () => Navigator.pop(ctx),
//                                       child: Container(
//                                         height: 54,
//                                         decoration: BoxDecoration(
//                                           color: AppColor.border
//                                               .withOpacity(0.4),
//                                           borderRadius:
//                                           BorderRadius.circular(16),
//                                           border: Border.all(
//                                               color: AppColor.border,
//                                               width: 1.5),
//                                         ),
//                                         child: const Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                           children: [
//                                             Icon(Icons.close_rounded,
//                                                 size: 18,
//                                                 color: AppColor.sub),
//                                             SizedBox(width: 6),
//                                             Text("Cancel",
//                                                 style: TextStyle(
//                                                     color: AppColor.sub,
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                     FontWeight.w600)),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     flex: 3,
//                                     child: AppButton(
//                                       title: isLoading
//                                           ? "Saving..."
//                                           : "Save Changes",
//                                       onTap: handleSubmit,
//                                       height: 54,
//                                       radius: 16,
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           AppColor.editGradA,
//                                           AppColor.editGradB
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       textColor: Colors.white,
//                                       icon: isLoading
//                                           ? null
//                                           : Icons.check_circle_outline_rounded,
//                                       loading: isLoading,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             else
//                               AppButton(
//                                 title: isLoading
//                                     ? "Adding Accountant..."
//                                     : "Add Accountant",
//                                 onTap: handleSubmit,
//                                 height: 54,
//                                 radius: 16,
//                                 gradient: AppColor.primaryGradient,
//                                 textColor: Colors.white,
//                                 icon: isLoading
//                                     ? null
//                                     : Icons.person_add_alt_1_rounded,
//                                 loading: isLoading,
//                               ),
//
//                             const SizedBox(height: 8),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//   Widget _dobField(TextEditingController ctrl, BuildContext ctx) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Date of Birth",
//             style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.sub,
//                 letterSpacing: 0.3)),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: ctrl,
//           readOnly: true,
//           style: const TextStyle(
//               fontSize: 14,
//               color: AppColor.text,
//               fontWeight: FontWeight.w500),
//           onTap: () async {
//             DateTime initial = DateTime(2000);
//             try {
//               if (ctrl.text.isNotEmpty) initial = DateTime.parse(ctrl.text);
//             } catch (_) {}
//             final picked = await showDatePicker(
//               context: ctx,
//               initialDate: initial,
//               firstDate: DateTime(1950),
//               lastDate: DateTime.now(),
//               builder: (c, child) => Theme(
//                 data: Theme.of(c).copyWith(
//                   colorScheme: const ColorScheme.light(
//                     primary: AppColor.primary,
//                     onPrimary: Colors.white,
//                     surface: Colors.white,
//                     onSurface: AppColor.text,
//                   ),
//                 ),
//                 child: child!,
//               ),
//             );
//             if (picked != null) {
//               ctrl.text =
//               "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//             }
//           },
//           decoration: InputDecoration(
//             hintText: "Select date of birth",
//             hintStyle: TextStyle(
//                 fontSize: 13.5, color: AppColor.sub.withOpacity(0.6)),
//             prefixIcon: Icon(Icons.cake_outlined,
//                 size: 18, color: AppColor.primary.withOpacity(0.7)),
//             suffixIcon: const Icon(Icons.arrow_drop_down_rounded,
//                 color: AppColor.sub),
//             filled: true,
//             fillColor: AppColor.primaryLight.withOpacity(0.5),
//             contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.border, width: 1.2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.primary, width: 1.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _empTypeChip({
//     required String label,
//     required String value,
//     required String selected,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     final isSelected = selected == value;
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
//         decoration: BoxDecoration(
//           gradient: isSelected ? AppColor.primaryGradient : null,
//           color: isSelected ? null : AppColor.primaryLight.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.transparent : AppColor.border,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 size: 16,
//                 color: isSelected ? Colors.white : AppColor.sub),
//             const SizedBox(width: 6),
//             Text(label,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: isSelected ? Colors.white : AppColor.sub,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String label, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: AppColor.sub),
//         const SizedBox(width: 6),
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.sub,
//                 letterSpacing: 0.3)),
//       ],
//     );
//   }
//   // ════════════════════════════════════════════════════════
//   //  FIELD WIDGETS
//   // ════════════════════════════════════════════════════════
//   Widget _sheetField(
//       TextEditingController ctrl,
//       String label,
//       String hint,
//       IconData icon, {
//         TextInputType keyboard = TextInputType.text,
//         List<TextInputFormatter>? formatters,
//         int maxLines = 1,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.sub,
//                 letterSpacing: 0.3)),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: ctrl,
//           keyboardType: keyboard,
//           inputFormatters: formatters,
//           maxLines: maxLines,
//           style: const TextStyle(
//               fontSize: 14,
//               color: AppColor.text,
//               fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(
//                 fontSize: 13.5, color: AppColor.sub.withOpacity(0.6)),
//             prefixIcon: Icon(icon,
//                 size: 18, color: AppColor.primary.withOpacity(0.7)),
//             filled: true,
//             fillColor: AppColor.primaryLight.withOpacity(0.5),
//             contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.border, width: 1.2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.primary, width: 1.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _passwordField({
//     required TextEditingController ctrl,
//     required bool obscure,
//     required bool isEdit,
//     required VoidCallback onToggle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text("Password",
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.sub,
//                     letterSpacing: 0.3)),
//             if (isEdit) ...[
//               const SizedBox(width: 6),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: AppColor.success.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: const Text("Optional",
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: AppColor.success)),
//               ),
//             ],
//           ],
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: ctrl,
//           obscureText: obscure,
//           style: const TextStyle(
//               fontSize: 14,
//               color: AppColor.text,
//               fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: isEdit
//                 ? "Leave blank to keep current password"
//                 : "Create a strong password",
//             hintStyle: TextStyle(
//                 fontSize: 13, color: AppColor.sub.withOpacity(0.6)),
//             prefixIcon: Icon(Icons.lock_outline_rounded,
//                 size: 18, color: AppColor.primary.withOpacity(0.7)),
//             suffixIcon: IconButton(
//               onPressed: onToggle,
//               icon: Icon(
//                 obscure
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 size: 18,
//                 color: AppColor.sub,
//               ),
//             ),
//             filled: true,
//             fillColor: AppColor.primaryLight.withOpacity(0.5),
//             contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.border, width: 1.2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.primary, width: 1.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _dateField(TextEditingController ctrl, BuildContext ctx) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Joining Date",
//             style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.sub,
//                 letterSpacing: 0.3)),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: ctrl,
//           readOnly: true,
//           style: const TextStyle(
//               fontSize: 14,
//               color: AppColor.text,
//               fontWeight: FontWeight.w500),
//           onTap: () async {
//             DateTime initial = DateTime.now();
//             try {
//               if (ctrl.text.isNotEmpty) initial = DateTime.parse(ctrl.text);
//             } catch (_) {}
//             final picked = await showDatePicker(
//               context: ctx,
//               initialDate: initial,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//               builder: (c, child) => Theme(
//                 data: Theme.of(c).copyWith(
//                   colorScheme: const ColorScheme.light(
//                     primary: AppColor.primary,
//                     onPrimary: Colors.white,
//                     surface: Colors.white,
//                     onSurface: AppColor.text,
//                   ),
//                 ),
//                 child: child!,
//               ),
//             );
//             if (picked != null) {
//               ctrl.text =
//               "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//             }
//           },
//           decoration: InputDecoration(
//             hintText: "Select joining date",
//             hintStyle: TextStyle(
//                 fontSize: 13.5, color: AppColor.sub.withOpacity(0.6)),
//             prefixIcon: Icon(Icons.calendar_today_outlined,
//                 size: 18, color: AppColor.primary.withOpacity(0.7)),
//             suffixIcon: const Icon(Icons.arrow_drop_down_rounded,
//                 color: AppColor.sub),
//             filled: true,
//             fillColor: AppColor.primaryLight.withOpacity(0.5),
//             contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.border, width: 1.2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.primary, width: 1.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _sectionCard({
//     required int index,
//     required IconData icon,
//     required String title,
//     required Color color,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColor.card,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 16,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.06),
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(20)),
//               border: Border(
//                   bottom: BorderSide(color: color.withOpacity(0.12))),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 28,
//                   height: 28,
//                   decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Center(
//                     child: Text("$index",
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Icon(icon, size: 18, color: color),
//                 const SizedBox(width: 8),
//                 Text(title,
//                     style: TextStyle(
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w600,
//                         color: color,
//                         letterSpacing: 0.2)),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: children),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _styledDropdown<T>({
//     required T? value,
//     required String hint,
//     required String label,
//     required IconData icon,
//     required List<DropdownMenuItem<T>> items,
//     required ValueChanged<T?> onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.sub,
//                 letterSpacing: 0.3)),
//         const SizedBox(height: 6),
//         DropdownButtonFormField<T>(
//           value: value,
//           items: items,
//           onChanged: onChanged,
//           hint: Text(hint,
//               style: TextStyle(
//                   fontSize: 13.5,
//                   color: AppColor.sub.withOpacity(0.6))),
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               color: AppColor.sub, size: 20),
//           style: const TextStyle(
//               fontSize: 14,
//               color: AppColor.text,
//               fontWeight: FontWeight.w500),
//           dropdownColor: Colors.white,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon,
//                 size: 18, color: AppColor.primary.withOpacity(0.7)),
//             filled: true,
//             fillColor: AppColor.primaryLight.withOpacity(0.5),
//             contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.border, width: 1.2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//               const BorderSide(color: AppColor.primary, width: 1.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _snack(BuildContext ctx, String msg) {
//     ScaffoldMessenger.of(ctx).showSnackBar(
//       SnackBar(
//         content: Row(children: [
//           const Icon(Icons.info_outline_rounded,
//               color: Colors.white, size: 18),
//           const SizedBox(width: 8),
//           Expanded(
//               child: Text(msg,
//                   style:
//                   const TextStyle(fontWeight: FontWeight.w500))),
//         ]),
//         backgroundColor: AppColor.error,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
//
//   // ════════════════════════════════════════════════════════
//   //  MAIN SCREEN
//   // ════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<AllAccountantListVieModel>(context);
//     final accountants =
//         viewModel.allAccountantListModel?.data ?? <AccountantData>[];
//
//     return Scaffold(
//       backgroundColor: AppColor.screenBg,
//       floatingActionButton:
//       // AllAccountantListScreen ke FAB mein:
//       FloatingActionButton.extended(
//         backgroundColor: AppColor.lightBlueColor,
//         icon: const Icon(Icons.add_rounded, color: Colors.white),
//         label: const Text(
//           'Add Accountant',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddAccountantScreen()),
//         ),
//         // ...
//       ),
//       // FloatingActionButton.extended(
//       //   backgroundColor: AppColor.lightBlueColor,
//       //   onPressed: _openAddAccountantSheet,
//       //   icon: const Icon(Icons.add_rounded, color: Colors.white),
//       //   label: const Text(
//       //     'Add Accountant',
//       //     style: TextStyle(
//       //         color: Colors.white, fontWeight: FontWeight.w600),
//       //   ),
//       // ),
//       body: Column(
//         children: [
//           // ── Header ──
//           Container(
//             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColor.lightBlueColor,
//                   AppColor.lightBlueColor.withOpacity(0.85),
//                 ],
//               ),
//               borderRadius: const BorderRadius.vertical(
//                   bottom: Radius.circular(28)),
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: AppColor.white.withOpacity(0.25),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white, size: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: AppText.customText(
//                     "All Accountants",
//                     size: 22,
//                     weight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 AppText.customText(
//                   "${accountants.length}",
//                   size: 16,
//                   weight: FontWeight.w600,
//                   color: Colors.white70,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // ── List with Pull to Refresh ──
//           Expanded(
//             child: viewModel.loading
//                 ? _shimmerList()
//                 : accountants.isEmpty
//                 ? RefreshIndicator(
//               color: AppColor.lightBlueColor,
//               onRefresh: _onRefresh,
//               child: ListView(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.5,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.green.withOpacity(0.08),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.account_balance_wallet_outlined,
//                             size: 50,
//                             color: Colors.green.shade400,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           "No Accountants Found",
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.sub,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Pull down to refresh",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade500,
//                           ),
//                         ),
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
//                 itemCount: accountants.length,
//                 itemBuilder: (context, index) =>
//                     _animatedCard(index, accountants[index]),
//               ),
//             ),
//           ),
//
//           SizedBox(height: screenHeight * 0.03),
//         ],
//       ),
//     );
//   }
//
//   Widget _shimmerList() {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
//       itemCount: 6,
//       itemBuilder: (_, __) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           height: 110,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(22),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _animatedCard(int index, AccountantData a) {
//     return AnimatedBuilder(
//       animation: _animCtrl,
//       builder: (context, child) {
//         final delay = index * 0.08;
//         final value = Curves.easeOut.transform(
//           (_animCtrl.value - delay).clamp(0.0, 1.0) / (1 - delay),
//         );
//         return Transform.translate(
//           offset: Offset(0, 25 * (1 - value)),
//           child: Opacity(opacity: value, child: child),
//         );
//       },
//       child: _accountantCard(a),
//     );
//   }
//
//   Widget _accountantCard(AccountantData a) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SchoolAccountantDetailScreen(
//               accountantId: a.accountantId ?? 0,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: AppColor.white,
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // Avatar
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   gradient: AppColor.primaryGradient,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(Icons.account_balance,
//                     color: Colors.white, size: 28),
//               ),
//               const SizedBox(width: 14),
//
//               // Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       a.name ?? "",
//                       style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: AppColor.text),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       a.userEmail ?? "",
//                       style: const TextStyle(
//                           fontSize: 12.5, color: AppColor.sub),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: AppColor.primaryLight,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         a.qualification ?? "N/A",
//                         style: const TextStyle(
//                             fontSize: 11.5,
//                             color: AppColor.primary,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Edit / Delete
//               Column(
//                 children: [
//                   _cardIconBtn(
//                     icon: Icons.edit_note_rounded,
//                     color: AppColor.lightBlueColor,
//                     bg: AppColor.primaryLight,
//                     onTap: () => _openEditAccountantSheet(a),
//                   ),
//                   const SizedBox(height: 6),
//                   _cardIconBtn(
//                     icon: Icons.delete_outline_rounded,
//                     color: AppColor.error,
//                     bg: AppColor.error.withOpacity(0.08),
//                     onTap: () async {
//                       final confirmed = await _showDeleteDialog();
//                       if (confirmed) {
//                         Provider.of<DeleteAccountantViewModel>(
//                           context,
//                           listen: false,
//                         ).deleteAccountantApi(a.accountantId, context);
//                       }
//                     },
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
//   Widget _cardIconBtn({
//     required IconData icon,
//     required Color color,
//     required Color bg,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: bg, borderRadius: BorderRadius.circular(10)),
//         child: Icon(icon, color: color, size: 20),
//       ),
//     );
//   }
//
//   // Future<bool> _showDeleteDialog() async {
//   //   return await showDialog<bool>(
//   //     context: context,
//   //     builder: (_) => AlertDialog(
//   //       shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(20)),
//   //       title: const Row(
//   //         children: [
//   //           Icon(Icons.warning_amber_rounded,
//   //               color: AppColor.error, size: 26),
//   //           SizedBox(width: 8),
//   //           Text("Delete Accountant",
//   //               style: TextStyle(
//   //                   fontSize: 17, fontWeight: FontWeight.w700)),
//   //         ],
//   //       ),
//   //       content: const Text(
//   //         "Are you sure you want to delete this accountant? This action cannot be undone.",
//   //         style: TextStyle(color: AppColor.sub, fontSize: 14),
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context, false),
//   //           child: const Text("Cancel",
//   //               style: TextStyle(
//   //                   color: AppColor.sub,
//   //                   fontWeight: FontWeight.w600)),
//   //         ),
//   //         ElevatedButton(
//   //           style: ElevatedButton.styleFrom(
//   //             backgroundColor: AppColor.error,
//   //             shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.circular(10)),
//   //           ),
//   //           onPressed: () => Navigator.pop(context, true),
//   //           child: const Text("Delete",
//   //               style: TextStyle(
//   //                   color: Colors.white,
//   //                   fontWeight: FontWeight.w600)),
//   //         ),
//   //       ],
//   //     ),
//   //   ) ??
//   //       false;
//   // }
//   Future<bool> _showDeleteDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
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
//                   color: AppColor.error.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.delete_outline,
//                   color: AppColor.error,
//                   size: 36,
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Title
//               const Text(
//                 "Delete Accountant",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Description
//               const Text(
//                 "Are you sure you want to delete this accountant?\nThis action cannot be undone.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColor.sub,
//                   fontSize: 14,
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
//                       onPressed: () =>
//                           Navigator.pop(context, false),
//                       style: OutlinedButton.styleFrom(
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 12),
//                         side: const BorderSide(color: AppColor.sub),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         "Cancel",
//                         style: TextStyle(
//                           color: AppColor.sub,
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
//                       onPressed: () =>
//                           Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColor.error,
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 12),
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
//     ) ??
//         false;
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/accountant/school_accountant_datail_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import '../../model/school_model/accountant/all_accountant_list_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/accountant/add_accountant_view_model.dart';
import '../../view_model/school_view_model/accountant/delete_accountant_view_model.dart';
import '../../view_model/school_view_model/accountant/edit_accountant_view_model.dart';
import 'add_accountant_screen.dart';

class AllAccountantListScreen extends StatefulWidget {
  const AllAccountantListScreen({super.key});

  @override
  State<AllAccountantListScreen> createState() =>
      _AllAccountantListScreenState();
}

class _AllAccountantListScreenState extends State<AllAccountantListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  String? selectedClassId;
  String? selectedSectionId;
  File? accountantPhoto;
  File? aadharCard;

  Future<void> _onRefresh() async {
    _animCtrl.reset();
    await Provider.of<AllAccountantListVieModel>(
      context,
      listen: false,
    ).allAccountantListApi(context);
    _animCtrl.forward();
  }

  Future<void> pickImage(
    ImageSource source,
    bool isAccountantPhoto,
    StateSetter setSheetState,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setSheetState(() {
        if (isAccountantPhoto) {
          accountantPhoto = File(picked.path);
        } else {
          aadharCard = File(picked.path);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!PermissionExtensions.canAccess(
          PermissionKeys.viewAccountants)) {

        Utils.show(
          "You don't have permission to view accountant",
          context,
        );

        Navigator.pop(context);
        return;
      }
      Provider.of<AllAccountantListVieModel>(
        context,
        listen: false,
      ).allAccountantListApi(context);
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _openAddAccountantSheet() {
    setState(() {
      selectedClassId = null;
      selectedSectionId = null;
      accountantPhoto = null;
      aadharCard = null;
    });
    _openAccountantSheet(existing: null);
  }

  void _openEditAccountantSheet(AccountantData a) {
    setState(() {
      selectedClassId = null;
      selectedSectionId = null;
      accountantPhoto = null;
      aadharCard = null;
    });
    _openAccountantSheet(existing: a);
  }

  // ── Image Picker Field ────────────────────────────────────────────────────
  Widget _imagePickerField({
    required String label,
    required IconData icon,
    required File? file,
    required Function(ImageSource) onPickImage,
    required StateSetter setSheetState,
    String? existingImageUrl,
  }) {
    final bool hasLocalFile = file != null;
    final bool hasNetworkImage =
        existingImageUrl != null && existingImageUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColor.sub),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColor.border,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.camera_alt_outlined),
                        title: const Text("Take Photo"),
                        onTap: () {
                          Navigator.pop(context);
                          setSheetState(() {});
                          onPickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library_outlined),
                        title: const Text("Choose from Gallery"),
                        onTap: () {
                          Navigator.pop(context);
                          setSheetState(() {});
                          onPickImage(ImageSource.gallery);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColor.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (hasLocalFile || hasNetworkImage)
                    ? AppColor.success.withOpacity(0.5)
                    : AppColor.border,
                width: 1.5,
              ),
            ),
            child: hasLocalFile
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(file, fit: BoxFit.cover),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : hasNetworkImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          existingImageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primary,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 32,
                              color: AppColor.sub,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(13),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Tap to change",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: AppColor.sub.withOpacity(0.6),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Tap to upload",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.sub.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ── Open Sheet ────────────────────────────────────────────────────────────
  void _openAccountantSheet({AccountantData? existing}) {
    final isEdit = existing != null;

    // ── Helper: ISO date → YYYY-MM-DD ──
    String prefillDate(dynamic raw) {
      if (raw == null) return '';
      try {
        final d = DateTime.parse(raw.toString());
        return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      } catch (_) {
        return '';
      }
    }

    // ── Controllers ──
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final emailCtrl = TextEditingController(text: existing?.userEmail ?? '');
    final passwordCtrl = TextEditingController();
    final qualificationCtrl = TextEditingController(
      text: existing?.qualification ?? '',
    );
    final experienceCtrl = TextEditingController(
      text: existing?.experienceYears != null
          ? existing!.experienceYears.toString()
          : '',
    );
    final joiningDateCtrl = TextEditingController(
      text: prefillDate(existing?.joiningDate),
    );
    final dobCtrl = TextEditingController(
      text: prefillDate(existing?.dob),
    ); // ✅
    final mobileCtrl = TextEditingController(
      text: existing?.mobileNumber ?? '',
    );
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    final fatherNameCtrl = TextEditingController(
      text: existing?.fatherName ?? '',
    );
    final motherNameCtrl = TextEditingController(
      text: existing?.motherName ?? '',
    );

    // ✅ Employment type — prefill from existing
    String selectedEmploymentType = existing?.employmentType ?? 'full_time';

    bool obscurePassword = true;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              final bottom = MediaQuery.of(ctx).viewInsets.bottom;

              Future<void> handleSubmit() async {
                // ── Validation (Add only) ──
                if (!isEdit) {
                  if (nameCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter full name");
                    return;
                  }
                  final email = emailCtrl.text.trim();
                  if (email.isEmpty) {
                    _snack(ctx, "Please enter email");
                    return;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(email)) {
                    _snack(ctx, "Please enter a valid email");
                    return;
                  }
                  if (passwordCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter password");
                    return;
                  }
                  if (qualificationCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter qualification");
                    return;
                  }
                  if (experienceCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter experience years");
                    return;
                  }
                  if (joiningDateCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter joining date");
                    return;
                  }
                  if (mobileCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter mobile number");
                    return;
                  }
                  if (addressCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter address");
                    return;
                  }
                  if (fatherNameCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter father's name");
                    return;
                  }
                  if (motherNameCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter mother's name");
                    return;
                  }
                }

                setSheetState(() => isLoading = true);
                HapticFeedback.mediumImpact();

                if (isEdit) {
                  await Provider.of<EditAccountantViewModel>(
                    context,
                    listen: false,
                  ).editAccountantApi(
                    context: context,
                    accountantId: existing!.accountantId.toString(),
                    name: nameCtrl.text.trim().isEmpty
                        ? (existing.name ?? '')
                        : nameCtrl.text.trim(),
                    email: emailCtrl.text.trim().isEmpty
                        ? (existing.userEmail ?? '')
                        : emailCtrl.text.trim(),
                    qualification: qualificationCtrl.text.trim().isEmpty
                        ? (existing.qualification ?? '')
                        : qualificationCtrl.text.trim(),
                    password: passwordCtrl.text.trim(),
                    experienceYears: experienceCtrl.text.trim().isEmpty
                        ? (existing.experienceYears?.toString() ?? '')
                        : experienceCtrl.text.trim(),
                    mobileNumber: mobileCtrl.text.trim().isEmpty
                        ? (existing.mobileNumber ?? '')
                        : mobileCtrl.text.trim(),
                    address: addressCtrl.text.trim().isEmpty
                        ? (existing.address ?? '')
                        : addressCtrl.text.trim(),
                    fatherName: fatherNameCtrl.text.trim().isEmpty
                        ? (existing.fatherName ?? '')
                        : fatherNameCtrl.text.trim(),
                    motherName: motherNameCtrl.text.trim().isEmpty
                        ? (existing.motherName ?? '')
                        : motherNameCtrl.text.trim(),
                    accountantPhoto: accountantPhoto,
                    aadharCard: aadharCard,
                    dob: dobCtrl.text.trim(), // ✅
                    joiningDate: joiningDateCtrl.text.trim(), // ✅
                    employmentType: selectedEmploymentType, // ✅
                  );
                } else {
                  await Provider.of<AddAccountantViewModel>(
                    context,
                    listen: false,
                  ).addAccountantApi(
                    context: context,
                    name: nameCtrl.text.trim(),
                    user_email: emailCtrl.text.trim(),
                    password: passwordCtrl.text.trim(),
                    qualification: qualificationCtrl.text.trim(),
                    experience_years: experienceCtrl.text.trim(),
                    mobile_number: mobileCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                    father_name: fatherNameCtrl.text.trim(),
                    mother_name: motherNameCtrl.text.trim(),
                    accountant_photo: accountantPhoto,
                    aadharCard: aadharCard,
                    dob: dobCtrl.text.trim(), // ✅
                    joining_date: joiningDateCtrl.text.trim(), // ✅
                    employment_type: selectedEmploymentType, // ✅
                  );
                }

                Provider.of<AllAccountantListVieModel>(
                  context,
                  listen: false,
                ).allAccountantListApi(context);

                setSheetState(() => isLoading = false);
                Navigator.pop(ctx);
              }

              return Container(
                decoration: const BoxDecoration(
                  color: AppColor.bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.border,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ── Header ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isEdit
                                    ? [AppColor.editGradA, AppColor.editGradB]
                                    : [AppColor.gradA, AppColor.gradB],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isEdit
                                              ? AppColor.editGradA
                                              : AppColor.primary)
                                          .withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              isEdit
                                  ? Icons.edit_note_rounded
                                  : Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? "Edit Accountant" : "Add Accountant",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.text,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isEdit
                                    ? "Update the details below"
                                    : "Fill in the details below",
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColor.sub,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.border.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColor.sub,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit banner
                    if (isEdit)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.success.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.success.withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: AppColor.success.withOpacity(0.8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColor.sub,
                                    ),
                                    children: [
                                      const TextSpan(text: "Editing: "),
                                      TextSpan(
                                        text: existing?.name ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.success,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "  •  Password optional",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ── Scrollable Fields ──
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 4, 20, bottom + 24),
                        child: Column(
                          children: [
                            // ── Section 1: Account Info ──
                            _sectionCard(
                              index: 1,
                              icon: Icons.manage_accounts_rounded,
                              title: "Account Info",
                              color: AppColor.lightBlueColor,
                              children: [
                                _sheetField(
                                  nameCtrl,
                                  "Full Name",
                                  "e.g. Rahul Sharma",
                                  Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 14),
                                _sheetField(
                                  emailCtrl,
                                  "Email Address",
                                  "e.g. rahul@school.com",
                                  Icons.email_outlined,
                                  keyboard: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),
                                _passwordField(
                                  ctrl: passwordCtrl,
                                  obscure: obscurePassword,
                                  isEdit: isEdit,
                                  onToggle: () => setSheetState(
                                    () => obscurePassword = !obscurePassword,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Section 2: Professional Details ──
                            _sectionCard(
                              index: 2,
                              icon: Icons.work_outline_rounded,
                              title: "Professional Details",
                              color: AppColor.success,
                              children: [
                                _sheetField(
                                  qualificationCtrl,
                                  "Qualification",
                                  "e.g. B.Com, CA",
                                  Icons.school_outlined,
                                ),
                                const SizedBox(height: 14),
                                _sheetField(
                                  experienceCtrl,
                                  "Experience (Years)",
                                  "e.g. 5",
                                  Icons.timeline_outlined,
                                  keyboard: TextInputType.number,
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _dateField(joiningDateCtrl, ctx),
                                const SizedBox(height: 14),

                                // ✅ DOB
                                _dobField(dobCtrl, ctx),
                                const SizedBox(height: 14),

                                // ✅ Employment Type
                                _buildLabel(
                                  "Employment Type",
                                  Icons.badge_outlined,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _empTypeChip(
                                        label: "Full Time",
                                        value: "full_time",
                                        selected: selectedEmploymentType,
                                        icon: Icons.work_rounded,
                                        onTap: () => setSheetState(
                                          () => selectedEmploymentType =
                                              "full_time",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _empTypeChip(
                                        label: "Part Time",
                                        value: "part_time",
                                        selected: selectedEmploymentType,
                                        icon: Icons.work_outline_rounded,
                                        onTap: () => setSheetState(
                                          () => selectedEmploymentType =
                                              "part_time",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Section 3: Personal Info ──
                            _sectionCard(
                              index: 3,
                              icon: Icons.badge_outlined,
                              title: "Personal Info",
                              color: const Color(0xFFF77F00),
                              children: [
                                _sheetField(
                                  mobileCtrl,
                                  "Mobile Number",
                                  "e.g. 9876543210",
                                  Icons.phone_outlined,
                                  keyboard: TextInputType.phone,
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _sheetField(
                                  addressCtrl,
                                  "Address",
                                  "Full residential address",
                                  Icons.location_on_outlined,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 14),
                                _sheetField(
                                  fatherNameCtrl,
                                  "Father's Name",
                                  "e.g. Suresh Sharma",
                                  Icons.family_restroom_outlined,
                                ),
                                const SizedBox(height: 14),
                                _sheetField(
                                  motherNameCtrl,
                                  "Mother's Name",
                                  "e.g. Sunita Sharma",
                                  Icons.woman_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Section 4: Documents & Photo ──
                            _sectionCard(
                              index: 4,
                              icon: Icons.photo_library_outlined,
                              title: "Documents & Photo",
                              color: const Color(0xFF7B2FBE),
                              children: [
                                _imagePickerField(
                                  label: "Accountant Photo",
                                  icon: Icons.person_pin_outlined,
                                  file: accountantPhoto,
                                  onPickImage: (source) =>
                                      pickImage(source, true, setSheetState),
                                  setSheetState: setSheetState,
                                  existingImageUrl:
                                      existing?.accountantPhotoUrl,
                                ),
                                const SizedBox(height: 14),
                                _imagePickerField(
                                  label: "Aadhar Card",
                                  icon: Icons.credit_card_outlined,
                                  file: aadharCard,
                                  onPickImage: (source) =>
                                      pickImage(source, false, setSheetState),
                                  setSheetState: setSheetState,
                                  existingImageUrl: existing?.aadharCardUrl,
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),

                            // ── Buttons ──
                            if (isEdit)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(ctx),
                                      child: Container(
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: AppColor.border.withOpacity(
                                            0.4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: AppColor.border,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close_rounded,
                                              size: 18,
                                              color: AppColor.sub,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: AppColor.sub,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 3,
                                    child: AppButton(
                                      title: isLoading
                                          ? "Saving..."
                                          : "Save Changes",
                                      onTap: handleSubmit,
                                      height: 54,
                                      radius: 16,
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColor.editGradA,
                                          AppColor.editGradB,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      textColor: Colors.white,
                                      icon: isLoading
                                          ? null
                                          : Icons.check_circle_outline_rounded,
                                      loading: isLoading,
                                    ),
                                  ),
                                ],
                              )
                            else
                              AppButton(
                                title: isLoading
                                    ? "Adding Accountant..."
                                    : "Add Accountant",
                                onTap: handleSubmit,
                                height: 54,
                                radius: 16,
                                gradient: AppColor.primaryGradient,
                                textColor: Colors.white,
                                icon: isLoading
                                    ? null
                                    : Icons.person_add_alt_1_rounded,
                                loading: isLoading,
                              ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ── DOB Field ─────────────────────────────────────────────────────────────
  Widget _dobField(TextEditingController ctrl, BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date of Birth",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            DateTime initial = DateTime(2000);
            try {
              if (ctrl.text.isNotEmpty) initial = DateTime.parse(ctrl.text);
            } catch (_) {}
            final picked = await showDatePicker(
              context: ctx,
              initialDate: initial,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              builder: (c, child) => Theme(
                data: Theme.of(c).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColor.text,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              ctrl.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: "Select date of birth",
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.cake_outlined,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColor.sub,
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ── Employment Type Chip ──────────────────────────────────────────────────
  Widget _empTypeChip({
    required String label,
    required String value,
    required String selected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColor.primaryGradient : null,
          color: isSelected ? null : AppColor.primaryLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColor.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColor.sub,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColor.sub,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Label Builder ─────────────────────────────────────────────────────────
  Widget _buildLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColor.sub),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  FIELD WIDGETS
  // ════════════════════════════════════════════════════════
  Widget _sheetField(
    TextEditingController ctrl,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          inputFormatters: formatters,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController ctrl,
    required bool obscure,
    required bool isEdit,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
                letterSpacing: 0.3,
              ),
            ),
            if (isEdit) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Optional",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColor.success,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: isEdit
                ? "Leave blank to keep current password"
                : "Create a strong password",
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColor.sub,
              ),
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField(TextEditingController ctrl, BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Joining Date",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            DateTime initial = DateTime.now();
            try {
              if (ctrl.text.isNotEmpty) initial = DateTime.parse(ctrl.text);
            } catch (_) {}
            final picked = await showDatePicker(
              context: ctx,
              initialDate: initial,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (c, child) => Theme(
                data: Theme.of(c).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColor.text,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              ctrl.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: "Select joining date",
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColor.sub,
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required int index,
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(color: color.withOpacity(0.12)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "$index",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  MAIN SCREEN BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllAccountantListVieModel>(context);
    final accountants =
        viewModel.allAccountantListModel?.data ?? <AccountantData>[];

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Accountant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          if (!PermissionExtensions.canAccess(PermissionKeys.addAccountant)) {
            Utils.show(
              "You don't have permission to add accountant",
              context,
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAccountantScreen()),
          );
        },
      ),
      body: Column(
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.lightBlueColor,
                  AppColor.lightBlueColor.withOpacity(0.85),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.25),
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
                    "All Accountants",
                    size: 22,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                AppText.customText(
                  "${accountants.length}",
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── List ──
          Expanded(
            child: viewModel.loading
                ? _shimmerList()
                : accountants.isEmpty
                ? RefreshIndicator(
                    color: AppColor.lightBlueColor,
                    onRefresh: _onRefresh,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 50,
                                  color: Colors.green.shade400,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Accountants Found",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.sub,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Pull down to refresh",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
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
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: accountants.length,
                      itemBuilder: (context, index) =>
                          _animatedCard(index, accountants[index]),
                    ),
                  ),
          ),
          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget _shimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _animatedCard(int index, AccountantData a) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animCtrl.value - delay).clamp(0.0, 1.0) / (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 25 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _accountantCard(a),
    );
  }

  Widget _accountantCard(AccountantData a) {
    return GestureDetector(
        onTap: () {

          if (!PermissionExtensions.canAccess(
              PermissionKeys.viewAccountants)) {

            Utils.show(
              "You don't have permission to view accountant details",
              context,
            );

            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SchoolAccountantDetailScreen(
                accountantId: a.accountantId ?? 0,
              ),
            ),
          );
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.name ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.userEmail ?? "",
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColor.sub,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        a.qualification ?? "N/A",
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _cardIconBtn(
                    icon: Icons.edit_note_rounded,
                    color: AppColor.lightBlueColor,
                    bg: AppColor.primaryLight,
                    onTap: () {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.editAccountants)) {

                        Utils.show(
                          "You don't have permission to edit accountant",
                          context,
                        );

                        return;
                      }

                      _openEditAccountantSheet(a);
                    },
                  ),
                  const SizedBox(height: 6),
                  _cardIconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppColor.error,
                    bg: AppColor.error.withOpacity(0.08),
                    onTap: () async {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.deleteAccountant)) {

                        Utils.show(
                          "You don't have permission to delete accountant",
                          context,
                        );

                        return;
                      }

                      final confirmed = await _showDeleteDialog();

                      if (confirmed) {
                        Provider.of<DeleteAccountantViewModel>(
                          context,
                          listen: false,
                        ).deleteAccountantApi(
                          a.accountantId,
                          context,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardIconBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppColor.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColor.error,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Delete Accountant",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to delete this accountant?\nThis action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.sub, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColor.sub),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColor.sub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.error,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}
