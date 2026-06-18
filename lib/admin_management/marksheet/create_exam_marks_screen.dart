
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/exam_mark/create_exam_maerks_view_model.dart';
import '../../view_model/school_view_model/timetable/school_exam_time_table_view_model.dart';
import '../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../view_model/school_view_model/exam/exam_management_view_model.dart';
import '../../repo/school_repo/section/all_sections_repo.dart';

class CreateExamMarksPage extends StatefulWidget {
  const CreateExamMarksPage({super.key});

  @override
  State<CreateExamMarksPage> createState() => _CreateExamMarksPageState();
}

class _CreateExamMarksPageState extends State<CreateExamMarksPage>
    with TickerProviderStateMixin {

  final List<Map<String, dynamic>> _classes   = [];
  final List<Map<String, dynamic>> _sections  = [];
  final List<Map<String, dynamic>> _exams     = [];

  final List<Map<String, dynamic>> _timetableSlots = [];

  String? _selectedClassId;
  String? _selectedSectionId;
  String? _selectedExamId;
  String? _selectedSubjectId;
  String? _selectedTimetableId;


  final List<Map<String, dynamic>> _studentRows = [];

  bool _loadingStudents   = false;
  bool _loadingTimetable  = false;
  bool _saving            = false;
  String? _successMsg;

  late AnimationController _headerAnim;
  late AnimationController _cardAnim;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
    _cardAnim   = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (!PermissionExtensions.canAccess(
          PermissionKeys.assignMarks)) {

        Utils.show(
          "You don't have permission to perform this action",
          context,
        );

        Navigator.pop(context);
        return;
      }

      _initDropdowns();
    });  }

  Future<void> _initDropdowns() async {
    final classVm = Provider.of<AllClassesViewModel>(context, listen: false);
    await classVm.allClassesApi(context);
    setState(() {
      _classes.addAll((classVm.allClassesModel?.data ?? []).map((e) => {
        'id': e.classId.toString(),
        'name': e.className ?? '',
      }));
    });

    final examVm = Provider.of<ExamManagementViewModel>(context, listen: false);
    await examVm.examManagementApi(context);
    setState(() {
      _exams.addAll((examVm.examManagementModel?.data ?? []).map((e) => {
        'id': e.examId.toString(),
        'name': e.examName ?? '',
      }));
    });
  }

  Future<void> _loadSections(String classId) async {
    final res = await AllSectionsRepository().allSectionsApi(classId);
    if (res['success'] == true) {
      setState(() {
        _sections.clear();
        _sections.addAll(List<Map<String, dynamic>>.from(res['data']));
        _selectedSectionId  = null;
        _selectedSubjectId  = null;
        _selectedTimetableId = null;
        _timetableSlots.clear();
        _studentRows.clear();
      });
    }
  }


  Future<void> _loadTimetable() async {
    if (_selectedExamId == null ||
        _selectedClassId == null ||
        _selectedSectionId == null) return;

    setState(() {
      _loadingTimetable    = true;
      _timetableSlots.clear();
      _selectedSubjectId   = null;
      _selectedTimetableId = null;
      _studentRows.clear();
    });

    // ✅ Correct ViewModel: SchoolExamTimeTableViewModel
    // ✅ Correct params:   examId, classId, sectionId
    final vm =
    Provider.of<SchoolExamTimeTableViewModel>(context, listen: false);
    await vm.getExamTimetable(
      examId:    int.parse(_selectedExamId!),
      classId:   int.parse(_selectedClassId!),
      sectionId: int.parse(_selectedSectionId!),
      context:   context,
    );

    // ✅ Model: ExamTimeTableModel → data: List<ExamTimetableData>
    final slots = vm.examTimeTableModel?.data ?? [];

    setState(() {
      _loadingTimetable = false;
      // Unique subjects — one timetable_id per subject
      final seen = <String>{};
      for (final slot in slots) {
        final sid = slot.subjectId.toString();
        if (seen.add(sid)) {
          _timetableSlots.add({
            'timetable_id' : slot.timetableId.toString(),
            'subject_id'   : sid,
            'subject_name' : slot.subjectName ?? '',
          });
        }
      }
    });

    if (_timetableSlots.isEmpty) {
      _snack('No timetable found for this exam / class / section',
          Colors.orange.shade600);
    }
  }

  // ── Load students for the section ──
  Future<void> _loadStudents() async {
    if (_selectedExamId == null ||
        _selectedClassId == null ||
        _selectedSectionId == null ||
        _selectedSubjectId == null ||
        _selectedTimetableId == null) {
      _snack('Please select Exam, Class, Section & Subject', Colors.orange.shade600);
      return;
    }

    setState(() {
      _loadingStudents = true;
      _studentRows.clear();
      _successMsg = null;
    });

    final vm = Provider.of<AllStudentListVieModel>(context, listen: false);
    await vm.allStudentListApi(context);

    final filtered = (vm.allStudentListModel?.data ?? [])
        .where((e) =>
    e.classId.toString() == _selectedClassId &&
        e.sectionId.toString() == _selectedSectionId)
        .toList();

    setState(() {
      _loadingStudents = false;
      for (final s in filtered) {
        _studentRows.add({
          'student'    : s,
          'marksCtrl'  : TextEditingController(),
          'remarksCtrl': TextEditingController(),
          'isAbsent'   : false,
        });
      }
    });

    if (_studentRows.isNotEmpty) _cardAnim.forward(from: 0);
    if (_studentRows.isEmpty) {
      _snack('No students found for this section', Colors.orange.shade600);
    }
  }

  // ── Save all marks ──
  Future<void> _saveAll() async {
    if (_studentRows.isEmpty) return;

    setState(() { _saving = true; _successMsg = null; });

    int success = 0, fail = 0;

    for (final row in _studentRows) {
      final s        = row['student'];
      final bool absent = row['isAbsent'];
      final String txt  = (row['marksCtrl'] as TextEditingController).text.trim();
      final double marks = absent ? 0.0 : (double.tryParse(txt) ?? 0.0);
      final String remarks = (row['remarksCtrl'] as TextEditingController).text.trim();

      // ✅ timetable_id comes from the slot selected by user
      // ✅ student_id comes from the loaded student object
      final ok = await Provider.of<CreateExamMarksViewModel>(
          context, listen: false)
          .createExamMarksApi(
        int.parse(_selectedTimetableId!), // timetable_id ✅
        s.studentId ?? 0,                 // student_id   ✅
        marks,
        absent ? 1 : 0,
        remarks,
        context,
      );

      ok ? success++ : fail++;
    }

    setState(() {
      _saving = false;
      if (success > 0) _successMsg = '$success/${_studentRows.length} marks saved!';
    });

    if (fail > 0) _snack('$fail records failed to save', Colors.red.shade400);
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ── Stats ──
  int get _total   => _studentRows.length;
  int get _present => _studentRows.where((r) => !(r['isAbsent'] as bool)).length;
  int get _absent  => _studentRows.where((r) =>  (r['isAbsent'] as bool)).length;
  int get _pass    => _studentRows.where((r) {
    if (r['isAbsent']) return false;
    final v = double.tryParse((r['marksCtrl'] as TextEditingController).text.trim()) ?? 0;
    return v >= 33;
  }).length;
  int get _fail => _present - _pass;
  double get _avg {
    final vals = _studentRows
        .where((r) => !(r['isAbsent'] as bool))
        .map((r) => double.tryParse((r['marksCtrl'] as TextEditingController).text.trim()) ?? 0.0)
        .toList();
    if (vals.isEmpty) return 0;
    return vals.reduce((a, b) => a + b) / vals.length;
  }

  Color _avatarBg(String name) {
    const colors = [
      Color(0xFF5C6BC0), Color(0xFF26A69A), Color(0xFFEF5350),
      Color(0xFFFF7043), Color(0xFF66BB6A), Color(0xFFAB47BC),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _cardAnim.dispose();
    for (final row in _studentRows) {
      (row['marksCtrl']   as TextEditingController).dispose();
      (row['remarksCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (_successMsg != null) _buildSuccessBanner(),
              _buildFilterCard(),
              const SizedBox(height: 16),
              if (_studentRows.isNotEmpty) ...[
                _buildStatsRow(),
                const SizedBox(height: 14),
                Row(children: [
                  Container(
                    width: 4, height: 18,
                    decoration: BoxDecoration(
                      color: AppColor.lightBlueColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Students (${_studentRows.length})',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                ]),
                const SizedBox(height: 10),
                ...List.generate(_studentRows.length, (i) {
                  return AnimatedBuilder(
                    animation: _cardAnim,
                    builder: (_, child) {
                      final delay = (i * 0.06).clamp(0.0, 1.0);
                      final p = ((_cardAnim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
                      return Opacity(opacity: p, child: Transform.translate(offset: Offset(0, 20 * (1 - p)), child: child));
                    },
                    child: _buildStudentCard(i),
                  );
                }),
                const SizedBox(height: 16),
                _buildSaveButton(),
              ],
              if (_studentRows.isEmpty && !_loadingStudents) _buildEmptyState(),
            ]),
          ),
        ),
      ]),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Opacity(opacity: _headerAnim.value, child: child),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 20),
        decoration: BoxDecoration(
          gradient: AppColor.primaryGradient,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
          boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Exam Marks Entry',
                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
            Text('Manage student performance',
                style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
          ])),
          if (_studentRows.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text('$_total Students',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ]),
      ),
    );
  }

  // ── SUCCESS BANNER ──
  Widget _buildSuccessBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(_successMsg!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))),
        GestureDetector(
          onTap: () => setState(() => _successMsg = null),
          child: const Icon(Icons.close_rounded, color: Colors.white70, size: 16),
        ),
      ]),
    );
  }

  // ── FILTER CARD ──
  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(9)),
            child: Icon(Icons.filter_list_rounded, color: AppColor.lightBlueColor, size: 16),
          ),
          const SizedBox(width: 9),
          const Text('Select Filters',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
        ]),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 14),

        // Row 1: Exam + Class
        Row(children: [
          Expanded(child: _filterDrop(
            label: 'EXAM', hint: 'Select Exam', icon: Icons.assignment_rounded,
            value: _selectedExamId,
            items: _exams.map((e) => DropdownMenuItem<String>(
              value: e['id'] as String,
              child: Text(e['name'] as String, style: const TextStyle(fontSize: 13)),
            )).toList(),
            onChanged: (v) async {
              setState(() {
                _selectedExamId      = v;
                _selectedSubjectId   = null;
                _selectedTimetableId = null;
                _timetableSlots.clear();
                _studentRows.clear();
              });
              // Re-fetch timetable if class+section already selected
              if (v != null &&
                  _selectedClassId != null &&
                  _selectedSectionId != null) {
                await _loadTimetable();
              }
            },
          )),
          const SizedBox(width: 12),
          Expanded(child: _filterDrop(
            label: 'CLASS', hint: 'Select Class', icon: Icons.class_rounded,
            value: _selectedClassId,
            items: _classes.map((e) => DropdownMenuItem<String>(
              value: e['id'] as String,
              child: Text(e['name'] as String, style: const TextStyle(fontSize: 13)),
            )).toList(),
            onChanged: (v) async {
              setState(() {
                _selectedClassId = v;
                _selectedSectionId  = null;
                _selectedSubjectId  = null;
                _selectedTimetableId = null;
                _sections.clear();
                _timetableSlots.clear();
                _studentRows.clear();
              });
              if (v != null) await _loadSections(v);
            },
          )),
        ]),

        const SizedBox(height: 12),

        // Row 2: Section + Subject (from timetable)
        Row(children: [
          Expanded(child: _filterDrop(
            label: 'SECTION', hint: 'Select Section', icon: Icons.dashboard_rounded,
            value: _selectedSectionId,
            items: _sections.map((e) => DropdownMenuItem(
              value: e['section_id'].toString(),
              child: Text(e['section_name'] ?? '', style: const TextStyle(fontSize: 13)),
            )).toList(),
            onChanged: (v) async {
              setState(() {
                _selectedSectionId  = v;
                _selectedSubjectId  = null;
                _selectedTimetableId = null;
                _timetableSlots.clear();
                _studentRows.clear();
              });
              // ✅ Fetch timetable only if exam also selected
              if (v != null && _selectedClassId != null && _selectedExamId != null) {
                await _loadTimetable();
              }
            },
          )),
          const SizedBox(width: 12),
          Expanded(
            child: _loadingTimetable
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('SUBJECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
              const SizedBox(height: 5),
              Container(
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFAFAFF),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 14, height: 14,
                      child: CircularProgressIndicator(color: AppColor.lightBlueColor, strokeWidth: 2)),
                  const SizedBox(width: 8),
                  Text('Loading...', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ]),
              ),
            ])
                : _filterDrop(
              label: 'SUBJECT', hint: 'Select Subject', icon: Icons.menu_book_rounded,
              value: _selectedSubjectId,
              items: _timetableSlots.map((e) => DropdownMenuItem<String>(
                value: e['subject_id'] as String,
                child: Text(e['subject_name'] as String, style: const TextStyle(fontSize: 13)),
              )).toList(),
              onChanged: (v) {
                // ✅ Auto-set timetable_id from the selected subject slot
                final slot = _timetableSlots.firstWhere(
                      (s) => s['subject_id'] == v,
                  orElse: () => {},
                );
                setState(() {
                  _selectedSubjectId   = v;
                  _selectedTimetableId = slot['timetable_id'] as String?;
                });
              },
            ),
          ),
        ]),

        // timetable_id debug hint (dev only — remove in prod)
        if (_selectedTimetableId != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(children: [
              Icon(Icons.check_circle_rounded, size: 14, color: Colors.green.shade600),
              const SizedBox(width: 6),
              Text('Timetable ID: $_selectedTimetableId',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],

        const SizedBox(height: 16),

        // Load Students Button
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: _loadingStudents ? null : _loadStudents,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
              disabledBackgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _loadingStudents
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(width: 16, height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              const SizedBox(width: 10),
              Text('Loading students...', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 14)),
            ])
                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.group_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Load Students', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ),
      ]),
    );
  }

  // ── STATS ROW ──
  Widget _buildStatsRow() {
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: [
        _statChip('Total',   '$_total',   const Color(0xFF5C6BC0), Icons.people_rounded),
        _statChip('Present', '$_present', const Color(0xFF26A69A), Icons.check_circle_rounded),
        _statChip('Absent',  '$_absent',  const Color(0xFFEF5350), Icons.cancel_rounded),
        _statChip('Pass',    '$_pass',    const Color(0xFF66BB6A), Icons.thumb_up_rounded),
        _statChip('Fail',    '$_fail',    const Color(0xFFFF7043), Icons.thumb_down_rounded),
        _statChip('Avg',     '${_avg.toStringAsFixed(1)}%', AppColor.lightBlueColor, Icons.bar_chart_rounded),
      ],
    );
  }

  Widget _statChip(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
      ]),
    );
  }

  // ── STUDENT CARD ──
  Widget _buildStudentCard(int i) {
    final row        = _studentRows[i];
    final s          = row['student'];
    final bool absent = row['isAbsent'];
    final marksCtrl  = row['marksCtrl']   as TextEditingController;
    final remarksCtrl = row['remarksCtrl'] as TextEditingController;
    final name       = s.name ?? 'N/A';
    final initials   = name.trim().isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';
    final double marksVal = double.tryParse(marksCtrl.text) ?? -1;
    final bool hasMark  = marksVal >= 0 && !absent;
    final bool isPassed = hasMark && marksVal >= 33;
    final double pct    = hasMark ? marksVal.clamp(0, 100).toDouble() : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: absent
              ? Colors.orange.withOpacity(0.3)
              : hasMark
              ? (isPassed ? Colors.green.withOpacity(0.25) : Colors.red.withOpacity(0.25))
              : Colors.transparent,
        ),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: absent ? Colors.grey.shade300 : _avatarBg(name),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(initials,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                      color: absent ? Colors.grey.shade400 : const Color(0xFF1A1F36)),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(
                'Roll No: ${s.rollNo ?? '—'}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ])),
            if (hasMark) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isPassed ? Colors.green.shade200 : Colors.red.shade200),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(isPassed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 12, color: isPassed ? Colors.green.shade600 : Colors.red.shade600),
                  const SizedBox(width: 4),
                  Text(isPassed ? 'PASS' : 'FAIL',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                          color: isPassed ? Colors.green.shade700 : Colors.red.shade700)),
                ]),
              ),
              const SizedBox(width: 6),
            ],
            Column(children: [
              Text('Absent',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                      color: absent ? Colors.orange.shade700 : Colors.grey.shade400)),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: absent,
                  activeColor: Colors.orange,
                  activeTrackColor: Colors.orange.shade100,
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  onChanged: (val) => setState(() {
                    _studentRows[i]['isAbsent'] = val;
                    if (val) marksCtrl.clear();
                  }),
                ),
              ),
            ]),
          ]),
        ),
        if (hasMark)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 4,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  pct >= 75 ? Colors.green.shade400 : pct >= 33 ? Colors.amber.shade400 : Colors.red.shade400,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('MARKS (out of 100)',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
              const SizedBox(height: 4),
              SizedBox(
                width: 90, height: 40,
                child: TextField(
                  controller: marksCtrl,
                  enabled: !absent,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                      color: absent ? Colors.grey.shade400 : AppColor.lightBlueColor),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: absent ? 'Absent' : '0–100',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: absent ? const Color(0xFFF9F9F9) : const Color(0xFFF0F4FF),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.lightBlueColor.withOpacity(0.3))),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.lightBlueColor, width: 1.5)),
                  ),
                ),
              ),
              if (hasMark)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text('${pct.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('REMARKS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
              const SizedBox(height: 4),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: remarksCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Add remark (optional)...',
                    hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                    filled: true, fillColor: const Color(0xFFFAFAFF),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.lightBlueColor, width: 1.5)),
                  ),
                ),
              ),
            ])),
          ]),
        ),
      ]),
    );
  }

  // ── SAVE BUTTON ──
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColor.lightBlueColor, AppColor.lightBlueColor.withBlue(255)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColor.lightBlueColor.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: _saving
            ? null
            : () {

          if (!PermissionExtensions.canAccess(
              PermissionKeys.assignMarks)) {

            Utils.show(
              "You don't have permission to perform this action",
              context,
            );
            return;
          }

          _saveAll();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _saving
            ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
          SizedBox(width: 10),
          Text('Saving marks...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        ])
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.save_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text('Save All Marks  ($_total students)',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        ]),
      ),
    );
  }

  // ── EMPTY STATE ──
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 6))],
            ),
            child: Icon(Icons.assignment_outlined, size: 50, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 16),
          Text('No Students Loaded',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade400)),
          const SizedBox(height: 6),
          Text('Select filters above & tap Load Students',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ]),
      ),
    );
  }

  // ── FILTER DROPDOWN ──
  Widget _filterDrop({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: value != null ? AppColor.lightBlueColor.withOpacity(0.4) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
          color: value != null ? const Color(0xFFF0F4FF) : const Color(0xFFFAFAFF),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            isDense: true,
            icon: Icon(Icons.expand_more_rounded, size: 18, color: Colors.grey.shade400),
            hint: Row(children: [
              Icon(icon, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 5),
              Flexible(child: Text(hint, style: TextStyle(fontSize: 12, color: Colors.grey.shade400), overflow: TextOverflow.ellipsis)),
            ]),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    ]);
  }
}