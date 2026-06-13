import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/view_model/school_view_model/all_home_work_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_subjects_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/school_model/all_classes_model.dart';
import '../model/school_model/all_home_work_model.dart';
import '../model/school_model/homework_details_model.dart';
import '../res/app_button.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/all_classes_view_model.dart';
import '../view_model/school_view_model/all_scetions_view_model.dart';
import '../view_model/school_view_model/all_student_list_view_model.dart';
import '../view_model/school_view_model/create_admin_teacher_home_work_view_model.dart';
import '../view_model/school_view_model/homework_details_viewmodel.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _DS {
  static const bg = AppColor.bg;
  static const card = AppColor.card;
  static const primary = AppColor.primary;
  static const primaryLight = AppColor.primaryLight;
  static const textDark = AppColor.text;
  static const textMid = AppColor.sub;
  static const border = AppColor.border;
  static const textLight = Color(0xFF9CA3AF);
  static const accent = Color(0xFFFF6B6B);
  static const green = Color(0xFF27AE7A);
  static const orange = Color(0xFFF59E0B);
  static const red = AppColor.error;
  static const gradientHeader = AppColor.primaryGradient;

  static BoxDecoration cardDecor({double radius = 20}) => BoxDecoration(
    color: card,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: AppColor.primary.withOpacity(0.07),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class AllHomeWorkScreen extends StatefulWidget {
  const AllHomeWorkScreen({super.key});
  @override
  State<AllHomeWorkScreen> createState() => _AllHomeWorkScreenState();
}

class _AllHomeWorkScreenState extends State<AllHomeWorkScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  String? _selectedSubject;
  String? selectedClassId;
  String? selectedSectionId;
  File? _selectedPdfFile;
  String? _selectedPdfName;
  String? _filterClassId;
  String? _filterSubjectId;

  File? _selectedImageFile;
  String? _selectedImageName;
  int? loadingHomeworkId;

  bool _allowSubmission = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!PermissionExtensions.canAccess(
          PermissionKeys.viewHomework)) {

        Utils.show(
          "You don't have permission to view homework",
          context,
        );

        Navigator.pop(context);
        return;
      }
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);
      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
      Provider.of<AllSubjectsVieModel>(
        context,
        listen: false,
      ).allSubjectsApi(context);
      await Provider.of<AllHomeWorkViewModel>(
        context,
        listen: false,
      ).allHomeworkApi(context);
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  String? _filterStatus; // "submitted" | "pending" | "late"
  @override
  void dispose() {
    _controller.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  // ✅ FIX #2 — UTC timezone shift avoid karo, local date string banao
  String _localDateString(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  // ─── Add Homework Bottom Sheet ─────────────────────────────────────────────
  void _showHomeworkBottomSheet() {
    _descriptionController.clear();
    _dueDateController.clear();
    _selectedSubject = null;
    selectedClassId = null;
    selectedSectionId = null;
    _selectedPdfFile = null;
    _selectedPdfName = null;
    _selectedImageFile = null;
    _selectedImageName = null;
    _allowSubmission = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _DS.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: _DS.gradientHeader,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.assignment_add,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Homework",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _DS.textDark,
                              ),
                            ),
                            Text(
                              "Fill in the details below",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: _DS.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _DS.bg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: _DS.textMid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Subject
                  _FormLabel("Subject", Icons.menu_book_rounded),
                  const SizedBox(height: 8),
                  Consumer<AllSubjectsVieModel>(
                    builder: (_, vm, __) {
                      if (vm.loading) return _loadingField();
                      final subjects = vm.allSubjectsModel?.data ?? [];
                      return _styledDropdown<String>(
                        value: _selectedSubject,
                        hint: "Choose subject",
                        icon: Icons.menu_book_rounded,
                        items: subjects
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.subjectId.toString(),
                                child: Text(s.subjectName!.trim()),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setSheet(() => _selectedSubject = v),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _FormLabel("Class", Icons.class_outlined),
                  const SizedBox(height: 8),
                  Consumer<AllClassesViewModel>(
                    builder: (_, vm, __) {
                      final classes = vm.allClassesModel?.data ?? [];
                      return _styledDropdown<String>(
                        value: selectedClassId,
                        hint: "Choose class",
                        icon: Icons.class_outlined,
                        items: classes
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.classId.toString(),
                                child: Text(c.className ?? ""),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          setSheet(() {
                            selectedClassId = v;
                            selectedSectionId = null;
                          });
                          Provider.of<AllSectionsViewModel>(
                            context,
                            listen: false,
                          ).allSectionsApi(context, v!);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Section field — replace karo existing Section block ko ──
                  _FormLabel("Section", Icons.grid_view_rounded),
                  const SizedBox(height: 8),
                  Consumer<AllSectionsViewModel>(
                    builder: (_, vm, __) {
                      final sections = vm.allSectionsModel?.data ?? [];

                      // Class select nahi hui abhi tak
                      if (selectedClassId == null) {
                        return _styledDropdown<String>(
                          value: null,
                          hint: "Choose section",
                          icon: Icons.grid_view_rounded,
                          items: const [],
                          onChanged: (_) {},
                        );
                      }

                      // Class select hui lekin sections nahi hain
                      if (sections.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _DS.orange.withOpacity(0.4),
                              width: 1.3,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: _DS.orange,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "No Section Available for this class",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Sections available
                      return _styledDropdown<String>(
                        value: selectedSectionId,
                        hint: "Choose section",
                        icon: Icons.grid_view_rounded,
                        items: sections
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.sectionId.toString(),
                                child: Text(s.sectionName ?? ""),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setSheet(() => selectedSectionId = v),
                      );
                    },
                  ),
                  // Section
                  // _FormLabel("Section", Icons.grid_view_rounded),
                  // const SizedBox(height: 8),
                  // Consumer<AllSectionsViewModel>(builder: (_, vm, __) {
                  //   final sections = vm.allSectionsModel?.data ?? [];
                  //   return _styledDropdown<String>(
                  //     value: selectedSectionId, hint: "Choose section", icon: Icons.grid_view_rounded,
                  //     items: sections.map((s) => DropdownMenuItem(value: s.sectionId.toString(), child: Text(s.sectionName ?? ""))).toList(),
                  //     onChanged: (v) => setSheet(() => selectedSectionId = v),
                  //   );
                  // }),
                  const SizedBox(height: 16),

                  // Description
                  _FormLabel("Description", Icons.edit_note_rounded),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 14, color: _DS.textDark),
                    decoration: _inputDeco(
                      hint: "Enter homework details...",
                      icon: Icons.edit_note_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ FIX #2 — Due Date: local date, no UTC shift
                  _FormLabel(
                    "Due Date (Optional)",
                    Icons.calendar_month_rounded,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dueDateController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 14, color: _DS.textDark),
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(2030),
                        builder: (c, child) => Theme(
                          data: Theme.of(c).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: _DS.primary,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setSheet(
                          () => _dueDateController.text = _localDateString(
                            picked,
                          ),
                        );
                      }
                    },
                    decoration: _inputDeco(
                      hint: "Select due date",
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _allowSubmission
                          ? AppColor.primary.withOpacity(.06)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _allowSubmission
                            ? AppColor.primary.withOpacity(.3)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _allowSubmission
                                ? AppColor.primary.withOpacity(.12)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.assignment_turned_in_rounded,
                            color: _allowSubmission
                                ? AppColor.primary
                                : Colors.grey,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Allow Online Submission",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _allowSubmission
                                    ? "Students can submit homework online"
                                    : "Submission disabled",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Switch.adaptive(
                          value: _allowSubmission,
                          activeColor: AppColor.primary,
                          onChanged: (v) {
                            setSheet(() {
                              _allowSubmission = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  //  FIX #1 — Document Upload
                  _FormLabel(
                    "Attachment (Optional)",
                    Icons.attach_file_rounded,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    // onTap: () async {
                    //   final result = await FilePicker.platform.pickFiles(
                    //     type: FileType.custom,
                    //     allowedExtensions: ["PDF, DOC, DOCX • Max 1 MB"],
                    //   );
                    //
                    //   if (result != null && result.files.single.path != null) {
                    //     final file = File(result.files.single.path!);
                    //
                    //     // ✅ 1 MB = 1024 * 1024 bytes
                    //     final fileSizeInBytes = file.lengthSync();
                    //
                    //     if (fileSizeInBytes > 1024 * 1024) {
                    //       // ❌ Size exceed
                    //       Utils.show("Max file size allowed is 1 MB", context);
                    //       return;
                    //     }
                    //
                    //     // ✅ Valid file
                    //     setSheet(() {
                    //       _selectedPdfFile = file;
                    //       _selectedPdfName = result.files.single.name;
                    //     });
                    //   }
                    // },
                    onTap: () async {
                      // ✅ Sirf PDF allow karo
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'], // ✅ Only PDF
                        allowMultiple: false,
                      );

                      if (result == null || result.files.isEmpty) return;

                      final pickedFile = result.files.first;

                      // ✅ 1 MB = 1024 * 1024 bytes
                      if (pickedFile.size > 1 * 1024 * 1024) {
                        Utils.show("PDF size must be less than 1 MB", context);
                        return;
                      }

                      setSheet(() {
                        _selectedPdfFile = File(pickedFile.path!);
                        _selectedPdfName = pickedFile.name;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedPdfFile != null
                            ? AppColor.primaryLight
                            : _DS.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedPdfFile != null
                              ? AppColor.primary.withOpacity(0.4)
                              : _DS.border,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _selectedPdfFile != null
                                  ? AppColor.primary.withOpacity(0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _selectedPdfFile != null
                                  ? Icons.picture_as_pdf_rounded
                                  : Icons.upload_file_rounded,
                              size: 20,
                              color: _selectedPdfFile != null
                                  ? AppColor.primary
                                  : _DS.textMid,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedPdfFile != null
                                      ? _selectedPdfName ?? "File selected"
                                      : "Tap to upload PDF",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: _selectedPdfFile != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: _selectedPdfFile != null
                                        ? AppColor.primary
                                        : _DS.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedPdfFile != null
                                      ? "${(_selectedPdfFile!.lengthSync() / 1024).toStringAsFixed(1)} KB"
                                      : "PDF, DOC, DOCX • Max 1 MB",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _DS.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedPdfFile != null)
                            GestureDetector(
                              onTap: () => setSheet(() {
                                _selectedPdfFile = null;
                                _selectedPdfName = null;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColor.error.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: AppColor.error,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: _DS.gradientHeader,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Browse",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormLabel(
                    "Submission Image (Optional)",
                    Icons.image_rounded,
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                      );

                      if (result == null) return;

                      final file = File(result.files.first.path!);

                      if (file.lengthSync() > 2 * 1024 * 1024) {
                        Utils.show(
                          "Image size must be less than 2 MB",
                          context,
                        );
                        return;
                      }

                      setSheet(() {
                        _selectedImageFile = file;
                        _selectedImageName = result.files.first.name;
                      });
                    },

                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColor.primary.withOpacity(.2),
                        ),
                        color: AppColor.primary.withOpacity(.03),
                      ),

                      child: _selectedImageFile == null
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_rounded,
                                    size: 40,
                                    color: AppColor.primary,
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    "Upload Homework Image",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "PNG, JPG • Max 2 MB",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    _selectedImageFile!,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: InkWell(
                                    onTap: () {
                                      setSheet(() {
                                        _selectedImageFile = null;
                                        _selectedImageName = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _selectedImageName ?? "",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const SizedBox(height: 28),

                  // Submit
                  Consumer<CreateAdminTeachersHomeworkViewModel>(
                    builder: (_, addVM, __) => AppButton(
                      title: "Add Homework",
                      icon: Icons.assignment_ind_outlined,
                      loading: addVM.loading,
                      onTap: () async {
                        print("PDF => ${_selectedPdfFile?.path}");
                        print("IMAGE => ${_selectedImageFile?.path}");

                        if (_selectedSubject == null ||
                            selectedClassId == null ||
                            selectedSectionId == null ||
                            _descriptionController.text.trim().isEmpty) {
                          Utils.show(
                            "Please select Subject, Class, Section and Description",
                            context,
                          );
                          return;
                        }

                        final success = await addVM.createAdminTeachersApi(
                          context: context,
                          classId: selectedClassId!,
                          sectionId: selectedSectionId!,
                          subjectId: _selectedSubject!,
                          description: _descriptionController.text.trim(),
                          dueDate: _dueDateController.text.trim().isEmpty
                              ? null
                              : _dueDateController.text.trim(),
                          submissionPdf: _selectedPdfFile,
                          submissionPhoto: _selectedImageFile,
                          allowSubmission: _allowSubmission ? 1 : 0,
                        );

                        if (success) {
                          await Provider.of<AllHomeWorkViewModel>(
                            context,
                            listen: false,
                          ).allHomeworkApi(context);

                          Navigator.pop(context);

                          Utils.show("Homework created successfully", context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── FIX #3: Submission Status Bottom Sheet ────────────────────────────────
  // void _showSubmissionStatus(HomeworkData hw) {
  //   final submitted = int.tryParse(hw.submittedCount ?? "0") ?? 0;
  //   final pending   = int.tryParse(hw.pendingCount   ?? "0") ?? 0;
  //   final late      = int.tryParse(hw.lateCount      ?? "0") ?? 0;
  //   final total     = hw.totalStudents ?? (submitted + pending + late);
  //   final progress  = total > 0 ? submitted / total : 0.0;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => SafeArea(
  //       child: Container(
  //         padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
  //         ),
  //         child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
  //           Center(child: Container(width: 44, height: 4,
  //               decoration: BoxDecoration(color: _DS.border, borderRadius: BorderRadius.circular(99)))),
  //           const SizedBox(height: 20),
  //
  //           // Title
  //           Row(children: [
  //             Container(padding: const EdgeInsets.all(10),
  //                 decoration: BoxDecoration(gradient: _DS.gradientHeader, borderRadius: BorderRadius.circular(12)),
  //                 child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20)),
  //             const SizedBox(width: 12),
  //             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //               Text(hw.subjectName ?? "Subject",
  //                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _DS.textDark)),
  //               Text("${hw.className ?? ''} • ${hw.sectionName ?? ''}",
  //                   style: const TextStyle(fontSize: 12, color: _DS.textLight)),
  //             ])),
  //           ]),
  //           const SizedBox(height: 24),
  //
  //           // Progress bar
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //             const Text("Overall Submission",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _DS.textMid)),
  //             Text("${(progress * 100).round()}%",
  //                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _DS.primary)),
  //           ]),
  //           const SizedBox(height: 8),
  //           ClipRRect(borderRadius: BorderRadius.circular(99),
  //               child: LinearProgressIndicator(value: progress, minHeight: 10,
  //                   backgroundColor: _DS.primaryLight,
  //                   valueColor: const AlwaysStoppedAnimation<Color>(_DS.primary))),
  //           const SizedBox(height: 24),
  //
  //           // 3 stat cards
  //           Row(children: [
  //             _statCard(icon: Icons.check_circle_rounded, label: "Submitted", value: "$submitted", color: _DS.green,   total: total),
  //             const SizedBox(width: 10),
  //             _statCard(icon: Icons.hourglass_empty_rounded, label: "Pending", value: "$pending",  color: _DS.orange,  total: total),
  //             const SizedBox(width: 10),
  //             _statCard(icon: Icons.schedule_rounded,        label: "Late",    value: "$late",      color: _DS.red,     total: total),
  //           ]),
  //           const SizedBox(height: 20),
  //
  //           // Total students
  //           Container(
  //             padding: const EdgeInsets.all(14),
  //             decoration: BoxDecoration(
  //                 color: _DS.bg, borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: _DS.border)),
  //             child: Row(children: [
  //               const Icon(Icons.people_rounded, size: 18, color: _DS.primary),
  //               const SizedBox(width: 10),
  //               const Text("Total Students",
  //                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _DS.textDark)),
  //               const Spacer(),
  //               Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                   decoration: BoxDecoration(color: AppColor.primaryLight, borderRadius: BorderRadius.circular(20)),
  //                   child: Text("$total",
  //                       style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _DS.primary))),
  //             ]),
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  void _showSubmissionStatus(HomeworkData hw) async {
    final detailsVM = Provider.of<HomeworkDetailsViewModel>(
      context,
      listen: false,
    );

    final homeworkData = detailsVM.homeworkDetailsModel?.data;

    if (homeworkData == null) {
      Utils.show("Unable to load submissions", context);
      return;
    }

    final students = homeworkData.students ?? [];

    final submitted = students.where((e) {
      return (e.status ?? "").toLowerCase() == "submitted";
    }).length;

    final pending = students.where((e) {
      return (e.status ?? "").toLowerCase() == "assigned";
    }).length;

    final late = students.where((e) {
      return (e.status ?? "").toLowerCase() == "late";
    }).length;

    final total = students.length;

    final progress = total > 0 ? submitted / total : 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: .80,
          minChildSize: .40,
          maxChildSize: .95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: _DS.gradientHeader,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hw.subjectName ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            Text(
                              "${hw.className} • ${hw.sectionName}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  IntrinsicHeight(
                    child: Row(
                      children: [
                        _detailStatTile(
                          "Total",
                          "$total",
                          Icons.people,
                          Colors.indigo,
                        ),

                        const SizedBox(width: 10),

                        _detailStatTile(
                          "Submitted",
                          "$submitted",
                          Icons.check_circle,
                          Colors.green,
                        ),

                        const SizedBox(width: 10),

                        _detailStatTile(
                          "Pending",
                          "$pending",
                          Icons.hourglass_empty,
                          Colors.orange,
                        ),

                        const SizedBox(width: 10),

                        _detailStatTile(
                          "Late",
                          "$late",
                          Icons.schedule,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Student Submissions (${students.length})",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...students.map((student) {
                    final status = student.status ?? "";

                    final isSubmitted = status.toLowerCase() == "submitted";

                    final statusColor = isSubmitted
                        ? Colors.green
                        : Colors.orange;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.primaryLight,
                                child: Text(
                                  student.studentName
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      "?",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.studentName ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    Text("Roll No : ${student.rollNo ?? "-"}"),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (isSubmitted) ...[
                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 36,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _showStudentHomeworkSheet(
                                      student.studentId!,
                                    );
                                  },

                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _DS.primary,
                                    side: BorderSide(
                                      color: AppColor.primary.withOpacity(.35),
                                      width: 1.2,
                                    ),
                                    backgroundColor: AppColor.primaryLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                  ),

                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.visibility_outlined, size: 14),

                                      SizedBox(width: 5),

                                      Text(
                                        "View Homework",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showStudentHomeworkSheet(int studentId) {
    final vm = Provider.of<HomeworkDetailsViewModel>(context, listen: false);

    final student = vm.homeworkDetailsModel?.data?.students?.firstWhere(
      (e) => e.studentId == studentId,
    );

    if (student == null) {
      Utils.show("Submission not found", context);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * .85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColor.primaryLight,
                            child: Text(
                              student.studentName!
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.studentName ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text("Roll: ${student.rollNo ?? "-"}"),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Submitted",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// PDF SECTION
                      if (student.submittedFile != null)
                        _pdfCard(student.submittedFile!.url ?? ""),

                      const SizedBox(height: 24),

                      /// IMAGES
                      if (student.submittedPhotos != null &&
                          student.submittedPhotos!.isNotEmpty)
                        _imageSection(student),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    title: "Close",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pdfCard(String pdfUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Submitted PDF",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 4),

                Text(
                  pdfUrl.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.red),
            onPressed: () async {
              await launchUrl(Uri.parse(pdfUrl));
            },
          ),
        ],
      ),
    );
  }

  Widget _imageSection(StudentSubmission student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Submitted Photos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(width: 8),

            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green.shade100,
              child: Text(
                student.submittedPhotos!.length.toString(),
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: student.submittedPhotos!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final imageUrl = student.submittedPhotos![index].url!;

            return GestureDetector(
              onTap: () {
                _showImagePreview(imageUrl);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              SizedBox(
                height: 500,
                child: PhotoView(imageProvider: NetworkImage(imageUrl)),
              ),

              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int? getClassIdFromName(String? className) {
    final classVM = Provider.of<AllClassesViewModel>(context, listen: false);
    final classes = classVM.allClassesModel?.data ?? [];

    try {
      final match = classes.firstWhere(
        (c) =>
            c.className?.trim().toLowerCase() ==
            className?.trim().toLowerCase(),
      );
      return match.classId;
    } catch (e) {
      return null;
    }
  }

  int? getSectionIdFromName(String? sectionName) {
    final sectionVM = Provider.of<AllSectionsViewModel>(context, listen: false);
    final sections = sectionVM.allSectionsModel?.data ?? [];

    try {
      final match = sections.firstWhere(
        (s) =>
            s.sectionName?.trim().toLowerCase() ==
            sectionName?.trim().toLowerCase(),
      );
      return match.sectionId;
    } catch (e) {
      return null;
    }
  }

  // Detail stat tile helper
  Widget _detailStatTile(String label, String value, IconData icon, Color color,) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 important
          children: [
            Icon(icon, color: color, size: 22),
            Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _DS.textMid,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Detail stat tile (Image 2 ke 4 boxes jaisa)

  //    Widget _detailStatTile(String label, String value, IconData icon, Color color) {
  //     return Expanded(child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: color.withOpacity(0.2)),
  //         borderRadius: BorderRadius.circular(14),
  //         color: color.withOpacity(0.05),
  //       ),
  //       child: Column(children: [
  //         Icon(icon, color: color, size: 22),
  //         const SizedBox(height: 8),
  //         Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
  //         const SizedBox(height: 4),
  //         Text(label, textAlign: TextAlign.center,
  //             style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _DS.textMid)),
  //       ]),
  //     ));
  // //   }
  // Widget _statCard({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  //   required Color color,
  //   required int total,
  // }) {
  //   final count = int.tryParse(value) ?? 0;
  //   final pct = total > 0 ? (count / total * 100).round() : 0;
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
  //       decoration: BoxDecoration(
  //         color: color.withOpacity(0.07),
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(color: color.withOpacity(0.2)),
  //       ),
  //       child: Column(
  //         children: [
  //           Icon(icon, color: color, size: 24),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w900,
  //               color: color,
  //             ),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               fontSize: 10,
  //               fontWeight: FontWeight.w600,
  //               color: _DS.textMid,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             "$pct%",
  //             style: TextStyle(
  //               fontSize: 10,
  //               fontWeight: FontWeight.w700,
  //               color: color.withOpacity(0.7),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String? getClassNameById(String? id) {
    final classes =
        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesModel?.data ??
        [];

    try {
      return classes.firstWhere((c) => c.classId.toString() == id).className;
    } catch (e) {
      return null;
    }
  }

  String? getSubjectNameById(String? id) {
    final subjects =
        Provider.of<AllSubjectsVieModel>(
          context,
          listen: false,
        ).allSubjectsModel?.data ??
        [];

    try {
      return subjects
          .firstWhere((s) => s.subjectId.toString() == id)
          .subjectName;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeworkVM = Provider.of<AllHomeWorkViewModel>(context);
    // final homeworkList = homeworkVM.allHomeworkModel?.data ?? <Data>[];
    final List<HomeworkData> homeworkList =
        (homeworkVM.allHomeworkModel?.data ?? []).cast<HomeworkData>();
    final isLoading = homeworkVM.loading;
    final filteredList = homeworkList.where((hw) {
      final matchClass = _filterClassId == null || hw.className?.toLowerCase() ==
              getClassNameById(_filterClassId)?.toLowerCase();
      final matchSubject = _filterSubjectId == null || hw.subjectName?.toLowerCase() ==
          getSubjectNameById(_filterSubjectId)?.toLowerCase();
      final submitted = int.tryParse(hw.submittedCount ?? "0") ?? 0;
      final pending = int.tryParse(hw.pendingCount ?? "0") ?? 0;
      final late = int.tryParse(hw.lateCount ?? "0") ?? 0;

      bool matchStatus = true;

      if (_filterStatus == "submitted") {
        matchStatus = submitted > 0;
      } else if (_filterStatus == "pending") {
        matchStatus = pending > 0;
      } else if (_filterStatus == "late") {
        matchStatus = late > 0;
      }

      return matchClass && matchSubject && matchStatus;
    }).toList();
    return Scaffold(
      backgroundColor: _DS.bg,
      floatingActionButton: _buildFAB(),
      body: Column(
        children: [
          _buildHeader(filteredList.length),
          _buildFilterRow(),
          Expanded(
            child: isLoading
                ? _shimmer()
                : filteredList.isEmpty
                ? _emptyView()
                : RefreshIndicator(
                    color: _DS.primary,
                    onRefresh: () async => homeworkVM.allHomeworkApi(context),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: filteredList.length,
                      itemBuilder: (_, i) => _animatedCard(i, filteredList[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // ✅ IMPORTANT
        child: Row(
          children: [
            /// Class
            SizedBox(
              width: 140,
              child: Consumer<AllClassesViewModel>(
                builder: (_, vm, __) {
                  final classes = vm.allClassesModel?.data ?? [];

                  return _styledDropdown<String>(
                    value: _filterClassId,
                    hint: "Class",
                    icon: Icons.class_,
                    items: classes.map((c) {
                      return DropdownMenuItem(
                        value: c.classId.toString(),
                        child: Text(c.className ?? ""),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() => _filterClassId = v);
                    },
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            /// Subject
            SizedBox(
              width: 150,
              child: Consumer<AllSubjectsVieModel>(
                builder: (_, vm, __) {
                  final subjects = vm.allSubjectsModel?.data ?? [];

                  return _styledDropdown<String>(
                    value: _filterSubjectId,
                    hint: "Subject",
                    icon: Icons.menu_book,
                    items: subjects.map((s) {
                      return DropdownMenuItem(
                        value: s.subjectId.toString(),
                        child: Text(s.subjectName ?? ""),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() => _filterSubjectId = v);
                    },
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            /// Status
            SizedBox(
              width: 160,
              child: _styledDropdown<String>(
                value: _filterStatus,
                hint: "Status",
                icon: Icons.filter_alt_rounded,
                items: const [
                  DropdownMenuItem(
                    value: "submitted",
                    child: Text("Submitted"),
                  ),
                  DropdownMenuItem(value: "pending", child: Text("Pending")),
                  DropdownMenuItem(value: "late", child: Text("Late")),
                ],
                onChanged: (v) {
                  setState(() => _filterStatus = v);
                },
              ),
            ),

            const SizedBox(width: 10),

            Container(
              height: 47,
              width: 48,
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.primary.withOpacity(.25)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColor.primary,
                ),
                onPressed: () async {
                  setState(() {
                    _filterClassId = null;
                    _filterSubjectId = null;
                    _filterStatus = null;
                  });

                  await Provider.of<AllHomeWorkViewModel>(
                    context,
                    listen: false,
                  ).allHomeworkApi(context);

                  Utils.show("Filters reset successfully", context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: const BoxDecoration(
        gradient: _DS.gradientHeader,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Homework",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      "Management Dashboard",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      "$count",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _headerStat("📚", "Total", "$count"),
              const SizedBox(width: 10),
              _headerStat("✅", "Active", "${(count * 0.7).round()}"),
              const SizedBox(width: 10),
              _headerStat("⏳", "Pending", "${(count * 0.3).round()}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.white60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: _DS.gradientHeader,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {

            if (!PermissionExtensions.canAccess(
                PermissionKeys.teacherCreateHomework)) {

              Utils.show(
                "You don't have permission to create homework",
                context,
              );

              return;
            }

            _showHomeworkBottomSheet();
          },
          borderRadius: BorderRadius.circular(18),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Add Homework",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedCard(int index, HomeworkData hw) {
    final submitted = int.tryParse(hw.submittedCount ?? "0") ?? 0;
    final pending = int.tryParse(hw.pendingCount ?? "0") ?? 0;
    final late = int.tryParse(hw.lateCount ?? "0") ?? 0;
    final total = hw.totalStudents ?? 1;
    final progress = total > 0 ? submitted / total : 0.0;
    final delay = index * 0.08;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: _DS.cardDecor(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ✅ Top red accent bar (web jaisa)
            Container(
              height: 4,
              decoration: const BoxDecoration(gradient: _DS.gradientHeader),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Row 1: Class•Section pill + Due date pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _pill(
                        "${hw.className ?? ''} – sec ${hw.sectionName ?? ''}",
                        _DS.primaryLight,
                        _DS.primary,
                        Icons.school_rounded,
                      ),
                      _pill(
                        "Due: ${_formatDate(hw.dueDate)}",
                        const Color(0xFFFFF3E0),
                        _DS.orange,
                        Icons.calendar_today_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ✅ Row 2: Subject icon + name (web jaisa bold heading)
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: _DS.gradientHeader,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hw.subjectName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _DS.textDark,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (hw.description?.isNotEmpty ?? false)
                              Text(
                                "Note: ${hw.description}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _DS.textMid,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ✅ Row 3: Total • Submitted • Pending (web ke 3 dots jaisa)
                  Row(
                    children: [
                      _dotStat("Total $total", Colors.grey),
                      const SizedBox(width: 16),
                      _dotStat("${submitted} Submitted", _DS.green),
                      const SizedBox(width: 16),
                      _dotStat("${pending} Pending", _DS.orange),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: _DS.primaryLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        _DS.primary,
                      ),
                    ),
                  ),

                  // ✅ Percentage right-aligned
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "${(progress * 100).round()}%",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _DS.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ✅ View Submissions button (web jaisa right-aligned)
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: loadingHomeworkId == hw.homeworkId
                          ? null
                          : () async {
                        if (!PermissionExtensions.canAccess(
                            PermissionKeys.viewHomework)) {

                          Utils.show(
                            "You don't have permission to view homework submissions",
                            context,
                          );

                          return;
                        }
                              setState(() {
                                loadingHomeworkId = hw.homeworkId;
                              });

                              try {
                                final vm =
                                    Provider.of<HomeworkDetailsViewModel>(
                                      context,
                                      listen: false,
                                    );

                                await vm.getHomeworkById(hw.homeworkId!);

                                if (!mounted) return;

                                _showSubmissionStatus(hw);
                              } catch (e) {
                                Utils.show(
                                  "Failed to load submissions",
                                  context,
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    loadingHomeworkId = null;
                                  });
                                }
                              }
                            },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: _DS.primary,
                        side: BorderSide(
                          color: AppColor.primary.withOpacity(.4),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        backgroundColor: AppColor.primaryLight,
                      ),

                      child: loadingHomeworkId == hw.homeworkId
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_forward_ios_rounded, size: 13),

                                SizedBox(width: 6),

                                Text(
                                  "View Submissions",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Naya helper widget — dot + label (web ke "● 0 Submitted" jaisa)
  Widget _dotStat(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _DS.textMid,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _pill(String text, Color bg, Color fg, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _statusChip(String label, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: color.withOpacity(0.2)),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         fontSize: 11,
  //         color: color,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: _DS.gradientHeader,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Homework Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _DS.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the button below to add homework",
            style: TextStyle(fontSize: 13, color: _DS.textLight),
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          height: 240,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _styledDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 12.5, color: _DS.textLight),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: _DS.textMid,
        size: 20,
      ),
      style: const TextStyle(
        fontSize: 14,
        color: _DS.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: _DS.bg,
        prefixIcon: Icon(icon, size: 18, color: _DS.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _DS.border, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _DS.primary, width: 1.8),
        ),
      ),
    );
  }

  InputDecoration _inputDeco({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _DS.textLight, fontSize: 13.5),
      filled: true,
      fillColor: _DS.bg,
      prefixIcon: Icon(icon, size: 18, color: _DS.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _DS.border, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _DS.primary, width: 1.8),
      ),
    );
  }

  Widget _loadingField() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // SnackBar _snackBar(String msg, {bool isError = false}) {
  //   return SnackBar(
  //     content: Row(
  //       children: [
  //         Icon(
  //           isError ? Icons.error_outline : Icons.check_circle_outline,
  //           color: Colors.white,
  //           size: 18,
  //         ),
  //         const SizedBox(width: 10),
  //         Text(
  //           msg,
  //           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
  //         ),
  //       ],
  //     ),
  //     backgroundColor: isError ? _DS.red : _DS.green,
  //     behavior: SnackBarBehavior.floating,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     margin: const EdgeInsets.all(16),
  //   );
  // }
}

class _FormLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  const _FormLabel(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _DS.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _DS.textDark,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
