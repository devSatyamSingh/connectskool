import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../model/school_model/timetable/get_school_exam_time_table_model.dart';
import '../../model/school_model/auth/school_admin_profile_model.dart';

class ExamTimetablePdfService {
  static const _darkBlue   = PdfColor.fromInt(0xFF1a237e);
  static const _midBlue    = PdfColor.fromInt(0xFF1565c0);
  static const _lightBlue  = PdfColor.fromInt(0xFFe3f2fd);
  static const _headerBg   = PdfColor.fromInt(0xFFf5f5f5);
  static const _border     = PdfColor.fromInt(0xFFcccccc);
  static const _greenPass  = PdfColor.fromInt(0xFF2e7d32);
  static const _textDark   = PdfColor.fromInt(0xFF212121);
  static const _textGrey   = PdfColor.fromInt(0xFF616161);
  static const _blueBorder = PdfColor.fromInt(0xFF90caf9);
  static const _stripeBg   = PdfColor.fromInt(0xFFfafafa);

  static const List<String> _instructions = [
    'Report 15 minutes before commencement of the exam',
    'Valid School ID Card & Admit Card must be carried',
    'Write Roll Number and Name clearly on the answer sheet',
    'Possession of electronic gadgets is strictly prohibited',
    'No student will be allowed to leave before duration ends',
    'Use of unfair means leads to immediate cancellation',
  ];

  static Future<File> generatePdf({
    required ExamTimeTableModel examTimeTableModel,
    required SchoolAdminProfileModel schoolAdminProfileModel,
    required String examName,
    required String className,
    required String sectionName,
  }) async {
    final school = schoolAdminProfileModel.data;
    final items  = examTimeTableModel.data ?? [];
    final pdf  = pw.Document();
    final now  = DateTime.now();
    final printedAt    = DateFormat('dd/MM/yyyy, HH:mm').format(now);
    final generatedDate = DateFormat('MMMM d, y').format(now);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18 * PdfPageFormat.mm, vertical: 14 * PdfPageFormat.mm),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildTimestampRow(printedAt),
              pw.Divider(color: _border, thickness: 0.5),
              pw.SizedBox(height: 6),
              _buildHeader(school, generatedDate),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  '${school?.schoolPhoneNumber ?? ''} | ${school?.schoolEmail ?? ''} | ${school?.schoolAdrees ?? ''}',
                  style: pw.TextStyle(fontSize: 8, color: _textGrey),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: _border, thickness: 0.5),
              pw.SizedBox(height: 6),
              _buildTitle(examName, className, sectionName),
              pw.SizedBox(height: 8),
              _buildInfoBox(examName, className, sectionName, items.length),
              pw.SizedBox(height: 10),
              _buildTimetableTable(items),
              pw.SizedBox(height: 12),
              _buildInstructionsBox(),
              pw.SizedBox(height: 20),
              _buildSignatureRow(generatedDate),
              pw.SizedBox(height: 4),
              pw.Divider(color: _border, thickness: 0.5),
              pw.SizedBox(height: 4),
              _buildFooter(school),
            ],
          );
        },
      ),
    );

    return _saveFile(pdf, examName, className, sectionName);
  }

  static pw.Widget _buildTimestampRow(String printedAt) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(printedAt,
            style: pw.TextStyle(fontSize: 7, color: _textGrey)),
        pw.Text('School Dashboard - Student Portal',
            style: pw.TextStyle(fontSize: 7, color: _textGrey)),
        pw.SizedBox(width: 40),
      ],
    );
  }

  static pw.Widget _buildHeader(Data? school, String generatedDate) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Text(
            (school?.schoolName ?? 'SCHOOL NAME').toUpperCase(),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: _darkBlue,
              letterSpacing: 1.2,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _darkBlue, width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('OFFICIAL DOCUMENT',
                  style: pw.TextStyle(fontSize: 7, color: _darkBlue, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text(generatedDate,
                  style: pw.TextStyle(fontSize: 7, color: _darkBlue)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTitle(String examName, String className, String sectionName) {
    return pw.Column(
      children: [
        pw.Center(
          child: pw.Text(
            'EXAMINATION TIMETABLE',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _darkBlue,
              letterSpacing: 1.5,
            ),
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Center(
          child: pw.Text(
            'Class: $className – Section $sectionName',
            style: pw.TextStyle(fontSize: 9, color: _textDark),
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Center(
          child: pw.Text(
            examName,
            style: pw.TextStyle(fontSize: 8, color: _textGrey, fontStyle: pw.FontStyle.italic),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInfoBox(
      String examName, String className, String sectionName, int total) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _headerBg),
          children: [
            _infoCell('EXAM', examName),
            _infoCell('CLASS & SECTION', '$className – $sectionName', hasBorder: true),
            _infoCell('TOTAL SUBJECTS', '$total Subjects', hasBorder: false),
          ],
        ),
      ],
    );
  }

  static pw.Widget _infoCell(String label, String value, {bool hasBorder = true}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: pw.BoxDecoration(
        border: hasBorder
            ? const pw.Border(right: pw.BorderSide(color: _border, width: 0.5))
            : null,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 7, color: _textGrey)),
          pw.SizedBox(height: 3),
          pw.Text(value,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _textDark)),
        ],
      ),
    );
  }

  static pw.Widget _buildTimetableTable(List<ExamTimetableData> items) {
    const headers = ['S.No', 'Subject', 'Date', 'Day', 'Start Time', 'End Time', 'Room', 'Max Marks', 'Pass Marks'];
    const colWidths = {
      0: pw.FlexColumnWidth(0.5),
      1: pw.FlexColumnWidth(1.2),
      2: pw.FlexColumnWidth(1.2),
      3: pw.FlexColumnWidth(1.0),
      4: pw.FlexColumnWidth(1.1),
      5: pw.FlexColumnWidth(1.1),
      6: pw.FlexColumnWidth(0.8),
      7: pw.FlexColumnWidth(1.1),
      8: pw.FlexColumnWidth(1.1),
    };

    // Header row
    final headerRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: _headerBg),
      children: headers.map((h) => _thCell(h)).toList(),
    );

    // Data rows
    final dataRows = items.asMap().entries.map((entry) {
      final i    = entry.key;
      final item = entry.value;
      final date = _parseDate(item.examDate ?? '');
      final day  = _parseDay(item.examDate ?? '');
      final room = (item.roomNo?.isEmpty ?? true) ? '-' : item.roomNo!;
      final bg   = i.isOdd ? _stripeBg : PdfColors.white;

      return pw.TableRow(
        decoration: pw.BoxDecoration(color: bg),
        children: [
          _tdCell('${i + 1}', align: pw.TextAlign.center),
          _tdCell(item.subjectName ?? '', bold: true),
          _tdCell(date),
          _tdCell(day, color: _midBlue, bold: true),
          _tdCell(_fmtTime(item.startTime ?? ''), align: pw.TextAlign.center),
          _tdCell(_fmtTime(item.endTime ?? ''),   align: pw.TextAlign.center),
          _tdCell(room,                            align: pw.TextAlign.center),
          _tdCell(_fmtMarks(item.maxMarks ?? ''), align: pw.TextAlign.center),
          _tdCell(_fmtMarks(item.minPassingMarks ?? ''),
              align: pw.TextAlign.center, color: _greenPass, bold: true),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.3),
      columnWidths: colWidths,
      children: [headerRow, ...dataRows],
    );
  }

  static pw.Widget _thCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(text,
          style: pw.TextStyle(fontSize: 7, color: _textGrey, fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _tdCell(
      String text, {
        pw.TextAlign align = pw.TextAlign.left,
        PdfColor color     = _textDark,
        bool bold          = false,
      }) {return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8,
          color: color,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildInstructionsBox() {
    final left  = _instructions.sublist(0, 3);
    final right = _instructions.sublist(3);

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _blueBorder, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Container(
            color: _lightBlue,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: pw.Text(
              '  IMPORTANT INSTRUCTIONS FOR STUDENTS',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _darkBlue,
              ),
            ),
          ),
          pw.Container(
            color: PdfColors.white,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: left
                        .map((t) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text('✓  $t',
                          style: pw.TextStyle(fontSize: 8, color: _textDark)),
                    ))
                        .toList(),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: right
                        .map((t) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text('✓  $t',
                          style: pw.TextStyle(fontSize: 8, color: _textDark)),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureRow(String generatedDate) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        // Stamp
        pw.Container(
          width: 60,
          height: 55,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _border, width: 1),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(40)),
          ),
          child: pw.Center(
            child: pw.Text(
              'SCHOOL\nSTAMP',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 7, color: _border),
            ),
          ),
        ),
        pw.Expanded(child: pw.SizedBox()),
        // Class Teacher
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Divider(color: _textDark, thickness: 0.8, indent: 0, endIndent: 0),
            pw.Text('Class Teacher', style: pw.TextStyle(fontSize: 8, color: _textDark)),
            pw.Text('SIGNATURE', style: pw.TextStyle(fontSize: 7, color: _textGrey)),
          ],
        ),
        pw.SizedBox(width: 30),
        // Principal
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Divider(color: _textDark, thickness: 0.8),
            pw.Text('Principal', style: pw.TextStyle(fontSize: 8, color: _textDark)),
            pw.Text('SIGNATURE', style: pw.TextStyle(fontSize: 7, color: _textGrey)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(Data? school) {
    return pw.Center(
      child: pw.Text(
        '${school?.schoolName ?? ''} | ${school?.schoolPhoneNumber ?? ''} | ${school?.schoolEmail ?? ''}',
        style: pw.TextStyle(fontSize: 7, color: _textGrey),
      ),
    );
  }

  static Future<File> _saveFile(
      pw.Document pdf, String examName, String className, String sectionName) async {
    final bytes     = await pdf.save();
    final dir       = await getApplicationDocumentsDirectory();
    final safeName  = '${examName}_${className}_$sectionName'
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '_');
    final file      = File('${dir.path}/exam_timetable_$safeName.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static String _parseDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMM d, y').format(dt);
    } catch (_) {
      return raw;
    }
  }

  static String _parseDay(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('EEEE').format(dt);
    } catch (_) {
      return '';
    }
  }

  static String _fmtTime(String t) {
    try {
      final parts = t.split(':');
      final dt    = DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return t;
    }
  }

  static String _fmtMarks(String m) {
    try {
      final v = double.parse(m);
      return v == v.roundToDouble() ? '${v.toInt()}.00' : m;
    } catch (_) {
      return m;
    }
  }

  static Future<void> downloadAndOpen({
    required BuildContext context,
    required ExamTimeTableModel examTimeTableModel,
    required SchoolAdminProfileModel schoolAdminProfileModel,
    required String examName,
    required String className,
    required String sectionName,
  }) async {
    try {
      if (Platform.isAndroid) {
        final sdk = await _getAndroidSdk();
        if (sdk < 33) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            _showSnack(context, 'Storage permission denied');
            return;
          }
        }
      }

      _showSnack(context, 'Generating PDF...');

      final file = await generatePdf(
        examTimeTableModel:      examTimeTableModel,
        schoolAdminProfileModel: schoolAdminProfileModel,
        examName:    examName,
        className:   className,
        sectionName: sectionName,
      );

      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        _showSnack(context, 'Could not open PDF: ${result.message}');
      }
    } catch (e) {
      _showSnack(context, 'Error: $e');
    }
  }

  static Future<void> shareFile({
    required BuildContext context,
    required ExamTimeTableModel examTimeTableModel,
    required SchoolAdminProfileModel schoolAdminProfileModel,
    required String examName,
    required String className,
    required String sectionName,
  }) async {
    try {
      _showSnack(context, 'Preparing PDF...');
      final file = await generatePdf(
        examTimeTableModel:      examTimeTableModel,
        schoolAdminProfileModel: schoolAdminProfileModel,
        examName:    examName,
        className:   className,
        sectionName: sectionName,
      );
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Exam Timetable - $examName',
      );
    } catch (e) {
      _showSnack(context, 'Error: $e');
    }
  }

  static Future<int> _getAndroidSdk() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    } catch (_) {
      return 30; // safe fallback — Android 11
    }
  }

  static void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}