import 'dart:io';
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
import 'package:school_pro/view_model/school_view_model/all_subjects_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
import 'package:shimmer/shimmer.dart';
import '../model/school_model/classes_time_table_model.dart';
import '../res/app_color.dart';
import '../res/const_text.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/all_classes_view_model.dart';
import '../view_model/school_view_model/all_scetions_view_model.dart';
import '../view_model/school_view_model/create_class_time_table_View_model.dart';
import '../view_model/school_view_model/delete_classes_time_table_view_model.dart';
import '../view_model/school_view_model/edit_class_time_table_view_model.dart';
import '../view_model/school_view_model/get_classes_timetable_view_model.dart';

class SchoolTimetableScreen extends StatefulWidget {
  const SchoolTimetableScreen({super.key});

  @override
  State<SchoolTimetableScreen> createState() => _SchoolTimetableScreenState();
}

class _SchoolTimetableScreenState extends State<SchoolTimetableScreen> {
  String? _selectedClassId;
  String? _selectedSectionId;

  final _dayOrder = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday'
  ];
  Future<void> _downloadTimetable(List<TimeTableData> data) async {
    // ── 1. Permission ──────────────────────────────────────
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Storage permission required'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }
    }

    // ── 2. Class & Section name fetch karo ─────────────────
    final classVm   = Provider.of<AllClassesViewModel>(context, listen: false);
    final secVm     = Provider.of<AllSectionsViewModel>(context, listen: false);
    final className = (classVm.allClassesModel?.data ?? [])
        .where((c) => c.classId?.toString() == _selectedClassId)
        .map((c) => c.className ?? '')
        .firstOrNull ?? 'Class';
    final sectionName = (secVm.allSectionsModel?.data ?? [])
        .where((s) => s.sectionId?.toString() == _selectedSectionId)
        .map((s) => s.sectionName ?? '')
        .firstOrNull ?? 'Section';

    // ── 3. PDF build karo ──────────────────────────────────
    final pdf = pw.Document();
    final grouped = _groupByDay(data);
    final sortedDays = _dayOrder.where((d) => grouped.containsKey(d)).toList();

    // Accent color (same as AppColor.lightBlueColor)
    const headerColor = PdfColor.fromInt(0xFF1E88E5);
    const lightBg     = PdfColor.fromInt(0xFFF0F4FF);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const pw.BoxDecoration(
                color: headerColor,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'School Timetable',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '$className  •  Section $sectionName',
                    style:  pw.TextStyle(color: PdfColors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
            ),
          ],
        ),
        build: (context) => sortedDays.map((day) {
          final periods = grouped[day]!;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Day Header ──
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const pw.BoxDecoration(
                  color: lightBg,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      day,
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: headerColor,
                      ),
                    ),
                    pw.Text(
                      '${periods.length} ${periods.length == 1 ? 'Period' : 'Periods'}',
                      style: const pw.TextStyle(fontSize: 11, color: headerColor),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              // ── Table ──
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey200, width: 0.8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),   // Time
                  1: const pw.FlexColumnWidth(3),   // Subject
                  2: const pw.FlexColumnWidth(3),   // Teacher
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE3EAFD)),
                    children: ['Time', 'Subject', 'Teacher'].map((h) =>
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: pw.Text(
                            h,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 11,
                              color: headerColor,
                            ),
                          ),
                        ),
                    ).toList(),
                  ),
                  // Data rows
                  ...periods.map((p) => pw.TableRow(
                    children: [
                      // Time
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: pw.Text(
                          '${p.startTime ?? '--'}\n${p.endTime ?? '--'}',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                      ),
                      // Subject
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: pw.Text(
                          p.subjectName?.toString() ?? '-',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      // Teacher
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: pw.Text(
                          p.teacherName?.toString() ?? '-',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 14),
            ],
          );
        }).toList(),
      ),
    );

    // ── 4. File save karo ─────────────────────────────────
    final Directory dir;
    if (Platform.isAndroid) {
      // Android: Downloads folder
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) await dir.create(recursive: true);
    } else {
      // iOS: App Documents folder
      dir = await getApplicationDocumentsDirectory();
    }

    final fileName =
        'Timetable_${className}_${sectionName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // ── 5. File open karo + snackbar ──────────────────────
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('Saved to Downloads: $fileName')),
          ]),
          backgroundColor: Colors.green.shade500,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () => OpenFile.open(file.path),
          ),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!PermissionExtensions.canAccess(
          PermissionKeys.viewTimetable)) {

        Utils.show(
          "You don't have permission to view timetable",
          context,
        );

        Navigator.pop(context);
        return;
      }
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
      Provider.of<AllSubjectsVieModel>(context, listen: false)
          .allSubjectsApi(context);
      // ✅ Teachers bhi load karo:
      Provider.of<AllTeachersListVieModel>(context, listen: false)
          .allTeachersListApi(context);
    });
  }

  Future<void> _loadSections(String classId) async {
    await Provider.of<AllSectionsViewModel>(context, listen: false)
        .allSectionsApi(context, classId);
  }

  Future<void> _loadTimetable() async {
    if (_selectedClassId == null || _selectedSectionId == null) return;
    await Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
        .getTimeTable(
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
              decoration:
              BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Delete Period',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(
                text: period.subjectName?.toString() ?? 'this period',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const TextSpan(text: ' from '),
              TextSpan(
                text: period.dayOfWeek?.toString() ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const TextSpan(text: '?\n\nThis action cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _deletePeriod(period);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePeriod(TimeTableData period) async {
    final success =
    await Provider.of<DeleteClassesTimeTableViewModel>(context, listen: false)
        .deleteClassesTimeTableApi(period.timetableId!, context);

    if (success && mounted) {
      Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
          .timetableList
          .removeWhere((e) {
        final item = e is TimeTableData
            ? e
            : TimeTableData.fromJson(Map<String, dynamic>.from(e));
        return item.timetableId == period.timetableId;
      });
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      Provider.of<GetClassesTimeTableViewModel>(context, listen: false)
          .notifyListeners();
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
    if (s.contains('sport') || s.contains('pe')) return Icons.sports_soccer_rounded;
    return Icons.class_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!PermissionExtensions.canAccess(
              PermissionKeys.manageTimetable)) {

            Utils.show(
              "You don't have permission to manage timetable",
              context,
            );
            return;
          }

          _showCreateSheet();
        },
        backgroundColor: AppColor.lightBlueColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Period',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
      ),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: AppColor.blueShadow, blurRadius: 15, offset: const Offset(0, 8)),
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
                            color: AppColor.glassWhite, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.customText('School Timetable',
                              size: 20, weight: FontWeight.bold, color: Colors.white),
                          AppText.customText('View class schedule',
                              size: 12, color: Colors.white70),
                        ],
                      ),
                    ),
                    // Header Row mein — calendar icon ki jagah ye widget daalo:
                    Consumer<GetClassesTimeTableViewModel>(
                      builder: (context, vm, _) {
                        final hasData = vm.timetableList.isNotEmpty &&
                            _selectedClassId != null &&
                            _selectedSectionId != null;
                        if (!hasData) return const SizedBox();

                        return GestureDetector(
                          onTap: () {
                            final data = vm.timetableList
                                .map((e) => e is TimeTableData
                                ? e
                                : TimeTableData.fromJson(Map<String, dynamic>.from(e)))
                                .toList();
                            _downloadTimetable(data);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: AppColor.glassWhite,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        );
                      },
                    ),
                    // const Icon(Icons.calendar_month_rounded, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    // ── Class ──
                    Expanded(
                      child: Consumer<AllClassesViewModel>(
                        builder: (context, vm, _) {
                          final classes = vm.allClassesModel?.data ?? [];
                          return _headerDropdown(
                            hint: 'Select Class',
                            value: _selectedClassId,
                            items: classes
                                .map((c) => DropdownMenuItem(
                              value: c.classId?.toString(),
                              child: Text(c.className ?? '',
                                  style: const TextStyle(fontSize: 13)),
                            ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedClassId   = v;
                                _selectedSectionId = null;
                              });
                              Provider.of<GetClassesTimeTableViewModel>(
                                  context, listen: false)
                                  .timetableList
                                  .clear();
                              if (v != null) _loadSections(v);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ── Section ──
                    Expanded(
                      child: Consumer<AllSectionsViewModel>(
                        builder: (context, vm, _) {
                          final sections = vm.allSectionsModel?.data ?? [];
                          // ✅ class select hai aur sections empty hain
                          final noSection = _selectedClassId != null && sections.isEmpty;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              // ✅ orange border jab no section
                              border: noSection
                                  ? Border.all(color: Colors.orange.shade400, width: 1.5)
                                  : null,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: sections.any((s) =>
                                s.sectionId?.toString() == _selectedSectionId)
                                    ? _selectedSectionId
                                    : null,
                                isExpanded: true,
                                // ✅ hint text hi warning hai — koi extra widget nahi
                                hint: Row(
                                  children: noSection
                                      ? [
                                    Icon(Icons.warning_amber_rounded,
                                        size: 14, color: Colors.orange.shade600),
                                    const SizedBox(width: 5),
                                    Text('No sections',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.orange.shade700,
                                            fontWeight: FontWeight.w500)),
                                  ]
                                      : [
                                    Text('Select Section',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade400)),
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
                                    .map((s) => DropdownMenuItem(
                                  value: s.sectionId?.toString(),
                                  child: Text(s.sectionName ?? '',
                                      style: const TextStyle(fontSize: 13)),
                                ))
                                    .toList(),
                                // ✅ no section hone par tap disable
                                onChanged: noSection
                                    ? null
                                    : (v) {
                                  setState(() => _selectedSectionId = v);
                                  if (v != null && _selectedClassId != null) {
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

                if (_selectedClassId != null && _selectedSectionId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Consumer2<AllClassesViewModel, AllSectionsViewModel>(
                      builder: (context, classVm, secVm, _) {
                        final className = (classVm.allClassesModel?.data ?? [])
                            .where((c) => c.classId?.toString() == _selectedClassId)
                            .map((c) => c.className ?? '')
                            .firstOrNull ?? '';
                        final sectionName = (secVm.allSectionsModel?.data ?? [])
                            .where((s) => s.sectionId?.toString() == _selectedSectionId)
                            .map((s) => s.sectionName ?? '')
                            .firstOrNull ?? '';
                        if (className.isEmpty) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColor.glassWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline_rounded,
                                  color: Colors.white70, size: 14),
                              const SizedBox(width: 6),
                              AppText.customText(
                                '$className  •  Section $sectionName',
                                size: 12, color: Colors.white, weight: FontWeight.w500,
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
                if (_selectedClassId == null || _selectedSectionId == null) {
                  return _selectFirstState();
                }
                if (vm.loading) return _shimmer();
                final rawList = vm.timetableList;
                if (rawList.isEmpty) return _emptyState();

                final List<TimeTableData> data = rawList
                    .map((e) => e is TimeTableData
                    ? e
                    : TimeTableData.fromJson(Map<String, dynamic>.from(e)))
                    .toList();

                final grouped = _groupByDay(data);
                final sortedDays =
                _dayOrder.where((d) => grouped.containsKey(d)).toList();

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
            ? Border.all(color: borderColor, width: 1.5)  // ✅ orange border when no section
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(
                color: hintColor ?? Colors.grey.shade400,
                fontSize: 13,
                fontWeight: hintColor != null ? FontWeight.w500 : FontWeight.normal,
              )),
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
  // Widget _headerDropdown({
  //   required String hint,
  //   required String? value,
  //   required List<DropdownMenuItem<String>> items,
  //   required void Function(String?) onChanged,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(14)),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         value: value,
  //         isExpanded: true,
  //         hint: Text(hint,
  //             style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
  //         icon: Icon(Icons.keyboard_arrow_down_rounded,
  //             color: AppColor.lightBlueColor, size: 20),
  //         items: items,
  //         onChanged: onChanged,
  //       ),
  //     ),
  //   );
  // }

  Widget _dayCard(String day, List<TimeTableData> periods) {
    final color = _dayColor(day);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.today_rounded, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                AppText.customText(day,
                    size: 15, weight: FontWeight.bold, color: color),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: AppText.customText(
                    '${periods.length} ${periods.length == 1 ? 'Period' : 'Periods'}',
                    size: 11,
                    color: color,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...periods.asMap().entries.map(
                  (e) => _periodTile(e.value, color, e.key == periods.length - 1)),
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
                child: Column(children: [
                  AppText.customText(period.startTime?.toString() ?? '--:--',
                      size: 12, weight: FontWeight.bold, color: color),
                  Container(
                      width: 1,
                      height: 14,
                      color: color.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(vertical: 2)),
                  AppText.customText(period.endTime?.toString() ?? '--:--',
                      size: 10, color: AppColor.softGreyText),
                ]),
              ),
              const SizedBox(width: 10),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(_subjectIcon(period.subjectName?.toString()),
                    color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                        period.subjectName?.toString() ?? 'Subject',
                        size: 14,
                        weight: FontWeight.bold),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.person_rounded,
                          size: 13, color: AppColor.softGreyText),
                      const SizedBox(width: 4),
                      Flexible(
                        child: AppText.customText(
                            period.teacherName?.toString() ?? '',
                            size: 12,
                            color: AppColor.softGreyText),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Row(children: [
                      Icon(Icons.groups_rounded,
                          size: 13, color: AppColor.softGreyText),
                      const SizedBox(width: 4),
                      AppText.customText(
                          '${period.className ?? ''} - ${period.sectionName ?? ''}',
                          size: 12,
                          color: AppColor.softGreyText),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTimetable)) {

                        Utils.show(
                          "You don't have permission to edit timetable",
                          context,
                        );
                        return;
                      }

                      _showEditSheet(period);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Icon(Icons.edit_rounded, color: color, size: 15),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageTimetable)) {

                        Utils.show(
                          "You don't have permission to delete timetable",
                          context,
                        );
                        return;
                      }

                      _confirmDelete(period);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(9)),
                      child: Icon(Icons.delete_rounded,
                          color: Colors.red.shade400, size: 15),
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
              color: Colors.grey.shade100),
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
              shape: BoxShape.circle),
          child: Icon(Icons.touch_app_rounded,
              size: 60, color: AppColor.lightBlueColor.withOpacity(0.4)),
        ),
        const SizedBox(height: 20),
        AppText.customText('Select Class & Section',
            size: 18, weight: FontWeight.bold),
        const SizedBox(height: 8),
        AppText.customText(
          'Choose class and section above\nto view the timetable',
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
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
              shape: BoxShape.circle),
          child: Icon(Icons.calendar_today_rounded,
              size: 60, color: AppColor.lightBlueColor.withOpacity(0.4)),
        ),
        const SizedBox(height: 20),
        AppText.customText('No Timetable Found',
            size: 18, weight: FontWeight.bold),
        const SizedBox(height: 8),
        AppText.customText(
          'No schedule found for\nthis class & section',
          size: 13,
          color: AppColor.softGreyText,
          align: TextAlign.center,
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CREATE / EDIT TIMETABLE BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════════════════════
//  CREATE / EDIT TIMETABLE BOTTOM SHEET — with validation fixes
// ═══════════════════════════════════════════════════════════════════════════════

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
  final _endCtrl   = TextEditingController();
  bool _loading    = false;

  // ✅ Validation error strings
  String? _sectionError;
  String? _subjectError;
  String? _teacherError;
  String? _dayError;
  String? _startError;
  String? _endError;

  bool get _isEditMode => widget.editData != null;

  final _days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

  @override
  void initState() {
    super.initState();
    _classId   = widget.preselectedClassId;
    _sectionId = widget.preselectedSectionId;

    if (_isEditMode) {
      final d    = widget.editData!;
      _classId   = d.classId?.toString()   ?? widget.preselectedClassId;
      _sectionId = d.sectionId?.toString() ?? widget.preselectedSectionId;
      _subjectId = d.subjectId?.toString();
      _teacherId = d.teacherId?.toString();
      _dayOfWeek = d.dayOfWeek?.toString();
      _startCtrl.text = d.startTime?.toString() ?? '';
      _endCtrl.text   = d.endTime?.toString()   ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context;
      Provider.of<AllClassesViewModel>(ctx, listen: false).allClassesApi(ctx);
      Provider.of<AllSubjectsVieModel>(ctx, listen: false).allSubjectsApi(ctx);
      Provider.of<AllTeachersListVieModel>(ctx, listen: false).allTeachersListApi(ctx);
      if (_classId != null) {
        Provider.of<AllSectionsViewModel>(ctx, listen: false)
            .allSectionsApi(ctx, _classId!);
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
            colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor)),
        child: child!,
      ),
    );
    if (t != null) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      setState(() => ctrl.text = '$h:$m:00');
    }
  }

  // ✅ Validate karo aur error set karo
  bool _validate(List sections) {
    bool valid = true;
    setState(() {
      // Section: class select hai but section available nahi
      if (_classId != null && sections.isEmpty) {
        _sectionError = "No sections available for this class";
        valid = false;
      } else if (_sectionId == null) {
        _sectionError = "Section is required";
        valid = false;
      } else {
        _sectionError = null;
      }

      if (_subjectId == null) { _subjectError = "Subject is required"; valid = false; }
      else _subjectError = null;

      if (_teacherId == null) { _teacherError = "Teacher is required"; valid = false; }
      else _teacherError = null;

      if (_dayOfWeek == null) { _dayError = "Day is required"; valid = false; }
      else _dayError = null;

      if (_startCtrl.text.isEmpty) { _startError = "Start time is required"; valid = false; }
      else _startError = null;

      if (_endCtrl.text.isEmpty) { _endError = "End time is required"; valid = false; }
      else _endError = null;
    });
    return valid;
  }

  Future<void> _submit(List sections) async {
    if (!_validate(sections)) return;

    // ✅ Class without section: section nahi hai toh block karo
    if (sections.isEmpty) {
      _showNoSectionDialog();
      return;
    }

    setState(() => _loading = true);

    if (_isEditMode) {
      final success = await Provider.of<EditClassesTimeTableViewModel>(context, listen: false)
          .editClassTimeTableApi(
        widget.editData!.timetableId!,
        int.parse(_classId!), int.parse(_sectionId!),
        int.parse(_subjectId!), int.parse(_teacherId!),
        _dayOfWeek!, _startCtrl.text, _endCtrl.text, context,
      );
      setState(() => _loading = false);
      if (success && mounted) {
        Navigator.pop(context);
        widget.onSuccess();
        // _showSuccessSnack("Timetable updated successfully");
      }
    } else {
      final success = await Provider.of<CreateClassTimetableViewModel>(context, listen: false)
          .createClassTimeTableApi(
        int.parse(_classId!), int.parse(_sectionId!),
        int.parse(_subjectId!), int.parse(_teacherId!),
        _dayOfWeek!, _startCtrl.text, _endCtrl.text, context,
      );
      setState(() => _loading = false);
      if (success && mounted) {
        // Navigator.pop(context);
        widget.onSuccess();
      }
    }
  }

  // ✅ Class mein section nahi hone par dialog
  void _showNoSectionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.orange.shade50, shape: BoxShape.circle),
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.orange.shade600, size: 22),
          ),
          const SizedBox(width: 10),
          const Text("No Section Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
        content: const Text(
          "This class has no sections assigned yet.\n\n"
              "Please add a section to this class first before creating a timetable.",
          style: TextStyle(fontSize: 13.5, height: 1.6),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(msg),
      ]),
      backgroundColor: Colors.green.shade500,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Consumer<AllSectionsViewModel>(
          builder: (ctx, secVm, _) {
            final sections = secVm.allSectionsModel?.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // Title
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                          _isEditMode ? Icons.edit_calendar_rounded : Icons.schedule_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      AppText.customText(
                          _isEditMode ? 'Edit Timetable' : 'Add Timetable',
                          size: 18, weight: FontWeight.bold),
                      AppText.customText(
                          _isEditMode ? 'Update period details' : 'Fill period details',
                          size: 12, color: AppColor.softGreyText),
                    ])),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.close_rounded, size: 18)),
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // ── Class & Section row ──────────────────────────
                  // Row(children: [
                  //   Expanded(child: _label('Class *',
                  //     Consumer<AllClassesViewModel>(builder: (ctx, vm, _) =>
                  //         _sheetDrop(
                  //           hint: 'Select',
                  //           value: _classId,
                  //           items: (vm.allClassesModel?.data ?? [])
                  //               .map((c) => DropdownMenuItem(
                  //               value: c.classId?.toString(),
                  //               child: Text(c.className ?? '')))
                  //               .toList(),
                  //           onChanged: (v) {
                  //             setState(() {
                  //               _classId   = v;
                  //               _sectionId = null;
                  //               _sectionError = null;
                  //             });
                  //             if (v != null) {
                  //               Provider.of<AllSectionsViewModel>(context, listen: false)
                  //                   .allSectionsApi(context, v);
                  //             }
                  //           },
                  //         )),
                  //   )),
                  //   const SizedBox(width: 12),
                  //   Expanded(child: _label('Section *',
                  //     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //       // ✅ Section empty hone par warning banner
                  //       if (_classId != null && sections.isEmpty)
                  //         Container(
                  //           margin: const EdgeInsets.only(bottom: 6),
                  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  //           decoration: BoxDecoration(
                  //             color: Colors.orange.shade50,
                  //             borderRadius: BorderRadius.circular(8),
                  //             border: Border.all(color: Colors.orange.shade200),
                  //           ),
                  //           child: Row(children: [
                  //             Icon(Icons.warning_amber_rounded,
                  //                 size: 14, color: Colors.orange.shade700),
                  //             const SizedBox(width: 6),
                  //             Flexible(child: Text(
                  //               "No sections for this class",
                  //               style: TextStyle(
                  //                   fontSize: 11,
                  //                   color: Colors.orange.shade800,
                  //                   fontWeight: FontWeight.w500),
                  //             )),
                  //           ]),
                  //         ),
                  //       _sheetDrop(
                  //         hint: 'Select',
                  //         value: sections.any((s) => s.sectionId?.toString() == _sectionId)
                  //             ? _sectionId : null,
                  //         items: sections.map((s) => DropdownMenuItem(
                  //             value: s.sectionId?.toString(),
                  //             child: Text(s.sectionName ?? ''))).toList(),
                  //         onChanged: sections.isEmpty
                  //             ? null  // ✅ Section nahi hai toh disable
                  //             : (v) => setState(() {
                  //           _sectionId    = v;
                  //           _sectionError = null;
                  //         }),
                  //         hasError: _sectionError != null,
                  //       ),
                  //       // ✅ Error text
                  //       if (_sectionError != null)
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 4, left: 4),
                  //           child: Text(_sectionError!,
                  //               style: const TextStyle(fontSize: 11, color: Colors.red)),
                  //         ),
                  //     ]),
                  //   )),
                  // ]),
                  // Sirf Class & Section Row replace karo — baaki sab same rahega

                  Row(children: [
                    Expanded(child: _label('Class *',
                      Consumer<AllClassesViewModel>(builder: (ctx, vm, _) =>
                          _sheetDrop(
                            hint: 'Select',
                            value: _classId,
                            items: (vm.allClassesModel?.data ?? [])
                                .map((c) => DropdownMenuItem(
                                value: c.classId?.toString(),
                                child: Text(c.className ?? '')))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _classId      = v;
                                _sectionId    = null;
                                _sectionError = null;
                              });
                              if (v != null) {
                                Provider.of<AllSectionsViewModel>(context, listen: false)
                                    .allSectionsApi(context, v);
                              }
                            },
                          )),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _label('Section *',
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // ✅ Warning banner HATA diya — ab sirf suffix icon se show hoga
                        _sheetDrop(
                          hint: _classId != null && sections.isEmpty
                              ? '⚠ No sections'   // ← hint text hi warning ban gaya
                              : 'Select',
                          value: sections.any((s) => s.sectionId?.toString() == _sectionId)
                              ? _sectionId : null,
                          items: sections.map((s) => DropdownMenuItem(
                              value: s.sectionId?.toString(),
                              child: Text(s.sectionName ?? ''))).toList(),
                          onChanged: sections.isEmpty
                              ? null
                              : (v) => setState(() {
                            _sectionId    = v;
                            _sectionError = null;
                          }),
                          hasError: _sectionError != null,
                          warningHint: _classId != null && sections.isEmpty, // ← orange hint
                        ),
                        if (_sectionError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(_sectionError!,
                                style: const TextStyle(fontSize: 11, color: Colors.red)),
                          ),
                      ]),
                    )),
                  ]),
                  const SizedBox(height: 14),

                  // ── Subject ──────────────────────────────────────
                  _label('Subject *',
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Consumer<AllSubjectsVieModel>(builder: (ctx, vm, _) {
                        final subjects = vm.allSubjectsModel?.data ?? [];
                        return _sheetDrop(
                          hint: 'Select Subject',
                          value: subjects.any((s) => s.subjectId.toString() == _subjectId)
                              ? _subjectId : null,
                          items: subjects.map((s) => DropdownMenuItem(
                              value: s.subjectId.toString(),
                              child: Text(s.subjectName ?? ''))).toList(),
                          onChanged: (v) => setState(() {
                            _subjectId   = v;
                            _subjectError = null;
                          }),
                          hasError: _subjectError != null,
                        );
                      }),
                      if (_subjectError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(_subjectError!,
                              style: const TextStyle(fontSize: 11, color: Colors.red)),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 14),

                  // ── Teacher ──────────────────────────────────────
                  _label('Teacher *',
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Consumer<AllTeachersListVieModel>(builder: (ctx, vm, _) {
                        final teachers = vm.allTeachersListModel?.data ?? [];
                        return _sheetDrop(
                          hint: 'Select Teacher',
                          value: teachers.any((t) => t.teacherId.toString() == _teacherId)
                              ? _teacherId : null,
                          items: teachers.map((t) => DropdownMenuItem(
                              value: t.teacherId.toString(),
                              child: Text(t.name ?? ''))).toList(),
                          onChanged: (v) => setState(() {
                            _teacherId    = v;
                            _teacherError = null;
                          }),
                          hasError: _teacherError != null,
                        );
                      }),
                      if (_teacherError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(_teacherError!,
                              style: const TextStyle(fontSize: 11, color: Colors.red)),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 14),

                  // ── Day of Week ──────────────────────────────────
                  _label('Day of Week *',
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _sheetDrop(
                        hint: 'Select Day',
                        value: _dayOfWeek,
                        items: _days.map((d) =>
                            DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => setState(() {
                          _dayOfWeek = v;
                          _dayError  = null;
                        }),
                        hasError: _dayError != null,
                      ),
                      if (_dayError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(_dayError!,
                              style: const TextStyle(fontSize: 11, color: Colors.red)),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 14),

                  // ── Start & End Time ─────────────────────────────
                  Row(children: [
                    Expanded(child: _label('Start Time *',
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _timeField(_startCtrl, '09:00:00', () async {
                          await _pickTime(_startCtrl);
                          setState(() => _startError = null);
                        }),
                        if (_startError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(_startError!,
                                style: const TextStyle(fontSize: 11, color: Colors.red)),
                          ),
                      ]),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _label('End Time *',
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _timeField(_endCtrl, '10:00:00', () async {
                          await _pickTime(_endCtrl);
                          setState(() => _endError = null);
                        }),
                        if (_endError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(_endError!,
                                style: const TextStyle(fontSize: 11, color: Colors.red)),
                          ),
                      ]),
                    )),
                  ]),
                  const SizedBox(height: 28),

                  // ── Submit ───────────────────────────────────────
                  GestureDetector(
                    onTap: _loading ? null : () => _submit(sections),
                    child: Container(
                      width: double.infinity, height: 52,
                      decoration: BoxDecoration(
                        gradient: _loading
                            ? null
                            : AppColor.primaryGradient,
                        color: _loading ? Colors.grey.shade300 : null,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _loading ? [] : [
                          BoxShadow(
                              color: AppColor.lightBlueColor.withOpacity(0.3),
                              blurRadius: 12, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Center(child: _loading
                          ? const SizedBox(width: 24, height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(_isEditMode ? Icons.save_rounded : Icons.check_circle_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        AppText.customText(
                            _isEditMode ? 'Update Timetable' : 'Create Timetable',
                            size: 15, weight: FontWeight.bold, color: Colors.white),
                      ])),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04,)
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
      AppText.customText(text, size: 12, weight: FontWeight.w600, color: AppColor.softGreyText),
      const SizedBox(height: 6),
      child,
    ],
  );
// _sheetDrop ko replace karo is se:

  Widget _sheetDrop({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    bool hasError = false,
    bool warningHint = false,   // ← naya param
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: onChanged == null
              ? Colors.grey.shade100
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasError
                ? Colors.red.shade400
                : warningHint
                ? Colors.orange.shade300   // ← orange border jab no section
                : Colors.grey.shade200,
            width: hasError || warningHint ? 1.4 : 1.0,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                // ← orange text jab no section, grey otherwise
                color: warningHint
                    ? Colors.orange.shade700
                    : Colors.grey.shade400,
                fontSize: 13,
                fontWeight: warningHint ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            icon: Icon(
              warningHint
                  ? Icons.warning_amber_rounded   // ← warning icon
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

  Widget _timeField(TextEditingController ctrl, String hint, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(children: [
            Icon(Icons.access_time_rounded, color: AppColor.lightBlueColor, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(
              ctrl.text.isEmpty ? hint : ctrl.text,
              style: TextStyle(fontSize: 13,
                  color: ctrl.text.isEmpty ? Colors.grey.shade400 : Colors.black87),
            )),
          ]),
        ),
      );
}
