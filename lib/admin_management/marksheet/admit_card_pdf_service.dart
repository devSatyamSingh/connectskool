// ════════════════════════════════════════════════════════════════════════════
// admit_card_pdf_service.dart  —  Production-ready  (matches website UI 1:1)
//
// Usage:
//   AdmitCardPdfService.showOptions(
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

class AdmitCardPdfService {
  // ── Palette (matches website exactly) ──────────────────────────────────────
  static final _navy = PdfColor.fromHex('#1A3A5C'); // header text
  static final _red = PdfColor.fromHex('#CC0000'); // label red
  static final _headerBg = PdfColor.fromHex('#F5F5F5'); // table header bg
  static final _rowAlt = PdfColor.fromHex('#FAFAFA'); // alt row bg
  static final _border = PdfColor.fromHex('#DDDDDD'); // all borders
  static final _grey = PdfColor.fromHex('#666666'); // sub text
  static final _lightGrey = PdfColor.fromHex('#999999'); // photo text
  static final _black = PdfColors.black;
  static final _white = PdfColors.white;

  // ── Accent badge bg (purple-blue tint like website "Admit Card" badge) ─────
  static final _badgeBg = PdfColor.fromHex('#EEF2FF');
  static final _badgeText = PdfColor.fromHex('#4F46E5');

  // ════════════════════════════════════════════════════════════════════════════
  // BUILD PDF BYTES
  // ════════════════════════════════════════════════════════════════════════════
  static Future<Uint8List> buildPdfBytes(GenerateAdmitCardModel model) async {
    final pdf = pw.Document();
    final data = model.data!;

    final schoolName = data.schoolInfo?.schoolName ?? 'School Name';
    final schoolAddress = data.schoolInfo?.address ?? '';
    final schoolPhone = data.schoolInfo?.phone ?? '';
    final schoolEmail = data.schoolInfo?.email ?? '';
    final examName = data.examInfo?.examName ?? '';
    final className = data.classInfo?.className ?? '';
    final sectionName = data.classInfo?.sectionName ?? '';
    final instructions = (data.instructions?.isNotEmpty == true)
        ? data.instructions!
        : [
            'Re-Examination will not be conducted in any circumstances.',
            'All the students will report in the school at 07:30 A.M Sharp.',
          ];

    for (final student in data.students ?? <Students>[]) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          build: (ctx) => _buildCard(
            student: student,
            schoolName: schoolName,
            schoolAddr: schoolAddress,
            schoolPhone: schoolPhone,
            schoolEmail: schoolEmail,
            examName: examName,
            className: '$className $sectionName'.trim(),
            instructions: instructions,
          ),
        ),
      );
    }

    return Uint8List.fromList(await pdf.save());
  }

  // ── Single admit card ────────────────────────────────────────────────────────
  static pw.Widget _buildCard({
    required Students student,
    required String schoolName,
    required String schoolAddr,
    required String schoolPhone,
    required String schoolEmail,
    required String examName,
    required String className,
    required List<String> instructions,
  }) {
    final schedule = student.examSchedule ?? [];

    // Format DOB — strip time component if ISO
    String dob = student.dob ?? '—';
    if (dob.contains('T')) dob = dob.split('T').first;

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _white,
        border: pw.Border.all(color: _border, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // ── SCHOOL HEADER ─────────────────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Logo circle — matches website purple-tinted circle with initial
                pw.Container(
                  width: 56,
                  height: 56,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: _badgeBg,
                    border: pw.Border.all(color: _badgeText, width: 1.5),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      schoolName.isNotEmpty ? schoolName[0].toUpperCase() : 'S',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: _badgeText,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 14),
                // School info + "Admit Card" badge
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        schoolName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: _navy,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        [
                          if (schoolAddr.isNotEmpty) schoolAddr,
                          if (schoolEmail.isNotEmpty) schoolEmail,
                          if (schoolPhone.isNotEmpty)
                            'Phone No. +91-$schoolPhone',
                        ].join(' | '),
                        style: pw.TextStyle(fontSize: 7.5, color: _grey),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 8),
                      // "Admit Card" pill badge — matches website purple pill
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 5,
                        ),
                        decoration: pw.BoxDecoration(
                          color: _badgeText,
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: pw.Text(
                          'Admit Card',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: _white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.Divider(color: _border, thickness: 0.8),

          // ── STUDENT INFO ──────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left: student fields
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                        'Name',
                        (student.name ?? '—').toUpperCase(),
                        bold: true,
                      ),
                      _infoRow(
                        'Class-Sec',
                        className,
                        extra:
                            '         Roll No. :  '
                            '${student.rollNo?.toString() ?? '—'}',
                        extraBold: true,
                      ),
                      _infoRow(
                        'D.O.B.',
                        dob,
                        extra:
                            '         Reg. No. :  '
                            '${student.regNo ?? '—'}',
                        extraBold: true,
                        extraRed: true,
                      ),
                      _infoRow('Father', student.fatherName ?? '—'),
                      _infoRow('Mother', student.motherName ?? '—'),
                      _infoRow('Address', student.address ?? '—'),
                    ],
                  ),
                ),
                pw.SizedBox(width: 14),
                // Photo box — matches grey dashed-style box on website
                pw.Container(
                  width: 72,
                  height: 88,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _border, width: 1),
                    borderRadius: pw.BorderRadius.circular(4),
                    color: PdfColor.fromHex('#F5F5F5'),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 28,
                        height: 28,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: _border,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Photo',
                        style: pw.TextStyle(fontSize: 8, color: _lightGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── EXAM SCHEDULE TABLE ───────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: pw.Table(
              border: pw.TableBorder.all(color: _border, width: 0.6),
              columnWidths: const {
                0: pw.FlexColumnWidth(2.2), // Exam Date
                1: pw.FlexColumnWidth(1.1), // Shift
                2: pw.FlexColumnWidth(2.6), // Exam Time
                3: pw.FlexColumnWidth(2.4), // Subject Name
                4: pw.FlexColumnWidth(1.6), // Signature
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: _headerBg),
                  children: [
                    _th('Exam Date'),
                    _th('Shift'),
                    _th('Exam Time'),
                    _th('Subject Name'),
                    _th('Signature'),
                  ],
                ),
                // Rows
                ...schedule.asMap().entries.map((e) {
                  final isEven = e.key % 2 == 0;
                  final row = e.value;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: isEven ? _white : _rowAlt,
                    ),
                    children: [
                      _td(
                        '${row.day ?? ''} ${row.examDate ?? ''}'.trim(),
                        bold: true,
                      ),
                      _td(row.shift ?? '—'),
                      _td(row.timeRange),
                      _td(row.subjectName ?? '—'),
                      _td(''), // blank signature cell
                    ],
                  );
                }),
                if (schedule.isEmpty)
                  pw.TableRow(
                    children: List.generate(
                      5,
                      (_) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          '—',
                          style: pw.TextStyle(fontSize: 8, color: _grey),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── INSTRUCTIONS ──────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Important Instructions to be strictly complied with –',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: _red,
                  ),
                ),
                pw.SizedBox(height: 5),
                ...instructions.map(_bullet),
              ],
            ),
          ),

          pw.Divider(color: _border, thickness: 0.6),

          // ── SIGNATURES ────────────────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _signatureLine('Student Signature'),
                _signatureLine('Principal Signature & Stamp'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoRow(
    String label,
    String value, {
    bool bold = false,
    String? extra,
    bool extraBold = false,
    bool extraRed = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 62,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 8,
                color: _red,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Text(' : ', style: pw.TextStyle(fontSize: 8, color: _black)),
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: value,
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: bold
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal,
                      color: _black,
                    ),
                  ),
                  if (extra != null)
                    pw.TextSpan(
                      text: extra,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: extraBold
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                        color: extraRed ? _red : _black,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _th(String text) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        color: _black,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );

  static pw.Widget _td(String text, {bool bold = false}) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: _black,
      ),
    ),
  );

  static pw.Widget _bullet(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(left: 6, bottom: 3),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Text(
            text,
            style: pw.TextStyle(fontSize: 7.5, color: _black),
          ),
        ),
      ],
    ),
  );

  static pw.Widget _signatureLine(String label) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Container(
        width: 130,
        height: 30,
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _black, width: 0.8)),
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Text(label, style: pw.TextStyle(fontSize: 8, color: _black)),
    ],
  );


  static void showOptions({
    required BuildContext context,
    required GenerateAdmitCardModel model,
  }) {
    final students = model.data?.students ?? [];
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No admit card data available',
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
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            // Title row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFF4F46E5),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admit Card PDF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A5C),
                      ),
                    ),
                    Text(
                      '${students.length} student(s) '
                      '${model.data?.examInfo?.examName ?? ''}',
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

  static Future<void> _shareOrPrint(
    BuildContext context,
    GenerateAdmitCardModel model,
  ) async {
    final bytes = await buildPdfBytes(model);
    final name = _fileName(model);
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: name);
  }

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
                      Text(
                        'PDF Downloaded!',
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
            backgroundColor: Color(0xFFD94040),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  static String _fileName(GenerateAdmitCardModel model) {
    final student = model.data?.students?.firstOrNull;
    final name = (student?.name ?? 'Student').replaceAll(' ', '_');
    final exam = (model.data?.examInfo?.examName ?? 'Exam').replaceAll(
      ' ',
      '_',
    );
    return '${name}_${exam}_AdmitCard.pdf';
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
                color: Color(0xFF4F46E5),
                strokeWidth: 3,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Generating PDF...',
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
