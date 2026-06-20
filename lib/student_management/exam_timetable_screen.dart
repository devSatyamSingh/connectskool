import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../model/school_model/classes/all_classes_model.dart';
import 'package:school_pro/model/school_model/exam/exam_management_model.dart';
import '../model/school_model/timetable/get_school_exam_time_table_model.dart';
import '../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../view_model/school_view_model/exam/exam_management_view_model.dart';
import '../view_model/auth_view_model/school_admin_profile_view_model.dart';
import '../view_model/school_view_model/timetable/school_exam_time_table_view_model.dart';
import '../model/school_model/section/all_sections_model.dart';
import '../view_model/school_view_model/section/all_scetions_view_model.dart';

class ExamTimetableScreen extends StatefulWidget {
  const ExamTimetableScreen({super.key});

  @override
  State<ExamTimetableScreen> createState() => _ExamTimetableScreenState();
}

class _ExamTimetableScreenState extends State<ExamTimetableScreen> {
  // ── Selected values ────────────────────────────────────────────────────────
  Data?   _selectedClass;
  SectionData? _selectedSection;
  ExamData?    _selectedExam;

  bool _pdfLoading = false;

  // ── Theme colors ───────────────────────────────────────────────────────────
  static const _primary   = Color(0xFF1a237e);
  static const _accent    = Color(0xFF6D28D9);
  static const _surface   = Color(0xFFF5F7FB);
  static const _card      = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApis());
  }

  Future<void> _initApis() async {
    final classVm  = context.read<AllClassesViewModel>();
    final examVm   = context.read<ExamManagementViewModel>();
    final profileVm = context.read<SchoolAdminProfileViewModel>();

    await Future.wait([
      classVm.allClassesApi(context),
      examVm.examManagementApi(context),
      profileVm.schoolAdminProfileApi(context),
    ]);
  }

  Future<void> _onClassChanged(Data? cls) async {
    setState(() {
      _selectedClass   = cls;
      _selectedSection = null;
    });
    if (cls?.classId == null) return;
    await context.read<AllSectionsViewModel>()
        .allSectionsApi(context, cls!.classId.toString());
  }

  Future<void> _loadTimetable() async {
    if (_selectedClass == null || _selectedSection == null || _selectedExam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select class, section, and exam')),
      );
      return;
    }
    await context.read<SchoolExamTimeTableViewModel>().getExamTimetable(
      examId:    _selectedExam!.examId!,
      classId:   _selectedClass!.classId!,
      sectionId: _selectedSection!.sectionId!,
      context:   context,
    );
  }

  // ── PDF ────────────────────────────────────────────────────────────────────
  Future<void> _downloadPdf() async {
    final ttVm      = context.read<SchoolExamTimeTableViewModel>();
    final profileVm = context.read<SchoolAdminProfileViewModel>();

    final items = ttVm.examTimeTableModel?.data;
    if (items == null || items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No timetable data to export')),
      );
      return;
    }

    setState(() => _pdfLoading = true);

    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted && !status.isLimited) {
          // Android 13+ doesn't need storage permission — proceed anyway
        }
      }

      final school = profileVm.schoolAdminProfileModel?.data;
      final file   = await _buildPdf(
        items:       items,
        schoolName:  school?.schoolName  ?? 'School',
        schoolPhone: school?.schoolPhoneNumber ?? '',
        schoolEmail: school?.schoolEmail ?? '',
        schoolAddr:  school?.schoolAdrees ?? '',
        examName:    _selectedExam?.examName  ?? 'Exam',
        className:   _selectedClass?.className ?? 'Class',
        sectionName: _selectedSection?.sectionName ?? 'Section',
      );

      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfLoading = false);
    }
  }

  // ── PDF Builder ────────────────────────────────────────────────────────────
  static Future<File> _buildPdf({
    required List<ExamTimetableData> items,
    required String schoolName,
    required String schoolPhone,
    required String schoolEmail,
    required String schoolAddr,
    required String examName,
    required String className,
    required String sectionName,
  }) async {
    const dBlue   = PdfColor.fromInt(0xFF1a237e);
    const mBlue   = PdfColor.fromInt(0xFF1565c0);
    const lBlue   = PdfColor.fromInt(0xFFe3f2fd);
    const hdrBg   = PdfColor.fromInt(0xFFf5f5f5);
    const border  = PdfColor.fromInt(0xFFcccccc);
    const green   = PdfColor.fromInt(0xFF2e7d32);
    const tDark   = PdfColor.fromInt(0xFF212121);
    const tGrey   = PdfColor.fromInt(0xFF616161);
    const stripe  = PdfColor.fromInt(0xFFfafafa);
    const blueBdr = PdfColor.fromInt(0xFF90caf9);

    String fmtDate(String? raw) {
      try { return DateFormat('MMM d, y').format(DateTime.parse(raw!)); } catch (_) { return raw ?? ''; }
    }
    String fmtDay(String? raw) {
      try { return DateFormat('EEEE').format(DateTime.parse(raw!)); } catch (_) { return ''; }
    }
    String fmtTime(String? t) {
      try {
        final p = (t ?? '').split(':');
        return DateFormat('h:mm a').format(DateTime(0,1,1,int.parse(p[0]),int.parse(p[1])));
      } catch (_) { return t ?? ''; }
    }
    String fmtMark(String? m) {
      try {
        final v = double.parse(m!);
        return '${v.toStringAsFixed(2)}';
      } catch (_) { return m ?? ''; }
    }

    final now       = DateTime.now();
    final printedAt = DateFormat('dd/MM/yyyy, HH:mm').format(now);
    final genDate   = DateFormat('MMMM d, y').format(now);

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18 * PdfPageFormat.mm, vertical: 14 * PdfPageFormat.mm),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // timestamp
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text(printedAt, style: pw.TextStyle(fontSize: 7, color: tGrey)),
            pw.Text('School Dashboard - Student Portal', style: pw.TextStyle(fontSize: 7, color: tGrey)),
            pw.SizedBox(width: 40),
          ]),
          pw.Divider(color: border, thickness: 0.5),
          pw.SizedBox(height: 6),

          // header
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Expanded(
              child: pw.Text(schoolName.toUpperCase(),
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: dBlue, letterSpacing: 1.2)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: dBlue, width: 1)),
              child: pw.Column(children: [
                pw.Text('OFFICIAL DOCUMENT', style: pw.TextStyle(fontSize: 7, color: dBlue, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 2),
                pw.Text(genDate, style: pw.TextStyle(fontSize: 7, color: dBlue)),
              ]),
            ),
          ]),
          pw.SizedBox(height: 3),
          pw.Center(child: pw.Text('$schoolPhone | $schoolEmail | $schoolAddr',
              style: pw.TextStyle(fontSize: 8, color: tGrey))),
          pw.SizedBox(height: 8),
          pw.Divider(color: border, thickness: 0.5),
          pw.SizedBox(height: 6),

          // title
          pw.Center(child: pw.Text('EXAMINATION TIMETABLE',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: dBlue, letterSpacing: 1.5))),
          pw.SizedBox(height: 3),
          pw.Center(child: pw.Text('Class: $className – Section $sectionName',
              style: pw.TextStyle(fontSize: 9, color: tDark))),
          pw.SizedBox(height: 2),
          pw.Center(child: pw.Text(examName,
              style: pw.TextStyle(fontSize: 8, color: tGrey, fontStyle: pw.FontStyle.italic))),
          pw.SizedBox(height: 8),

          // info box
          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.5),
            columnWidths: const {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(1), 2: pw.FlexColumnWidth(1)},
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: hdrBg),
                children: [
                  _infoCell('EXAM', examName, border, tGrey, tDark),
                  _infoCell('CLASS & SECTION', '$className – $sectionName', border, tGrey, tDark, right: true),
                  _infoCell('TOTAL SUBJECTS', '${items.length} Subjects', border, tGrey, tDark, right: false),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // table
          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.3),
            columnWidths: const {
              0: pw.FlexColumnWidth(0.5),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.1),
              4: pw.FlexColumnWidth(1.1),
              5: pw.FlexColumnWidth(1.1),
              6: pw.FlexColumnWidth(0.8),
              7: pw.FlexColumnWidth(1.0),
              8: pw.FlexColumnWidth(1.0),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: hdrBg),
                children: ['S.No','Subject','Date','Day','Start Time','End Time','Room','Max Marks','Pass Marks']
                    .map((h) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  child: pw.Text(h, style: pw.TextStyle(fontSize: 7, color: tGrey, fontWeight: pw.FontWeight.bold)),
                )).toList(),
              ),
              ...items.asMap().entries.map((e) {
                final i    = e.key;
                final item = e.value;
                final bg   = i.isOdd ? stripe : PdfColors.white;
                final room = (item.roomNo?.isEmpty ?? true) ? '-' : item.roomNo!;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bg),
                  children: [
                    _td('${i+1}', tDark, center: true),
                    _td(item.subjectName ?? '', tDark, bold: true),
                    _td(fmtDate(item.examDate), tDark),
                    _td(fmtDay(item.examDate), mBlue, bold: true),
                    _td(fmtTime(item.startTime), tDark, center: true),
                    _td(fmtTime(item.endTime),   tDark, center: true),
                    _td(room,                    tDark, center: true),
                    _td(fmtMark(item.maxMarks),  tDark, center: true),
                    _td(fmtMark(item.minPassingMarks), green, bold: true, center: true),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 12),

          // instructions
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(color: blueBdr, width: 0.8)),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
              pw.Container(
                color: lBlue,
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: pw.Text('  IMPORTANT INSTRUCTIONS FOR STUDENTS',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: dBlue)),
              ),
              pw.Container(
                color: PdfColors.white,
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    'Report 15 minutes before commencement of the exam',
                    'Valid School ID Card & Admit Card must be carried',
                    'Write Roll Number and Name clearly on the answer sheet',
                  ].map((t) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text('✓  $t', style: pw.TextStyle(fontSize: 8, color: tDark)),
                  )).toList())),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    'Possession of electronic gadgets is strictly prohibited',
                    'No student will be allowed to leave before duration ends',
                    'Use of unfair means leads to immediate cancellation',
                  ].map((t) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text('✓  $t', style: pw.TextStyle(fontSize: 8, color: tDark)),
                  )).toList())),
                ]),
              ),
            ]),
          ),
          pw.SizedBox(height: 20),

          // signatures
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Container(
              width: 60, height: 55,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: border), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(40))),
              child: pw.Center(child: pw.Text('SCHOOL\nSTAMP', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, color: border))),
            ),
            pw.Expanded(child: pw.SizedBox()),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.SizedBox(width: 100, child: pw.Divider(color: tDark, thickness: 0.8)),
              pw.Text('Class Teacher', style: pw.TextStyle(fontSize: 8, color: tDark)),
              pw.Text('SIGNATURE',    style: pw.TextStyle(fontSize: 7, color: tGrey)),
            ]),
            pw.SizedBox(width: 30),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
              pw.SizedBox(width: 100, child: pw.Divider(color: tDark, thickness: 0.8)),
              pw.Text('Principal',  style: pw.TextStyle(fontSize: 8, color: tDark)),
              pw.Text('SIGNATURE', style: pw.TextStyle(fontSize: 7, color: tGrey)),
            ]),
          ]),
          pw.SizedBox(height: 4),
          pw.Text('Date: $genDate', style: pw.TextStyle(fontSize: 8, color: tDark)),
          pw.SizedBox(height: 8),
          pw.Divider(color: border, thickness: 0.5),
          pw.SizedBox(height: 4),
          pw.Center(child: pw.Text('$schoolName | $schoolPhone | $schoolEmail',
              style: pw.TextStyle(fontSize: 7, color: tGrey))),
        ],
      ),
    ));

    final bytes = await pdf.save();
    final dir   = await getApplicationDocumentsDirectory();
    final file  = File('${dir.path}/exam_timetable_${examName.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static pw.Widget _infoCell(String label, String value,
      PdfColor border, PdfColor tGrey, PdfColor tDark, {bool right = true}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: right ? pw.BoxDecoration(border: const pw.Border(right: pw.BorderSide(color: PdfColor.fromInt(0xFFcccccc), width: 0.5))) : null,
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 7, color: tGrey)),
        pw.SizedBox(height: 3),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: tDark)),
      ]),
    );
  }

  static pw.Widget _td(String text, PdfColor color,
      {bool bold = false, bool center = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(text,
          textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
          style: pw.TextStyle(fontSize: 8, color: color,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
    );
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: _surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Exam Timetable',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFilterCard(),
              const SizedBox(height: 16),
              Consumer<SchoolExamTimeTableViewModel>(
                builder: (_, vm, __) {
                  if (vm.loading) return const _LoadingCard();
                  final data = vm.examTimeTableModel?.data;
                  if (data == null) return const SizedBox();
                  if (data.isEmpty) return const _EmptyCard();
                  return Column(children: [
                    _buildStatsRow(data),
                    const SizedBox(height: 16),
                    _buildTableCard(data),
                  ]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter Card ────────────────────────────────────────────────────────────
  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF3FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_today_rounded, color: _primary, size: 22),
            ),
            const SizedBox(width: 12),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Exam Timetable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Filter by class, section & exam', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]),
          ]),
          const SizedBox(height: 20),
          _buildClassDropdown(),
          const SizedBox(height: 12),
          _buildSectionDropdown(),
          const SizedBox(height: 12),
          _buildExamDropdown(),
          const SizedBox(height: 16),
          _buildLoadButton(),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Consumer<AllClassesViewModel>(
      builder: (_, vm, __) {
        final items = vm.allClassesModel?.data ?? [];
        return _DropdownField<Data>(
          label: 'Select Class',
          icon: Icons.class_rounded,
          value: _selectedClass,
          items: items,
          itemLabel: (c) => c.className ?? '',
          onChanged: vm.loading ? null : (v) => _onClassChanged(v),
          isLoading: vm.loading,
        );
      },
    );
  }

  Widget _buildSectionDropdown() {
    return Consumer<AllSectionsViewModel>(
      builder: (_, vm, __) {
        final items = vm.allSectionsModel?.data ?? [];
        return _DropdownField<SectionData>(
          label: 'Select Section',
          icon: Icons.group_rounded,
          value: _selectedSection,
          items: items,
          itemLabel: (s) => s.sectionName ?? '',
          onChanged: (_selectedClass == null || vm.loading) ? null : (v) {
            setState(() => _selectedSection = v);
          },
          isLoading: vm.loading,
          hint: _selectedClass == null ? 'Select class first' : 'Select Section',
        );
      },
    );
  }

  Widget _buildExamDropdown() {
    return Consumer<ExamManagementViewModel>(
      builder: (_, vm, __) {
        final items = vm.examManagementModel?.data ?? [];
        return _DropdownField<ExamData>(
          label: 'Select Exam',
          icon: Icons.assignment_rounded,
          value: _selectedExam,
          items: items,
          itemLabel: (e) => e.examName ?? '',
          onChanged: vm.loading ? null : (v) => setState(() => _selectedExam = v),
          isLoading: vm.loading,
        );
      },
    );
  }

  Widget _buildLoadButton() {
    return Consumer<SchoolExamTimeTableViewModel>(
      builder: (_, vm, __) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: vm.loading ? null : _loadTimetable,
            icon: vm.loading
                ? const SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.search_rounded),
            label: Text(vm.loading ? 'Loading...' : 'Load Timetable',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow(List<ExamTimetableData> data) {
    final totalDays    = data.map((e) => e.examDate).toSet().length;
    final uniqueSubs   = data.map((e) => e.subjectName).toSet().length;
    final maxMarksVals = data.map((e) => double.tryParse(e.maxMarks ?? '0') ?? 0);
    final maxMark      = maxMarksVals.isEmpty ? 0 : maxMarksVals.reduce((a, b) => a > b ? a : b);

    final stats = [
      _StatInfo('TOTAL\nSUBJECTS', '${data.length}',   const Color(0xFFEEF3FB), const Color(0xFF003B8F), Icons.book_rounded),
      _StatInfo('EXAM\nDAYS',      '$totalDays',       const Color(0xFFDDF6E7), Colors.green.shade800,   Icons.event_rounded),
      _StatInfo('UNIQUE\nSUBJECTS','$uniqueSubs',      const Color(0xFFEEE8FF), Colors.deepPurple,       Icons.category_rounded),
      _StatInfo('MAX\nMARKS',      '${maxMark.toInt()}',const Color(0xFFFFF1DB), Colors.deepOrange,      Icons.star_rounded),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.1,
      children: stats.map((s) => _statCard(s)).toList(),
    );
  }

  Widget _statCard(_StatInfo s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Icon(s.icon, color: s.valueColor, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(s.label, style: TextStyle(fontSize: 10, letterSpacing: 0.5, fontWeight: FontWeight.w600, color: s.valueColor.withOpacity(0.7))),
            const SizedBox(height: 4),
            Text(s.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: s.valueColor, height: 1)),
          ]),
        ),
      ]),
    );
  }

  // ── Table Card ─────────────────────────────────────────────────────────────
  Widget _buildTableCard(List<ExamTimetableData> data) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_selectedExam?.examName ?? 'Timetable',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${_selectedClass?.className ?? ''} - ${_selectedSection?.sectionName ?? ''}  •  ${data.length} subjects',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ])),
              _pdfLoading
                  ? const SizedBox(width: 24, height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: _accent))
                  : ElevatedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 0,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // horizontal scroll table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: _buildDataTable(data),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<ExamTimetableData> data) {
    String fmtDate(String? raw) {
      try { return DateFormat('MMM d, y').format(DateTime.parse(raw!)); } catch (_) { return raw ?? ''; }
    }
    String fmtDay(String? raw) {
      try { return DateFormat('EEEE').format(DateTime.parse(raw!)); } catch (_) { return ''; }
    }
    String fmtTime(String? t) {
      try {
        final p = (t ?? '').split(':');
        return DateFormat('h:mm a').format(DateTime(0,1,1,int.parse(p[0]),int.parse(p[1])));
      } catch (_) { return t ?? ''; }
    }
    String fmtMark(String? m) {
      try { return double.parse(m!).toStringAsFixed(2); } catch (_) { return m ?? ''; }
    }

    const hStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF555555));
    const cols = ['Subject','Date','Day','Start Time','End Time','Room','Max Marks','Pass Marks'];

    return DataTable(
      headingRowHeight: 44,
      dataRowMinHeight: 52,
      dataRowMaxHeight: 52,
      columnSpacing: 24,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF5F7FB)),
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      columns: cols.map((c) => DataColumn(label: Text(c, style: hStyle))).toList(),
      rows: data.asMap().entries.map((entry) {
        final i    = entry.key;
        final item = entry.value;
        final room = (item.roomNo?.isEmpty ?? true) ? '-' : item.roomNo!;
        final day  = fmtDay(item.examDate);

        // day color
        const dayColors = {
          'Sunday': Color(0xFFE53935), 'Saturday': Color(0xFF8E24AA),
          'Monday': Color(0xFF1E88E5), 'Tuesday': Color(0xFF00897B),
          'Wednesday': Color(0xFFFB8C00), 'Thursday': Color(0xFF3949AB),
          'Friday': Color(0xFF43A047),
        };
        final dayColor = dayColors[day] ?? const Color(0xFF1565c0);

        return DataRow(
          color: MaterialStateProperty.resolveWith((states) =>
          i.isEven ? Colors.white : const Color(0xFFFAFAFA)),
          cells: [
            DataCell(Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3FB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('${i+1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: _primary, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Text(item.subjectName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ])),
            DataCell(Text(fmtDate(item.examDate), style: const TextStyle(fontSize: 13))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: dayColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(day, style: TextStyle(color: dayColor, fontWeight: FontWeight.w600, fontSize: 12)),
            )),
            DataCell(Text(fmtTime(item.startTime), style: const TextStyle(fontSize: 13))),
            DataCell(Text(fmtTime(item.endTime),   style: const TextStyle(fontSize: 13))),
            DataCell(room == '-'
                ? Text(room, style: const TextStyle(color: Colors.grey))
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF3FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(room, style: const TextStyle(fontWeight: FontWeight.w600, color: _primary, fontSize: 12)),
            )),
            DataCell(Text(fmtMark(item.maxMarks),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
            DataCell(Text(fmtMark(item.minPassingMarks),
                style: const TextStyle(color: Color(0xFF2e7d32), fontWeight: FontWeight.bold, fontSize: 13))),
          ],
        );
      }).toList(),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────
class _DropdownField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final bool isLoading;
  final String? hint;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.isLoading = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: isLoading
            ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
            : Icon(icon, color: const Color(0xFF1a237e)),
        filled: true,
        fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1a237e), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      hint: Text(hint ?? label, style: const TextStyle(color: Colors.grey)),
      isExpanded: true,
      items: items.map((item) => DropdownMenuItem<T>(
        value: item,
        child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
      )).toList(),
      onChanged: onChanged,
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: Color(0xFF1a237e)),
        SizedBox(height: 16),
        Text('Loading timetable...', style: TextStyle(color: Colors.grey)),
      ])),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey),
        SizedBox(height: 12),
        Text('No timetable found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        SizedBox(height: 4),
        Text('Try a different filter combination', style: TextStyle(color: Colors.grey)),
      ])),
    );
  }
}

class _StatInfo {
  final String label, value;
  final Color bg, valueColor;
  final IconData icon;
  const _StatInfo(this.label, this.value, this.bg, this.valueColor, this.icon);
}