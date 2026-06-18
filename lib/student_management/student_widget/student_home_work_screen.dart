import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/student_view_model/student_home_work_view_model.dart';
import 'package:school_pro/view_model/student_view_model/submit_home_work_view_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/student_model/student_home_work_model.dart';
import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import 'homework_submission_details_screen.dart';

class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {

  bool _pdfLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (!PermissionExtensions.canAccess(
        PermissionKeys.viewHomework,
      )) {

        Utils.show(
          "You don't have permission to view Homework",
          context,
        );

        Navigator.pop(context);
        return;
      }

      Provider.of<StudentHomeworkViewModel>(
        context,
        listen: false,
      ).studentHomeWorkApi(context);
    });
  }


  Future<void> _refreshHomework() async {
    if (!PermissionExtensions.canAccess(
      PermissionKeys.viewHomework,
    )) {

      Utils.show(
        "You don't have permission to view Homework",
        context,
      );

      Navigator.pop(context);
      return;
    }
    await Provider.of<StudentHomeworkViewModel>(
      context,
      listen: false,
    ).studentHomeWorkApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        children: [
          /// 🔹 Header
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
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
                    "Home Work",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Homework List
          Expanded(
            child: Consumer<StudentHomeworkViewModel>(
              builder: (context, vm, child) {
                if (vm.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.homeworkList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 60,
                          color: AppColor.sub.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        AppText.customText(
                          "No Homework Found",
                          size: 16,
                          weight: FontWeight.w500,
                          color: AppColor.sub,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshHomework,
                  child: ListView.builder(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    itemCount: vm.homeworkList.length,
                    itemBuilder: (context, index) {
                      return _buildHomeworkCard(
                        vm.homeworkList[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(StudentProfileData data) {
    final bool isSubmitted =
        data.status == "submitted" || data.submittedAt != null;

    final bool isOnline = data.allowSubmission == 1;

    final bool isOffline =
        data.allowSubmission == 0 || data.allowSubmission == null;

    final bool showPending = !isSubmitted && isOnline;

    final bool showSubmitted = isSubmitted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSubmitted
                  ? Colors.green.withOpacity(0.08)
                  : Colors.orange.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isSubmitted ? Colors.green : Colors.orange)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: isSubmitted ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText(
                    data.subjectName ?? "",
                    size: 16,
                    weight: FontWeight.w600,
                    color: AppColor.text,
                  ),
                ),
                if (showSubmitted)
                  const _StatusBadge(
                    isSubmitted: true,
                    status: "Submitted",
                  ),

                if (showPending)
                  const _StatusBadge(
                    isSubmitted: false,
                    status: "Pending",
                  ),              ],
            ),
          ),

          /// Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText(
                  data.title ?? "",
                  size: 15,
                  weight: FontWeight.w600,
                  color: AppColor.text,
                ),
                const SizedBox(height: 6),
                AppText.customText(
                  data.description ?? "",
                  size: 14,
                  weight: FontWeight.w400,
                  color: AppColor.sub,
                ),
                const SizedBox(height: 10),

                if (data.dueDate != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColor.sub,
                      ),
                      const SizedBox(width: 6),

                      AppText.customText(
                        data.dueDate == null
                            ? "No due date"
                            : "Due ${DateFormat('MMM d, yyyy').format(
                          DateTime.parse(data.dueDate!),
                        )}",
                        size: 12,
                        weight: FontWeight.w500,
                        color: data.dueDate == null
                            ? AppColor.sub
                            : Colors.red,
                      ),
                    ],
                  ),

                if (data.attachment != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _openPdf(data.attachment!.url ?? "");
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              data.attachment!.url!
                                  .split('/')
                                  .last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const Icon(Icons.open_in_new),
                        ],
                      ),
                    ),
                  ),
                if (data.attachmentPhotos != null &&
                    data.attachmentPhotos!.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _openImagePreview(
                        context,
                        data.attachmentPhotos!,
                        0,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image,
                            color: Colors.green,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "${data.attachmentPhotos!.length} photo attached",
                            ),
                          ),

                          const Icon(Icons.open_in_full),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                if (isSubmitted)

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {

                        if (!PermissionExtensions.canAccess(
                            PermissionKeys.viewHomework)) {

                          Utils.show(
                            "You don't have permission to view homework",
                            context,
                          );

                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                HomeworkSubmissionDetailsScreen(
                                  homework: data,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xff16a34a),
                      ),
                      label: Text(
                        "View Submission",
                        style: GoogleFonts.poppins(),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff15803d),
                        side: const BorderSide(
                          color: Color(0xff86efac),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  )

                else if (isOnline)

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {

                        if (!PermissionExtensions.canAccess(
                            PermissionKeys.submitHomework)) {

                          Utils.show(
                            "You don't have permission to submit homework",
                            context,
                          );

                          return;
                        }

                        _openSubmitBottomSheet(data);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Submit Homework",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  )

                else if (isOffline)

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.school_outlined,
                        ),
                        label: Text(
                          "Submit At School",
                          style: GoogleFonts.poppins(),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xffb45309),
                          disabledForegroundColor:
                          const Color(0xffb45309),
                          side: const BorderSide(
                            color: Color(0xfffcd34d),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Submit Bottom Sheet
  void _openSubmitBottomSheet(StudentProfileData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SubmitHomeworkSheet(homeworkData: data),
    );
  }

  Future<void> _openPdf(String url) async {
    if (_pdfLoading) return;

    setState(() {
      _pdfLoading = true;
    });

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            url: url,
          ),
        ),
      );
    } catch (e) {
      debugPrint("PDF Error => $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to open PDF"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _pdfLoading = false;
        });
      }
    }
  }


  void _openImagePreview(
      BuildContext context,
      List<HomeworkAttachment> photos,
      int initialIndex,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkImagePreviewScreen(
          photos: photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}


class PdfViewerScreen extends StatelessWidget {
  final String url;

  const PdfViewerScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework PDF"),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isSubmitted;
  final String status;
  const _StatusBadge({required this.isSubmitted, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSubmitted ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSubmitted ? Icons.check : Icons.hourglass_empty_rounded,
            color: Colors.white,
            size: 11,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}


class _SubmitHomeworkSheet extends StatefulWidget {
  final StudentProfileData homeworkData;
  const _SubmitHomeworkSheet({required this.homeworkData});

  @override
  State<_SubmitHomeworkSheet> createState() => _SubmitHomeworkSheetState();
}

class _SubmitHomeworkSheetState extends State<_SubmitHomeworkSheet> {
  File? _selectedPdf;
  String? _selectedPdfName;
  bool _isSubmitting = false;

  // ✅ PDF picker — only PDF, max 1MB
  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // ✅ Only PDF
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    // ✅ Size check — 1MB = 1 * 1024 * 1024 bytes
    if (file.size > 1 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text("PDF size must be less than 1 MB"),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
      return;
    }

    setState(() {
      _selectedPdf = File(file.path!);
      _selectedPdfName = file.name;
    });
  }

  Future<void> _submitHomework() async {
    if (_selectedPdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline,
                  color: Colors.white,
                  size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Please select a PDF to submit",
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final submitHomeworkVm =
      Provider.of<SubmitHomeworkViewModel>(
        context,
        listen: false,
      );

      final response =
      await submitHomeworkVm.submitHomeworkApi(
        context: context,
        homeworkId: widget
            .homeworkData.homeworkId
            .toString(),
        attachments: _selectedPdf!,
      );

      if (!mounted) return;

      /// SUCCESS
      if (response == true) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Homework submitted successfully!",
                  ),
                ),
              ],
            ),
            backgroundColor:
            Colors.green.shade600,
            behavior:
            SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
            margin:
            const EdgeInsets.all(12),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: const Text(
              "Homework submission failed",
            ),
            backgroundColor: Colors.red,
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
          "Homework Submit Error: $e");
      debugPrintStack(
          stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to submit: ${e.toString()}",
          ),
          backgroundColor: Colors.red,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ✅ File size readable format
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assignment_turned_in_rounded,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                          "Submit Homework",
                          size: 17,
                          weight: FontWeight.w700,
                          color: AppColor.text,
                        ),
                        AppText.customText(
                          widget.homeworkData.subjectName ?? "",
                          size: 13,
                          weight: FontWeight.w400,
                          color: AppColor.sub,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),
              const Divider(height: 1),
              SizedBox(height: screenHeight * 0.02),

              // Label + size hint
              Row(
                children: [
                  AppText.customText(
                    "Attach PDF *",
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColor.text,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      "Max 1 MB",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ✅ PDF selected preview OR pick button
              if (_selectedPdf != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Colors.red.shade700,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedPdfName ?? "document.pdf",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _formatSize(_selectedPdf!.lengthSync()),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Remove button
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedPdf = null;
                          _selectedPdfName = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.red.shade700,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: _pickPdf,
                    icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                    label: const Text("Change PDF"),
                  ),
                ),
              ] else ...[
                // ✅ Pick PDF button
                GestureDetector(
                  onTap: _pickPdf,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      color: AppColor.primary.withValues(alpha: 0.04),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColor.primary,
                          size: 36,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap to select PDF",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Only .pdf files * Max size 1 MB",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: screenHeight * 0.02),

              AppButton(
                title: "Submit Homework",
                icon: Icons.send_rounded,
                loading: _isSubmitting,
                onTap: _submitHomework,
                bgColor: AppColor.primary,
                textColor: Colors.white,
              ),

              SizedBox(height: screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}


class HomeworkImagePreviewScreen extends StatefulWidget {
  final List<HomeworkAttachment> photos;
  final int initialIndex;

  const HomeworkImagePreviewScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<HomeworkImagePreviewScreen> createState() =>
      _HomeworkImagePreviewScreenState();
}

class _HomeworkImagePreviewScreenState
    extends State<HomeworkImagePreviewScreen> {

  late final PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: PageView.builder(
        controller: _controller,
        itemCount: widget.photos.length,

        itemBuilder: (_, index) {
          return PhotoView(
            imageProvider: NetworkImage(
              widget.photos[index].url ?? "",
            ),
            minScale:
            PhotoViewComputedScale.contained,
            maxScale:
            PhotoViewComputedScale.covered * 3,
          );
        },
      ),
    );
  }
}
