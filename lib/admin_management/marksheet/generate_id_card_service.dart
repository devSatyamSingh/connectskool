// ════════════════════════════════════════════════════════════════════════════
// generate_id_card_service.dart  —  Production-ready  (matches website UI 1:1)
//
// Usage:
//   IdCardPdfService.showOptions(
//     context: context,
//     model:   vm.admitCardModel!,
//   );
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../model/school_model/marksheet/generate_admit_card_model.dart';

class IdCardPdfService {
  // ════════════════════════════════════════════════════════════════════════════
  // BUILD PDF BYTES — Portrait ID card (A6-ish: 105 × 148 mm)
  // ════════════════════════════════════════════════════════════════════════════
  static Future<Uint8List> buildPdfBytes(GenerateAdmitCardModel model) async {
    final pdf = pw.Document();
    final data = model.data;
    final student = data?.students?.firstOrNull;
    final school = data?.schoolInfo;
    final cls = data?.classInfo;

    // A6 portrait — fits a nice ID card with margin
    const pageW = 105.0 * PdfPageFormat.mm;
    const pageH = 148.0 * PdfPageFormat.mm;

    // Try to load student photo from network
    pw.ImageProvider? photo;
    try {
      final url = student?.studentPhoto;
      if (url != null && url.isNotEmpty) {
        photo = await networkImage(url);
      }
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(pageW, pageH, marginAll: 0),
        build: (ctx) => _buildCard(student, school, cls, photo, data),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  // ── Card layout — matches website design 1:1 ─────────────────────────────
  static pw.Widget _buildCard(
    Students? student,
    SchoolInfo? school,
    ClassInfo? cls,
    pw.ImageProvider? photo,
    AdmitCardResponseData? data,
  ) {
    // ── Colors
    const red = PdfColor.fromInt(0xFFCC0000);
    const redLight = PdfColor.fromInt(0xFFFFEEEE);
    const white = PdfColors.white;
    const darkText = PdfColor.fromInt(0xFF1A1A1A);
    const greyLabel = PdfColor.fromInt(0xFFCC0000); // website uses red labels
    const greyValue = PdfColor.fromInt(0xFF333333);
    const borderC = PdfColor.fromInt(0xFFDDDDDD);
    const bgGrey = PdfColor.fromInt(0xFFF5F5F5);

    final schoolName = school?.schoolName ?? '';
    final schoolAddress = school?.address ?? '';
    final schoolPhone = school?.phone ?? '';
    final academicYear = data?.examInfo?.academicYear ?? '';
    final className = '${cls?.className ?? ''} ${cls?.sectionName ?? ''}'
        .trim();

    // Format DOB
    String dob = student?.dob ?? '—';
    if (dob.contains('T')) dob = dob.split('T').first;

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: white,
        border: pw.Border.all(color: borderC, width: 0.5),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          // ── RED SCHOOL HEADER ─────────────────────────────────────────────
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: const pw.BoxDecoration(
              color: red,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              children: [
                // School initial in white rounded box
                pw.Container(
                  width: 34,
                  height: 34,
                  decoration: pw.BoxDecoration(
                    color: white,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      schoolName.isNotEmpty ? schoolName[0].toUpperCase() : 'S',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: red,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        schoolName,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: white,
                        ),
                      ),
                      if (schoolAddress.isNotEmpty)
                        pw.Text(
                          schoolAddress,
                          style: pw.TextStyle(
                            fontSize: 7,
                            color: PdfColors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'ID CARD',
                    style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Center(
            child: pw.Container(
              width: 72,
              height: 88,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: red, width: 2),
                borderRadius: pw.BorderRadius.circular(6),
                color: bgGrey,
              ),
              child: photo != null
                  ? pw.ClipRRect(
                      horizontalRadius: 5,
                      verticalRadius: 5,
                      child: pw.Image(photo, fit: pw.BoxFit.cover),
                    )
                  : pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 28,
                          height: 28,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: PdfColors.grey300,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'PHOTO',
                          style: pw.TextStyle(
                            fontSize: 7,
                            color: PdfColors.grey500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          pw.SizedBox(height: 10),

          // ── STUDENT NAME (bold, centered, caps) ───────────────────────────
          pw.Center(
            child: pw.Text(
              (student?.name ?? '').toUpperCase(),
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: darkText,
              ),
            ),
          ),

          if (academicYear.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Center(
              child: pw.Text(
                academicYear,
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ),
          ],

          pw.SizedBox(height: 8),

          // ── DIVIDER ───────────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14),
            child: pw.Divider(color: borderC, thickness: 0.6),
          ),

          pw.SizedBox(height: 6),

          // ── INFO GRID — two columns ───────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Column(
              children: [
                // Row 1: Class-Sec + Roll No
                _infoGrid(
                  l1: 'Class-Sec',
                  v1: className,
                  l2: 'Roll No.',
                  v2: student?.rollNo?.toString() ?? '—',
                  lc: greyLabel,
                  vc: greyValue,
                ),
                pw.SizedBox(height: 5),
                // Row 2: D.O.B + Reg. No.
                _infoGrid(
                  l1: 'D.O.B.',
                  v1: dob,
                  l2: 'Reg. No.',
                  v2: student?.regNo ?? '—',
                  lc: greyLabel,
                  vc: greyValue,
                ),
                pw.SizedBox(height: 5),
                // Row 3: Father (full width)
                _infoSingle(
                  label: 'Father',
                  value: student?.fatherName ?? '—',
                  lc: greyLabel,
                  vc: greyValue,
                ),
                pw.SizedBox(height: 5),
                // Row 4: Mother (full width)
                _infoSingle(
                  label: 'Mother',
                  value: student?.motherName ?? '—',
                  lc: greyLabel,
                  vc: greyValue,
                ),
                pw.SizedBox(height: 5),
                // Row 5: Address (full width, wrapping)
                _infoSingle(
                  label: 'Address',
                  value: student?.address ?? '—',
                  lc: greyLabel,
                  vc: greyValue,
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 10),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14),
            child: pw.Divider(color: borderC, thickness: 0.6),
          ),
          pw.SizedBox(height: 8),

          // ── SIGNATURES ────────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _sigBlock('Student Signature'),
                _sigBlock('Principal Signature'),
              ],
            ),
          ),

          pw.SizedBox(height: 10),

          // ── RED FOOTER — school contact ───────────────────────────────────
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            decoration: const pw.BoxDecoration(
              color: red,
              borderRadius: pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(10),
                bottomRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Center(
              child: pw.Text(
                schoolPhone.isNotEmpty
                    ? 'School Contact # $schoolPhone'
                    : schoolName,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Two-column info row ──────────────────────────────────────────────────────
  static pw.Widget _infoGrid({
    required String l1,
    required String v1,
    required String l2,
    required String v2,
    required PdfColor lc,
    required PdfColor vc,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _infoSingle(label: l1, value: v1, lc: lc, vc: vc),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _infoSingle(label: l2, value: v2, lc: lc, vc: vc),
        ),
      ],
    );
  }

  // ── Single label : value row ─────────────────────────────────────────────────
  static pw.Widget _infoSingle({
    required String label,
    required String value,
    required PdfColor lc,
    required PdfColor vc,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 46,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 7.5,
              color: lc,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Text(
          ' : ',
          style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
              color: vc,
            ),
          ),
        ),
      ],
    );
  }

  // ── Signature block ──────────────────────────────────────────────────────────
  static pw.Widget _sigBlock(String label) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 100,
          height: 22,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black, width: 0.6),
            ),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 7, color: PdfColors.black),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ════════════════════════════════════════════════════════════════════════════
  static void showOptions({
    required BuildContext context,
    required GenerateAdmitCardModel model,
  }) {
    final students = model.data?.students ?? [];
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No ID card data available',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC0000).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.badge_rounded,
                    color: Color(0xFFCC0000),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ID Card PDF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A5C),
                      ),
                    ),
                    Text(
                      '${students.length} student(s) * '
                      '${model.data?.schoolInfo?.schoolName ?? ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            // Share / Print
            _optionTile(
              icon: Icons.share_rounded,
              iconColor: const Color(0xFF2C7BBF),
              bgColor: const Color(0xFFEBF5FF),
              title: 'Share / Print',
              subtitle: 'Share via WhatsApp, email, or print',
              onTap: () {
                Navigator.pop(context);
                _shareOrPrint(context, model);
              },
            ),
            const SizedBox(height: 10),
            // Download
            _optionTile(
              icon: Icons.download_rounded,
              iconColor: const Color(0xFF1B8B5A),
              bgColor: const Color(0xFFE8F8F1),
              title: 'Download PDF',
              subtitle: Platform.isAndroid
                  ? 'Save to Downloads folder'
                  : 'Save to Files app',
              onTap: () {
                Navigator.pop(context);
                _download(context, model);
              },
            ),
            const SizedBox(height: 10),
            // Cancel
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Share / Print ─────────────────────────────────────────────────────────────
  static Future<void> _shareOrPrint(
    BuildContext context,
    GenerateAdmitCardModel model,
  ) async {
    final bytes = await buildPdfBytes(model);
    final name = _fileName(model);
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: name);
  }

  // ── Download ──────────────────────────────────────────────────────────────────
  static Future<void> _download(
    BuildContext context,
    GenerateAdmitCardModel model,
  ) async {
    try {
      _showLoadingDialog(context);
      final bytes = await buildPdfBytes(model);
      final fileName = _fileName(model);

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir =
              (await getExternalStorageDirectory()) ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${dir.path}/$fileName';
      await File(filePath).writeAsBytes(bytes, flush: true);

      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID Card Downloaded!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        filePath,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1B8B5A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () => OpenFile.open(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Download failed: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFD94040),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  static String _fileName(GenerateAdmitCardModel model) {
    final student = model.data?.students?.firstOrNull;
    final name = (student?.name ?? 'Student').replaceAll(' ', '_');
    return '${name}_IDCard.pdf';
  }

  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Row(
            children: [
              const CircularProgressIndicator(
                color: Color(0xFFCC0000),
                strokeWidth: 3,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Generating ID Card...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A5C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please wait',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _optionTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: iconColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
