import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:school_pro/student_management/student_widget/student_home_work_screen.dart';

import '../../../model/student_model/student_home_work_model.dart';
import '../../../res/app_color.dart';
import '../../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';

class HomeworkSubmissionDetailsScreen extends StatelessWidget {
  final StudentProfileData homework;

  const HomeworkSubmissionDetailsScreen({super.key, required this.homework});

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return "-";
    }

    try {
      return DateFormat('MMM dd, yyyy * hh:mm a').format(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherPdfCount = homework.attachment != null ? 1 : 0;

    final teacherPhotoCount = homework.attachmentPhotos?.length ?? 0;

    final submittedPdfCount = homework.submittedFile != null ? 1 : 0;

    final submittedPhotoCount = homework.submittedPhotos?.length ?? 0;
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewHomework)) {

      return const Scaffold(
        body: Center(
          child: Text(
            "You don't have permission",
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.bg,
        body: Column(
          children: [
            /// Header
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                          "Submission Details",
                          size: 17,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 2),

                        AppText.customText(
                          homework.subjectName ?? "Homework",
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          "Submitted",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                      homework.title ?? homework.description ?? "Homework",
                      size: 20,
                      weight: FontWeight.w500,
                      color: AppColor.text,
                    ),

                    const SizedBox(height: 20),

                    /// Submission Status Card
                    SubmissionHeaderCard(
                      submittedAt: _formatDate(homework.submittedAt),
                      dueDate: _formatDate(homework.dueDate),
                    ),

                    const SizedBox(height: 16),

                    /// Summary
                    SubmissionSummaryCard(
                      subject: homework.subjectName ?? "",
                      teacherPdf: teacherPdfCount,
                      teacherPhotos: teacherPhotoCount,
                      yourPdf: submittedPdfCount,
                      yourPhotos: submittedPhotoCount,
                    ),

                    const SizedBox(height: 16),

                    /// Teacher Files
                    TeacherFilesSection(homework: homework),

                    const SizedBox(height: 16),

                    /// Submitted Files
                    SubmittedFilesSection(homework: homework),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Back To Homework"),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmissionHeaderCard extends StatelessWidget {
  final String submittedAt;
  final String dueDate;

  const SubmissionHeaderCard({
    super.key,
    required this.submittedAt,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff0fdf4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffbbf7d0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xffdcfce7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xffbbf7d0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xff16a34a),
                    size: 30,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Submission Received",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff14532d),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        submittedAt,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Color(0xff15803d),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.calendar_today,
                    title: "Due Date",
                    value: dueDate,
                    bgColor: const Color(0xfff8fafc),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _InfoTile(
                    icon: Icons.access_time,
                    title: "Submitted At",
                    value: submittedAt,
                    bgColor: const Color(0xffecfdf5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color bgColor;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xff64748b)),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Color(0xff64748b),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff0f172a),
            ),
          ),
        ],
      ),
    );
  }
}

class SubmissionSummaryCard extends StatelessWidget {
  final String subject;

  final int teacherPdf;
  final int teacherPhotos;

  final int yourPdf;
  final int yourPhotos;

  const SubmissionSummaryCard({
    super.key,
    required this.subject,
    required this.teacherPdf,
    required this.teacherPhotos,
    required this.yourPdf,
    required this.yourPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffe2e8f0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SUMMARY",
            style: GoogleFonts.poppins(
              fontSize: 13,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              color: Color(0xff94a3b8),
            ),
          ),

          const SizedBox(height: 18),

          _summaryRow("Subject", subject, Colors.black87),

          _summaryRow(
            "Teacher PDF",
            "$teacherPdf file",
            const Color(0xff7c3aed),
          ),

          _summaryRow(
            "Teacher Photos",
            "$teacherPhotos photo",
            const Color(0xff7c3aed),
          ),

          const Divider(height: 24),

          _summaryRow("Your PDF", "$yourPdf file", const Color(0xff16a34a)),

          _summaryRow(
            "Your Photos",
            "$yourPhotos photo",
            const Color(0xff16a34a),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(fontSize: 15, color: Color(0xff64748b)),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherFilesSection extends StatelessWidget {
  final StudentProfileData homework;

  const TeacherFilesSection({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    final pdf = homework.attachment;
    final photos = homework.attachmentPhotos ?? [];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffe2e8f0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xfff5f3ff),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffddd6fe)),
            ),
            child: Row(
              children: [
                Icon(Icons.menu_book_outlined, color: Color(0xff7c3aed)),
                SizedBox(width: 10),
                Text(
                  "TEACHER'S ASSIGNMENT FILES",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Color(0xff7c3aed),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (pdf != null)
            _PdfCard(
              title: "ASSIGNMENT PDF",
              fileName: pdf.url?.split('/').last ?? "document.pdf",
              color: const Color(0xffef4444),
              pdfUrl: pdf.url ?? "",
            ),

          if (photos.isNotEmpty) ...[
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.photo_library, color: Color(0xff7c3aed)),
                const SizedBox(width: 8),
                const Text(
                  "ASSIGNMENT PHOTOS",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xff64748b),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffede9fe),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${photos.length} photo"),
                ),
              ],
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9,
              ),
              itemBuilder: (_, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeworkImagePreviewScreen(
                            photos: photos,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        photos[index].url ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PdfCard extends StatelessWidget {
  final String title;
  final String fileName;
  final Color color;
  final String pdfUrl;

  const _PdfCard({
    required this.title,
    required this.fileName,
    required this.color,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.picture_as_pdf, color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xff94a3b8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              await Future.delayed(const Duration(milliseconds: 300));

              if (context.mounted) {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewerScreen(url: pdfUrl),
                  ),
                );
              }
            },
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
    );
  }
}

class SubmittedFilesSection extends StatelessWidget {
  final StudentProfileData homework;

  const SubmittedFilesSection({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    final pdf = homework.submittedFile;
    final photos = homework.submittedPhotos ?? [];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xfff0fdf4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffbbf7d0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xffdcfce7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff16a34a)),
                SizedBox(width: 10),
                Text(
                  "YOUR SUBMITTED FILES",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: Color(0xff15803d),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (pdf != null)
            _SubmittedPdfCard(
              fileName: pdf.url?.split('/').last ?? '',
              pdfUrl: pdf.url ?? '',
            ),

          if (photos.isNotEmpty) ...[
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.image, color: Color(0xff16a34a)),
                const SizedBox(width: 8),
                const Text(
                  "YOUR PHOTOS",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffdcfce7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${photos.length} photo"),
                ),
              ],
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9,
              ),
              itemBuilder: (_, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeworkImagePreviewScreen(
                            photos: photos,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        photos[index].url ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SubmittedPdfCard extends StatelessWidget {
  final String fileName;
  final String pdfUrl;

  const _SubmittedPdfCard({required this.fileName, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfffef2f2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xfffecaca)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xfffee2e2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.picture_as_pdf, color: Color(0xffef4444)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PdfViewerScreen(url: pdfUrl)),
              );
            },
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
    );
  }
}
