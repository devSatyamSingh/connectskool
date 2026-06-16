import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/Exam_management_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import '../model/school_model/exam_marks_model.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/all_classes_view_model.dart';
import '../view_model/school_view_model/all_subjects_view_model.dart';
import '../view_model/school_view_model/create_exam_maerks_view_model.dart';
import '../view_model/school_view_model/exam_marks_view_model.dart';
import '../repo/school_repo/all_sections_repo.dart';
import '../view_model/school_view_model/school_exam_time_table_view_model.dart';
import 'create_exam_marks_screen.dart';

class SchoolExamMarksScreen extends StatefulWidget {
  const SchoolExamMarksScreen({super.key});

  @override
  State<SchoolExamMarksScreen> createState() => _SchoolExamMarksScreenState();
}

class _SchoolExamMarksScreenState extends State<SchoolExamMarksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // ── Filters ──
  final _classes = <Map<String, dynamic>>[];
  final _sections = <Map<String, dynamic>>[];
  final _exams = <Map<String, dynamic>>[];
  final _timetables = <Map<String, dynamic>>[];

  String? _selectedClassId;
  String? _selectedSectionId;
  String? _selectedExamId;
  String? _selectedTimetableId;
  String? _selectedSubjectId;

  // ── Marks entry controllers ──
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!PermissionExtensions.canAccess(
          PermissionKeys.viewMarks)) {

        Utils.show(
          "You don't have permission to perform this action",
          context,
        );

        Navigator.pop(context);
        return;
      }
      // Classes load
      final classesVm =
      Provider.of<AllClassesViewModel>(context, listen: false);
      await classesVm.allClassesApi(context);
      final data = classesVm.allClassesModel?.data ?? [];
      setState(() {
        _classes.addAll(data.map((e) => {
          'class_id': e.classId.toString(),
          'class_name': e.className ?? '',
        }));
      });

      // Exams load
      final examVm =
      Provider.of<ExamManagementViewModel>(context, listen: false);
      await examVm.examManagementApi(context);
      final examData = examVm.examManagementModel?.data ?? [];
      setState(() {
        _exams.addAll(examData.map((e) => {
          'exam_id': e.examId.toString(),
          'exam_name': e.examName ?? '',
        }));
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ────────────────────────────────────────────
  // LOAD SECTIONS
  // ────────────────────────────────────────────
  Future<void> _loadSections(String classId) async {
    final repo = AllSectionsRepository();
    final res = await repo.allSectionsApi(classId);
    if (res['success'] == true) {
      setState(() {
        _sections.clear();
        _sections.addAll(List<Map<String, dynamic>>.from(res['data']));
        _selectedSectionId = null;
        _selectedTimetableId = null;
        _selectedSubjectId = null;
        _timetables.clear();
      });
    }
  }

  // ────────────────────────────────────────────
  // LOAD TIMETABLES (getExamTimetable API)
  // ────────────────────────────────────────────
  Future<void> _loadTimetables(
      String examId, String classId, String sectionId) async {
    final vm = Provider.of<SchoolExamTimeTableViewModel>(context, listen: false);
    await vm.getExamTimetable(
      examId: int.parse(examId),
      classId: int.parse(classId),
      sectionId: int.parse(sectionId),
      context: context,
    );

    final data = vm.examTimeTableModel?.data ?? [];
    print("📋 EXAM TIMETABLE COUNT: ${data.length}");

    setState(() {
      _timetables.clear();
      _selectedTimetableId = null;
      _selectedSubjectId = null;

      _timetables.addAll(data.map((e) => {
        'timetable_id': e.timetableId.toString(),
        'subject_id': e.subjectId.toString(),
        'subject_name': e.subjectName ?? '',
        'max_marks': e.maxMarks ?? '100',
      }));
    });
  }

  // ────────────────────────────────────────────
  // RESOLVE TIMETABLE FROM SUBJECT
  // ────────────────────────────────────────────
  void _resolveTimetableFromSubject(String subjectId) {
    final match = _timetables.firstWhere(
          (t) => t['subject_id'] == subjectId,
      orElse: () => {},
    );
    _selectedTimetableId =
    match.isNotEmpty ? match['timetable_id'] : null;
    print(
        "🎯 subject_id: $subjectId → timetable_id: $_selectedTimetableId");
  }

  // ────────────────────────────────────────────
  // LOAD MARKS
  // ────────────────────────────────────────────
  Future<void> _loadMarks() async {
    if (_selectedTimetableId == null && _selectedSubjectId != null) {
      _resolveTimetableFromSubject(_selectedSubjectId!);
    }

    if (_selectedClassId == null ||
        _selectedSectionId == null ||
        _selectedExamId == null ||
        _selectedTimetableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select Class, Section, Exam & Subject'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    await Provider.of<ExamMarksViewModel>(context, listen: false)
        .getExamMarksApi(
      examId: _selectedExamId!,
      timetableId: _selectedTimetableId!,
      classId: _selectedClassId!,
      sectionId: _selectedSectionId!,
      context: context,
    );

    final marks =
        Provider.of<ExamMarksViewModel>(context, listen: false).marksList;
    print("📊 Total marks loaded: ${marks.length}");

    _controllers.clear();
    for (final s in marks) {
      _controllers[s.studentId ?? 0] = TextEditingController(
        text: s.marksObtained?.toStringAsFixed(0) ?? '',
      );
    }

    _animController.reset();
    _animController.forward();
  }

  // ────────────────────────────────────────────
  // STATS HELPERS
  // ────────────────────────────────────────────
  int _totalStudents(List<ExamMarksData> list) => list.length;

  int _appeared(List<ExamMarksData> list) =>
      list.where((s) => s.marksObtained != null).length;

  int _passed(List<ExamMarksData> list) => list
      .where((s) =>
  s.marksObtained != null &&
      s.totalMarks != null &&
      (s.marksObtained! / s.totalMarks!) * 100 >= 33)
      .length;

  int _failed(List<ExamMarksData> list) => _appeared(list) - _passed(list);

  double _classAverage(List<ExamMarksData> list) {
    final m = list
        .where((s) => s.marksObtained != null)
        .map((s) => s.marksObtained!)
        .toList();
    if (m.isEmpty) return 0;
    return m.reduce((a, b) => a + b) / m.length;
  }

  double _percentage(ExamMarksData s) =>
      (s.marksObtained != null &&
          s.totalMarks != null &&
          s.totalMarks! > 0)
          ? (s.marksObtained! / s.totalMarks!) * 100
          : 0;

  bool _isPassed(ExamMarksData s) => _percentage(s) >= 33;

  Color _percentageColor(double pct) {
    if (pct >= 75) return const Color(0xFF00C853);
    if (pct >= 50) return const Color(0xFF2196F3);
    if (pct >= 33) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  Color _gradeColor(String? g) {
    switch (g) {
      case 'A+':
        return const Color(0xFF00C853);
      case 'A':
        return const Color(0xFF4CAF50);
      case 'B':
        return const Color(0xFF2196F3);
      case 'C':
        return const Color(0xFFFF9800);
      case 'D':
        return const Color(0xFFFF5722);
      case 'F':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }


  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ExamMarksViewModel>(
      builder: (context, vm, _) {
        final marks = vm.marksList;

        return Scaffold(
          backgroundColor: AppColor.pageBgColor,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColor.lightBlueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
              onPressed: () {

                if (!PermissionExtensions.canAccess(
                    PermissionKeys.assignMarks)) {

                  Utils.show(
                    "You don't have permission to assign marks.",
                    context,
                    type: "warning",
                  );

                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateExamMarksPage(),
                  ),
                );
              },
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            label: Text(
              'Enter Marks',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildHeader(marks),
              const SizedBox(height: 12),
              _buildFilters(),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(vm, marks)),
            ],
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────
  // HEADER
  // ────────────────────────────────────────────
  Widget _buildHeader(List<ExamMarksData> marks) {
    final subject = marks.isNotEmpty ? marks.first.subjectName : null;
    final exam = marks.isNotEmpty ? marks.first.examName : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 22),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: AppColor.blueShadow,
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColor.glassWhite, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText('Exam Marks',
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white),
                if (subject != null && exam != null)
                  AppText.customText('$subject • $exam',
                      size: 12, color: Colors.white70),
              ],
            ),
          ),
          if (marks.isNotEmpty)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.glassWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText.customText('${marks.length} Students',
                  size: 12,
                  weight: FontWeight.bold,
                  color: Colors.white),
            ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // FILTERS
  // ────────────────────────────────────────────
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // ── Row 1: Class + Section ──
          Row(
            children: [
              Expanded(
                child: _filterDropdown(
                  hint: 'Class',
                  icon: Icons.class_,
                  value: _selectedClassId,
                  items: _classes
                      .map((e) => DropdownMenuItem<String>(
                    value: e['class_id'],
                    child: Text(e['class_name'],
                        style: const TextStyle(fontSize: 13)),
                  ))
                      .toList(),
                  onChanged: (v) async {
                    setState(() {
                      _selectedClassId = v;
                      _selectedSectionId = null;
                      _selectedTimetableId = null;
                      _selectedSubjectId = null;
                      _timetables.clear();
                    });
                    Provider.of<ExamMarksViewModel>(context, listen: false)
                        .clearMarks();
                    if (v != null) await _loadSections(v);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _selectedClassId == null
                    ? _filterDropdown(
                  hint: 'Section',
                  icon: Icons.group,
                  value: null,
                  items: const [],
                  onChanged: (_) {},
                )
                    : _sections.isEmpty
                    ? _noDataBox('No Section')
                    : _filterDropdown(
                  hint: 'Section',
                  icon: Icons.group,
                  value: _selectedSectionId,
                  items: _sections
                      .map((e) => DropdownMenuItem<String>(
                    value: e['section_id'].toString(),
                    child: Text(e['section_name'] ?? '',
                        style: const TextStyle(
                            fontSize: 13)),
                  ))
                      .toList(),
                  onChanged: (v) async {
                    setState(() {
                      _selectedSectionId = v;
                      _selectedTimetableId = null;
                      _selectedSubjectId = null;
                      _timetables.clear();
                    });
                    Provider.of<ExamMarksViewModel>(context,
                        listen: false)
                        .clearMarks();
                    if (_selectedExamId != null &&
                        _selectedClassId != null &&
                        v != null) {
                      await _loadTimetables(
                          _selectedExamId!,
                          _selectedClassId!,
                          v);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Exam ──
          _filterDropdown(
            hint: 'Exam',
            icon: Icons.assignment_outlined,
            value: _selectedExamId,
            items: _exams
                .map((e) => DropdownMenuItem<String>(
              value: e['exam_id'],
              child: Text(e['exam_name'],
                  style: const TextStyle(fontSize: 13)),
            ))
                .toList(),
            onChanged: (v) async {
              setState(() {
                _selectedExamId = v;
                _selectedTimetableId = null;
                _selectedSubjectId = null;
                _timetables.clear();
              });
              Provider.of<ExamMarksViewModel>(context, listen: false)
                  .clearMarks();
              if (_selectedClassId != null &&
                  _selectedSectionId != null &&
                  v != null) {
                await _loadTimetables(
                    v, _selectedClassId!, _selectedSectionId!);
              }
            },
          ),
          const SizedBox(height: 10),

          // ── Subject (from timetable) ──
          _timetables.isEmpty
              ? _noDataBox('Select Class, Section & Exam first',
              icon: Icons.menu_book_outlined)
              : _filterDropdown(
            hint: 'Subject',
            icon: Icons.menu_book_outlined,
            value: _selectedSubjectId,
            items: _timetables
                .map((e) => DropdownMenuItem<String>(
              value: e['subject_id'],
              child: Text(e['subject_name'] ?? '',
                  style: const TextStyle(fontSize: 13)),
            ))
                .toList(),
            onChanged: (v) {
              setState(() {
                _selectedSubjectId = v;
                if (v != null) _resolveTimetableFromSubject(v);
              });
              Provider.of<ExamMarksViewModel>(context, listen: false)
                  .clearMarks();
            },
          ),
          const SizedBox(height: 10),

          // ── Load Button ──
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _loadMarks,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.search_rounded,
                  color: Colors.white, size: 18),
              label: const Text('Load Marks',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDataBox(String text,
      {IconData icon = Icons.info_outline_rounded}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style:
              TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        ),
      ]),
    );
  }

  Widget _filterDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Row(children: [
            Icon(icon, size: 14, color: AppColor.lightBlueColor),
            const SizedBox(width: 6),
            Text(hint,
                style:
                const TextStyle(fontSize: 13, color: Colors.grey)),
          ]),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // STATS ROW
  // ────────────────────────────────────────────
  Widget _buildStatsRow(List<ExamMarksData> marks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _statChip('Total', '${_totalStudents(marks)}', Icons.people,
              Colors.blue),
          const SizedBox(width: 8),
          _statChip('Appeared', '${_appeared(marks)}',
              Icons.how_to_reg, Colors.purple),
          const SizedBox(width: 8),
          _statChip('Passed', '${_passed(marks)}',
              Icons.check_circle, Colors.green),
          const SizedBox(width: 8),
          _statChip(
              'Failed', '${_failed(marks)}', Icons.cancel, Colors.red),
        ],
      ),
    );
  }

  Widget _statChip(
      String label, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(val,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // BODY
  // ────────────────────────────────────────────
  Widget _buildBody(
      ExamMarksViewModel vm, List<ExamMarksData> marks) {
    if (vm.loading) return _shimmer();

    if (marks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Select filters & load marks',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500)),
            const SizedBox(height: 8),
            Text(
                'Choose class, section, exam & subject\nthen tap Load Marks',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    final avg = _classAverage(marks);

    return Column(
      children: [
        // ── Stats ──
        _buildStatsRow(marks),
        const SizedBox(height: 10),

        // ── Average Bar ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                AppText.customText('Class Average',
                    size: 12, color: Colors.white70),
                const Spacer(),
                AppText.customText(
                  '${avg.toStringAsFixed(1)} / ${marks.first.totalMarks?.toStringAsFixed(0) ?? "100"}',
                  size: 15,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText.customText(
                      '${avg.toStringAsFixed(1)}%',
                      size: 11,
                      weight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Record count ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Showing 1 to ${marks.length} of ${marks.length} records',
              style: TextStyle(
                  fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Table ──
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _tableHeader(),
                    const Divider(
                        height: 1, color: Color(0xFFE8ECF0)),
                    ...marks.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return _animated(
                        i,
                        Column(children: [
                          _tableRow(s, i),
                          if (i < marks.length - 1)
                            const Divider(
                                height: 1,
                                color: Color(0xFFEEF1F5)),
                        ]),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────
  // TABLE HEADER
  // ────────────────────────────────────────────
  Widget _tableHeader() {
    return Container(
      width: 960,
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _headerCell('ROLL NO', width: 80),
          _headerCell('STUDENT NAME', width: 150),
          _headerCell('EXAM', width: 130),
          _headerCell('SUBJECT', width: 90),
          _headerCell('CLASS-SECTION', width: 110),
          _headerCell('MARKS', width: 120),
          _headerCell('EXAM DATE', width: 110),
          _headerCell('REMARKS', width: 70),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required double width}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // TABLE ROW
  // ────────────────────────────────────────────
  Widget _tableRow(ExamMarksData s, int index) {
    final pct = _percentage(s);
    final pctColor = _percentageColor(pct);
    final totalMarks = s.totalMarks ?? 100;

    final progressValue =
    totalMarks > 0
        ? (s.marksObtained ?? 0) / totalMarks
        : 0.0;
    final bg =
    index.isEven ? Colors.white : const Color(0xFFFAFBFC);

    // Avatar
    final avatarColors = [
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEF4444),
    ];
    final avatarColor =
    avatarColors[(s.studentName?.codeUnitAt(0) ?? 0) %
        avatarColors.length];
    final initials = (s.studentName ?? 'S')
        .substring(0, min(2, s.studentName?.length ?? 1))
        .toUpperCase();

    return Container(
      width: 1000,
      color: bg,
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ── Roll No ──
          SizedBox(
            width: 80,
            child: Text(
              s.studentId != null ? '#${s.studentId}' : '—',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151)),
            ),
          ),

          // ── Student Name + Avatar ──
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle),
                  child: Center(
                    child: Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    s.studentName ?? 'N/A',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ── Exam ──
          SizedBox(
            width: 130,
            child: Text(s.examName ?? '—',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF374151)),
                overflow: TextOverflow.ellipsis),
          ),

          // ── Subject ──
          SizedBox(
            width: 90,
            child: Text(s.subjectName ?? '—',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF374151)),
                overflow: TextOverflow.ellipsis),
          ),

          // ── Class - Section ──
          SizedBox(
            width: 110,
            child: Text(
              '${s.className ?? ''} - ${s.sectionName ?? ''}',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF374151)),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Marks ──
          SizedBox(
            width: 120,
            child: s.marksObtained != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      s.marksObtained!.toStringAsFixed(0),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: pctColor),
                    ),
                    Text(
                      ' / ${s.totalMarks?.toStringAsFixed(0) ?? '100'}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 90,
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue.clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        pctColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
                : Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: Colors.orange.shade200),
              ),
              child: Text('Absent',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600)),
            ),
          ),

          // ── Exam Date ──
          SizedBox(
            width: 110,
            child: Text(
              _formatDate(s.examDate.toString()),
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),

          // ── Remarks ──
          SizedBox(
            width: 170,
            child: Text(
              s.remarks ?? '—',
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF6B7280)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // SHIMMER
  // ────────────────────────────────────────────
  Widget _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // ANIMATION
  // ────────────────────────────────────────────
  Widget _animated(int i, Widget child) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (_, c) {
        final delay = (i * 0.08).clamp(0.0, 0.9);
        final raw =
            (_animController.value - delay) / (1.0 - delay);
        final val =
        Curves.easeOut.transform(raw.clamp(0.0, 1.0));
        return Transform.translate(
          offset: Offset(0, 20 * (1 - val)),
          child: Opacity(opacity: val, child: c),
        );
      },
      child: child,
    );
  }
}

// ════════════════════════════════════════════
// MARKS ENTRY SHEET
// ════════════════════════════════════════════
class _MarksEntrySheet extends StatefulWidget {
  final List<ExamMarksData> marks;
  final Map<int, TextEditingController> controllers;
  final String? timetableId;
  final VoidCallback onSuccess;

  const _MarksEntrySheet({
    required this.marks,
    required this.controllers,
    required this.timetableId,
    required this.onSuccess,
  });

  @override
  State<_MarksEntrySheet> createState() => _MarksEntrySheetState();
}

class _MarksEntrySheetState extends State<_MarksEntrySheet> {
  bool _saving = false;
  final Map<int, String?> _errors = {};

  bool _validate() {
    bool valid = true;
    _errors.clear();
    for (final s in widget.marks) {
      final id = s.studentId ?? 0;
      final text = widget.controllers[id]?.text.trim() ?? '';
      if (text.isEmpty) continue;
      final val = double.tryParse(text);
      if (val == null) {
        _errors[id] = 'Invalid number';
        valid = false;
      } else if (val < 0) {
        _errors[id] = 'Cannot be negative';
        valid = false;
      } else if (val > (s.totalMarks ?? 100)) {
        _errors[id] =
        'Max: ${s.totalMarks?.toStringAsFixed(0) ?? "100"}';
        valid = false;
      }
    }
    setState(() {});
    return valid;
  }

  Future<void> _saveAll() async {
    if (!_validate()) return;
    if (widget.timetableId == null) {
      _snack('Timetable ID missing. Please reload marks.',
          Colors.red.shade400);
      return;
    }

    setState(() => _saving = true);
    final vm =
    Provider.of<CreateExamMarksViewModel>(context, listen: false);
    int successCount = 0;
    int failCount = 0;

    for (final student in widget.marks) {
      final studentId = student.studentId;
      if (studentId == null) continue;

      final text =
          widget.controllers[studentId]?.text.trim() ?? '';
      final isAbsent = text.isEmpty ? 1 : 0;
      final marksValue =
      text.isEmpty ? 0 : double.tryParse(text) ?? 0;

      final success = await vm.createExamMarksApi(
        int.parse(widget.timetableId!),
        studentId,
        marksValue,
        isAbsent,
        student.remarks ?? '',
        context,
      );

      success ? successCount++ : failCount++;
    }

    setState(() => _saving = false);
    if (!mounted) return;

    Navigator.pop(context);
    widget.onSuccess();

    _snack(
      failCount == 0
          ? '$successCount student(s) marks saved successfully!'
          : '$successCount saved, $failCount failed.',
      failCount == 0
          ? Colors.green.shade500
          : Colors.orange.shade600,
    );
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          msg.contains('failed') || msg.contains('missing')
              ? Icons.warning_amber_rounded
              : Icons.check_circle_rounded,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ));
  }

  Color _avatarColor(String? gender) {
    return (gender ?? '').toLowerCase() == 'male'
        ? AppColor.maleColor
        : AppColor.femaleColor;
  }

  @override
  Widget build(BuildContext context) {
    final total =
        widget.marks.firstOrNull?.totalMarks ?? 100;

    return ClipRRect(
      borderRadius:
      const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            bottom:
            MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(
                    top: 10, bottom: 4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit_note_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      AppText.customText('Enter Marks',
                          size: 18,
                          weight: FontWeight.bold),
                      AppText.customText(
                        '${widget.marks.length} students  •  Total: ${total.toStringAsFixed(0)}',
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
                        shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded,
                        size: 18),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade100, height: 1),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight:
                  MediaQuery.of(context).size.height *
                      0.52),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    20, 12, 20, 12),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.marks.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final s = widget.marks[i];
                  final id = s.studentId ?? 0;
                  final hasError = _errors[id] != null;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: hasError
                          ? Colors.red.shade50
                          : AppColor.pageBgColor,
                      borderRadius:
                      BorderRadius.circular(16),
                      border: Border.all(
                        color: hasError
                            ? Colors.red.shade200
                            : Colors.grey.shade200,
                        width: hasError ? 1.4 : 1,
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _avatarColor(s.gender)
                              .withOpacity(0.12),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.person_rounded,
                            color:
                            _avatarColor(s.gender),
                            size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              s.studentName ?? 'N/A',
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                            Row(children: [
                              Icon(Icons.badge_outlined,
                                  size: 11,
                                  color:
                                  AppColor.softGreyText),
                              const SizedBox(width: 3),
                              AppText.customText(
                                s.admissionNo ?? '',
                                size: 11,
                                color: AppColor.softGreyText,
                              ),
                            ]),
                            if (hasError)
                              Text(_errors[id]!,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller:
                          widget.controllers[id],
                          keyboardType:
                          TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold),
                          onChanged: (_) {
                            if (_errors[id] != null) {
                              setState(() =>
                                  _errors.remove(id));
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Absent',
                            hintStyle: TextStyle(
                                fontSize: 11,
                                color: Colors
                                    .orange.shade300,
                                fontWeight:
                                FontWeight.w500),
                            filled: true,
                            fillColor: hasError
                                ? Colors.red.shade50
                                : Colors.white,
                            contentPadding:
                            const EdgeInsets
                                .symmetric(
                                horizontal: 10,
                                vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  12),
                              borderSide:
                              BorderSide.none,
                            ),
                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  12),
                              borderSide: BorderSide(
                                color: hasError
                                    ? Colors.red.shade300
                                    : Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  12),
                              borderSide: BorderSide(
                                  color: AppColor
                                      .lightBlueColor,
                                  width: 1.8),
                            ),
                            suffixText:
                            '/${total.toStringAsFixed(0)}',
                            suffixStyle: TextStyle(
                                fontSize: 11,
                                color:
                                Colors.grey.shade500),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
            Divider(color: Colors.grey.shade100, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 14, 20, 24),
              child: Column(children: [
                Row(children: [
                  Icon(Icons.info_outline_rounded,
                      size: 13,
                      color: Colors.orange.shade400),
                  const SizedBox(width: 6),
                  Text(
                    'Leave field empty to mark student as Absent',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade600),
                  ),
                ]),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _saving ? null : _saveAll,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: _saving
                          ? null
                          : AppColor.primaryGradient,
                      color: _saving
                          ? Colors.grey.shade300
                          : null,
                      borderRadius:
                      BorderRadius.circular(16),
                      boxShadow: _saving
                          ? []
                          : [
                        BoxShadow(
                          color: AppColor
                              .lightBlueColor
                              .withOpacity(0.3),
                          blurRadius: 12,
                          offset:
                          const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _saving
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                        CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2),
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Icon(
                              Icons.save_rounded,
                              color: Colors.white,
                              size: 20),
                          const SizedBox(width: 8),
                          AppText.customText(
                            'Save All Marks',
                            size: 15,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}