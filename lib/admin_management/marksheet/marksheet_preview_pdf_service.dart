import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MarksheetPreviewPdfService {
  // ── Brand Colors ──────────────────────────────────────────────────────────────
  static const _primaryBlue  = PdfColor.fromInt(0xFF153D91);
  static const _darkBlueText = PdfColor.fromInt(0xFF0F2C67);
  static const _borderGrey   = PdfColor.fromInt(0xFFD6D6D6);
  static const _white        = PdfColors.white;
  static const _black87      = PdfColor.fromInt(0xDD000000);
  static const _black54      = PdfColor.fromInt(0x8A000000);

  // ─────────────────────────────────────────────────────────────────────────────
  /// Entry point — PDF banao aur Share/Open dialog dikhao
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> showOptions({
    required BuildContext context,
    required dynamic marksheetData,   // GenerateMarksheetViewModel ka data
    required dynamic schoolData,      // SchoolAdminProfileViewModel ka data
  }) async {
    final bytes = await _buildPdf(
      marksheetData: marksheetData,
      schoolData: schoolData,
    );

    final dir  = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/report_card_${DateTime.now().millisecondsSinceEpoch}.pdf',
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
              // drag handle
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Report Card PDF Ready',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Share
              _bottomButton(
                icon: Icons.share_rounded,
                label: 'Share PDF',
                color: const Color(0xFF153D91),
                onTap: () {
                  Navigator.pop(context);
                  Share.shareXFiles(
                    [XFile(file.path)],
                    text: 'Report Card — ${marksheetData?.academicYear ?? ""}',
                  );
                },
              ),
              const SizedBox(height: 12),

              _bottomButton(
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

  static Widget _bottomButton({
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

  // ─────────────────────────────────────────────────────────────────────────────
  // PDF BUILD
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<List<int>> _buildPdf({
    required dynamic marksheetData,
    required dynamic schoolData,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        build: (ctx) => [
          // 1. School Header
          _pdfSchoolHeader(schoolData),
          pw.SizedBox(height: 10),
          _pdfReportTitle(
            year:        marksheetData?.academicYear?.toString() ?? '—',
            className:   marksheetData?.studentInfo?.className?.toString() ?? '—',
            sectionName: marksheetData?.studentInfo?.sectionName?.toString() ?? '—',
          ),
          pw.SizedBox(height: 12),

          // 3. Student Profile
          _pdfStudentProfile(marksheetData?.studentInfo),
          pw.SizedBox(height: 12),

          // 4. Attendance
          _pdfAttendance(marksheetData),
          pw.SizedBox(height: 12),

          // 5. Scholastic Area
          _pdfScholasticSection(marksheetData?.scholastic),
          pw.SizedBox(height: 12),

          // 6. Summary Cards (CGPA / % / Result)
          _pdfSummaryCards(marksheetData),
          pw.SizedBox(height: 12),

          // 7. Co-Scholastic + Grading Scale side-by-side
          _pdfCoScholasticAndScale(marksheetData?.coScholastic),
          pw.SizedBox(height: 32),

          // 8. Signature Footer
          _pdfSignatureSection(),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _pdfSchoolHeader(dynamic school) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Left circle badge
        pw.Container(
          width: 50, height: 50,
          decoration: const pw.BoxDecoration(
            color: _primaryBlue,
            shape: pw.BoxShape.circle,
          ),
          child: pw.Center(
            child: pw.Text(
              'S',
              style: pw.TextStyle(
                color: _white, fontSize: 22, fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.SizedBox(width: 14),

        // School info center
        pw.Expanded(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                (school?.schoolName ?? 'School Name').toString().toUpperCase(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: _primaryBlue,
                  letterSpacing: 1.5,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                (school?.schoolAdrees ?? 'School Address').toString(),
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8, color: _black54),
              ),
              pw.Text(
                'Email : ${school?.schoolEmail ?? "—"}',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8, color: _black54),
              ),
              pw.Text(
                'Phone : ${school?.schoolPhoneNumber ?? "—"}',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8, color: _black54),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 50),
      ],
    );
  }

  static pw.Widget _pdfReportTitle({
    required String year,
    required String className,
    required String sectionName,
  }) {
    return pw.Column(
      children: [
        pw.Divider(color: _primaryBlue, thickness: 2, height: 1),
        pw.SizedBox(height: 6),
        pw.Text(
          'REPORT CARD SESSION $year',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: _darkBlueText,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: pw.BoxDecoration(
            color: const PdfColor.fromInt(0x0F153D91),
            borderRadius: pw.BorderRadius.circular(5),
            border: pw.Border.all(color: const PdfColor.fromInt(0x33153D91)),
          ),
          child: pw.Text(
            '$className ($sectionName)',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _white,
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(color: _primaryBlue, thickness: 2, height: 1),
      ],
    );
  }

  static pw.Widget _pdfStudentProfile(dynamic student) {
    pw.Widget labelCell(String text) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: _black87),
      ),
    );
    pw.Widget valueCell(String? text) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        (text != null && text.isNotEmpty) ? ': $text' : '',
        style: const pw.TextStyle(fontSize: 9),
      ),
    );

    final rows = [
      ['Name of Student', student?.name,        'Roll No',       student?.rollNo],
      ['Admission No.',   student?.admissionNo,  'Section',       student?.sectionName],
      ['Date of Birth',   student?.dob,          'Class',         student?.className],
      ["Mother's Name",   student?.motherName,   "Father's Name", student?.fatherName],
      ['Address',         student?.address,      '',              ''],
    ];

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor.fromInt(0x4D153D91)),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section Title Bar
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0x0A153D91),
              border: pw.Border(bottom: pw.BorderSide(color: _borderGrey)),
            ),
            child: pw.Text(
              'STUDENT PROFILE',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: _white,
                fontSize: 10,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.2),
                1: const pw.FlexColumnWidth(2.5),
                2: const pw.FlexColumnWidth(1.0),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: rows.map((r) => pw.TableRow(children: [
                labelCell(r[0] ?? ''),
                valueCell(r[1]),
                labelCell(r[2] ?? ''),
                valueCell(r[3]),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfAttendance(dynamic data) {
    final rollNo      = data?.studentInfo?.rollNo ?? '—';
    final workingDays = data?.attendance?.totalWorkingDays ?? 0;
    final presentDays = data?.attendance?.presentDays ?? 0;

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor.fromInt(0xFF90CAF9)),
        color: const PdfColor.fromInt(0x05153D91),
      ),
      child: pw.Row(
        children: [
          pw.Text('Attendance',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 10, color: _white)),
          pw.SizedBox(width: 20),
          pw.Text('Total Working Days : ',
              style: const pw.TextStyle(fontSize: 9, color: _white)),
          pw.Text('$workingDays',
              style: pw.TextStyle(
                  fontSize: 9, fontWeight: pw.FontWeight.bold, color: _white)),
          pw.SizedBox(width: 20),
          pw.Text('Total Attendance : ',
              style: const pw.TextStyle(fontSize: 9, color: _white)),
          pw.Text('$presentDays',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700)),
          pw.Spacer(),
          pw.Text('Roll No : $rollNo',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 10, color: _white),),
        ],
      ),
    );
  }

  static pw.Widget _pdfScholasticSection(Map<String, dynamic>? scholasticData) {
    final hasData = scholasticData != null && scholasticData.isNotEmpty;

    pw.Widget cell(String text, {bool bold = false, bool header = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: (bold || header) ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: header ? _black87 : null,
            ),
          ),
        );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header bar
        pw.Container(
          width: double.infinity,
          color: _primaryBlue,
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: pw.Text(
            'SCHOLASTIC AREA  (8 POINT SCALE)',
            style: pw.TextStyle(
              color: _white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(color: _borderGrey)),
          child: hasData
              ? pw.Table(
            border: pw.TableBorder.all(color: _borderGrey),
            children: [
              // Table header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFEFEFEF),
                ),
                children: [
                  cell('Subject', bold: true),
                  cell('Max',     bold: true),
                  cell('Obtained',bold: true),
                  cell('Grade',   bold: true),
                ],
              ),
              // Data rows
              ...scholasticData!.entries.map((e) {
                final item = e.value;
                return pw.TableRow(children: [
                  cell(e.key),
                  cell('${item['max_marks'] ?? '—'}'),
                  cell('${item['obtained_marks'] ?? '—'}'),
                  cell('${item['grade'] ?? '—'}'),
                ]);
              }),
            ],
          )
              : pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 16),
            child: pw.Center(
              child: pw.Text(
                'No scholastic records for this session.',
                style: pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _pdfSummaryCards(dynamic data) {
    final pct    = double.tryParse(data?.overallPercentage?.toString() ?? '0') ?? 0.0;
    final isPass = pct >= 33.0;

    pw.Widget card(String title, String value, PdfColor color) =>
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const pw.EdgeInsets.symmetric(horizontal: 4),
            decoration: pw.BoxDecoration(
              color: PdfColor(color.red, color.green, color.blue, 0.015),
              border: pw.Border.all(
                color: PdfColor(color.red, color.green, color.blue, 0.20),
                width: 1.5,
              ),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  value,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: color,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: _black54,
                  ),
                ),
              ],
            ),
          ),
        );

    return pw.Row(
      children: [
        card('CGPA',      '${data?.cgpa ?? "—"}',          _primaryBlue),
        card('OVERALL %', '${pct.toStringAsFixed(1)}%',    const PdfColor.fromInt(0xFF2E7D32)),
        card('RESULT',
          isPass ? 'PASS' : 'FAIL',
          isPass
              ? const PdfColor.fromInt(0xFF2E7D32)
              : const PdfColor.fromInt(0xFFD32F2F),
        ),
      ],
    );
  }

  static pw.Widget _pdfCoScholasticAndScale(Map<String, dynamic>? coScholasticData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(flex: 3, child: _pdfCoScholasticTable(coScholasticData)),
        pw.SizedBox(width: 14),
        pw.Expanded(flex: 2, child: _pdfGradingScaleTable()),
      ],
    );
  }

  static pw.Widget _pdfCoScholasticTable(Map<String, dynamic>? data) {
    final term1 = Map<String, dynamic>.from(data?['term1'] ?? {});
    final term2 = Map<String, dynamic>.from(data?['term2'] ?? {});
    final allIds = <String>{...term1.keys, ...term2.keys};

    pw.Widget hCell(String text) => pw.Padding(
      padding: const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      ),
    );
    pw.Widget dCell(String text, {bool center = false}) => pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: center
          ? pw.Center(child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)))
          : pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          color: _primaryBlue,
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: pw.Text(
            'CO-SCHOLASTIC AREA',
            style: pw.TextStyle(
              color: _white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: _borderGrey),
          columnWidths: {
            0: const pw.FlexColumnWidth(2.5),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF3F4F6)),
              children: [hCell('Activity'), hCell('Term-1'), hCell('Term-2')],
            ),
            // Data or empty
            if (allIds.isEmpty)
              pw.TableRow(children: [
                dCell('No Co-Scholastic Records'),
                dCell(''),
                dCell(''),
              ])
            else
              ...allIds.map((id) {
                final t1   = term1[id];
                final t2   = term2[id];
                final name = (t1?['subject_name'] ?? t2?['subject_name'] ?? '—').toString();
                final g1   = (t1?['grade'] ?? '—').toString();
                final g2   = (t2?['grade'] ?? '—').toString();
                return pw.TableRow(children: [
                  dCell(name),
                  dCell(g1, center: true),
                  dCell(g2, center: true),
                ]);
              }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _pdfGradingScaleTable() {
    final scales = [
      ['A1', 'Outstanding',   const PdfColor.fromInt(0xFF2E7D32)],
      ['A2', 'Excellent',     PdfColors.blue],
      ['B1', 'Very Good',     PdfColors.purple],
      ['B2', 'Good',          PdfColors.cyan],
      ['C1', 'Above Average', PdfColors.orange],
      ['C2', 'Average',       PdfColors.orangeAccent],
      ['D',  'Below Average', PdfColors.redAccent],
      ['E',  'Needs Effort',  const PdfColor.fromInt(0xFFB71C1C)],
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          color: _primaryBlue,
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: pw.Text(
            'SCALE INDICATORS',
            style: pw.TextStyle(
              color: _white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: _borderGrey),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(2.5),
          },
          children: scales.map((s) {
            final color = s[2] as PdfColor;
            return pw.TableRow(children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                color: PdfColor(color.red, color.green, color.blue, 0.12),
                child: pw.Center(
                  child: pw.Text(
                    s[0] as String,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      color: _white,
                    ),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                child: pw.Text(
                  s[1] as String,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  static pw.Widget _pdfSignatureSection() {
    pw.Widget sig(String label) => pw.Column(
      children: [
        pw.Container(
          width: 110, height: 1,
          color: const PdfColor.fromInt(0x42000000),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: _black87,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey, thickness: 0.8),
        pw.SizedBox(height: 14),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            sig('DIRECTOR'),
            sig('CLASS TEACHER'),
            sig('PRINCIPAL'),
          ],
        ),
      ],
    );
  }
}