import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:collection/collection.dart';

class ChartMarksheetPdfService {
  static const _brandRed = PdfColor.fromInt(0xFFBA1A1A);
  static const _darkSlate = PdfColor.fromInt(0xFF2F3B52);
  static const _borderGrey = PdfColor.fromInt(0xFFCCCCCC);
  static const _black54 = PdfColor.fromInt(0x8A000000);
  static const _white = PdfColors.white;

  // ─── Entry Point ─────────────────────────────────────────────────────────────
  static Future<void> showOptions({
    required BuildContext context,
    required List<dynamic> grades,
    required String schoolName,
    required String schoolAddress,
    required String affiliationNo,
    required String academicYear,
  }) async {
    final bytes = await _buildPdf(
      grades: grades,
      schoolName: schoolName,
      schoolAddress: schoolAddress,
      academicYear: academicYear,
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/chart_marksheet_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(bytes);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Chart Marksheet PDF Ready',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _sheetButton(
                icon: Icons.share_rounded,
                label: 'Share PDF',
                color: const Color(0xFF0D2B55),
                onTap: () {
                  Navigator.pop(context);
                  Share.shareXFiles([
                    XFile(file.path),
                  ], text: 'Chart Marksheet - $academicYear');
                },
              ),
              const SizedBox(height: 12),
              _sheetButton(
                icon: Icons.download_rounded,
                label: 'Open / Download',
                color: const Color(0xFFC8922A),
                onTap: () {
                  Navigator.pop(context);
                  OpenFile.open(file.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sheetButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PDF Build ────────────────────────────────────────────────────────────────
  static Future<List<int>> _buildPdf({
    required List<dynamic> grades,
    required String schoolName,
    required String schoolAddress,
    required String academicYear,
  }) async {
    final pdf = pw.Document();

    final term1 = grades.where((g) => g.term == 'term1').toList();
    final term2 = grades.where((g) => g.term == 'term2').toList();

    // ✅ Student info proxy se lo
    final first = grades.isNotEmpty ? grades.first : null;
    final stuName = first?.studentName ?? '';
    final className = first?.className ?? '';
    final section = first?.sectionName ?? '';
    final rollNo = first?.rollNo ?? '';
    final dob = first?.dob ?? '';
    final father = first?.fatherName ?? '';
    final mother = first?.motherName ?? '';
    final admNo = first?.admissionNo ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _pdfHeader(schoolName, schoolAddress, academicYear),
            pw.SizedBox(height: 14),
            _pdfStudentProfile(
              stuName,
              className,
              section,
              rollNo,
              dob,
              father,
              mother,
              admNo,
            ),
            pw.SizedBox(height: 10),
            _pdfCoScholasticTable(term1, term2),
            pw.SizedBox(height: 10),
            _pdfGradingScale(),
            pw.SizedBox(height: 24),
            _pdfFooter(),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  // ─── Header ───────────────────────────────────────────────────────────────────
  static pw.Widget _pdfHeader(String name, String address, String year) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 48,
              height: 48,
              decoration: const pw.BoxDecoration(
                color: _brandRed,
                shape: pw.BoxShape.circle,
              ),
              child: pw.Center(
                child: pw.Text(
                  'S',
                  style: pw.TextStyle(
                    color: _white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    name.toUpperCase(),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _brandRed,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'TRUST ON EDUCATION',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _brandRed,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    address,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8, color: _black54),
                  ),
                ],
              ),
            ),
            pw.Container(
              width: 40,
              height: 40,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _brandRed, width: 2),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Center(
                child: pw.Text(
                  'B',
                  style: pw.TextStyle(
                    color: _brandRed,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: _brandRed, width: 1.5),
              bottom: pw.BorderSide(color: _brandRed, width: 1.5),
            ),
          ),
          child: pw.Center(
            child: pw.Text(
              'PROGRESS REPORT * $year', // ✅ • → * (Unicode fix)
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Student Profile ──────────────────────────────────────────────────────────
  static pw.Widget _pdfStudentProfile(
    String name,
    String cls,
    String sec,
    String roll,
    String dob,
    String father,
    String mother,
    String admNo,
  ) {
    pw.Widget row(String l1, String v1, String l2, String v2) => pw.Row(
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            l1,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            v1.isNotEmpty ? ': $v1' : '',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            l2,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            v2.isNotEmpty ? ': $v2' : '',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Student Profile',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            decoration: pw.TextDecoration.underline,
          ),
        ),
        pw.SizedBox(height: 6),
        row('Name of Student', name, 'Class & Section', '$cls - $sec'),
        pw.SizedBox(height: 4),
        row("Mother's Name", mother, 'Roll No', roll),
        pw.SizedBox(height: 4),
        row("Father's Name", father, 'D.O.B.', dob),
        pw.SizedBox(height: 4),
        row('Admission No.', admNo, '', ''),
      ],
    );
  }

  // ─── Co-Scholastic Table ──────────────────────────────────────────────────────
  static pw.Widget _pdfCoScholasticTable(List term1, List term2) {
    final allKeys = <String>{};
    for (final g in [...term1, ...term2]) {
      allKeys.add((g.subjectName as String?) ?? 'Activity');
    }

    pw.Widget cell(String text, {bool header = false, bool left = false}) =>
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          child: header
              ? pw.Center(
                  child: pw.Text(
                    text,
                    style: pw.TextStyle(
                      color: _white,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                )
              : pw.Text(
                  text,
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: left ? pw.TextAlign.left : pw.TextAlign.center,
                ),
        );

    final rows = allKeys.map((key) {
      final g1List = term1.where((g) => g.subjectName == key).toList();
      final g2List = term2.where((g) => g.subjectName == key).toList();

      final g1 = g1List.isNotEmpty ? g1List.first : null;
      final g2 = g2List.isNotEmpty ? g2List.first : null;

      return [
        key,
        g1?.grade ?? '-',
        g2?.grade ?? '-',
      ];
    }).toList();

    final half = (rows.length / 2).ceil();
    final left = rows.sublist(0, half);
    final right = rows.sublist(half);
    while (right.length < left.length) right.add(['', '', '']);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 5,
          child: pw.Table(
            border: pw.TableBorder.all(color: _borderGrey),
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(2.5),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: _darkSlate),
                children: [
                  cell('Co Scholastic Area', header: true),
                  cell('Term-1', header: true),
                  cell('Term-2', header: true),
                  cell('Co Scholastic Area', header: true),
                  cell('Term-1', header: true),
                  cell('Term-2', header: true),
                ],
              ),
              ...List.generate(left.length, (i) {
                final l = left[i];
                final r = right[i];
                return pw.TableRow(
                  children: [
                    cell(l[0], left: true),
                    cell(l[1]),
                    cell(l[2]),
                    cell(r[0], left: true),
                    cell(r[1]),
                    cell(r[2]),
                  ],
                );
              }),
            ],
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          flex: 2,
          child: pw.Table(
            border: pw.TableBorder.all(color: _borderGrey),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
            },
            children:
                [
                      ['A1', 'Outstanding'],
                      ['A2', 'Excellent'],
                      ['B1', 'Very Good'],
                      ['B2', 'Good'],
                      ['C1', 'Above Average'],
                      ['C2', 'Average'],
                      ['D', 'Below Average'],
                    ]
                    .map(
                      (e) => pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Center(
                              child: pw.Text(
                                e[0],
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: pw.Text(
                              e[1],
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  // ─── Grading Scale ────────────────────────────────────────────────────────────
  static pw.Widget _pdfGradingScale() {
    pw.Widget hCell(String t) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Center(
        child: pw.Text(
          t,
          style: pw.TextStyle(
            color: _white,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );

    pw.Widget vCell(String t, PdfColor c) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Center(
        child: pw.Text(
          t,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: c,
            fontSize: t.length > 3 ? 7 : 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Instructions:- Grading scale:- Grades are awarded on a 8-point grading scale as follows',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: _borderGrey),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _brandRed),
              children: [
                hCell('91-100'),
                hCell('81-90'),
                hCell('71-80'),
                hCell('61-70'),
                hCell('51-60'),
                hCell('41-50'),
                hCell('33-40'),
                hCell('32 & Below'),
              ],
            ),
            pw.TableRow(
              children: [
                vCell('A1', PdfColors.green800),
                vCell('A2', PdfColors.blue800),
                vCell('B1', PdfColors.purple),
                vCell('B2', PdfColors.cyan800),
                vCell('C1', PdfColors.orange),
                vCell('C2', PdfColors.orangeAccent),
                vCell('D', PdfColors.redAccent),
                // ✅ bullet/newline hata ke simple text
                vCell('E(Need Imp.)', PdfColors.red),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────────
  static pw.Widget _pdfFooter() {
    pw.Widget sig(String label) => pw.Column(
      children: [
        pw.Container(
          width: 130,
          height: 1,
          color: const PdfColor.fromInt(0x61000000),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    return pw.Row(
      children: [
        pw.Text(
          'Date : $date',
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.Spacer(),
        sig('CLASS TEACHER'),
        pw.SizedBox(width: 40),
        sig('PRINCIPAL'),
      ],
    );
  }
}
