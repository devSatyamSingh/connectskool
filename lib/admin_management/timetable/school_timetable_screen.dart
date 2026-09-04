import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' show MultiPage;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/school_view_model/subject/all_subjects_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/school_model/timetable/classes_time_table_model.dart';
import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../view_model/school_view_model/section/all_scetions_view_model.dart';
import '../../view_model/school_view_model/timetable/create_class_time_table_View_model.dart';
import '../../view_model/school_view_model/timetable/delete_classes_time_table_view_model.dart';
import '../../view_model/school_view_model/timetable/edit_class_time_table_view_model.dart';
import '../../view_model/school_view_model/timetable/get_classes_timetable_view_model.dart';

class SchoolTimetableScreen extends StatefulWidget {
  const SchoolTimetableScreen({super.key});

  @override
  State<SchoolTimetableScreen> createState() => _SchoolTimetableScreenState();
}

class _SchoolTimetableScreenState extends State<SchoolTimetableScreen> {
  String? _selectedClassId;
  String? _selectedSectionId;
  String? selectedDay;
  bool _isDownloadingPdf = false;

  final List<String> dayList = [
    "All",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final _dayOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  Future<void> _downloadTimetable(List<TimeTableData> data) async {
    if (_isDownloadingPdf) return;

    setState(() => _isDownloadingPdf = true);

    try {
      final classVm = Provider.of<AllClassesViewModel>(context, listen: false);
      final secVm   = Provider.of<AllSectionsViewModel>(context, listen: false);

      final className =
          (classVm.allClassesModel?.data ?? [])
              .where((e) => e.classId?.toString() == _selectedClassId)
              .map((e) => e.className ?? '')
              .firstOrNull ?? 'Class';

      final sectionName =
          (secVm.allSectionsModel?.data ?? [])
              .where((e) => e.sectionId?.toString() == _selectedSectionId)
              .map((e) => e.sectionName ?? '')
              .firstOrNull ?? 'Section';

      final pdf     = pw.Document();
      final grouped = _groupByDay(data);
      final sortedDays = _dayOrder.where((d) => grouped.containsKey(d)).toList();
      final now     = DateTime.now();
      final dateStr = '${now.day.toString().padLeft(2,'0')}/'
          '${now.month.toString().padLeft(2,'0')}/'
          '${now.year}  ${now.hour.toString().padLeft(2,'0')}:'
          '${now.minute.toString().padLeft(2,'0')}';

      const headerBg  = PdfColor.fromInt(0xFF1a237e);
      const accentBg  = PdfColor.fromInt(0xFF1565c0);
      const lightBlue = PdfColor.fromInt(0xFFe3f2fd);
      const rowAlt    = PdfColor.fromInt(0xFFf5f7ff);
      const border    = PdfColor.fromInt(0xFFdde3f0);
      const tDark     = PdfColor.fromInt(0xFF212121);
      const tGrey     = PdfColor.fromInt(0xFF616161);
      const tWhite    = PdfColors.white;
      const greenDot  = PdfColor.fromInt(0xFF2e7d32);

      const dayColors = {
        'Monday':    PdfColor.fromInt(0xFF1E88E5),
        'Tuesday':   PdfColor.fromInt(0xFF00897B),
        'Wednesday': PdfColor.fromInt(0xFFFB8C00),
        'Thursday':  PdfColor.fromInt(0xFF3949AB),
        'Friday':    PdfColor.fromInt(0xFF43A047),
        'Saturday':  PdfColor.fromInt(0xFF8E24AA),
        'Sunday':    PdfColor.fromInt(0xFFE53935),
      };

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(20, 20, 20, 24),

          header: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: const pw.BoxDecoration(color: headerBg),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'timetable.class_timetable'.tr().toUpperCase(),
                          style: pw.TextStyle(
                            color: tWhite,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '$className * ${'timetable.section'.tr()} $sectionName',
                          style: pw.TextStyle(color: tWhite, fontSize: 10),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          '${'timetable.academic_schedule'.tr()} ${data.length} ${'timetable.periods'.tr()}',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFFbbdefb),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColor.fromInt(0xFF90caf9),
                              width: 0.8,
                            ),
                          ),
                          child: pw.Text(
                            'timetable.official_document'.tr().toUpperCase(),
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFbbdefb),
                              fontSize: 7,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${'timetable.generated'.tr()}: $dateStr',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFFbbdefb),
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const pw.BoxDecoration(color: lightBlue),
                child: pw.Row(
                  children: [
                    _statChip('timetable.total_periods'.tr(), '${data.length}', accentBg, tWhite),
                    pw.SizedBox(width: 12),
                    _statChip('timetable.working_days'.tr(), '${sortedDays.length}', greenDot, tWhite),
                    pw.SizedBox(width: 12),
                    _statChip(
                      'timetable.subjects_count'.tr(),
                      '${data.map((e) => e.subjectName).toSet().length}',
                      PdfColor.fromInt(0xFF6D28D9),
                      tWhite,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          ),

          footer: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Divider(color: border, thickness: 0.5),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '$className | ${'timetable.section'.tr()} $sectionName | ${'timetable.class_timetable'.tr()}',
                    style: pw.TextStyle(fontSize: 7, color: tGrey),
                  ),
                  pw.Text(
                    'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                    style: pw.TextStyle(fontSize: 7, color: tGrey),
                  ),
                ],
              ),
            ],
          ),

          build: (_) => sortedDays.map((day) {
            final periods  = grouped[day]!;
            final dayColor = dayColors[day] ?? accentBg;
            final lightDay = PdfColor(
              dayColor.red,
              dayColor.green,
              dayColor.blue,
              0.08,
            );

            final dayKey = day.toLowerCase();
            final dayLabel = dayKey == 'monday' ? 'timetable.monday'.tr() :
            dayKey == 'tuesday' ? 'timetable.tuesday'.tr() :
            dayKey == 'wednesday' ? 'timetable.wednesday'.tr() :
            dayKey == 'thursday' ? 'timetable.thursday'.tr() :
            dayKey == 'friday' ? 'timetable.friday'.tr() :
            dayKey == 'saturday' ? 'timetable.saturday'.tr() :
            dayKey == 'sunday' ? 'timetable.sunday'.tr() : day;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: pw.BoxDecoration(
                    color: dayColor,
                    borderRadius: const pw.BorderRadius.only(
                      topLeft:  pw.Radius.circular(6),
                      topRight: pw.Radius.circular(6),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        dayLabel.toUpperCase(),
                        style: pw.TextStyle(
                          color: tWhite,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                        ),
                        child: pw.Text(
                          '${periods.length} ${'timetable.periods'.tr()}',
                          style: pw.TextStyle(
                            color: dayColor,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Table(
                  border: pw.TableBorder.all(color: border, width: 0.4),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.6),
                    1: pw.FlexColumnWidth(2.2),
                    2: pw.FlexColumnWidth(2.2),
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFEEF3FB),
                      ),
                      children: [
                        _pdfTh('timetable.time'.tr()),
                        _pdfTh('timetable.subject_label'.tr()),
                        _pdfTh('timetable.teacher_label'.tr()),
                      ],
                    ),

                    ...periods.asMap().entries.map((entry) {
                      final idx  = entry.key;
                      final p    = entry.value;
                      final bg   = idx.isOdd
                          ? const PdfColor.fromInt(0xFFFAFAFA)
                          : PdfColors.white;

                      return pw.TableRow(
                        decoration: pw.BoxDecoration(color: bg),
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  _fmtTime(p.startTime),
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: tDark,
                                  ),
                                ),
                                pw.Text(
                                  ' ${_fmtTime(p.endTime)}',
                                  style: pw.TextStyle(fontSize: 8, color: tGrey),
                                ),
                              ],
                            ),
                          ),

                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  width: 4,
                                  height: 28,
                                  decoration: pw.BoxDecoration(
                                    color: dayColor,
                                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Expanded(
                                  child: pw.Text(
                                    p.subjectName ?? '-',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      color: tDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColor.fromInt(0xFFEEF3FB),
                                    shape: pw.BoxShape.circle,
                                  ),
                                  child: pw.Center(
                                    child: pw.Text(
                                      (p.teacherName?.isNotEmpty == true)
                                          ? p.teacherName![0].toUpperCase()
                                          : '?',
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold,
                                        color: accentBg,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Expanded(
                                  child: pw.Text(
                                    p.teacherName ?? '-',
                                    style: pw.TextStyle(fontSize: 9, color: tDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 14),
              ],
            );
          }).toList(),
        ),
      );

      final dir      = await getApplicationDocumentsDirectory();
      final fileName = 'Timetable_${className}_${sectionName}_${now.millisecondsSinceEpoch}.pdf';
      final file     = File('${dir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;
      setState(() => _isDownloadingPdf = false);

      await OpenFile.open(file.path);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text('timetable.pdf_downloaded'.tr()),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('PDF DOWNLOAD ERROR => $e');
      if (!mounted) return;
      setState(() => _isDownloadingPdf = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'timetable.pdf_failed'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  pw.Widget _statChip(String label, String value, PdfColor bg, PdfColor fg) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 6, color: PdfColor(fg.red, fg.green, fg.blue, 0.75))),
          pw.SizedBox(height: 1),
          pw.Text(value,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: fg)),
        ],
      ),
    );
  }

  pw.Widget _pdfTh(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: const PdfColor.fromInt(0xFF616161),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  String _fmtTime(String? t) {
    try {
      final p  = (t ?? '').split(':');
      final dt = DateTime(0, 1, 1, int.parse(p[0]), int.parse(p[1]));
      final h  = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final m  = dt.minute.toString().padLeft(2, '0');
      final a  = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $a';
    } catch (_) {
      return t ?? '';
    }
  }

  pw.Widget _pdfCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!PermissionExtensions.canAccess(PermissionKeys.viewTimetable)) {
        Utils.show('timetable.you_dont_have_permission'.tr(), context);
        Navigator.pop(context);
        return;
      }
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);
      Provider.of<AllSubjectsVieModel>(
        context,
        listen: false,
      ).allSubjectsApi(context);
      Provider.of<AllTeachersListVieModel>(
        context,
        listen: false,
      ).allTeachersListApi(context);
    });
  }

  Future<void> _loadSections(String classId) async {
    await Provider.of<AllSectionsViewModel>(
      context,
      listen: false,
    ).allSectionsApi(context, classId);
  }

  Future<void> _loadTimetable() async {
    if (_selectedClassId == null || _selectedSectionId == null) return;
    await Provider.of<GetClassesTimeTableViewModel>(
      context,
      listen: false,
    ).getTimeTable(
      classId: int.parse(_selectedClassId!),
      sectionId: int.parse(_selectedSectionId!),
    );
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateTimetableSheet(
        preselectedClassId: _selectedClassId,
        preselectedSectionId: _selectedSectionId,
        onSuccess: _loadTimetable,
      ),
    );
  }

  void _showEditSheet(TimeTableData period) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateTimetableSheet(
        preselectedClassId: _selectedClassId,
        preselectedSectionId: _selectedSectionId,
        onSuccess: _loadTimetable,
        editData: period,
      ),
    );
  }

  void _confirmDelete(TimeTableData period) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_rounded,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'timetable.delete_period'.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'timetable.delete_confirm'.tr()
                    .replaceAll('{subject}', period.subjectName?.toString() ?? 'this period')
                    .replaceAll('{day}', period.dayOfWeek?.toString() ?? ''),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'timetable.cancel'.tr(),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _deletePeriod(period);
            },
            child: Text('timetable.delete'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePeriod(TimeTableData period) async {
    final success = await Provider.of<DeleteClassesTimeTableViewModel>(
      context,
      listen: false,
    ).deleteClassesTimeTableApi(period.timetableId!, context);

    if (success && mounted) {
      Provider.of<GetClassesTimeTableViewModel>(
        context,
        listen: false,
      ).timetableList.removeWhere((e) => e.timetableId == period.timetableId);
      Provider.of<GetClassesTimeTableViewModel>(
        context,
        listen: false,
      ).notifyListeners();
    }
  }

  Map<String, List<TimeTableData>> _groupByDay(List<TimeTableData> data) {
    final Map<String, List<TimeTableData>> grouped = {};
    for (final item in data) {
      final day = item.dayOfWeek?.toString() ?? 'Unknown';
      grouped.putIfAbsent(day, () => []).add(item);
    }
    return grouped;
  }

  Color _dayColor(String day) {
    const colors = {
      'Monday': Color(0xFF5C6BC0),
      'Tuesday': Color(0xFF26A69A),
      'Wednesday': Color(0xFFEF5350),
      'Thursday': Color(0xFFFF7043),
      'Friday': Color(0xFF66BB6A),
      'Saturday': Color(0xFFAB47BC),
      'Sunday': Color(0xFF78909C),
    };
    return colors[day] ?? AppColor.lightBlueColor;
  }

  IconData _subjectIcon(String? subject) {
    final s = subject?.toLowerCase() ?? '';
    if (s.contains('math')) return Icons.calculate_rounded;
    if (s.contains('science')) return Icons.science_rounded;
    if (s.contains('english')) return Icons.menu_book_rounded;
    if (s.contains('hindi')) return Icons.translate_rounded;
    if (s.contains('history')) return Icons.history_edu_rounded;
    if (s.contains('geo')) return Icons.public_rounded;
    if (s.contains('computer')) return Icons.computer_rounded;
    if (s.contains('art')) return Icons.palette_rounded;
    if (s.contains('sport') || s.contains('pe'))
      return Icons.sports_soccer_rounded;
    return Icons.class_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: SizedBox(
        width: 170,
        child: AppButton(
          title: 'timetable.add_period'.tr(),
          icon: Icons.add_rounded,
          height: 56,
          radius: 16,
          onTap: () {
            if (!PermissionExtensions.canAccess(
              PermissionKeys.manageTimetable,
            )) {
              Utils.show('timetable.no_permission_manage'.tr(), context);
              return;
            }

            _showCreateSheet();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
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
                            'timetable.title'.tr(),
                            size: 20,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          AppText.customText(
                            'timetable.subtitle'.tr(),
                            size: 12,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                    Consumer<GetClassesTimeTableViewModel>(
                      builder: (context, vm, _) {
                        final hasData =
                            vm.timetableList.isNotEmpty &&
                                _selectedClassId != null &&
                                _selectedSectionId != null;

                        if (!hasData) {
                          return const SizedBox();
                        }

                        return IgnorePointer(
                          ignoring: _isDownloadingPdf,
                          child: GestureDetector(
                            onTap: () async {
                              await _downloadTimetable(
                                vm.timetableList,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 250,
                              ),
                              height: 42,
                              width: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.glassWhite,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _isDownloadingPdf
                                  ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<AllClassesViewModel>(
                        builder: (context, vm, _) {
                          final classes = vm.allClassesModel?.data ?? [];
                          return _headerDropdown(
                            hint: 'timetable.select_class'.tr(),
                            value: _selectedClassId,
                            items: classes
                                .map(
                                  (c) => DropdownMenuItem(
                                value: c.classId?.toString(),
                                child: Text(
                                  c.className ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedClassId = v;
                                _selectedSectionId = null;
                                selectedDay = null;
                              });
                              Provider.of<GetClassesTimeTableViewModel>(
                                context,
                                listen: false,
                              ).timetableList.clear();
                              if (v != null) _loadSections(v);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Consumer<AllSectionsViewModel>(
                        builder: (context, vm, _) {
                          final sections = vm.allSectionsModel?.data ?? [];
                          final noSection =
                              _selectedClassId != null && sections.isEmpty;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: noSection
                                  ? Border.all(
                                color: Colors.orange.shade400,
                                width: 1.5,
                              )
                                  : null,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value:
                                sections.any(
                                      (s) =>
                                  s.sectionId?.toString() ==
                                      _selectedSectionId,
                                )
                                    ? _selectedSectionId
                                    : null,
                                isExpanded: true,
                                hint: Row(
                                  children: noSection
                                      ? [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 14,
                                      color: Colors.orange.shade600,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'timetable.no_sections'.tr(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]
                                      : [
                                    Text(
                                      'timetable.select_section'.tr(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                                icon: Icon(
                                  noSection
                                      ? Icons.warning_amber_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: noSection
                                      ? Colors.orange.shade400
                                      : AppColor.lightBlueColor,
                                  size: 20,
                                ),
                                items: sections
                                    .map(
                                      (s) => DropdownMenuItem(
                                    value: s.sectionId?.toString(),
                                    child: Text(
                                      s.sectionName ?? '',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: noSection
                                    ? null
                                    : (v) {
                                  setState(() {
                                    _selectedSectionId = v;
                                    selectedDay = null;
                                  });
                                  if (v != null &&
                                      _selectedClassId != null) {
                                    _loadTimetable();
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Consumer<GetClassesTimeTableViewModel>(
                  builder: (context, vm, _) {
                    final canSelectDay =
                        _selectedClassId != null &&
                            _selectedSectionId != null;

                    return Opacity(
                      opacity: canSelectDay ? 1 : 0.5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            value: selectedDay,
                            isExpanded: true,
                            hint: Text(
                              'timetable.select_day'.tr(),
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            items: dayList.map((day) {
                              final dayKey = day.toLowerCase();
                              final label = dayKey == 'all' ? 'timetable.all_days'.tr() :
                              dayKey == 'monday' ? 'timetable.monday'.tr() :
                              dayKey == 'tuesday' ? 'timetable.tuesday'.tr() :
                              dayKey == 'wednesday' ? 'timetable.wednesday'.tr() :
                              dayKey == 'thursday' ? 'timetable.thursday'.tr() :
                              dayKey == 'friday' ? 'timetable.friday'.tr() :
                              dayKey == 'saturday' ? 'timetable.saturday'.tr() :
                              dayKey == 'sunday' ? 'timetable.sunday'.tr() : day;
                              return DropdownMenuItem<String>(
                                value: day,
                                child: Text(label),
                              );
                            }).toList(),
                            onChanged: !canSelectDay
                                ? null
                                : (value) async {
                              setState(() {
                                selectedDay = value;
                              });
                              await _loadTimetable();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_selectedClassId != null && _selectedSectionId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Consumer2<AllClassesViewModel, AllSectionsViewModel>(
                      builder: (context, classVm, secVm, _) {
                        final className =
                            (classVm.allClassesModel?.data ?? [])
                                .where(
                                  (c) =>
                              c.classId?.toString() == _selectedClassId,
                            )
                                .map((c) => c.className ?? '')
                                .firstOrNull ??
                                '';
                        final sectionName =
                            (secVm.allSectionsModel?.data ?? [])
                                .where(
                                  (s) =>
                              s.sectionId?.toString() ==
                                  _selectedSectionId,
                            )
                                .map((s) => s.sectionName ?? '')
                                .firstOrNull ??
                                '';
                        if (className.isEmpty) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.glassWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              AppText.customText(
                                '$className  •  ${'timetable.section'.tr()} $sectionName',
                                size: 12,
                                color: Colors.white,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<GetClassesTimeTableViewModel>(
              builder: (context, vm, _) {
                if (_selectedClassId == null ||
                    _selectedSectionId == null) {
                  return _selectFirstState();
                }

                if (selectedDay == null) {
                  return _selectDayState();
                }

                if (vm.loading) {
                  return _shimmer();
                }

                final List<TimeTableData> data = vm.timetableList;

                if (data.isEmpty) {
                  return _emptyState();
                }

                List<TimeTableData> filteredData = data;

                if (selectedDay != "All") {
                  filteredData = data
                      .where((e) => e.dayOfWeek == selectedDay)
                      .toList();
                }

                if (filteredData.isEmpty) {
                  return _emptyDayState();
                }

                final grouped = _groupByDay(filteredData);

                final sortedDays = _dayOrder
                    .where((d) => grouped.containsKey(d))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortedDays.length,
                  itemBuilder: (_, i) {
                    final day = sortedDays[i];

                    return _dayCard(day, grouped[day]!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerDropdown({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    Color? hintColor,
    Color? borderColor,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border.all(
          color: borderColor,
          width: 1.5,
        )
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: hintColor ?? Colors.grey.shade400,
              fontSize: 13,
              fontWeight: hintColor != null
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          icon: Icon(
            suffixIcon ?? Icons.keyboard_arrow_down_rounded,
            color: suffixColor ?? AppColor.lightBlueColor,
            size: 20,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _emptyDayState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'timetable.no_timetable'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              selectedDay == "All"
                  ? 'timetable.no_timetable'.tr()
                  : 'timetable.no_timetable_day'.tr().replaceAll('{day}', selectedDay!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectDayState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'timetable.select_day'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'timetable.select_day_desc'.tr(),
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCard(String day, List<TimeTableData> periods) {
    final color = _dayColor(day);
    final dayKey = day.toLowerCase();
    final dayLabel = dayKey == 'monday' ? 'timetable.monday'.tr() :
    dayKey == 'tuesday' ? 'timetable.tuesday'.tr() :
    dayKey == 'wednesday' ? 'timetable.wednesday'.tr() :
    dayKey == 'thursday' ? 'timetable.thursday'.tr() :
    dayKey == 'friday' ? 'timetable.friday'.tr() :
    dayKey == 'saturday' ? 'timetable.saturday'.tr() :
    dayKey == 'sunday' ? 'timetable.sunday'.tr() : day;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.today_rounded, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                AppText.customText(
                  dayLabel,
                  size: 15,
                  weight: FontWeight.bold,
                  color: color,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText.customText(
                    '${periods.length} ${periods.length == 1 ? 'timetable.period'.tr() : 'timetable.periods'.tr()}',
                    size: 11,
                    color: color,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...periods.asMap().entries.map(
                (e) => _periodTile(e.value, color, e.key == periods.length - 1),
          ),
        ],
      ),
    );
  }

  Widget _periodTile(TimeTableData period, Color color, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Column(
                  children: [
                    AppText.customText(
                      period.startTime?.toString() ?? '--:--',
                      size: 12,
                      weight: FontWeight.bold,
                      color: color,
                    ),
                    Container(
                      width: 1,
                      height: 14,
                      color: color.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                    AppText.customText(
                      period.endTime?.toString() ?? '--:--',
                      size: 10,
                      color: AppColor.softGreyText,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _subjectIcon(period.subjectName?.toString()),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                      period.subjectName?.toString() ?? 'Subject',
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: AppColor.softGreyText,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: AppText.customText(
                            period.teacherName?.toString() ?? '',
                            size: 12,
                            color: AppColor.softGreyText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.groups_rounded,
                          size: 13,
                          color: AppColor.softGreyText,
                        ),
                        const SizedBox(width: 4),
                        AppText.customText(
                          '${period.className ?? ''} - ${period.sectionName ?? ''}',
                          size: 12,
                          color: AppColor.softGreyText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!PermissionExtensions.canAccess(
                        PermissionKeys.manageTimetable,
                      )) {
                        Utils.show('timetable.no_permission_edit'.tr(), context);
                        return;
                      }
                      _showEditSheet(period);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(Icons.edit_rounded, color: color, size: 15),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      if (!PermissionExtensions.canAccess(
                        PermissionKeys.manageTimetable,
                      )) {
                        Utils.show('timetable.no_permission_delete'.tr(), context);
                        return;
                      }
                      _confirmDelete(period);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        Icons.delete_rounded,
                        color: Colors.red.shade400,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 70,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }

  Widget _selectFirstState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColor.lightBlueColor.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.touch_app_rounded,
            size: 60,
            color: AppColor.lightBlueColor.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 20),
        AppText.customText(
          'timetable.select_class_section'.tr(),
          size: 18,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        AppText.customText(
          'timetable.select_class_section_desc'.tr(),
          size: 13,
          color: AppColor.softGreyText,
          align: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _shimmer() => ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    itemCount: 3,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColor.lightBlueColor.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.calendar_today_rounded,
            size: 60,
            color: AppColor.lightBlueColor.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 20),
        AppText.customText(
          'timetable.no_timetable'.tr(),
          size: 18,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        AppText.customText(
          'timetable.no_timetable_desc'.tr(),
          size: 13,
          color: AppColor.softGreyText,
          align: TextAlign.center,
        ),
      ],
    ),
  );
}

class _CreateTimetableSheet extends StatefulWidget {
  final String? preselectedClassId;
  final String? preselectedSectionId;
  final VoidCallback onSuccess;
  final TimeTableData? editData;

  const _CreateTimetableSheet({
    this.preselectedClassId,
    this.preselectedSectionId,
    required this.onSuccess,
    this.editData,
  });

  @override
  State<_CreateTimetableSheet> createState() => _CreateTimetableSheetState();
}

class _CreateTimetableSheetState extends State<_CreateTimetableSheet> {
  String? _classId;
  String? _sectionId;
  String? _subjectId;
  String? _teacherId;
  String? _dayOfWeek;
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  bool _loading = false;

  String? _sectionError;
  String? _subjectError;
  String? _teacherError;
  String? _dayError;
  String? _startError;
  String? _endError;

  bool get _isEditMode => widget.editData != null;

  final _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _classId = widget.preselectedClassId;
    _sectionId = widget.preselectedSectionId;

    if (_isEditMode) {
      final d = widget.editData!;
      _classId = d.classId?.toString() ?? widget.preselectedClassId;
      _sectionId = d.sectionId?.toString() ?? widget.preselectedSectionId;
      _subjectId = d.subjectId?.toString();
      _teacherId = d.teacherId?.toString();
      _dayOfWeek = d.dayOfWeek?.toString();
      _startCtrl.text = d.startTime?.toString() ?? '';
      _endCtrl.text = d.endTime?.toString() ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context;
      Provider.of<AllClassesViewModel>(ctx, listen: false).allClassesApi(ctx);
      Provider.of<AllSubjectsVieModel>(ctx, listen: false).allSubjectsApi(ctx);
      Provider.of<AllTeachersListVieModel>(
        ctx,
        listen: false,
      ).allTeachersListApi(ctx);
      if (_classId != null) {
        Provider.of<AllSectionsViewModel>(
          ctx,
          listen: false,
        ).allSectionsApi(ctx, _classId!);
      }
    });
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (t != null) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      setState(() => ctrl.text = '$h:$m:00');
    }
  }

  bool _validate(List sections) {
    bool valid = true;
    setState(() {
      if (_classId != null && sections.isEmpty) {
        _sectionError = 'timetable.no_section_error'.tr();
        valid = false;
      } else if (_sectionId == null) {
        _sectionError = 'timetable.section_required'.tr();
        valid = false;
      } else {
        _sectionError = null;
      }

      if (_subjectId == null) {
        _subjectError = 'timetable.subject_required'.tr();
        valid = false;
      } else
        _subjectError = null;

      if (_teacherId == null) {
        _teacherError = 'timetable.teacher_required'.tr();
        valid = false;
      } else
        _teacherError = null;

      if (_dayOfWeek == null) {
        _dayError = 'timetable.day_required'.tr();
        valid = false;
      } else
        _dayError = null;

      if (_startCtrl.text.isEmpty) {
        _startError = 'timetable.start_time_required'.tr();
        valid = false;
      } else
        _startError = null;

      if (_endCtrl.text.isEmpty) {
        _endError = 'timetable.end_time_required'.tr();
        valid = false;
      } else
        _endError = null;
    });
    return valid;
  }

  Future<void> _submit(List sections) async {
    if (!_validate(sections)) return;

    if (sections.isEmpty) {
      _showNoSectionDialog();
      return;
    }

    setState(() => _loading = true);

    if (_isEditMode) {
      final success =
      await Provider.of<EditClassesTimeTableViewModel>(
        context,
        listen: false,
      ).editClassTimeTableApi(
        widget.editData!.timetableId!,
        int.parse(_classId!),
        int.parse(_sectionId!),
        int.parse(_subjectId!),
        int.parse(_teacherId!),
        _dayOfWeek!,
        _startCtrl.text,
        _endCtrl.text,
        context,
      );
      setState(() => _loading = false);
      if (success && mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } else {
      final success =
      await Provider.of<CreateClassTimetableViewModel>(
        context,
        listen: false,
      ).createClassTimeTableApi(
        int.parse(_classId!),
        int.parse(_sectionId!),
        int.parse(_subjectId!),
        int.parse(_teacherId!),
        _dayOfWeek!,
        _startCtrl.text,
        _endCtrl.text,
        context,
      );
      setState(() => _loading = false);
      if (success && mounted) {
        widget.onSuccess();
      }
    }
  }

  void _showNoSectionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade600,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'timetable.no_section_dialog_title'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'timetable.no_section_dialog_desc'.tr(),
          style: const TextStyle(fontSize: 13.5, height: 1.6),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text('timetable.ok'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: Colors.green.shade500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Consumer<AllSectionsViewModel>(
          builder: (ctx, secVm, _) {
            final sections = secVm.allSectionsModel?.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isEditMode
                              ? Icons.edit_calendar_rounded
                              : Icons.schedule_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              _isEditMode ? 'timetable.edit_timetable'.tr() : 'timetable.add_timetable'.tr(),
                              size: 18,
                              weight: FontWeight.bold,
                            ),
                            AppText.customText(
                              _isEditMode
                                  ? 'timetable.update_details'.tr()
                                  : 'timetable.fill_details'.tr(),
                              size: 12,
                              color: AppColor.softGreyText,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _label(
                          '${'timetable.class'.tr()} *',
                          Consumer<AllClassesViewModel>(
                            builder: (ctx, vm, _) => _sheetDrop(
                              hint: 'timetable.select'.tr(),
                              value: _classId,
                              items: (vm.allClassesModel?.data ?? [])
                                  .map(
                                    (c) => DropdownMenuItem(
                                  value: c.classId?.toString(),
                                  child: Text(c.className ?? ''),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  _classId = v;
                                  _sectionId = null;
                                  _sectionError = null;
                                });
                                if (v != null) {
                                  Provider.of<AllSectionsViewModel>(
                                    context,
                                    listen: false,
                                  ).allSectionsApi(context, v);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _label(
                          '${'timetable.section'.tr()} *',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sheetDrop(
                                hint: _classId != null && sections.isEmpty
                                    ? '⚠ ${'timetable.no_sections'.tr()}'
                                    : 'timetable.select'.tr(),
                                value:
                                sections.any(
                                      (s) =>
                                  s.sectionId?.toString() == _sectionId,
                                )
                                    ? _sectionId
                                    : null,
                                items: sections
                                    .map(
                                      (s) => DropdownMenuItem(
                                    value: s.sectionId?.toString(),
                                    child: Text(s.sectionName ?? ''),
                                  ),
                                )
                                    .toList(),
                                onChanged: sections.isEmpty
                                    ? null
                                    : (v) => setState(() {
                                  _sectionId = v;
                                  _sectionError = null;
                                }),
                                hasError: _sectionError != null,
                                warningHint:
                                _classId != null &&
                                    sections.isEmpty,
                              ),
                              if (_sectionError != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 4,
                                  ),
                                  child: Text(
                                    _sectionError!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _label(
                    '${'timetable.subject'.tr()} *',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<AllSubjectsVieModel>(
                          builder: (ctx, vm, _) {
                            final subjects = vm.allSubjectsModel?.data ?? [];
                            return _sheetDrop(
                              hint: 'timetable.select_subject'.tr(),
                              value:
                              subjects.any(
                                    (s) => s.subjectId.toString() == _subjectId,
                              )
                                  ? _subjectId
                                  : null,
                              items: subjects
                                  .map(
                                    (s) => DropdownMenuItem(
                                  value: s.subjectId.toString(),
                                  child: Text(s.subjectName ?? ''),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _subjectId = v;
                                _subjectError = null;
                              }),
                              hasError: _subjectError != null,
                            );
                          },
                        ),
                        if (_subjectError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(
                              _subjectError!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  _label(
                    '${'timetable.teacher'.tr()} *',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<AllTeachersListVieModel>(
                          builder: (ctx, vm, _) {
                            final teachers =
                                vm.allTeachersListModel?.data ?? [];
                            return _sheetDrop(
                              hint: 'timetable.select_teacher'.tr(),
                              value:
                              teachers.any(
                                    (t) => t.teacherId.toString() == _teacherId,
                              )
                                  ? _teacherId
                                  : null,
                              items: teachers
                                  .map(
                                    (t) => DropdownMenuItem(
                                  value: t.teacherId.toString(),
                                  child: Text(t.name ?? ''),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _teacherId = v;
                                _teacherError = null;
                              }),
                              hasError: _teacherError != null,
                            );
                          },
                        ),
                        if (_teacherError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(
                              _teacherError!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  _label(
                    '${'timetable.day_of_week'.tr()} *',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sheetDrop(
                          hint: 'timetable.select_day_hint'.tr(),
                          value: _dayOfWeek,
                          items: _days
                              .map(
                                (d) => DropdownMenuItem(
                              value: d,
                              child: Text(
                                d.toLowerCase() == 'monday' ? 'timetable.monday'.tr() :
                                d.toLowerCase() == 'tuesday' ? 'timetable.tuesday'.tr() :
                                d.toLowerCase() == 'wednesday' ? 'timetable.wednesday'.tr() :
                                d.toLowerCase() == 'thursday' ? 'timetable.thursday'.tr() :
                                d.toLowerCase() == 'friday' ? 'timetable.friday'.tr() :
                                d.toLowerCase() == 'saturday' ? 'timetable.saturday'.tr() :
                                'timetable.sunday'.tr(),
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (v) => setState(() {
                            _dayOfWeek = v;
                            _dayError = null;
                          }),
                          hasError: _dayError != null,
                        ),
                        if (_dayError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(
                              _dayError!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _label(
                          '${'timetable.start_time'.tr()} *',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _timeField(_startCtrl, '09:00:00', () async {
                                await _pickTime(_startCtrl);
                                setState(() => _startError = null);
                              }),
                              if (_startError != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 4,
                                  ),
                                  child: Text(
                                    _startError!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _label(
                          '${'timetable.end_time'.tr()} *',
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _timeField(_endCtrl, '10:00:00', () async {
                                await _pickTime(_endCtrl);
                                setState(() => _endError = null);
                              }),
                              if (_endError != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 4,
                                  ),
                                  child: Text(
                                    _endError!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: _loading ? null : () => _submit(sections),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _loading ? null : AppColor.primaryGradient,
                        color: _loading ? Colors.grey.shade300 : null,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _loading
                            ? []
                            : [
                          BoxShadow(
                            color: AppColor.lightBlueColor.withOpacity(
                              0.3,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isEditMode
                                  ? Icons.save_rounded
                                  : Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            AppText.customText(
                              _isEditMode
                                  ? 'timetable.update_timetable'.tr()
                                  : 'timetable.create_timetable'.tr(),
                              size: 15,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _label(String text, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.customText(
        text,
        size: 12,
        weight: FontWeight.w600,
        color: AppColor.softGreyText,
      ),
      const SizedBox(height: 6),
      child,
    ],
  );

  Widget _sheetDrop({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    bool hasError = false,
    bool warningHint = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: onChanged == null ? Colors.grey.shade100 : const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: hasError
            ? Colors.red.shade400
            : warningHint
            ? Colors.orange.shade300
            : Colors.grey.shade200,
        width: hasError || warningHint ? 1.4 : 1.0,
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: value,
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            color: warningHint ? Colors.orange.shade700 : Colors.grey.shade400,
            fontSize: 13,
            fontWeight: warningHint ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        icon: Icon(
          warningHint
              ? Icons.warning_amber_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: warningHint
              ? Colors.orange.shade500
              : onChanged == null
              ? Colors.grey.shade400
              : AppColor.lightBlueColor,
          size: 20,
        ),
        items: items,
        onChanged: onChanged,
      ),
    ),
  );

  Widget _timeField(
      TextEditingController ctrl,
      String hint,
      VoidCallback onTap,
      ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: AppColor.lightBlueColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ctrl.text.isEmpty ? hint : ctrl.text,
              style: TextStyle(
                fontSize: 13,
                color: ctrl.text.isEmpty
                    ? Colors.grey.shade400
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}