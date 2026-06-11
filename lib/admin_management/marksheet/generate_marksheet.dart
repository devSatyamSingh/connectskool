import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../model/school_model/school_admin_marksheet_model.dart';

class MarksheetPdfService {

  // ── Colors ─────────────────────────────────────────────────────────────────
  static final _navy      = PdfColor.fromHex('#0D2B55');
  static final _lightBlue = PdfColor.fromHex('#D6E4F0');
  static final _border    = PdfColor.fromHex('#8899BB');
  static final _grey      = PdfColor.fromHex('#555555');
  static final _lightGrey = PdfColor.fromHex('#F2F2F2');
  static final _white     = PdfColors.white;
  static final _black     = PdfColors.black;

  // ── Helpers ────────────────────────────────────────────────────────────────
  static String _fileName(List<CoScholasticGrade> grades, String academicYear) {
    final name = (grades.isNotEmpty
        ? grades.first.studentName ?? 'Student'
        : 'Student').replaceAll(' ', '_');
    return '${name}_${academicYear}_ReportCard.pdf';
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BUILD PDF
  // ════════════════════════════════════════════════════════════════════════════
  static Future<Uint8List> _buildPdfBytes({
    required List<CoScholasticGrade> grades,
    required String schoolName,
    required String schoolAddress,
    required String affiliationNo,
    required String academicYear,
  }) async {
    final pdf = pw.Document();

    // ── Student info ─────────────────────────────────────────────────────────
    final first       = grades.isNotEmpty ? grades.first : null;
    final studentName = (first?.studentName ?? '—').toUpperCase();
    final studentId   = first?.studentId?.toString() ?? '—';

    // ── Group: term → subject → grade ────────────────────────────────────────
    final Map<String, Map<String, String>> termMap = {};
    for (final g in grades) {
      final term    = (g.term ?? 'term1').toLowerCase().trim();
      final subject = (g.subjectName ?? '').trim();
      final grade   = (g.grade ?? '—').trim();
      if (subject.isNotEmpty) {
        termMap.putIfAbsent(term, () => {})[subject] = grade;
        // termMap.putIfAbsent(term, () <String, String>{})[subject] = grade;
      }
    }

    // ── Unique subjects ───────────────────────────────────────────────────────
    final allSubjects = <String>[];
    for (final g in grades) {
      final s = (g.subjectName ?? '').trim();
      if (s.isNotEmpty && !allSubjects.contains(s)) allSubjects.add(s);
    }

    // ── Existing terms ────────────────────────────────────────────────────────
    final existingTerms = ['term1', 'term2', 'term3']
        .where((t) => termMap.containsKey(t))
        .toList();
    if (existingTerms.isEmpty) existingTerms.add('term1');

    String gradeFor(String term, String subject) =>
        termMap[term]?[subject] ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (ctx) => pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _navy, width: 1.5),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [

              // ── HEADER ─────────────────────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: pw.Stack(children: [
                  // Affiliation top-right
                  pw.Positioned(
                    top: 0, right: 0,
                    child: pw.Text(
                      'Affiliation No. $affiliationNo',
                      style: pw.TextStyle(fontSize: 6.5, color: _grey),
                    ),
                  ),
                  // School name centered
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 10),
                      pw.Text(
                        schoolName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: _navy,
                          letterSpacing: 1.2,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        schoolAddress,
                        style: pw.TextStyle(fontSize: 7.5, color: _grey),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'REPORT CARD  •  SESSION $academicYear',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: _navy,
                          letterSpacing: 0.8,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ]),
              ),

              pw.Divider(color: _navy, thickness: 1),

              // ── STUDENT PROFILE ────────────────────────────────────────────
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(14, 7, 14, 5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Student Profile',
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: _navy)),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _profileRow('Name of Student', studentName),
                              _profileRow('Admission No.', studentId),
                              _profileRow('Academic Year', academicYear),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 30),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _profileRow('Roll No.', '—'),
                              _profileRow('Total Working Days', '—'),
                              _profileRow('Total Attendance', '—'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.Divider(color: _navy, thickness: 0.8),

              // ── CO-SCHOLASTIC TABLE ────────────────────────────────────────
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(14, 6, 14, 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Section label
                    pw.Container(
                      color: _lightBlue,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: pw.Text(
                        'Co Scholastic Area  (8 Point Scale)',
                        style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: _navy),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    _buildCoScholasticTable(
                      allSubjects,
                      termMap,
                      existingTerms,
                      gradeFor,
                    ),
                  ],
                ),
              ),

              pw.Divider(color: _navy, thickness: 0.8),

              // ── GRADE SCALE STRIP ──────────────────────────────────────────
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(14, 5, 14, 5),
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: pw.TextStyle(fontSize: 6.5, color: _black),
                    children: [
                      pw.TextSpan(
                        text: '8 Point Scale : ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.TextSpan(text:
                      'A1(91%-100%), A2(81%-90%), B1(71%-80%), B2(61%-70%), '
                          'C1(51%-60%), C2(41%-50%), D(33%-40%), F(32% AND BELOW)',
                      ),
                    ],
                  ),
                ),
              ),

              pw.Divider(color: _navy, thickness: 0.8),

              // ── SIGNATURES ─────────────────────────────────────────────────
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _signatureBox('Director'),
                    _signatureBox('Class Teacher'),
                    _signatureBox('Principal'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  // ── Profile row ─────────────────────────────────────────────────────────────
  static pw.Widget _profileRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 115,
            child: pw.Text(label,
                style: pw.TextStyle(fontSize: 8, color: _black)),
          ),
          pw.Text(': ', style: pw.TextStyle(fontSize: 8, color: _black)),
          pw.Expanded(
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: _black)),
          ),
        ],
      ),
    );
  }

  // ── Co-scholastic two-column table ──────────────────────────────────────────
  static pw.Widget _buildCoScholasticTable(
      List<String> subjects,
      Map<String, Map<String, String>> termMap,
      List<String> existingTerms,
      String Function(String, String) gradeFor,
      ) {
    // Split subjects into two halves
    final half     = (subjects.length / 2).ceil();
    final leftCol  = subjects.sublist(0, half);
    final rightCol = subjects.length > half ? subjects.sublist(half) : <String>[];

    // Term header labels
    final termHeaders = existingTerms
        .map((t) => t == 'term1' ? 'Term-1'
        : t == 'term2' ? 'Term-2'
        : 'Term-3')
        .toList();

    // ── Cell builders ──────────────────────────────────────────────────────
    pw.Widget _hdrCell(String text, {int flex = 1}) => pw.Expanded(
      flex: flex,
      child: pw.Container(
        color: _navy,
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        child: pw.Text(text,
            style: pw.TextStyle(
                color: _white, fontSize: 7,
                fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center),
      ),
    );

    pw.Widget _subjectCell(String name, bool isEven) => pw.Expanded(
      flex: 3,
      child: pw.Container(
        color: isEven ? _lightGrey : _white,
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: pw.Text(
          name.trim().toUpperCase(),
          style: pw.TextStyle(fontSize: 7, color: _black),
          overflow: pw.TextOverflow.clip,
        ),
      ),
    );

    pw.Widget _gradeCell(String grade, bool isEven) => pw.Expanded(
      child: pw.Container(
        color: isEven ? _lightGrey : _white,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        child: pw.Text(
          grade.isEmpty || grade == '—' ? '' : grade,
          style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: _navy),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );

    // ── Build header ──────────────────────────────────────────────────────
    pw.Widget buildHeader() => pw.Row(children: [
      _hdrCell('Co Scholastic Area', flex: 3),
      for (final h in termHeaders) _hdrCell(h),
    ]);

    // ── Build data rows for one side ──────────────────────────────────────
    List<pw.Widget> buildRows(List<String> sideSubjects) {
      return sideSubjects.asMap().entries.map((e) {
        final isEven = e.key % 2 == 0;
        final subj   = e.value;
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(color: _border, width: 0.3)),
          ),
          child: pw.Row(children: [
            _subjectCell(subj, isEven),
            for (final t in existingTerms)
              _gradeCell(gradeFor(t, subj), isEven),
          ]),
        );
      }).toList();
    }

    // ── One table side (header + rows) ────────────────────────────────────
    pw.Widget buildSide(List<String> sideSubjects) => pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          buildHeader(),
          ...buildRows(sideSubjects),
        ],
      ),
    );

    // ── Grade legend box (right side) ─────────────────────────────────────
    final gradeEntries = {
      'A1': 'Outstanding',
      'A2': 'Excellent',
      'B1': 'Very Good',
      'B2': 'Good',
      'C1': 'Above Average',
      'C2': 'Average',
      'D':  'Below',
    };

    pw.Widget legendBox() => pw.Container(
      width: 88,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            color: _navy,
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 4, vertical: 5),
            child: pw.Text('Grade',
                style: pw.TextStyle(
                    color: _white, fontSize: 7,
                    fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center),
          ),
          ...gradeEntries.entries.map((e) => pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 5, vertical: 3.5),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(color: _border, width: 0.3)),
            ),
            child: pw.Row(children: [
              pw.Text(e.key,
                  style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                      color: _navy)),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Text(e.value,
                    style: pw.TextStyle(fontSize: 6.5, color: _grey)),
              ),
            ]),
          )),
        ],
      ),
    );

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: buildSide(leftCol)),
        pw.SizedBox(width: 6),
        pw.Expanded(
            child: buildSide(
                rightCol.isEmpty ? <String>[] : rightCol)),
        pw.SizedBox(width: 6),
        legendBox(),
      ],
    );
  }

  // ── Signature box ───────────────────────────────────────────────────────────
  static pw.Widget _signatureBox(String label) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 110, height: 44,
          decoration: pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(color: _black, width: 0.8)),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: 8.5,
                fontWeight: pw.FontWeight.bold,
                color: _black)),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ════════════════════════════════════════════════════════════════════════════

  static Future<void> shareOrPrint({
    required BuildContext context,
    required List<CoScholasticGrade> grades,
    required String schoolName,
    required String schoolAddress,
    required String affiliationNo,
    required String academicYear,
  }) async {
    final bytes = await _buildPdfBytes(
      grades: grades, schoolName: schoolName,
      schoolAddress: schoolAddress, affiliationNo: affiliationNo,
      academicYear: academicYear,
    );
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: _fileName(grades, academicYear),
    );
  }

  static Future<void> download({
    required BuildContext context,
    required List<CoScholasticGrade> grades,
    required String schoolName,
    required String schoolAddress,
    required String affiliationNo,
    required String academicYear,
  }) async {
    try {
      _showLoadingDialog(context);
      final bytes    = await _buildPdfBytes(
        grades: grades, schoolName: schoolName,
        schoolAddress: schoolAddress, affiliationNo: affiliationNo,
        academicYear: academicYear,
      );
      final fileName = _fileName(grades, academicYear);

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = (await getExternalStorageDirectory()) ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${dir.path}/$fileName';
      await File(filePath).writeAsBytes(bytes, flush: true);
      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PDF Downloaded!',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(filePath,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 10),
                    overflow: TextOverflow.ellipsis),
              ],
            )),
          ]),
          backgroundColor: const Color(0xFF1B8B5A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OPEN',
            textColor: Colors.white,
            onPressed: () => OpenFile.open(filePath),
          ),
        ));
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Download failed: $e',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFD94040),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }

  static void showOptions({
    required BuildContext context,
    required List<CoScholasticGrade> grades,
    required String schoolName,
    required String schoolAddress,
    required String affiliationNo,
    required String academicYear,
  }) {
    if (grades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('No grade data available',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ));
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF0D2B55).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: Color(0xFF0D2B55), size: 20),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Report Card PDF',
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D2B55))),
                Text('Choose an action',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ]),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _optionTile(
              icon: Icons.share_rounded,
              iconColor: const Color(0xFF2C7BBF),
              bgColor: const Color(0xFFEBF5FF),
              title: 'Share / Print',
              subtitle: 'Share via WhatsApp, email, or print',
              onTap: () {
                Navigator.pop(context);
                shareOrPrint(
                  context: context, grades: grades,
                  schoolName: schoolName, schoolAddress: schoolAddress,
                  affiliationNo: affiliationNo, academicYear: academicYear,
                );
              },
            ),
            const SizedBox(height: 10),
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
                download(
                  context: context, grades: grades,
                  schoolName: schoolName, schoolAddress: schoolAddress,
                  affiliationNo: affiliationNo, academicYear: academicYear,
                );
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14)),
                child: const Center(
                  child: Text('Cancel',
                      style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Row(children: [
            const CircularProgressIndicator(
                color: Color(0xFF0D2B55), strokeWidth: 3),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Generating PDF...',
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D2B55))),
              const SizedBox(height: 4),
              Text('Please wait',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500)),
            ]),
          ]),
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
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.bold, color: iconColor)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade600)),
            ],
          )),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: iconColor.withOpacity(0.5)),
        ]),
      ),
    );
  }
}