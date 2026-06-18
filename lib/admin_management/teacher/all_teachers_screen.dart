import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/teacher/school_teachers_detail_screen.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/school_view_model/teacher/add_teacher_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';
import '../../model/school_model/teacher/all_teachers_list_model.dart';
import '../../res/app_button.dart';
import '../../utils/permission_error_message.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../view_model/school_view_model/teacher/delete_teacher_view_model.dart';
import '../../view_model/school_view_model/teacher/edit_teacher_view_model.dart';
import 'add_teacher_screen.dart';

class AllTeacherListScreen extends StatefulWidget {
  const AllTeacherListScreen({super.key});

  @override
  State createState() => _AllTeacherListScreenState();
}

class _AllTeacherListScreenState extends State
    with SingleTickerProviderStateMixin {
  Future<void> pickImage(ImageSource source, bool isTeacherPhoto, StateSetter setSheetState) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setSheetState(() {
        if (isTeacherPhoto) {
          teacherPhoto = File(picked.path);
        } else {
          aadharCard = File(picked.path);
        }
      });
    }
  }
  late AnimationController _animationController;
  String? selectedClassId;
  String? selectedSectionId;
  File? teacherPhoto;
  File? aadharCard;
  Future<void> _onRefresh() async {
    _animationController.reset();
    await Provider.of<AllTeachersListVieModel>(context, listen: false)
        .allTeachersListApi(context);
    _animationController.forward();
  }
// AllTeacherModel mein
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllTeachersListVieModel>(context, listen: false)
          .allTeachersListApi(context);
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

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.info_outline_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(msg,
                  style:
                  const TextStyle(fontWeight: FontWeight.w500))),
        ]),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Image Picker Field — network image support ──
  Widget _imagePickerField({
    required String label,
    required IconData icon,
    required File? file,
    required Function(ImageSource) onPickImage,
    required StateSetter setSheetState,
    String? existingImageUrl, // existing server image URL
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
                          onPickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library_outlined),
                        title: const Text("Choose from Gallery"),
                        onTap: () {
                          Navigator.pop(context);
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
            width: screenWidth,
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
            // 1. Naya pick kiya local file
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
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            )
                : hasNetworkImage
            // 2. Server se existing image
                ? ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    existingImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.primary,
                          value: loadingProgress
                              .expectedTotalBytes !=
                              null
                              ? loadingProgress
                              .cumulativeBytesLoaded /
                              loadingProgress
                                  .expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                          Icons.broken_image_outlined,
                          size: 32,
                          color: AppColor.sub),
                    ),
                  ),
                  // "Tap to change" overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(13)),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_outlined,
                              color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text("Tap to change",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
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
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            )
            // 3. Koi image nahi
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    size: 28,
                    color: AppColor.sub.withOpacity(0.6)),
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
  void _openAccountantSheet({AllTeacherModel? existing}) {
    final isEdit = existing != null;

    final nameCtrl =
    TextEditingController(text: existing?.name ?? '');
    final emailCtrl =
    TextEditingController(text: existing?.userEmail ?? '');
    final passwordCtrl = TextEditingController();
    final qualificationCtrl =
    TextEditingController(text: existing?.qualification ?? '');
    // final experienceCtrl = TextEditingController(
    //     text: existing?.experienceYears?.toString() ?? '');
    // ✅ BAAD MEIN (Fix)
    final experienceCtrl = TextEditingController(
        text: existing?.experienceYears != null
            ? existing!.experienceYears!.toInt().toString()  // "5.0" → "5"
            : '');
    final joiningDateCtrl =
    TextEditingController(text: existing?.joiningDate ?? '');
    final mobileCtrl =
    TextEditingController(text: existing?.mobileNumber ?? '');
    final addressCtrl =
    TextEditingController(text: existing?.address ?? '');
    final fatherNameCtrl =
    TextEditingController(text: existing?.fatherName ?? '');
    final motherNameCtrl =
    TextEditingController(text: existing?.motherName ?? '');
    final employeeIdCtrl =
    TextEditingController(text: existing?.employeeId ?? '');
    final designationCtrl =
    TextEditingController(text: existing?.designation ?? '');
    final dobCtrl =
    TextEditingController(text: existing?.dob ?? '');

    bool obscurePassword = true;
    bool isLoading = false;

    const List<String> genderOptions = ["Male", "Female", "Other"];
    const List<String> employmentOptions = [
      "Full Time",
      "Part Time",
      "Contract",
      "Temporary"
    ];

    String? selectedGender;
    String? selectedEmploymentType;

    // Normalize gender from API
    if (existing?.gender != null && existing!.gender!.isNotEmpty) {
      final apiGender = existing.gender!.toLowerCase();
      selectedGender = genderOptions.firstWhere(
            (g) => g.toLowerCase() == apiGender,
        orElse: () => '',
      );
      if (selectedGender!.isEmpty) selectedGender = null;
    }

    // Normalize employment type from API
    if (existing?.employmentType != null &&
        existing!.employmentType!.isNotEmpty) {
      final apiType = existing.employmentType!.toLowerCase();
      selectedEmploymentType = employmentOptions.firstWhere(
            (e) => e.toLowerCase() == apiType,
        orElse: () => '',
      );
      if (selectedEmploymentType!.isEmpty) selectedEmploymentType = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              final bottom = MediaQuery.of(ctx).viewInsets.bottom;

              Future handleSubmit() async {
                // ── ADD MODE VALIDATION ──
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(email)) {
                    _snack(ctx, "Please enter a valid email");
                    return;
                  }
                  if (passwordCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter password");
                    return;
                  }
                  if (employeeIdCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter employee ID");
                    return;
                  }
                  if (selectedGender == null) {
                    _snack(ctx, "Please select gender");
                    return;
                  }
                  if (selectedEmploymentType == null) {
                    _snack(ctx, "Please select employment type");
                    return;
                  }
                  if (designationCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter designation");
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
                  if (dobCtrl.text.trim().isEmpty) {
                    _snack(ctx, "Please enter date of birth");
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
                  await Provider.of<EditTeacherViewModel>(
                    context,
                    listen: false,
                  ).editTeacherApi(
                    context: context,
                    teacherId: existing!.teacherId.toString(),
                    name: nameCtrl.text.trim().isEmpty
                        ? (existing!.name ?? '')
                        : nameCtrl.text.trim(),
                    email: emailCtrl.text.trim().isEmpty
                        ? (existing!.userEmail ?? '')
                        : emailCtrl.text.trim(),
                    qualification: qualificationCtrl.text.trim().isEmpty
                        ? (existing!.qualification ?? '')
                        : qualificationCtrl.text.trim(),
                    // ✅ BAAD MEIN
                    experinceYears: experienceCtrl.text.trim().isEmpty
                        ? (existing!.experienceYears != null
                        ? existing!.experienceYears!.toInt().toString()
                        : '')

                        : experienceCtrl.text.trim(),
                    mobileNumber: mobileCtrl.text.trim().isEmpty
                        ? (existing!.mobileNumber ?? '') : mobileCtrl.text.trim(),
                    address: addressCtrl.text.trim().isEmpty
                        ? (existing!.address ?? '') : addressCtrl.text.trim(),
                    fatherName: fatherNameCtrl.text.trim().isEmpty
                        ? (existing!.fatherName ?? '') : fatherNameCtrl.text.trim(),
                    motherName: motherNameCtrl.text.trim().isEmpty
                        ? (existing!.motherName ?? '') : motherNameCtrl.text.trim(),
                    teacher_photo: teacherPhoto,   // ✅ state variable
                    aadharCard: aadharCard,
                    // experinceYears: experienceCtrl.text.trim().isEmpty
                    //     ? (existing!.experienceYears?.toString() ?? '')
                    //     : experienceCtrl.text.trim(),
                    joining_date: joiningDateCtrl.text.trim().isEmpty
                        ? (existing!.joiningDate ?? '')
                        : joiningDateCtrl.text.trim(),
                    password: passwordCtrl.text.trim(),
                    employeeId: employeeIdCtrl.text.trim().isEmpty
                        ? (existing!.employeeId ?? '')
                        : employeeIdCtrl.text.trim(),
                    gender: selectedGender ?? existing!.gender ?? '',
                    employmentType: selectedEmploymentType ??
                        existing!.employmentType ?? '',
                    designation: designationCtrl.text.trim().isEmpty
                        ? (existing!.designation ?? '')
                        : designationCtrl.text.trim(),
                    dob: dobCtrl.text.trim().isEmpty
                        ? (existing!.dob ?? '')
                        : dobCtrl.text.trim(),
                  );
                } else {
                  await Provider.of<AddTeachersViewModel>(
                    context,
                    listen: false,
                  ).addTeachersApi(
                    context: context,
                    name: nameCtrl.text.trim(),
                    userEmail: emailCtrl.text.trim(),
                    password: passwordCtrl.text.trim(),
                    qualification: qualificationCtrl.text.trim(),
                    experienceYears: experienceCtrl.text.trim(),
                    joiningDate: joiningDateCtrl.text.trim(),
                    mobileNumber: mobileCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                    fatherName: fatherNameCtrl.text.trim(),
                    motherName: motherNameCtrl.text.trim(),
                    employeeId: employeeIdCtrl.text.trim(),
                    gender: selectedGender ?? '',
                    employmentType: selectedEmploymentType ?? '',
                    designation: designationCtrl.text.trim(),
                    dob: dobCtrl.text.trim(),
                    teacher_photo: teacherPhoto,   // ← ADD THIS
                    aadharCard: aadharCard,
                  );
                }

                Provider.of<AllTeachersListVieModel>(
                  context,
                  listen: false,
                ).allTeachersListApi(context);

                setSheetState(() => isLoading = false);
                Navigator.pop(ctx);
              }

              return Container(
                decoration: const BoxDecoration(
                  color: AppColor.bg,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(32)),
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
                      padding:
                      const EdgeInsets.fromLTRB(20, 14, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isEdit
                                    ? [
                                  AppColor.editGradA,
                                  AppColor.editGradB
                                ]
                                    : [AppColor.gradA, AppColor.gradB],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (isEdit
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
                                isEdit ? "Edit Teacher" : "Add Teacher",
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
                                    color: AppColor.sub),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                AppColor.border.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.close_rounded,
                                  size: 18, color: AppColor.sub),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit info banner
                    if (isEdit)
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColor.success.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                AppColor.success.withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 16,
                                  color:
                                  AppColor.success.withOpacity(0.8)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColor.sub),
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
                                          text: " • Password optional"),
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
                        padding: EdgeInsets.fromLTRB(
                            20, 4, 20, bottom + 24),
                        child: Column(
                          children: [
                            // ── Section 1 — Account Info ──
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
                                  onToggle: () => setSheetState(() =>
                                  obscurePassword =
                                  !obscurePassword),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ── Section 2 — Professional Details ──
                            _sectionCard(
                              index: 2,
                              icon: Icons.work_outline_rounded,
                              title: "Professional Details",
                              color: AppColor.success,
                              children: [
                                // Employee ID
                                _sheetField(
                                  employeeIdCtrl,
                                  "Employee ID",
                                  "e.g. EMP001",
                                  Icons.badge_outlined,
                                ),
                                const SizedBox(height: 14),

                                // Gender
                                _dropdownField(
                                  label: "Gender",
                                  icon: Icons.wc_outlined,
                                  value: genderOptions
                                      .contains(selectedGender)
                                      ? selectedGender
                                      : null,
                                  hint: "Select Gender",
                                  items: genderOptions,
                                  onChanged: (val) => setSheetState(
                                          () => selectedGender = val),
                                ),
                                const SizedBox(height: 14),

                                // Employment Type
                                _dropdownField(
                                  label: "Employment Type",
                                  icon: Icons.work_history_outlined,
                                  value: employmentOptions.contains(
                                      selectedEmploymentType)
                                      ? selectedEmploymentType
                                      : null,
                                  hint: "Select Employment Type",
                                  items: employmentOptions,
                                  onChanged: (val) => setSheetState(
                                          () =>
                                      selectedEmploymentType = val),
                                ),
                                const SizedBox(height: 14),

                                // Designation
                                _sheetField(
                                  designationCtrl,
                                  "Designation",
                                  "e.g. Senior Teacher",
                                  Icons.military_tech_outlined,
                                ),
                                const SizedBox(height: 14),

                                // Qualification
                                _sheetField(
                                  qualificationCtrl,
                                  "Qualification",
                                  "e.g. B.Ed, M.Sc",
                                  Icons.school_outlined,
                                ),
                                const SizedBox(height: 14),

                                // Experience
                                _sheetField(
                                  experienceCtrl,
                                  "Experience (Years)",
                                  "e.g. 5",
                                  Icons.timeline_outlined,
                                  keyboard: TextInputType.number,
                                  formatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Joining Date
                                _dateField(joiningDateCtrl, ctx),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ── Section 3 — Personal Info ──
                            _sectionCard(
                              index: 3,
                              icon: Icons.badge_outlined,
                              title: "Personal Info",
                              color: const Color(0xFFF77F00),
                              children: [
                                // Date of Birth
                                _dobField(dobCtrl, ctx),
                                const SizedBox(height: 14),

                                // Mobile
                                _sheetField(
                                  mobileCtrl,
                                  "Mobile Number",
                                  "e.g. 9876543210",
                                  Icons.phone_outlined,
                                  keyboard: TextInputType.phone,
                                  formatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Address
                                _sheetField(
                                  addressCtrl,
                                  "Address",
                                  "Full residential address",
                                  Icons.location_on_outlined,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 14),

                                // Father's Name
                                _sheetField(
                                  fatherNameCtrl,
                                  "Father's Name",
                                  "e.g. Suresh Sharma",
                                  Icons.family_restroom_outlined,
                                ),
                                const SizedBox(height: 14),

                                // Mother's Name
                                _sheetField(
                                  motherNameCtrl,
                                  "Mother's Name",
                                  "e.g. Sunita Sharma",
                                  Icons.woman_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

// ── Section 4 — Documents / Photos ──
                            _sectionCard(
                              index: 4,
                              icon: Icons.photo_library_outlined,
                              title: "Documents & Photo",
                              color: const Color(0xFF7B2FBE),
                              children: [
                                // Teacher Photo
                                // Teacher Photo
//                                 _imagePickerField(
//                                   label: "Teacher Photo",
//                                   icon: Icons.person_pin_outlined,
//                                   file: teacherPhoto,
//                                   onPickImage: (source) => pickImage(source, true, setSheetState),
//                                 ),
//                                 const SizedBox(height: 14),
//
// // Aadhar Card
//                                 _imagePickerField(
//                                   label: "Aadhar Card",
//                                   icon: Icons.credit_card_outlined,
//                                   file: aadharCard,
//                                   onPickImage: (source) => pickImage(source, false, setSheetState),
//                                 ),
                                // Section 4 — Documents & Photo ke andar

                                _imagePickerField(
                                  label: "Teacher Photo",
                                  icon: Icons.person_pin_outlined,
                                  file: teacherPhoto,
                                  onPickImage: (source) => pickImage(source, true, setSheetState),
                                  setSheetState: setSheetState,          // ✅ ADD
                                  existingImageUrl: existing?.teacherPhotoUrl, // ✅ ADD
                                ),
                                const SizedBox(height: 14),
                                _imagePickerField(
                                  label: "Aadhar Card",
                                  icon: Icons.credit_card_outlined,
                                  file: aadharCard,
                                  onPickImage: (source) => pickImage(source, false, setSheetState),
                                  setSheetState: setSheetState,          // ✅ ADD
                                  existingImageUrl: existing?.aadharCardUrl,   // ✅ ADD
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
                                          color: AppColor.border
                                              .withOpacity(0.4),
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          border: Border.all(
                                              color: AppColor.border,
                                              width: 1.5),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded,
                                                size: 18,
                                                color: AppColor.sub),
                                            SizedBox(width: 6),
                                            Text("Cancel",
                                                style: TextStyle(
                                                    color: AppColor.sub,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w600)),
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
                                          : Icons
                                          .check_circle_outline_rounded,
                                      loading: isLoading,
                                    ),
                                  ),
                                ],
                              )
                            else
                              AppButton(
                                title: isLoading
                                    ? "Adding Teacher..."
                                    : "Add Teacher",
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllTeachersListVieModel>(context);
    final teachers = viewModel.allTeachersListModel?.data ?? [];

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: AppColor.lightBlueColor,
      //   onPressed: _openAddAccountantSheet,
      //   icon: const Icon(Icons.add_rounded, color: Colors.white),
      //   label: const Text(
      //     'Add Teachers',
      //     style: TextStyle(
      //         color: Colors.white, fontWeight: FontWeight.w600),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        onPressed: () {

          if (!PermissionGuard.check(
            context,
            PermissionKeys.addTeacher,
            "Add Teacher",
          )) {
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTeacherScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Add Teacher',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          /// ===== CUSTOM HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(14, 50, 20, 24),
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
              boxShadow: [
                BoxShadow(
                  color: AppColor.cardShadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
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
                const SizedBox(width: 14),
                Expanded(
                  child: AppText.customText(
                    "All Teachers",
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                AppText.customText(
                  "${teachers.length}",
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ===== LIST =====
          Expanded(
            child: viewModel.loading
                ? _shimmerList()
                : teachers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Teachers Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
            //     : ListView.builder(
            //   padding:
            //   const EdgeInsets.fromLTRB(18, 8, 18, 20),
            //   physics: const BouncingScrollPhysics(),
            //   itemCount: teachers.length,
            //   itemBuilder: (context, index) {
            //     return _animatedTeacherCard(
            //         index, teachers[index]);
            //   },
            // ),
                : RefreshIndicator(
              color: AppColor.lightBlueColor,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  return _animatedTeacherCard(index, teachers[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Shimmer
  // ─────────────────────────────────────────────
  Widget _shimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 110,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Dropdown field helper
  // ─────────────────────────────────────────────
  Widget _dropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          hint: Text(
            hint,
            style: TextStyle(
                fontSize: 13.5,
                color: AppColor.sub.withOpacity(0.6)),
          ),
          items: items
              .map((item) =>
              DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColor.sub, size: 20),
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Animated teacher card
  // ─────────────────────────────────────────────
  Widget _animatedTeacherCard(int index, dynamic t) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) /
              (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 25 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _teacherCard(t),
    );
  }

  // ─────────────────────────────────────────────
  // Sheet field
  // ─────────────────────────────────────────────
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
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
                letterSpacing: 0.3)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          inputFormatters: formatters,
          maxLines: maxLines,
          style: const TextStyle(
              fontSize: 14,
              color: AppColor.text,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 13.5,
                color: AppColor.sub.withOpacity(0.6)),
            prefixIcon: Icon(icon,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Password field
  // ─────────────────────────────────────────────
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
            const Text("Password",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.sub,
                    letterSpacing: 0.3)),
            if (isEdit) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Optional",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColor.success)),
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
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: isEdit
                ? "Leave blank to keep current password"
                : "Create a strong password",
            hintStyle: TextStyle(
                fontSize: 13, color: AppColor.sub.withOpacity(0.6)),
            prefixIcon: Icon(Icons.lock_outline_rounded,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
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
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Joining Date field
  // ─────────────────────────────────────────────
  Widget _dateField(TextEditingController ctrl, BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Joining Date",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
                letterSpacing: 0.3)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          readOnly: true,
          style: const TextStyle(
              fontSize: 14,
              color: AppColor.text,
              fontWeight: FontWeight.w500),
          onTap: () async {
            DateTime initial = DateTime.now();
            try {
              if (ctrl.text.isNotEmpty)
                initial = DateTime.parse(ctrl.text);
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
                color: AppColor.sub.withOpacity(0.6)),
            prefixIcon: Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
            suffixIcon: const Icon(Icons.arrow_drop_down_rounded,
                color: AppColor.sub),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Date of Birth field
  // ─────────────────────────────────────────────
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
              if (ctrl.text.isNotEmpty)
                initial = DateTime.parse(ctrl.text);
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
                color: AppColor.sub.withOpacity(0.6)),
            prefixIcon: Icon(Icons.cake_outlined,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
            suffixIcon: const Icon(Icons.arrow_drop_down_rounded,
                color: AppColor.sub),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Section card
  // ─────────────────────────────────────────────
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
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                  bottom: BorderSide(color: color.withOpacity(0.12))),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text("$index",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.2)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Teacher card
  // ─────────────────────────────────────────────
  Widget _teacherCard(dynamic t) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {

        if (!PermissionGuard.check(
          context,
          PermissionKeys.viewOneTeacherProfile,
          "View Teacher Profile",
        )) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchoolTeachersDetailScreen(
              teacherId: t.teacherId,
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
          padding: EdgeInsets.all(w * 0.04),
          child: Row(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColor.lightBlueColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 30),
              ),
              SizedBox(width: w * 0.035),

              // Teacher Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                      t.name ?? "",
                      size: 17,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    AppText.customText(
                      t.userEmail ?? "",
                      size: 13,
                      color: AppColor.textGrey,
                    ),
                    const SizedBox(height: 4),
                    AppText.customText(
                      "Designation: ${t.designation ?? "N/A"}",
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColor.lightBlueColor,
                    ),
                    const SizedBox(height: 2),
                    AppText.customText(
                      "Emp ID: ${t.employeeId ?? "N/A"}  •  ${t.employmentType ?? "N/A"}",
                      size: 12,
                      color: AppColor.textGrey,
                    ),
                  ],
                ),
              ),

              // Edit & Delete buttons
              // Column(
              //   children: [
              //     IconButton(
              //       onPressed: () =>
              //           _openAccountantSheet(existing: t),
              //       icon: const Icon(Icons.edit,
              //           color: AppColor.lightBlueColor),
              //     ),
              //     IconButton(
              //       onPressed: () async {
              //         bool confirmed = await _showDeleteDialog();
              //         if (confirmed) {
              //           Provider.of<DeleteTeacherViewModel>(context,
              //               listen: false)
              //               .deleteTeacherApi(t.teacherId, context);
              //         }
              //       },
              //       icon: const Icon(Icons.delete_forever,
              //           color: Colors.red),
              //     ),
              //   ],
              // ),
              // Edit & Delete buttons
              Column(
                children: [
                  // IconButton(
                  //   onPressed: () =>
                  //       _openAccountantSheet(existing: t),
                  //   icon: const Icon(Icons.edit,
                  //       color: AppColor.lightBlueColor),
                  // ),
                  // IconButton(
                  //   onPressed: () async {
                  //     bool confirmed = await _showDeleteDialog();
                  //     if (confirmed) {
                  //       Provider.of<DeleteTeacherViewModel>(context,
                  //           listen: false)
                  //           .deleteTeacherApi(t.teacherId, context);
                  //     }
                  //   },
                  //   icon: const Icon(Icons.delete_forever,
                  //       color: Colors.red),
                  // ),
                  GestureDetector(
                    onTap: () {

                      if(
                      !PermissionGuard.check(
                        context,
                        PermissionKeys.editTeacher,
                        "Edit Teacher",
                      )
                      ){
                        return;
                      }

                      _openAccountantSheet(existing: t);
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

                      if(
                      !PermissionGuard.check(
                        context,
                        PermissionKeys.deleteTeacher,
                        "Delete Teacher",
                      )
                      ){
                        return;
                      }

                      bool confirmed = await _showDeleteDialog();

                      if (confirmed) {
                        Provider.of<DeleteTeacherViewModel>(
                          context,
                          listen: false,
                        ).deleteTeacherApi(
                          t.teacherId,
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

  // ─────────────────────────────────────────────
  // Delete dialog
  // ─────────────────────────────────────────────
  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Icon
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 34,
                ),
              ),

              const SizedBox(height: 14),

              // Title
              const Text(
                "Delete Teacher",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // Message
              const Text(
                "Are you sure you want to delete this teacher?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 22),

              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Delete"),
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
  // Future<bool> _showDeleteDialog() async {
  //   return await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Confirm Delete"),
  //       content: const Text(
  //           "Are you sure you want to delete this teacher?"),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: const Text("Cancel")),
  //         TextButton(
  //             onPressed: () => Navigator.pop(context, true),
  //             child: const Text("Delete",
  //                 style: TextStyle(color: Colors.red))),
  //       ],
  //     ),
  //   ) ??
  //       false;
  // }

}