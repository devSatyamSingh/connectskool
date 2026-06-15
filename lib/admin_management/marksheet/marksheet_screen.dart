import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/school_admin_profile_view_model.dart';
import '../../res/app_color.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/all_classes_view_model.dart';
import '../../view_model/school_view_model/all_scetions_view_model.dart';
import '../../view_model/school_view_model/all_student_list_view_model.dart';
import '../../view_model/school_view_model/all_subjects_view_model.dart';
import '../../view_model/school_view_model/create_admin_mark_sheet_view_model.dart';
import '../../view_model/school_view_model/delete_school_admin_marksheet_view_model.dart';
import '../../view_model/school_view_model/get_school_admin_marksheet_view_model.dart';
import '../../view_model/school_view_model/update_school_admin_mark_sheet_view_model.dart';
import '../school_exam_marks_screen.dart';
import 'generate_marksheet.dart';

// ─── Dropdown Models ──────────────────────────────────────────────────────────

class StudentItem {
  final int id;
  final String name;
  final String admissionNo;
  final String className;
  StudentItem({
    required this.id,
    required this.name,
    required this.admissionNo,
    required this.className,
  });
}

class SubjectItem {
  final int id;
  final String name;
  SubjectItem({required this.id, required this.name});
}

// ─── Mark Model ───────────────────────────────────────────────────────────────

class SubjectMark {
  final int? id;
  final int subjectId;
  final int studentId;
  final String subject;
  final String studentName;
  final int maxMarks;
  final int theoryMax;
  final int practicalMax;
  int theoryObtained;
  int practicalObtained;
  String term;
  String grade;
  String academicYear;

  SubjectMark({
    this.id,
    required this.subjectId,
    required this.studentId,
    required this.subject,
    required this.studentName,
    required this.maxMarks,
    required this.theoryMax,
    required this.practicalMax,
    required this.theoryObtained,
    required this.practicalObtained,
    required this.term,
    required this.grade,
    required this.academicYear,
  });

  int get totalObtained => theoryObtained + practicalObtained;
  double get percentage => maxMarks > 0 ? (totalObtained / maxMarks) * 100 : 0;

  String get autoGrade {
    final p = percentage;
    if (p >= 91) return 'A1';
    if (p >= 81) return 'A2';
    if (p >= 71) return 'B1';
    if (p >= 61) return 'B2';
    if (p >= 51) return 'C1';
    if (p >= 41) return 'C2';
    if (p >= 33) return 'D';
    return 'F';
  }

  Color get gradeColor {
    final p = percentage;
    if (p >= 81) return const Color(0xFF1B8B5A);
    if (p >= 61) return const Color(0xFF2C7BBF);
    if (p >= 41) return const Color(0xFFE07B2A);
    return const Color(0xFFD94040);
  }

  String get status => totalObtained >= (maxMarks * 0.33) ? 'PASS' : 'FAIL';

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'subject_id': subjectId,
    'term': term,
    'grade': autoGrade,
    'academic_year': academicYear,
    'theory_obtained': theoryObtained,
    'practical_obtained': practicalObtained,
  };
}

// ─── Academic Year Generator ──────────────────────────────────────────────────

List<String> _generateAcademicYears() {
  final now = DateTime.now();
  final List<String> years = [];
  for (int i = 2; i >= -2; i--) {
    final start = now.year - i;
    final end = start + 1;
    years.add('$start-${end.toString().substring(2)}');
  }
  return years;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class MarksheetScreen extends StatefulWidget {
  const MarksheetScreen({super.key});

  @override
  State<MarksheetScreen> createState() => _MarksheetScreenState();
}

class _MarksheetScreenState extends State<MarksheetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  String? _selectedClassId;
  String? _selectedSectionId;
  String? _selectedClassName;
  String? _selectedSectionName;
  // ── Filter State ──────────────────────────────────────────────────────────
  StudentItem? _selectedStudent;
  String _selectedAcademicYear = '2026-27';
  String _selectedTerm = 'term1';
  final _terms = ['term1', 'term2', 'term3'];
  final _academicYears = _generateAcademicYears();

  List<SubjectMark> subjects = [];

  // ── Colours ──────────────────────────────────────────────────────────────────
  static const Color _navy = Color(0xFF0D2B55);
  static const Color _gold = Color(0xFFC8922A);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFDDE3ED);

  // ── Computed ─────────────────────────────────────────────────────────────────
  List<SubjectMark> get _filtered =>
      subjects.where((s) => s.term == _selectedTerm).toList();

  int get totalMax => _filtered.fold(0, (s, e) => s + e.maxMarks);
  int get totalObtained => _filtered.fold(0, (s, e) => s + e.totalObtained);
  double get overallPercent =>
      totalMax > 0 ? (totalObtained / totalMax) * 100 : 0;

  String get overallGrade {
    final p = overallPercent;
    if (p >= 91) return 'A1';
    if (p >= 81) return 'A2';
    if (p >= 71) return 'B1';
    if (p >= 61) return 'B2';
    if (p >= 51) return 'C1';
    if (p >= 41) return 'C2';
    if (p >= 33) return 'D';
    return 'F';
  }

  String get result =>
      _filtered.isNotEmpty && _filtered.every((s) => s.status == 'PASS')
      ? 'PASS'
      : 'FAIL / COMPARTMENT';

  final List<String> _grades = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'D', 'F'];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initState ke addPostFrameCallback mein yeh add karo:
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
      Provider.of<AllSubjectsVieModel>(
        context,
        listen: false,
      ).allSubjectsApi(context);
      Provider.of<SchoolAdminProfileViewModel>(
        context,
        listen: false,
      ).schoolAdminProfileApi(context);
      Provider.of<AcademicViewModel>(
        context,
        listen: false,
      ).academicApi(context);
        final vm = Provider.of<AcademicViewModel>(context, listen: false);
        if (vm.currentYear != null) {
          setState(() {
            _selectedAcademicYear = vm.currentYear!.yearName!;
          });
        }

    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchMarksheet() async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewMarks)) {

      Utils.show(
        "You don't have permission to perform this action",
        context,
      );
      return;
    }
    if (_selectedStudent == null) return;

    setState(() => _selectedTerm = '');

    final vm = Provider.of<GetCoScholasticViewModel>(context, listen: false);
    await vm.getCoScholasticGrades(
      '${_selectedStudent!.id}',
      _selectedAcademicYear,
      context,
    );

    if (!mounted) return;

    final data = vm.marksheetModel.data ?? [];

    if (data.isNotEmpty) {
      String? autoTerm;
      for (final t in _terms) {
        if (data.any((d) => d.term == t)) {
          autoTerm = t;
          break;
        }
      }
      setState(() => _selectedTerm = autoTerm ?? data.first.term ?? 'term1');
    } else {
      setState(() => _selectedTerm = 'term1');
    }
  }

  // ─── REPLACE _buildTermSelector() with this ──────────────────────────────────

  Widget _buildTermSelector() {
    return Consumer<GetCoScholasticViewModel>(
      builder: (context, vm, _) {
        final availableTerms = (vm.marksheetModel.data ?? [])
            .map((d) => d.term ?? '')
            .where((t) => t.isNotEmpty)
            .toSet();

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: _terms.map((t) {
              final sel = _selectedTerm == t;
              final hasData =
                  availableTerms.isEmpty || availableTerms.contains(t);

              return Expanded(
                child: GestureDetector(
                  onTap: hasData
                      ? () => setState(() => _selectedTerm = t)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: sel ? AppColor.primaryGradient : null,
                      color: !hasData ? Colors.grey.shade50 : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          t.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: sel
                                ? Colors.white
                                : hasData
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (hasData && !sel)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ── API stubs ─────────────────────────────────────────────────────────────
  Future<bool> _apiDelete(int id) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SEARCHABLE PICKER
  // ─────────────────────────────────────────────────────────────────────────────

  Future<T?> _showPicker<T>({
    required BuildContext ctx,
    required List<T> items,
    required String title,
    required IconData icon,
    required String Function(T) label,
    required String Function(T) sublabel,
    T? selected,
  }) async {
    final searchCtrl = TextEditingController();
    T? result;

    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (innerCtx) => StatefulBuilder(
        builder: (innerCtx, setInner) {
          final query = searchCtrl.text.toLowerCase();
          final filtered = items
              .where(
                (it) =>
                    label(it).toLowerCase().contains(query) ||
                    sublabel(it).toLowerCase().contains(query),
              )
              .toList();

          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(innerCtx).size.height * 0.65,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: AppColor.primaryGradient,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(icon, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Select $title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _navy,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(innerCtx),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      controller: searchCtrl,
                      autofocus: true,
                      onChanged: (_) => setInner(() {}),
                      style: const TextStyle(fontSize: 13, color: _navy),
                      decoration: InputDecoration(
                        hintText: 'Search ${title.toLowerCase()}...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _navy,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 40,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: Colors.grey.shade100),
                            itemBuilder: (_, i) {
                              final item = filtered[i];
                              final isSel =
                                  selected != null &&
                                  label(selected!) == label(item);
                              return GestureDetector(
                                onTap: () {
                                  result = item;
                                  Navigator.pop(innerCtx);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? _navy.withOpacity(0.05)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSel
                                        ? Border.all(
                                            color: _navy.withOpacity(0.2),
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isSel
                                              ? _navy
                                              : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            label(
                                              item,
                                            ).substring(0, 1).toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isSel
                                                  ? Colors.white
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              label(item),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: isSel
                                                    ? _navy
                                                    : Colors.black87,
                                              ),
                                            ),
                                            if (sublabel(item).isNotEmpty)
                                              Text(
                                                sublabel(item),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (isSel)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: _navy,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CREATE / EDIT BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────────────────────

  void _openMarkSheet({SubjectMark? existing, int? globalIndex}) {
    final studentVm = Provider.of<AllStudentListVieModel>(
      context,
      listen: false,
    );
    final subjectVm = Provider.of<AllSubjectsVieModel>(context, listen: false);
    final allStudents = (studentVm.allStudentListModel?.data ?? [])
        .map((s) => StudentItem(
      id: s.studentId ?? 0,
      name: s.name ?? '',
      admissionNo: s.admissionNo ?? '',
      className: '${s.className ?? ''} · ${s.sectionName ?? ''}',
    ))
        .toList();

    final List<StudentItem> studentList = allStudents.where((s) {
      if (_selectedClassId == null && _selectedSectionId == null) return true;
      final parts = s.className.split('·');
      final cls = parts.isNotEmpty ? parts[0].trim() : '';
      final sec = parts.length > 1 ? parts[1].trim() : '';
      final classMatch = _selectedClassName == null || cls == _selectedClassName;
      final secMatch = _selectedSectionName == null || sec == _selectedSectionName;
      return classMatch && secMatch;
    }).toList();
    // final List<StudentItem> studentList =
    //     (studentVm.allStudentListModel?.data ?? [])
    //         .map(
    //           (s) => StudentItem(
    //             id: s.studentId ?? 0,
    //             name: s.name ?? '',
    //             admissionNo: s.admissionNo ?? '',
    //             className: '${s.className ?? ''} · ${s.sectionName ?? ''}',
    //           ),
    //         )
    //         .toList();

    final List<SubjectItem> subjectList =
        (subjectVm.allSubjectsModel?.data ?? [])
            .map(
              (s) =>
                  SubjectItem(id: s.subjectId ?? 0, name: s.subjectName ?? ''),
            )
            .toList();

    StudentItem? selStudent = existing != null && studentList.isNotEmpty
        ? studentList.firstWhere(
            (s) => s.id == existing.studentId,
            orElse: () => studentList.first,
          )
        : _selectedStudent;

    SubjectItem? selSubject = existing != null && subjectList.isNotEmpty
        ? subjectList.firstWhere(
            (s) => s.id == existing.subjectId,
            orElse: () => subjectList.first,
          )
        : null;

    String selGrade = existing?.grade.isNotEmpty == true
        ? existing!.grade
        : 'A2';
    String term = existing?.term ?? _selectedTerm;
    final yearCtrl = TextEditingController(
      text: existing?.academicYear ?? _selectedAcademicYear,
    );
    bool loading = false;
    bool studentError = false;
    bool subjectError = false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Widget pickerTile({
            required String title,
            required String? selectedLabel,
            required String? selectedSub,
            required IconData icon,
            required bool hasError,
            required VoidCallback onTap,
          }) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(title),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasError ? Colors.red.shade300 : _border,
                        width: hasError ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (selectedLabel != null) ...[
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: _navy,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                selectedLabel.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedLabel,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _navy,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (selectedSub != null &&
                                    selectedSub.isNotEmpty)
                                  Text(
                                    selectedSub,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ] else
                          Expanded(
                            child: Text(
                              'Select $title',
                              style: TextStyle(
                                fontSize: 13,
                                color: hasError
                                    ? Colors.red.shade400
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      'Please select a $title',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
              ],
            );
          }

          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: SafeArea(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(ctx).viewInsets.bottom + 24,
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColor.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                existing == null
                                    ? Icons.add_rounded
                                    : Icons.edit_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              existing == null
                                  ? 'Add Subject Marks'
                                  : 'Edit Marks',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _navy,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // ── STUDENT PICKER ──────────────────────────────────────
                        if (studentVm.loading)
                          _loaderTile('Loading students...')
                        else if (studentList.isEmpty)
                          _emptyTile(
                            'No students found',
                            Icons.person_off_rounded,
                          )
                        else
                          pickerTile(
                            title: 'Student',
                            selectedLabel: selStudent?.name,
                            selectedSub: selStudent != null
                                ? '${selStudent!.admissionNo} · ${selStudent!.className}'
                                : null,
                            icon: Icons.person_rounded,
                            hasError: studentError,
                            onTap: () async {
                              final picked = await _showPicker<StudentItem>(
                                ctx: ctx,
                                items: studentList,
                                title: 'Student',
                                icon: Icons.person_rounded,
                                label: (s) => s.name,
                                sublabel: (s) =>
                                    '${s.admissionNo} · ${s.className}',
                                selected: selStudent,
                              );
                              if (picked != null) {
                                setSheet(() {
                                  selStudent = picked;
                                  studentError = false;
                                });
                              }
                            },
                          ),
                        const SizedBox(height: 12),

                        // ── SUBJECT PICKER ──────────────────────────────────────
                        if (subjectVm.loading)
                          _loaderTile('Loading subjects...')
                        else if (subjectList.isEmpty)
                          _emptyTile(
                            'No subjects found',
                            Icons.menu_book_outlined,
                          )
                        else
                          pickerTile(
                            title: 'Subject',
                            selectedLabel: selSubject?.name,
                            selectedSub: null,
                            icon: Icons.menu_book_rounded,
                            hasError: subjectError,
                            onTap: () async {
                              final picked = await _showPicker<SubjectItem>(
                                ctx: ctx,
                                items: subjectList,
                                title: 'Subject',
                                icon: Icons.menu_book_rounded,
                                label: (s) => s.name,
                                sublabel: (_) => '',
                                selected: selSubject,
                              );
                              if (picked != null) {
                                setSheet(() {
                                  selSubject = picked;
                                  subjectError = false;
                                });
                              }
                            },
                          ),
                        const SizedBox(height: 12),

                        // ── GRADE + TERM ────────────────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Grade'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F7FA),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _border),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selGrade,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.grey.shade500,
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _gradeColor(selGrade),
                                        ),
                                        items: _grades
                                            .map(
                                              (g) => DropdownMenuItem(
                                                value: g,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 22,
                                                      height: 22,
                                                      decoration: BoxDecoration(
                                                        color: _gradeColor(
                                                          g,
                                                        ).withOpacity(0.12),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          g,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: _gradeColor(
                                                              g,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      g,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _gradeColor(g),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      _gradeRange(g),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setSheet(() => selGrade = v!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Term'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F7FA),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _border),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: term,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.grey.shade500,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: _navy,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        items: _terms
                                            .map(
                                              (t) => DropdownMenuItem(
                                                value: t,
                                                child: Text(t.toUpperCase()),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setSheet(() => term = v!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Academic Year ───────────────────────────────────────
                        _col('Academic Year', yearCtrl, '2026-27', false),
                        const SizedBox(height: 20),

                        // ── Submit ──────────────────────────────────────────────
                        GestureDetector(
                          onTap: loading
                              ? null
                              : () async {
                                  bool valid = formKey.currentState!.validate();
                                  if (selStudent == null) {
                                    setSheet(() => studentError = true);
                                    valid = false;
                                  }
                                  if (selSubject == null) {
                                    setSheet(() => subjectError = true);
                                    valid = false;
                                  }
                                  if (!valid) return;
                                  setSheet(() => loading = true);

                                  bool ok = false;
                                  // if (existing == null) {
                                  //   // ✅ CREATE
                                  //   final response =
                                  //       await Provider.of<
                                  //             CreateAdminMarkSheetViewModel
                                  //           >(context, listen: false)
                                  //           .createAdminMarkSheetApi(
                                  //             selStudent!.id,
                                  //             selSubject!.id,
                                  //             term,
                                  //             selGrade,
                                  //             yearCtrl.text.trim(),
                                  //             context,
                                  //           );
                                  //   ok = response == true;
                                  // }
                                  if (existing == null) {
                                    final createVm = Provider.of<CreateAdminMarkSheetViewModel>(context, listen: false);

                                    final response = await createVm.createAdminMarkSheetApi(
                                      selStudent!.id,
                                      selSubject!.id,
                                      term,
                                      selGrade,
                                      yearCtrl.text.trim(),
                                      context,
                                    );
                                    ok = response == true;

                                    // ✅ co-scholastic error → redirect to Exam Marks screen
                                    if (!ok) {
                                      final err = (createVm.lastError ?? '').toLowerCase();
                                      if (err.contains('co-scholastic')) {
                                        setSheet(() => loading = false);
                                        if (ctx.mounted) Navigator.pop(ctx);
                                        if (mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const SchoolExamMarksScreen()),
                                          );
                                        }
                                        return;
                                      }
                                    }
                                  }

                                  else {
                                    // ✅ UPDATE — grade_id aur grade bhejo
                                    ok =
                                        await Provider.of<
                                              UpdateSchoolAdminMarkSheetViewModel
                                            >(context, listen: false)
                                            .updateSchoolAdminMarkSheetApi(
                                              existing!.id!, // grade_id
                                              selGrade, // grade
                                              context,
                                            );
                                  }

                                  setSheet(() => loading = false);

                                  if (ok && mounted) {
                                    _fetchMarksheet();
                                    if (ctx.mounted) Navigator.pop(ctx);
                                    _snack(
                                      existing == null
                                          ? '✅ Marks added!'
                                          : '✅ Marks updated!',
                                      Colors.green.shade500,
                                    );
                                  }
                                },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppColor.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          existing == null
                                              ? Icons.add_rounded
                                              : Icons.check_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          existing == null
                                              ? 'Add Marks'
                                              : 'Update Marks',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper Tiles ────────────────────────────────────────────────────────────
  Widget _loaderTile(String msg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: _navy),
        ),
        const SizedBox(width: 12),
        Text(msg, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      ],
    ),
  );

  Widget _emptyTile(String msg, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 20),
        const SizedBox(width: 10),
        Text(msg, style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
      ],
    ),
  );

  Color _gradeColor(String g) {
    switch (g) {
      case 'A1':
      case 'A2':
        return const Color(0xFF1B8B5A);
      case 'B1':
      case 'B2':
        return const Color(0xFF2C7BBF);
      case 'C1':
      case 'C2':
        return const Color(0xFFE07B2A);
      default:
        return const Color(0xFFD94040);
    }
  }

  String _gradeRange(String g) {
    const map = {
      'A1': '91–100',
      'A2': '81–90',
      'B1': '71–80',
      'B2': '61–70',
      'C1': '51–60',
      'C2': '41–50',
      'D': '33–40',
      'F': '0–32',
    };
    return map[g] ?? '';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DELETE CONFIRM
  // ─────────────────────────────────────────────────────────────────────────────

  void _confirmDelete(SubjectMark s, int globalIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.delete_rounded,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Delete Marks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            children: [
              const TextSpan(text: 'Delete marks for '),
              TextSpan(
                text: s.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              const TextSpan(text: '? This cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              /// 👇 ViewModel
              final vm = Provider.of<DeleteSchoolAdminMarkSheetViewModel>(
                context,
                listen: false,
              );

              bool ok = true;

              if (s.id != null) {
                ok = await vm.deleteSchoolAdminMarkSheetApi(s.id, context);
              }

              if (ok && mounted) {
                setState(() {
                  subjects.removeWhere((e) => e.id == s.id);
                });

                _snack('🗑 ${s.subject} marks deleted', Colors.red.shade400);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Future<void> _generatePdf() async {
  //   if (_selectedStudent == null) return;
  //
  //   final vm = Provider.of<GetCoScholasticViewModel>(context, listen: false);
  //   final apiData = (vm.marksheetModel.data ?? [])
  //       .where((d) => d.term == _selectedTerm)
  //       .toList();
  //
  //   if (apiData.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('No data available for selected term',
  //           style: TextStyle(color: Colors.white)),
  //       backgroundColor: Colors.orange.shade400,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ));
  //     return;
  //   }
  //
  //   final adminVm  = Provider.of<SchoolAdminProfileViewModel>(context, listen: false);
  //   final profile  = adminVm.schoolAdminProfileModel;
  //
  //   final subjectRows = apiData.asMap().entries.map((e) => MarksheetSubjectRow(
  //     srNo:        e.key + 1,
  //     subjectName: e.value.subjectName ?? 'N/A',
  //     grade:       e.value.grade ?? 'N/A',
  //   )).toList();
  //
  //   final classParts = _selectedStudent!.className.split('·');
  //   final className  = classParts.isNotEmpty ? classParts[0].trim() : _selectedStudent!.className;
  //   final section    = classParts.length > 1  ? classParts[1].trim() : '';
  //
  //   // ✅ showOptions — user choose karega Share ya Download
  //   MarksheetPdfService.showOptions(
  //     context: context,
  //     data: MarksheetData(
  //       schoolName:    profile?.data?.schoolName    ?? 'School Name',
  //       schoolAddress: profile?.data?.schoolAdrees ?? 'School Address, City',
  //       affiliationNo:  'N/A',
  //       studentName:   _selectedStudent!.name,
  //       admissionNo:   _selectedStudent!.admissionNo,
  //       className:     className,
  //       sectionName:   section,
  //       academicYear:  _selectedAcademicYear,
  //       term:          _selectedTerm,
  //       fatherName:    '',
  //       motherName:    '',
  //       subjects:      subjectRows,
  //     ),
  //   );
  // }  \
  Future<void> _generatePdf() async {
    final grades =
        Provider.of<GetCoScholasticViewModel>(
          context,
          listen: false,
        ).marksheetModel.data ??
        [];

    final profile = Provider.of<SchoolAdminProfileViewModel>(
      context,
      listen: false,
    ).schoolAdminProfileModel;

    MarksheetPdfService.showOptions(
      context: context,
      grades: grades, // ✅ List<CoScholasticGrade>
      schoolName: profile?.data?.schoolName ?? 'School Name',
      schoolAddress: profile?.data?.schoolAdrees ?? 'School Address',
      affiliationNo: 'N/A',
      academicYear: _selectedAcademicYear,
    );
  } // BUILD
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final adminProfile = Provider.of<SchoolAdminProfileViewModel>(
      context,
    ).schoolAdminProfileModel;
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: _selectedStudent == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── GENERATE PDF button ───────────────────────────────────
                FloatingActionButton.extended(
                  heroTag: 'pdf_btn',
                  onPressed: () {

                    if (!PermissionExtensions.canAccess(
                        PermissionKeys.generateMarksheet)) {

                      Utils.show(
                        "You don't have permission to perform this action",
                        context,
                      );
                      return;
                    }

                    _generatePdf();
                  },                  backgroundColor: const Color(0xFFC8922A), // gold
                  icon: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Generate PDF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ── ADD MARKS button ──────────────────────────────────────
                FloatingActionButton.extended(
                  heroTag: 'add_btn',
                  onPressed: () {

                    if (!PermissionExtensions.canAccess(
                        PermissionKeys.generateMarksheet)) {

                      Utils.show(
                        "You don't have permission to perform this action",
                        context,
                      );
                      return;
                    }

                    _openMarkSheet();
                  },                  backgroundColor: _navy, // navy
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text(
                    'Add Marks',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  children: [
                    // ── FILTER CARD ─────────────────────────────────────────
                    _buildFilterCard(),
                    const SizedBox(height: 14),

                    // ── Only show rest when student is selected ──────────────
                    if (_selectedStudent != null) ...[
                      _buildStudentCard(),
                      const SizedBox(height: 14),
                      _buildTermSelector(),
                      const SizedBox(height: 14),
                      _buildMarksTable(),
                    ] else
                      _buildEmptyState(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final adminProfile = Provider.of<SchoolAdminProfileViewModel>(
      context,
    ).schoolAdminProfileModel;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        18,
      ),
      decoration: const BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Report Card',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),

                    // Text(
                    //   'Co-Scholastic Grades',
                    //   style: TextStyle(
                    //     color: Colors.white.withOpacity(0.65),
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CBSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 👇 School Name from API
                  Text(
                    adminProfile?.data?.schoolName ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 👇 affiliation text
                  const Text(
                    'Affiliated to CBSE | School No. 1234567',
                    style: TextStyle(color: Color(0xFFAEC6E8), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── FILTER CARD — Student + Academic Year dropdowns ─────────────────────────
  Widget _buildFilterCard() {
    return Consumer<AllStudentListVieModel>(
      builder: (context, studentVm, _) {
        final List<StudentItem> studentList =
            (studentVm.allStudentListModel?.data ?? [])
                .map(
                  (s) => StudentItem(
                    id: s.studentId ?? 0,
                    name: s.name ?? '',
                    admissionNo: s.admissionNo ?? '',
                    className: '${s.className ?? ''} · ${s.sectionName ?? ''}',
                  ),
                )
                .toList();

        return _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Select Student & Year',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
// ── Class Dropdown ─────────────────────────────────────────────
              _label('Class'),
              Consumer<AllClassesViewModel>(
                builder: (context, classVm, _) {
                  final classes = classVm.allClassesModel?.data ?? [];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedClassId,
                        isExpanded: true,
                        hint: Text('Select Class',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey.shade400, size: 20),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: _navy),
                        items: classes.map((c) => DropdownMenuItem<String>(
                          value: c.classId?.toString(),
                          child: Row(children: [
                            Icon(Icons.class_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 8),
                            Text(c.className ?? ''),
                          ]),
                        )).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedClassId = v;
                            _selectedSectionId = null;
                            _selectedSectionName = null;
                            _selectedClassName = classes
                                .firstWhere((c) => c.classId?.toString() == v,
                                orElse: () => classes.first)
                                .className;
                            // Student reset karo jab class change ho
                            _selectedStudent = null;
                          });
                          if (v != null) {
                            Provider.of<AllSectionsViewModel>(context, listen: false)
                                .allSectionsApi(context, v);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

// ── Section Dropdown ───────────────────────────────────────────
              _label('Section'),
              Consumer<AllSectionsViewModel>(
                builder: (context, secVm, _) {
                  final sections = secVm.allSectionsModel?.data ?? [];
                  final noSection = _selectedClassId != null && sections.isEmpty;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: noSection ? Colors.grey.shade50 : const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: noSection ? Colors.orange.shade200 : _border,
                        width: noSection ? 1.5 : 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sections.any((s) => s.sectionId?.toString() == _selectedSectionId)
                            ? _selectedSectionId
                            : null,
                        isExpanded: true,
                        hint: Row(children: noSection
                            ? [
                          Icon(Icons.warning_amber_rounded,
                              size: 14, color: Colors.orange.shade600),
                          const SizedBox(width: 6),
                          Text('No sections available',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500)),
                        ]
                            : [
                          Text('Select Section',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade400)),
                        ]),
                        icon: Icon(
                          noSection
                              ? Icons.warning_amber_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: noSection ? Colors.orange.shade400 : Colors.grey.shade400,
                          size: 20,
                        ),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: _navy),
                        items: sections.map((s) => DropdownMenuItem<String>(
                          value: s.sectionId?.toString(),
                          child: Row(children: [
                            Icon(Icons.bookmark_rounded,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 8),
                            Text(s.sectionName ?? ''),
                          ]),
                        )).toList(),
                        onChanged: noSection
                            ? null
                            : (v) {
                          final sec = sections.firstWhere(
                                  (s) => s.sectionId?.toString() == v,
                              orElse: () => sections.first);
                          setState(() {
                            _selectedSectionId = v;
                            _selectedSectionName = sec.sectionName;
                            // Student reset karo jab section change ho
                            _selectedStudent = null;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // ── Student Picker ─────────────────────────────────────────────
              _label('Student'),
              if (studentVm.loading)
                _loaderTile('Loading students...')
              else
                GestureDetector(
                  onTap: studentList.isEmpty
                      ? null
                      : () async {
                          final picked = await _showPicker<StudentItem>(
                            ctx: context,
                            items: studentList,
                            title: 'Student',
                            icon: Icons.person_rounded,
                            label: (s) => s.name,
                            sublabel: (s) =>
                                '${s.admissionNo} · ${s.className}',
                            selected: _selectedStudent,
                          );
                          if (picked != null) {
                            setState(() => _selectedStudent = picked);
                            _fetchMarksheet();
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        if (_selectedStudent != null) ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: _navy,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _selectedStudent!.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedStudent!.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _navy,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${_selectedStudent!.admissionNo} · ${_selectedStudent!.className}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Student picker ke hint text mein:
                          Text(
                            studentList.isEmpty && _selectedClassId != null
                                ? 'No students in this class/section'
                                : 'Tap to select student',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                          ),
                          // Text(
                          //   studentList.isEmpty
                          //       ? 'No students found'
                          //       : 'Tap to select student',
                          //   style: TextStyle(
                          //     fontSize: 13,
                          //     color: Colors.grey.shade400,
                          //   ),
                          // ),
                        ],
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // ── Academic Year Dropdown ──────────────────────────────────────
              _label('Academic Year'),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 14),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF5F7FA),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: _border),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       value: _selectedAcademicYear,
              //       isExpanded: true,
              //       icon: Icon(Icons.keyboard_arrow_down_rounded,
              //           color: Colors.grey.shade400, size: 20),
              //       style: const TextStyle(fontSize: 13,
              //           fontWeight: FontWeight.w600, color: _navy),
              //       items: _academicYears.map((y) => DropdownMenuItem(
              //         value: y,
              //         child: Row(children: [
              //           Icon(Icons.calendar_today_rounded,
              //               size: 14, color: Colors.grey.shade500),
              //           const SizedBox(width: 8),
              //           Text(y),
              //         ]),
              //       )).toList(),
              //       onChanged: (v) {
              //         if (v == null) return;
              //         setState(() => _selectedAcademicYear = v);
              //         if (_selectedStudent != null) _fetchMarksheet();
              //       },
              //     ),
              //   ),
              // ),
              Consumer<AcademicViewModel>(
                builder: (context, academicVm, child) {
                  final years = academicVm.years;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedAcademicYear,
                        isExpanded: true,
                        hint: const Text("Select Academic Year"),
                        items: years.map((y) {
                          return DropdownMenuItem<String>(
                            value: y.yearName,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Text(y.yearName ?? ''),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAcademicYear = value!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              // ── Apply button (visible only when student selected) ───────────
              if (_selectedStudent != null) ...[
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _fetchMarksheet,
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'View Marksheet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() => _card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _navy.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 48,
                color: _navy,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a Student',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _navy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose a student and academic year\nto view their marksheet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    ),
  );

  // ─── Student Card ─────────────────────────────────────────────────────────────
  Widget _buildStudentCard() {
    final s = _selectedStudent!;
    final fields = [
      ['Student Name', s.name],
      ['Admission No.', s.admissionNo],
      ['Class & Section', s.className],
      ['Student ID', '${s.id}'],
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.person_rounded, 'Student Information'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: fields.length,
            itemBuilder: (_, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fields[i][0],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  fields[i][1],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksTable() {
    return Consumer<GetCoScholasticViewModel>(
      builder: (context, vm, _) {
        if (vm.loading) {
          return _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(Icons.table_chart_rounded, 'Subject-wise Grades'),
                const SizedBox(height: 40),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 40),
              ],
            ),
          );
        }

        final data = vm.marksheetModel.data;
        // final apiData = (vm.marksheetModel.data is List)
        //     ? (vm.marksheetModel.data as List)
        //     .where((d) => d.term == _selectedTerm)
        //     .toList()
        //     : [];
        final apiData = (vm.marksheetModel.data ?? [])
            .where((d) => d.term == _selectedTerm)
            .toList();
        if (apiData.isEmpty) {
          return _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(Icons.table_chart_rounded, 'Subject-wise Grades'),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 46,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No grades for ${_selectedTerm.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "+ Add Marks" to get started',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        }

        return _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle(
                    Icons.table_chart_rounded,
                    'Subject-wise Grades',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${apiData.length} subjects',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _th('#', flex: 1),
                    _th('Subject', flex: 4),
                    _th('Student', flex: 4),
                    _th('Grade', flex: 2),
                    _th('Actions', flex: 3),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Table Rows
              ...apiData.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                final isEven = i % 2 == 0;

                final sm = SubjectMark(
                  id: d.coScholasticGradesId,
                  subjectId: d.subjectId ?? 0,
                  studentId: d.studentId ?? 0,
                  subject: d.subjectName ?? '',
                  studentName: d.studentName ?? '',
                  maxMarks: 100,
                  theoryMax: 80,
                  practicalMax: 20,
                  theoryObtained: 0,
                  practicalObtained: 0,
                  term: d.term ?? _selectedTerm,
                  grade: d.grade ?? '',
                  academicYear: d.academicYear ?? '',
                );

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: isEven ? const Color(0xFFF8FAFD) : Colors.white,
                    border: Border(
                      bottom: BorderSide(color: _border.withOpacity(0.6)),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Sr No
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Subject
                      Expanded(
                        flex: 4,
                        child: Text(
                          d.subjectName ?? '—',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _navy,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Student
                      Expanded(
                        flex: 4,
                        child: Text(
                          d.studentName ?? '—',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Grade badge
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _gradeColor(
                                d.grade ?? '',
                              ).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _gradeColor(
                                  d.grade ?? '',
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              d.grade ?? '—',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _gradeColor(d.grade ?? ''),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Actions
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {

                                if (!PermissionExtensions.canAccess(
                                    PermissionKeys.generateMarksheet)) {

                                  Utils.show(
                                    "You don't have permission to perform this action",
                                    context,
                                  );
                                  return;
                                }

                                _openMarkSheet(existing: sm);
                              },                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  size: 14,
                                  color: Colors.blue.shade500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {

                                if (!PermissionExtensions.canAccess(
                                    PermissionKeys.generateMarksheet)) {

                                  Utils.show(
                                    "You don't have permission to perform this action",
                                    context,
                                  );
                                  return;
                                }

                                _confirmDelete(sm, i);
                              },                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  Icons.delete_rounded,
                                  size: 14,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _navy.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    const Expanded(
                      flex: 4,
                      child: Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _navy,
                        ),
                      ),
                    ),
                    const Expanded(flex: 4, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${apiData.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _gold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(flex: 3, child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Widget _th(String text, {required int flex}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget _td(
    String text, {
    required int flex,
    bool bold = false,
    bool small = false,
  }) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(
        fontSize: small ? 10 : 11,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: Colors.grey.shade700,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  Widget _sectionTitle(IconData icon, String title) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _navy.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _navy, size: 16),
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: _navy,
        ),
      ),
    ],
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    ),
  );

  Widget _col(
    String lbl,
    TextEditingController ctrl,
    String hint,
    bool isNum,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(lbl),
      _field(
        controller: ctrl,
        hint: hint,
        isNum: isNum,
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
    ],
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool isNum = false,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: isNum ? TextInputType.number : TextInputType.text,
    validator: validator,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: _navy,
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _navy, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    ),
  );
}
