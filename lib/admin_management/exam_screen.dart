import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/Exam_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_exam_time_table_view_model.dart';
import 'package:shimmer/shimmer.dart';
import '../model/school_model/get_school_exam_time_table_model.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/academic_view_model.dart';
import '../view_model/school_view_model/all_classes_view_model.dart';
import '../view_model/school_view_model/all_scetions_view_model.dart';
import '../view_model/school_view_model/all_subjects_view_model.dart';
import '../view_model/school_view_model/all_teachers_view_model.dart';
import '../view_model/school_view_model/delete_exam_view_model.dart';
import '../view_model/school_view_model/edit_exam_view_model.dart';
import '../view_model/school_view_model/school_exam_time_table_view_model.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}
class _ExamScreenState extends State<ExamScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late TabController _tabController;
  final _ttExamDateCtrl = TextEditingController();

  // ── Exam form controllers ──
  final _examNameCtrl = TextEditingController();
  final _examStartDateCtrl = TextEditingController();
  final _examEndDateCtrl = TextEditingController();
  final _academicYearCtrl = TextEditingController();
  final _resultDateCtrl = TextEditingController();
  String? _selectedExamTypeId;

  // ── Timetable form controllers ──
  final _ttSubjectCtrl = TextEditingController();
  final _ttTeacherCtrl = TextEditingController();
  final _ttStartTimeCtrl = TextEditingController();
  final _ttEndTimeCtrl = TextEditingController();
  final _ttRoomNoCtrl = TextEditingController();
  final _ttMaxMarksCtrl = TextEditingController();
  final _ttMinPassingMarksCtrl = TextEditingController();
  final _ttInstructionsCtrl = TextEditingController();
  String? _selectedTTDay;
  String? _selectedTerm;
  final TextEditingController _weightageCtrl = TextEditingController();

  // ── Timetable filter ──
  String _filterDay = 'All';
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // ── Timetable tab filter state ──
  String? _viewExamId;
  String? _viewClassId;
  String? _viewSectionId;

  // ── Add timetable bottom sheet state ──
  String? _addClassId;
  String? _addSectionId;
  String? _selectedTeacherId;
  String? _selectedSubjectId;

  @override
  // void initState() {
  //   super.initState();
  //
  //   _tabController = TabController(length: 2, vsync: this);
  //   _animController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 900),
  //   )..forward();
  //
  //   _tabController.addListener(() {
  //     if (_tabController.indexIsChanging) {
  //       _animController.reset();
  //       _animController.forward();
  //     }
  //   });
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<AllClassesViewModel>(context, listen: false)
  //         .allClassesApi(context);
  //     Provider.of<ExamManagementViewModel>(context, listen: false)
  //         .examManagementApi(context);
  //   });
  // }
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _animController.reset();
        _animController.forward();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
      Provider.of<ExamManagementViewModel>(context, listen: false)
          .examManagementApi(context);

      // ✅ Academic years load karo
      Provider.of<AcademicViewModel>(context, listen: false)
          .academicApi(context);
    });
  }
  @override
  void dispose() {
    _animController.dispose();
    _tabController.dispose();
    _examNameCtrl.dispose();
    _examStartDateCtrl.dispose();
    _examEndDateCtrl.dispose();
    _academicYearCtrl.dispose();
    _resultDateCtrl.dispose();
    _ttSubjectCtrl.dispose();
    _ttTeacherCtrl.dispose();
    _ttStartTimeCtrl.dispose();
    _ttEndTimeCtrl.dispose();
    _ttRoomNoCtrl.dispose();
    _ttMaxMarksCtrl.dispose();
    _ttMinPassingMarksCtrl.dispose();
    _ttInstructionsCtrl.dispose();
    _weightageCtrl.dispose();
    _ttExamDateCtrl.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(iso).toLocal();
      if (dt.year < 2000) return 'N/A';
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return iso;
    }
  }

  String _isoToDateOnly(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      if (dt.year < 2000) return '';
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {
      return '';
    }
  }

  String _formatTime(String? t) {
    if (t == null || t.isEmpty) return 'N/A';
    try {
      final p = t.split(':');
      final dt = DateTime(0, 1, 1, int.parse(p[0]), int.parse(p[1]));
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return t;
    }
  }

  Color _statusColor(String? s) {
    switch (s?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.orange;
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _dayColor(String? d) {
    const map = {
      'Monday': Color(0xFF3F51B5),
      'Tuesday': Color(0xFF009688),
      'Wednesday': Color(0xFF9C27B0),
      'Thursday': Color(0xFFFF9800),
      'Friday': Color(0xFF4CAF50),
      'Saturday': Color(0xFFF44336),
    };
    return map[d] ?? const Color(0xFF607D8B);
  }

  // ─── EXAM BOTTOM SHEET ───────────────────────

  void _showExamBottomSheet({dynamic exam}) {
    final isEdit = exam != null;
    if (isEdit) {
      _examNameCtrl.text = exam.examName ?? '';
      _academicYearCtrl.text = exam.academicYear ?? '';
      _examStartDateCtrl.text = _isoToDateOnly(exam.startDate);
      _examEndDateCtrl.text = _isoToDateOnly(exam.endDate);
      _resultDateCtrl.text = _isoToDateOnly(exam.resultDate);
      _selectedExamTypeId = exam.examTypeId?.toString();
      _selectedTerm = exam.term;
      _weightageCtrl.text = exam.weightagePercentage?.toString() ?? '';
    } else {
      _examNameCtrl.clear();
      _academicYearCtrl.clear();
      _examStartDateCtrl.clear();
      _examEndDateCtrl.clear();
      _resultDateCtrl.clear();
      _selectedExamTypeId = null;
      _selectedTerm = null;
      _weightageCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColor.cardWhite,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHeader(
                      isEdit ? 'Edit Exam' : 'Add New Exam',
                      isEdit ? Icons.edit : Icons.add_circle_outline,
                      ctx,
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      'Exam Name',
                      _examNameCtrl,
                      Icons.school,
                      'e.g., Mid Term Examination',
                    ),
                    const SizedBox(height: 16),
                    AppText.customText('Academic Year', size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Consumer<AcademicViewModel>(
                      builder: (context, academicVm, _) {
                        final years = academicVm.years;
                        if (academicVm.loading) {
                          return Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColor.pageBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: LinearProgressIndicator()),
                          );
                        }
                        // ✅ Pre-fill controller bhi set karo jab year change ho
                        return DropdownButtonFormField<String>(
                          value: years.any((y) => y.yearName == _academicYearCtrl.text)
                              ? _academicYearCtrl.text
                              : (years.isNotEmpty
                              ? (academicVm.currentYear?.yearName ?? years.first.yearName)
                              : null),
                          decoration: _inputDeco('Select Academic Year', Icons.calendar_view_month),
                          items: years
                              .map((y) => DropdownMenuItem(
                            value: y.yearName,
                            child: Text(y.yearName ?? ""),
                          ))
                              .toList(),
                          onChanged: (v) {
                            setSheet(() {
                              _academicYearCtrl.text = v ?? '';
                            });
                          },
                        );
                      },
                    ),
                    // _labeledField(
                    //   'Academic Year',
                    //   _academicYearCtrl,
                    //   Icons.calendar_view_month,
                    //   'e.g., 2025-2026',
                    // ),
                    const SizedBox(height: 16),
                    AppText.customText('Term',
                        size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedTerm,
                      decoration:
                      _inputDeco('Select term', Icons.timeline),
                      items: const [
                        DropdownMenuItem(
                            value: 'term1', child: Text('Term 1')),
                        DropdownMenuItem(
                            value: 'term2', child: Text('Term 2')),
                      ],
                      onChanged: (v) => setSheet(() => _selectedTerm = v),
                    ),
                    const SizedBox(height: 16),
                    _labeledDateField(ctx, 'Start Date',
                        _examStartDateCtrl, Icons.calendar_today),
                    const SizedBox(height: 16),
                    _labeledDateField(
                        ctx, 'End Date', _examEndDateCtrl, Icons.event),
                    const SizedBox(height: 16),
                    _labeledDateField(
                        ctx,
                        'Result Date (Optional)',
                        _resultDateCtrl,
                        Icons.assessment),
                    const SizedBox(height: 24),
                    _submitButton(
                      label: isEdit ? 'Update Exam' : 'Add Exam',
                      onPressed: () async {
                        final academicVm = Provider.of<AcademicViewModel>(context, listen: false);
                        if (!isEdit) {
                          if (_examNameCtrl.text.trim().isEmpty ||
                              _academicYearCtrl.text.trim().isEmpty ||
                              _examStartDateCtrl.text.trim().isEmpty ||
                              _examEndDateCtrl.text.trim().isEmpty) {
                            Utils.show(
                                'Please fill all required fields', context);
                            return;
                          }
                        }

                        final createVm = Provider.of<CreateExamViewModel>(
                            context,
                            listen: false);
                        final examVm = Provider.of<ExamManagementViewModel>(
                            context,
                            listen: false);
                        final nav = Navigator.of(context);
                        final outerCtx = context;
                        bool success = false;

                        if (!isEdit) {
                          success = await createVm.createExamApi(
                            int.tryParse(_selectedExamTypeId ?? '') ?? 0,
                            _examNameCtrl.text.trim(),
                            _selectedTerm,
                            _weightageCtrl.text.trim(),
                            _academicYearCtrl.text.trim(),
                            _examStartDateCtrl.text.trim(),
                            _examEndDateCtrl.text.trim(),
                            _resultDateCtrl.text.trim(),
                            outerCtx,
                          );
                        } else {
                          success = await Provider.of<EditExamViewModel>(
                            context,
                            listen: false,
                          ).editExamApi(
                            exam.examId,
                            int.tryParse(_selectedExamTypeId ?? '') ?? 0,
                            _examNameCtrl.text.trim().isEmpty
                                ? (exam.examName ?? '')
                                : _examNameCtrl.text.trim(),
                          _academicYearCtrl.text = academicVm.currentYear?.yearName
                              ?? (academicVm.years.isNotEmpty ? academicVm.years.first.yearName ?? '' : ''),
                            // _academicYearCtrl.text.trim().isEmpty
                            //     ? (exam.academicYear ?? '')
                            //     : _academicYearCtrl.text.trim(),
                            _examStartDateCtrl.text.trim().isEmpty
                                ? _isoToDateOnly(exam.startDate)
                                : _examStartDateCtrl.text.trim(),
                            _examEndDateCtrl.text.trim().isEmpty
                                ? _isoToDateOnly(exam.endDate)
                                : _examEndDateCtrl.text.trim(),
                            _resultDateCtrl.text.trim().isEmpty
                                ? _isoToDateOnly(exam.resultDate)
                                : _resultDateCtrl.text.trim(),
                            context,
                          );
                        }
                        if (success) {
                          nav.pop();
                          examVm.examManagementApi(outerCtx);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── DELETE EXAM DIALOG ───────────────────────

  void _showDeleteExamDialog(dynamic exam) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.warning_rounded,
                  color: Colors.red, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Delete Exam?',
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete '${exam.examName}'?",
          style: TextStyle(color: AppColor.softGreyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<DeleteExamViewModel>(
                context,
                listen: false,
              ).deleteExamApi(exam.examId, context);
              Provider.of<ExamManagementViewModel>(context, listen: false)
                  .examManagementApi(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
            const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── DELETE TIMETABLE ENTRY DIALOG ──────────

  void _showDeleteTimetableDialog(ExamTimetableData entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.warning_rounded,
                  color: Colors.red, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Delete Entry?',
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: AppColor.softGreyText, fontSize: 14),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(
                text: entry.subjectName ?? 'this entry',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const TextSpan(text: ' on '),
              TextSpan(
                // ✅ Data model mein examDate use karo (dayOfWeek nahi hai)
                text: entry.examDate ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const TextSpan(text: '? This action cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<DeleteExamTimeTableViewModel>(
                context,
                listen: false,
              ).deleteExamTimeTableApi(
                entry.timetableId,
                context,
              );
              // ✅ SchoolExamTimeTableViewModel se refresh karo
              if (_viewExamId != null &&
                  _viewClassId != null &&
                  _viewSectionId != null) {
                Provider.of<SchoolExamTimeTableViewModel>(
                    context, listen: false)
                    .getExamTimetable(
                  examId: int.parse(_viewExamId!),
                  classId: int.parse(_viewClassId!),
                  sectionId: int.parse(_viewSectionId!),
                  context: context,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
            const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── ADD / EDIT TIMETABLE BOTTOM SHEET ───────

  void _showTimetableBottomSheet({ExamTimetableData? entry}) {
    final isEdit = entry != null;

    // ── Pre-fill controllers ──
    _ttStartTimeCtrl.text = isEdit ? (entry.startTime ?? '') : '';
    _ttEndTimeCtrl.text = isEdit ? (entry.endTime ?? '') : '';
    _ttExamDateCtrl.text = isEdit ? (entry.examDate ?? '') : '';
    _ttRoomNoCtrl.text = isEdit ? (entry.roomNo ?? '') : '';
    _ttMaxMarksCtrl.text = isEdit ? (entry.maxMarks ?? '') : '';
    _ttMinPassingMarksCtrl.text =
    isEdit ? (entry.minPassingMarks ?? '') : '';
    _ttInstructionsCtrl.text = isEdit ? (entry.instructions ?? '') : '';

    _selectedTTDay = null; // Data model mein dayOfWeek nahi hai
    _addClassId = isEdit ? entry.classId?.toString() : null;
    _addSectionId = isEdit ? entry.sectionId?.toString() : null;
    _selectedTeacherId = null; // Data model mein teacherId nahi hai
    _selectedSubjectId = isEdit ? entry.subjectId?.toString() : null;

    String? _sheetExamId =
    isEdit ? entry.examId?.toString() : _viewExamId;

    Provider.of<AllTeachersListVieModel>(context, listen: false)
        .allTeachersListApi(context);
    Provider.of<AllSubjectsVieModel>(context, listen: false)
        .allSubjectsApi(context);

    if (isEdit && _addClassId != null) {
      context
          .read<AllSectionsViewModel>()
          .allSectionsApi(context, _addClassId!);
    }

    final exams =
        Provider.of<ExamManagementViewModel>(context, listen: false)
            .examManagementModel
            ?.data ??
            [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColor.cardWhite,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──
                    _sheetHeader(
                      isEdit
                          ? 'Edit Timetable Entry'
                          : 'Add Timetable Entry',
                      isEdit
                          ? Icons.edit_note_rounded
                          : Icons.add_box_outlined,
                      ctx,
                    ),
                    const SizedBox(height: 24),

                    // ── Edit badge ──
                    if (isEdit)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.blue.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: Colors.blue.shade400, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Editing: ${entry.subjectName ?? ""} — ${entry.examDate ?? ""}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── EXAM DROPDOWN ──
                    AppText.customText('Select Exam',
                        size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.pageBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _sheetExamId != null
                              ? AppColor.lightBlueColor.withOpacity(0.5)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: exams.any(
                                (e) => e.examId.toString() == _sheetExamId)
                            ? _sheetExamId
                            : null,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColor.lightBlueColor),
                        decoration: InputDecoration(
                          hintText: exams.isEmpty
                              ? 'No exams available'
                              : 'Choose an exam',
                          hintStyle: TextStyle(
                              color: AppColor.softGreyText, fontSize: 13),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: Icon(Icons.assignment_rounded,
                              color: AppColor.lightBlueColor, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        items: exams
                            .map<DropdownMenuItem<String>>((exam) =>
                            DropdownMenuItem<String>(
                              value: exam.examId.toString(),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColor.lightBlueColor
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(7),
                                    ),
                                    child: Icon(
                                        Icons.assignment_outlined,
                                        color: AppColor.lightBlueColor,
                                        size: 15),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      exam.examName ??
                                          'Exam ${exam.examId}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                            .toList(),
                        onChanged: (v) =>
                            setSheet(() => _sheetExamId = v),
                      ),
                    ),

                    if (_sheetExamId != null &&
                        exams.any(
                                (e) => e.examId.toString() == _sheetExamId)) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.green.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.green, size: 15),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                'Exam: ${exams.firstWhere((e) => e.examId.toString() == _sheetExamId).examName ?? ''}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── EXAM DATE ──
                    AppText.customText('Exam Date',
                        size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ttExamDateCtrl,
                      readOnly: true,
                      decoration: _inputDeco(
                          'Select exam date', Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          builder: (c, child) => Theme(
                            data: Theme.of(c).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: AppColor.lightBlueColor),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setSheet(() {
                            _ttExamDateCtrl.text =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Class & Section ──
                    Row(
                      children: [
                        Flexible(
                          child: Consumer<AllClassesViewModel>(
                            builder: (context, vm, _) {
                              final list =
                                  vm.allClassesModel?.data ?? [];
                              final safeClassId = list.any((e) =>
                              e.classId.toString() == _addClassId)
                                  ? _addClassId
                                  : null;
                              return DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: safeClassId,
                                decoration:
                                _inputDeco('Class', Icons.class_),
                                items: list
                                    .map((e) => DropdownMenuItem(
                                  value: e.classId.toString(),
                                  child:
                                  Text(e.className ?? ''),
                                ))
                                    .toList(),
                                onChanged: (v) {
                                  setSheet(() {
                                    _addClassId = v;
                                    _addSectionId = null;
                                  });
                                  if (v != null) {
                                    context
                                        .read<AllSectionsViewModel>()
                                        .allSectionsApi(context, v);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Consumer<AllSectionsViewModel>(
                            builder: (context, vm, _) {
                              final list =
                                  vm.allSectionsModel?.data ?? [];
                              final safeSectionId = list.any((e) =>
                              e.sectionId.toString() ==
                                  _addSectionId)
                                  ? _addSectionId
                                  : null;
                              return DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: safeSectionId,
                                decoration:
                                _inputDeco('Section', Icons.group),
                                items: list
                                    .map((e) => DropdownMenuItem(
                                  value:
                                  e.sectionId.toString(),
                                  child: Text(
                                      e.sectionName ?? ''),
                                ))
                                    .toList(),
                                onChanged: (v) => setSheet(
                                        () => _addSectionId = v),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Subject ──
                    AppText.customText('Subject',
                        size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Consumer<AllSubjectsVieModel>(
                      builder: (context, vm, _) {
                        final list = vm.allSubjectsModel?.data ?? [];
                        final safeSubjectId = list.any((e) =>
                        e.subjectId.toString() ==
                            _selectedSubjectId)
                            ? _selectedSubjectId
                            : null;
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: safeSubjectId,
                          decoration:
                          _inputDeco('Select Subject', Icons.book),
                          items: list
                              .map((e) => DropdownMenuItem(
                            value: e.subjectId.toString(),
                            child:
                            Text(e.subjectName ?? ''),
                          ))
                              .toList(),
                          onChanged: (v) =>
                              setSheet(() => _selectedSubjectId = v),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Teacher ──
                    AppText.customText('Teacher',
                        size: 14, weight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Consumer<AllTeachersListVieModel>(
                      builder: (context, vm, _) {
                        final list =
                            vm.allTeachersListModel?.data ?? [];
                        final safeTeacherId = list.any((e) =>
                        e.teacherId.toString() ==
                            _selectedTeacherId)
                            ? _selectedTeacherId
                            : null;
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: safeTeacherId,
                          decoration: _inputDeco(
                              'Select Teacher', Icons.person),
                          items: list
                              .map((e) => DropdownMenuItem(
                            value: e.teacherId.toString(),
                            child: Text(e.name ?? ''),
                          ))
                              .toList(),
                          onChanged: (v) =>
                              setSheet(() => _selectedTeacherId = v),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Start & End Time ──
                    Row(
                      children: [
                        Expanded(
                          child: _labeledTimeField(ctx, 'Start Time',
                              _ttStartTimeCtrl, Icons.access_time),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeledTimeField(
                              ctx,
                              'End Time',
                              _ttEndTimeCtrl,
                              Icons.access_time_filled),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Room No & Max Marks ──
                    Row(
                      children: [
                        Expanded(
                          child: _labeledField('Room No', _ttRoomNoCtrl,
                              Icons.meeting_room, 'e.g., A-12'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeledField(
                              'Max Marks',
                              _ttMaxMarksCtrl,
                              Icons.score,
                              'e.g., 100',
                              keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Min Passing Marks ──
                    _labeledField(
                      'Min Passing Marks',
                      _ttMinPassingMarksCtrl,
                      Icons.check_circle_outline,
                      'e.g., 33',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // ── Instructions ──
                    _labeledField(
                      'Instructions',
                      _ttInstructionsCtrl,
                      Icons.info_outline,
                      'e.g., Answer all questions',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // ── Submit ──
                    _submitButton(
                      label: isEdit ? 'Update Entry' : 'Add Entry',
                      onPressed: () {
                        if (!isEdit) {
                          if (_sheetExamId == null) {
                            Utils.show(
                                'Please select an exam', context);
                            return;
                          }
                          if (_ttExamDateCtrl.text.trim().isEmpty) {
                            Utils.show(
                                'Please select exam date', context);
                            return;
                          }
                          if (_addClassId == null ||
                              _addSectionId == null ||
                              _selectedSubjectId == null ||
                              _ttStartTimeCtrl.text.trim().isEmpty ||
                              _ttEndTimeCtrl.text.trim().isEmpty) {
                            Utils.show(
                                'Please fill all required fields',
                                context);
                            return;
                          }
                        }

                        final nav = Navigator.of(ctx);
                        final ttVm =
                        Provider.of<SchoolExamTimeTableViewModel>(
                            context,
                            listen: false);
                        final outerCtx = context;

                        final finalExamId =
                            _sheetExamId ?? _viewExamId;
                        final finalClassId =
                            _addClassId ?? entry?.classId?.toString();
                        final finalSectionId = _addSectionId ??
                            entry?.sectionId?.toString();
                        final finalSubjectId = _selectedSubjectId ??
                            entry?.subjectId?.toString();
                        final finalStartTime =
                        _ttStartTimeCtrl.text.trim().isNotEmpty
                            ? _ttStartTimeCtrl.text.trim()
                            : (entry?.startTime ?? '');
                        final finalEndTime =
                        _ttEndTimeCtrl.text.trim().isNotEmpty
                            ? _ttEndTimeCtrl.text.trim()
                            : (entry?.endTime ?? '');
                        final finalExamDate =
                        _ttExamDateCtrl.text.trim().isNotEmpty
                            ? _ttExamDateCtrl.text.trim()
                            : (entry?.examDate ?? '');

                        if (finalExamId == null ||
                            finalClassId == null ||
                            finalSectionId == null ||
                            finalSubjectId == null) {
                          Utils.show(
                              'Some required fields are missing',
                              context);
                          return;
                        }

                        final int? examIdInt =
                        int.tryParse(finalExamId);
                        final int? classIdInt =
                        int.tryParse(finalClassId);
                        final int? sectionIdInt =
                        int.tryParse(finalSectionId);
                        final int? subjectIdInt =
                        int.tryParse(finalSubjectId);

                        if (examIdInt == null ||
                            classIdInt == null ||
                            sectionIdInt == null ||
                            subjectIdInt == null) {
                          Utils.show(
                              'Invalid ID values, please reselect',
                              context);
                          return;
                        }

                        Provider.of<CreateTimetableViewModel>(context,
                            listen: false)
                            .createExamTimeTableApi(
                          examIdInt,
                          classIdInt,
                          sectionIdInt.toString(),
                          subjectIdInt,
                          finalExamDate,
                          finalStartTime,
                          finalEndTime,
                          _ttRoomNoCtrl.text.trim(),
                          int.tryParse(_ttMaxMarksCtrl.text.trim()),
                          int.tryParse(
                              _ttMinPassingMarksCtrl.text.trim()),
                          _ttInstructionsCtrl.text.trim(),
                          context,
                        ).then((_) {
                          ttVm.getExamTimetable(
                            examId: examIdInt,
                            classId: classIdInt,
                            sectionId: sectionIdInt,
                            context: outerCtx,
                          );
                          setState(() {
                            _viewExamId = finalExamId;
                            _viewClassId = finalClassId;
                            _viewSectionId = finalSectionId;
                          });
                        });

                        nav.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── BUILD ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        onPressed: () => _tabController.index == 0
            ? _showExamBottomSheet()
            : _showTimetableBottomSheet(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: AnimatedBuilder(
          animation: _tabController,
          builder: (_, __) => Text(
            _tabController.index == 0 ? 'Add Exam' : 'Add Timetable',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // ✅ TimeTableViewModel → SchoolExamTimeTableViewModel
      body: Consumer2<ExamManagementViewModel,
          SchoolExamTimeTableViewModel>(
        builder: (context, examVm, ttVm, _) {
          final exams = examVm.examManagementModel?.data ?? [];
          return Column(
            children: [
              _buildHeader(exams),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExamsTab(examVm, exams),
                    _buildTimetableTab(ttVm, exams),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────

  Widget _buildHeader(List exams) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
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
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText.customText('Exam Management',
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.glassWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText.customText(
                  exams.length.toString(),
                  size: 15,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _statCard('Total', exams.length.toString(),
                  Icons.assignment, Colors.purple),
              const SizedBox(width: 10),
              _statCard(
                  'Scheduled',
                  exams
                      .where((e) => e.status == 'scheduled')
                      .length
                      .toString(),
                  Icons.schedule,
                  Colors.blue),
              const SizedBox(width: 10),
              _statCard(
                  'Cancelled',
                  exams
                      .where((e) => e.status == 'cancelled')
                      .length
                      .toString(),
                  Icons.cancel,
                  Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColor.glassWhite,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColor.lightBlueColor,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, size: 16),
                      SizedBox(width: 6),
                      Text('Exams'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_chart, size: 16),
                      SizedBox(width: 6),
                      Text('Timetable'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── TAB 1: EXAMS ────────────────────────────

  Widget _buildExamsTab(ExamManagementViewModel vm, List exams) {
    if (vm.loading) return _shimmer();
    if (exams.isEmpty) {
      return _emptyView(
          'No Exams Found', 'Tap + to add your first exam', Icons.assignment);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
      itemCount: exams.length,
      itemBuilder: (_, i) => _animated(i, _examCard(exams[i])),
    );
  }

  Widget _examCard(dynamic exam) {
    final sc = _statusColor(exam.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.assignment,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(exam.examName ?? 'N/A',
                          size: 16, weight: FontWeight.bold),
                      const SizedBox(height: 4),
                        _iconRow(Icons.calendar_today, exam.startDate != null
                          ? 'Start Date: ${_formatDate(exam.startDate)}'
                          : 'No Start date'),
                      const SizedBox(height: 2),
                      _iconRow(Icons.school, exam.endDate != null
                          ? 'End Date: ${_formatDate(exam.endDate)}'
                          : 'No end date'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: sc.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText.customText(
                          (exam.status ?? 'N/A').toUpperCase(),
                          size: 10,
                          weight: FontWeight.bold,
                          color: sc,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  color: AppColor.white,
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      onTap: () => Future.delayed(Duration.zero,
                              () => _showExamBottomSheet(exam: exam)),
                      child: _menuRow(Icons.edit, 'Edit', Colors.blue),
                    ),
                    PopupMenuItem(
                      onTap: () => Future.delayed(Duration.zero,
                              () => _showDeleteExamDialog(exam)),
                      child:
                      _menuRow(Icons.delete, 'Delete', Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _chip(Icons.calendar_month,
                    'Year: ${exam.academicYear ?? 'N/A'}'),
                _chip(Icons.event_available,
                    'Result: ${_formatDate(exam.resultDate)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAB 2: TIMETABLE ────────────────────────

  // ✅ SchoolExamTimeTableViewModel use ho raha hai
  Widget _buildTimetableTab(
      SchoolExamTimeTableViewModel ttVm, List exams) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExamDropdown(exams),
          if (_viewExamId != null) _buildClassSectionFilterRow(),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['All', ..._days].map(_dayChip).toList(),
            ),
          ),
          const SizedBox(height: 8),
          if (_viewExamId == null)
            _emptyView(
                'Select an Exam',
                'Choose an exam above to view its timetable',
                Icons.assignment_outlined)
          else if (_viewClassId == null || _viewSectionId == null)
            _emptyView(
                'Select Class & Section',
                'Choose class and section to load timetable',
                Icons.filter_list)
          else if (ttVm.loading)
              _shimmer()
            else if (ttVm.filterByDay(_filterDay).isEmpty)
                _emptyView('No Timetable Entries',
                    'Tap + to add a timetable entry', Icons.table_chart)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
                  itemCount: ttVm.filterByDay(_filterDay).length,
                  itemBuilder: (_, i) => _animated(
                    i,
                    _timetableCard(ttVm.filterByDay(_filterDay)[i]), // ✅ cast hata do
                  ),
                ),          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget _buildExamDropdown(List exams) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                AppText.customText('Select Exam',
                    size: 14,
                    weight: FontWeight.bold,
                    color: Colors.white),
                const Spacer(),
                if (_viewExamId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText.customText('Selected ✓',
                        size: 11,
                        weight: FontWeight.w600,
                        color: Colors.white),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: DropdownButtonFormField<String>(
              value: _viewExamId,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColor.lightBlueColor),
              decoration: InputDecoration(
                hintText: 'Choose an exam to view timetable',
                hintStyle: TextStyle(
                    color: AppColor.softGreyText, fontSize: 13),
                filled: true,
                fillColor: AppColor.pageBgColor,
                prefixIcon: Icon(Icons.search_rounded,
                    color: AppColor.lightBlueColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              items: exams.map((exam) {
                return DropdownMenuItem<String>(
                  value: exam.examId.toString(),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                          AppColor.lightBlueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.assignment_outlined,
                            color: AppColor.lightBlueColor, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          exam.examName ?? 'Exam ${exam.examId}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _viewExamId = v;
                  _viewClassId = null;
                  _viewSectionId = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSectionFilterRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.lightBlueColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
              border: Border(
                bottom: BorderSide(
                  color: AppColor.lightBlueColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_alt_rounded,
                    color: AppColor.lightBlueColor, size: 18),
                const SizedBox(width: 8),
                AppText.customText('Filter by Class & Section',
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColor.lightBlueColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── Class ──
                Expanded(
                  child: Consumer<AllClassesViewModel>(
                    builder: (context, vm, _) {
                      final list = vm.allClassesModel?.data ?? [];
                      final safeViewClassId = list.any((e) =>
                      e.classId.toString() == _viewClassId)
                          ? _viewClassId
                          : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.class_rounded,
                                  size: 13,
                                  color: AppColor.lightBlueColor),
                              const SizedBox(width: 4),
                              AppText.customText('Class',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColor.lightBlueColor),
                            ],
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: safeViewClassId,
                            isExpanded: true,
                            icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColor.lightBlueColor,
                                size: 20),
                            decoration: InputDecoration(
                              hintText: 'Select',
                              hintStyle: TextStyle(
                                  color: AppColor.softGreyText,
                                  fontSize: 12),
                              filled: true,
                              fillColor: AppColor.pageBgColor,
                              prefixIcon: Icon(Icons.class_outlined,
                                  color: AppColor.lightBlueColor,
                                  size: 18),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _viewClassId != null
                                      ? AppColor.lightBlueColor
                                      .withOpacity(0.4)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                            ),
                            items: list
                                .map((e) => DropdownMenuItem(
                              value: e.classId.toString(),
                              child: Text(e.className ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w500)),
                            ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _viewClassId = v;
                                _viewSectionId = null;
                              });
                              if (v != null) {
                                context
                                    .read<AllSectionsViewModel>()
                                    .allSectionsApi(context, v);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 22, left: 8, right: 8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                      AppColor.lightBlueColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColor.lightBlueColor),
                  ),
                ),
                // ── Section ──
                Expanded(
                  child: Consumer<AllSectionsViewModel>(
                    builder: (context, vm, _) {
                      final list = vm.allSectionsModel?.data ?? [];
                      final safeViewSectionId = list.any((e) =>
                      e.sectionId.toString() == _viewSectionId)
                          ? _viewSectionId
                          : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.group_rounded,
                                  size: 13,
                                  color: AppColor.lightBlueColor),
                              const SizedBox(width: 4),
                              AppText.customText('Section',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColor.lightBlueColor),
                            ],
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: safeViewSectionId,
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _viewClassId != null
                                  ? AppColor.lightBlueColor
                                  : AppColor.softGreyText,
                              size: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: _viewClassId == null
                                  ? 'Pick class first'
                                  : 'Select',
                              hintStyle: TextStyle(
                                  color: AppColor.softGreyText,
                                  fontSize: 12),
                              filled: true,
                              fillColor: _viewClassId == null
                                  ? AppColor.pageBgColor
                                  .withOpacity(0.5)
                                  : AppColor.pageBgColor,
                              prefixIcon: Icon(Icons.group_outlined,
                                  color: _viewClassId != null
                                      ? AppColor.lightBlueColor
                                      : AppColor.softGreyText,
                                  size: 18),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: _viewSectionId != null
                                      ? AppColor.lightBlueColor
                                      .withOpacity(0.4)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                            ),
                            items: list
                                .map((e) => DropdownMenuItem(
                              value: e.sectionId.toString(),
                              child: Text(e.sectionName ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w500)),
                            ))
                                .toList(),
                            onChanged: _viewClassId == null
                                ? null
                                : (v) {
                              setState(
                                      () => _viewSectionId = v);
                              // ✅ SchoolExamTimeTableViewModel.getExamTimetable call
                              if (_viewExamId != null &&
                                  _viewClassId != null &&
                                  v != null) {
                                Provider.of<SchoolExamTimeTableViewModel>(
                                    context,
                                    listen: false)
                                    .getExamTimetable(
                                  examId:
                                  int.parse(_viewExamId!),
                                  classId: int.parse(
                                      _viewClassId!),
                                  sectionId: int.parse(v),
                                  context: context,
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_viewClassId != null && _viewSectionId != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                      color: Colors.green.withOpacity(0.2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  AppText.customText(
                    'Loading timetable for selected class & section…',
                    size: 11,
                    color: Colors.green.shade700,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Data type use karo (SchoolExamTimeTableViewModel ka model)
  // Widget _timetableCard(ExamTimetableData e) {
  //   // Data model mein dayOfWeek nahi hai, examDate use karo header mein
  //   final dc = const Color(0xFF607D8B); // default color
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     decoration: BoxDecoration(
  //       color: AppColor.cardWhite,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //             color: AppColor.cardShadow,
  //             blurRadius: 10,
  //             offset: const Offset(0, 6)),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.symmetric(
  //               horizontal: 16, vertical: 10),
  //           decoration: BoxDecoration(
  //             color: dc.withOpacity(0.1),
  //             borderRadius: const BorderRadius.vertical(
  //                 top: Radius.circular(20)),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 12, vertical: 4),
  //                 decoration: BoxDecoration(
  //                   color: dc,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Text(
  //                   // ✅ examDate show karo
  //                   _formatDate(e.examDate),
  //                   style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12),
  //                 ),
  //               ),
  //               const Spacer(),
  //               Icon(Icons.access_time, size: 14, color: dc),
  //               const SizedBox(width: 4),
  //               Text(
  //                 '${_formatTime(e.startTime)} – ${_formatTime(e.endTime)}',
  //                 style: TextStyle(
  //                     color: dc,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 12),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(14),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   gradient: AppColor.primaryGradient,
  //                   borderRadius: BorderRadius.circular(14),
  //                 ),
  //                 child: const Icon(Icons.menu_book,
  //                     color: Colors.white, size: 26),
  //               ),
  //               const SizedBox(width: 14),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     AppText.customText(e.subjectName ?? 'N/A',
  //                         size: 15, weight: FontWeight.bold),
  //                     const SizedBox(height: 4),
  //                     // ✅ roomNo show karo (className/sectionName nahi hai model mein)
  //                     _iconRow(Icons.meeting_room,
  //                         'Room: ${e.roomNo ?? 'N/A'}'),
  //                     const SizedBox(height: 2),
  //                     _iconRow(Icons.score,
  //                         'Max Marks: ${e.maxMarks ?? 'N/A'}'),
  //                   ],
  //                 ),
  //               ),
  //               PopupMenuButton(
  //                 icon: const Icon(Icons.more_vert),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12)),
  //                 itemBuilder: (_) => [
  //                   PopupMenuItem(
  //                     onTap: () => Future.delayed(
  //                       Duration.zero,
  //                           () => _showTimetableBottomSheet(entry: e),
  //                     ),
  //                     child:
  //                     _menuRow(Icons.edit, 'Edit', Colors.blue),
  //                   ),
  //                   PopupMenuItem(
  //                     onTap: () => Future.delayed(
  //                       Duration.zero,
  //                           () => _showDeleteTimetableDialog(e),
  //                     ),
  //                     child: _menuRow(
  //                         Icons.delete, 'Delete', Colors.red),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _timetableCard(ExamTimetableData e) {  // ✅ ExamTimetableData → TimetableData
    final dc = const Color(0xFF607D8B);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: dc.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: dc,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _formatDate(e.examDate),   // ✅ TimetableData mein examDate
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 14, color: dc),
                const SizedBox(width: 4),
                Text(
                  '${_formatTime(e.startTime)} – ${_formatTime(e.endTime)}',
                  style: TextStyle(
                      color: dc, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.menu_book,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(e.subjectName ?? 'N/A',
                          size: 15, weight: FontWeight.bold),
                      const SizedBox(height: 4),
                      _iconRow(Icons.meeting_room,
                          'Room: ${e.roomNo ?? 'N/A'}'),
                      const SizedBox(height: 2),
                      _iconRow(Icons.score,
                          'Max Marks: ${e.maxMarks ?? 'N/A'}'),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      onTap: () => Future.delayed(
                        Duration.zero,
                            () => _showTimetableBottomSheet(entry: e),
                      ),
                      child: _menuRow(Icons.edit, 'Edit', Colors.blue),
                    ),
                    PopupMenuItem(
                      onTap: () => Future.delayed(
                        Duration.zero,
                            () => _showDeleteTimetableDialog(e),
                      ),
                      child: _menuRow(Icons.delete, 'Delete', Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ─── REUSABLE WIDGETS ─────────────────────────

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColor.glassWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            AppText.customText(value,
                size: 17,
                weight: FontWeight.bold,
                color: Colors.white),
            AppText.customText(label, size: 10, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(String day) {
    final sel = _filterDay == day;
    return GestureDetector(
      onTap: () => setState(() => _filterDay = day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: sel ? AppColor.primaryGradient : null,
          color: sel ? null : AppColor.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Text(
          day,
          style: TextStyle(
            color: sel ? Colors.white : AppColor.softGreyText,
            fontWeight:
            sel ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColor.softGreyText),
        const SizedBox(width: 4),
        Flexible(
          child: AppText.customText(label,
              size: 12, color: AppColor.softGreyText),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColor.lightBlueColor),
        const SizedBox(width: 5),
        AppText.customText(label,
            size: 11, color: AppColor.softGreyText),
      ],
    );
  }

  Widget _menuRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _emptyView(String title, String sub, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 80,
              color: AppColor.lightBlueColor.withOpacity(0.4)),
          const SizedBox(height: 16),
          AppText.customText(title, size: 18, weight: FontWeight.bold),
          const SizedBox(height: 8),
          AppText.customText(sub,
              size: 14, color: AppColor.softGreyText),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _animated(int i, Widget child) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (_, c) {
        final delay = (i * 0.08).clamp(0.0, 0.9);
        final raw =
            (_animController.value - delay) / (1.0 - delay);
        final val = Curves.easeOut.transform(raw.clamp(0.0, 1.0));
        return Transform.translate(
          offset: Offset(0, 30 * (1 - val)),
          child: Opacity(opacity: val, child: c),
        );
      },
      child: child,
    );
  }

  // ─── INPUT HELPERS ────────────────────────────

  InputDecoration _inputDeco(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.softGreyText),
        filled: true,
        fillColor: AppColor.pageBgColor,
        prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      );

  Widget _sheetHeader(
      String title, IconData icon, BuildContext ctx) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppText.customText(title,
              size: 18, weight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Navigator.pop(ctx),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _labeledField(
      String label,
      TextEditingController ctrl,
      IconData icon,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.customText(label, size: 14, weight: FontWeight.w600),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: _inputDeco(hint, icon),
        ),
      ],
    );
  }

  Widget _labeledDateField(
      BuildContext ctx,
      String label,
      TextEditingController ctrl,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.customText(label, size: 14, weight: FontWeight.w600),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: true,
          decoration: _inputDeco('Select date', icon),
          onTap: () async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
              builder: (c, child) => Theme(
                data: Theme.of(c).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: AppColor.lightBlueColor),
                ),
                child: child!,
              ),
            );
            if (picked != null)
              ctrl.text = DateFormat('yyyy-MM-dd').format(picked);
          },
        ),
      ],
    );
  }

  Widget _labeledTimeField(
      BuildContext ctx,
      String label,
      TextEditingController ctrl,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.customText(label, size: 14, weight: FontWeight.w600),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: true,
          decoration: _inputDeco('Select time', icon),
          onTap: () async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: TimeOfDay.now(),
              builder: (c, child) => Theme(
                data: Theme.of(c).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: AppColor.lightBlueColor),
                ),
                child: child!,
              ),
            );
            if (picked != null) ctrl.text = picked.format(ctx);
          },
        ),
      ],
    );
  }

  Widget _submitButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.lightBlueColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}

// class _ExamScreenState extends State<ExamScreen> with TickerProviderStateMixin {
//   late AnimationController _animController;
//   late TabController _tabController;
//   final _ttExamDateCtrl = TextEditingController();
//   // ── Exam form controllers ──
//   final _examNameCtrl = TextEditingController();
//   final _examStartDateCtrl = TextEditingController();
//   final _examEndDateCtrl = TextEditingController();
//   final _academicYearCtrl = TextEditingController();
//   final _resultDateCtrl = TextEditingController();
//   String? _selectedExamTypeId;
//
//   // ── Timetable form controllers ──
//   final _ttSubjectCtrl = TextEditingController();
//   final _ttTeacherCtrl = TextEditingController();
//   final _ttStartTimeCtrl = TextEditingController();
//   final _ttEndTimeCtrl = TextEditingController();
//   final _ttRoomNoCtrl = TextEditingController();
//   final _ttMaxMarksCtrl = TextEditingController();
//   final _ttMinPassingMarksCtrl = TextEditingController();
//   final _ttInstructionsCtrl = TextEditingController();
//   String? _selectedTTDay;
//   String? _selectedTerm;
//   final TextEditingController _weightageCtrl = TextEditingController();
//
//   // ── Timetable filter ──
//   String _filterDay = 'All';
//   final List<String> _days = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//   ];
//
//   // ── Timetable tab filter state ──
//   String? _viewExamId;
//   String? _viewClassId;
//   String? _viewSectionId;
//
//   // ── Add timetable bottom sheet state ──
//   String? _addClassId;
//   String? _addSectionId;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _tabController = TabController(length: 2, vsync: this);
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         _animController.reset();
//         _animController.forward();
//       }
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AllClassesViewModel>(context, listen: false)
//           .allClassesApi(context);
//       Provider.of<ExamManagementViewModel>(context, listen: false)
//           .examManagementApi(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _animController.dispose();
//     _tabController.dispose();
//     _examNameCtrl.dispose();
//     _examStartDateCtrl.dispose();
//     _examEndDateCtrl.dispose();
//     _academicYearCtrl.dispose();
//     _resultDateCtrl.dispose();
//     _ttSubjectCtrl.dispose();
//     _ttTeacherCtrl.dispose();
//     _ttStartTimeCtrl.dispose();
//     _ttEndTimeCtrl.dispose();
//     _ttRoomNoCtrl.dispose();
//     _ttMaxMarksCtrl.dispose();
//     _ttMinPassingMarksCtrl.dispose();
//     _ttInstructionsCtrl.dispose();
//     _weightageCtrl.dispose();
//     super.dispose();
//   }
//
//   // ─── Helpers ─────────────────────────────────
//
//   String _formatDate(String? iso) {
//     if (iso == null || iso.isEmpty) return 'N/A';
//     try {
//       final dt = DateTime.parse(iso).toLocal();
//       if (dt.year < 2000) return 'N/A';
//       return DateFormat('dd MMM yyyy').format(dt);
//     } catch (_) {
//       return iso;
//     }
//   }
//
//   String _isoToDateOnly(String? iso) {
//     if (iso == null || iso.isEmpty) return '';
//     try {
//       final dt = DateTime.parse(iso).toLocal();
//       if (dt.year < 2000) return '';
//       return DateFormat('yyyy-MM-dd').format(dt);
//     } catch (_) {
//       return '';
//     }
//   }
//
//   String _formatTime(String? t) {
//     if (t == null || t.isEmpty) return 'N/A';
//     try {
//       final p = t.split(':');
//       final dt = DateTime(0, 1, 1, int.parse(p[0]), int.parse(p[1]));
//       return DateFormat('hh:mm a').format(dt);
//     } catch (_) {
//       return t;
//     }
//   }
//
//   Color _statusColor(String? s) {
//     switch (s?.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'ongoing':
//         return Colors.orange;
//       case 'scheduled':
//         return Colors.blue;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Color _dayColor(String? d) {
//     const map = {
//       'Monday': Color(0xFF3F51B5),
//       'Tuesday': Color(0xFF009688),
//       'Wednesday': Color(0xFF9C27B0),
//       'Thursday': Color(0xFFFF9800),
//       'Friday': Color(0xFF4CAF50),
//       'Saturday': Color(0xFFF44336),
//     };
//     return map[d] ?? const Color(0xFF607D8B);
//   }
//
//   // ─── EXAM BOTTOM SHEET ───────────────────────
//
//   void _showExamBottomSheet({dynamic exam}) {
//     final isEdit = exam != null;
//     if (isEdit) {
//       _examNameCtrl.text = exam.examName ?? '';
//       _academicYearCtrl.text = exam.academicYear ?? '';
//       _examStartDateCtrl.text = _isoToDateOnly(exam.startDate);
//       _examEndDateCtrl.text = _isoToDateOnly(exam.endDate);
//       _resultDateCtrl.text = _isoToDateOnly(exam.resultDate);
//       _selectedExamTypeId = exam.examTypeId?.toString();
//       _selectedTerm = exam.term;
//       _weightageCtrl.text = exam.weightagePercentage?.toString() ?? '';
//     } else {
//       _examNameCtrl.clear();
//       _academicYearCtrl.clear();
//       _examStartDateCtrl.clear();
//       _examEndDateCtrl.clear();
//       _resultDateCtrl.clear();
//       _selectedExamTypeId = null;
//       _selectedTerm = null;
//       _weightageCtrl.clear();
//     }
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, setSheet) => SafeArea(
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(ctx).viewInsets.bottom,
//             ),
//             decoration: BoxDecoration(
//               color: AppColor.cardWhite,
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _sheetHeader(
//                       isEdit ? 'Edit Exam' : 'Add New Exam',
//                       isEdit ? Icons.edit : Icons.add_circle_outline,
//                       ctx,
//                     ),
//                     const SizedBox(height: 16),
//                     _labeledField(
//                       'Exam Name',
//                       _examNameCtrl,
//                       Icons.school,
//                       'e.g., Mid Term Examination',
//                     ),
//                     const SizedBox(height: 16),
//                     _labeledField(
//                       'Academic Year',
//                       _academicYearCtrl,
//                       Icons.calendar_view_month,
//                       'e.g., 2025-2026',
//                     ),
//                     const SizedBox(height: 16),
//                     AppText.customText('Term',
//                         size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       value: _selectedTerm,
//                       decoration:
//                       _inputDeco('Select term', Icons.timeline),
//                       items: const [
//                         DropdownMenuItem(
//                             value: 'term1', child: Text('Term 1')),
//                         DropdownMenuItem(
//                             value: 'term2', child: Text('Term 2')),
//                       ],
//                       onChanged: (v) =>
//                           setSheet(() => _selectedTerm = v),
//                     ),
//                     const SizedBox(height: 16),
//                     _labeledDateField(ctx, 'Start Date',
//                         _examStartDateCtrl, Icons.calendar_today),
//                     const SizedBox(height: 16),
//                     _labeledDateField(
//                         ctx, 'End Date', _examEndDateCtrl, Icons.event),
//                     const SizedBox(height: 16),
//                     _labeledDateField(
//                         ctx,
//                         'Result Date (Optional)',
//                         _resultDateCtrl,
//                         Icons.assessment),
//                     const SizedBox(height: 24),
//                     _submitButton(
//                       label: isEdit ? 'Update Exam' : 'Add Exam',
//                       onPressed: () async {
//                         if (!isEdit) {
//                           if (_examNameCtrl.text.trim().isEmpty ||
//                               _academicYearCtrl.text.trim().isEmpty ||
//                               _examStartDateCtrl.text.trim().isEmpty ||
//                               _examEndDateCtrl.text.trim().isEmpty) {
//                             Utils.show(
//                                 'Please fill all required fields', context);
//                             return;
//                           }
//                         }
//
//                         final createVm =
//                         Provider.of<CreateExamViewModel>(context,
//                             listen: false);
//                         final examVm =
//                         Provider.of<ExamManagementViewModel>(context,
//                             listen: false);
//                         final nav = Navigator.of(context);
//                         final outerCtx = context;
//                         bool success = false;
//
//                         if (!isEdit) {
//                           success = await createVm.createExamApi(
//                             int.tryParse(_selectedExamTypeId ?? '') ?? 0,
//                             _examNameCtrl.text.trim(),
//                             _selectedTerm,
//                             _weightageCtrl.text.trim(),
//                             _academicYearCtrl.text.trim(),
//                             _examStartDateCtrl.text.trim(),
//                             _examEndDateCtrl.text.trim(),
//                             _resultDateCtrl.text.trim(),
//                             outerCtx,
//                           );
//                         } else {
//                           success = await Provider.of<EditExamViewModel>(
//                             context,
//                             listen: false,
//                           ).editExamApi(
//                             exam.examId,
//                             int.tryParse(_selectedExamTypeId ?? '') ?? 0,
//                             _examNameCtrl.text.trim().isEmpty
//                                 ? (exam.examName ?? '')
//                                 : _examNameCtrl.text.trim(),
//                             _academicYearCtrl.text.trim().isEmpty
//                                 ? (exam.academicYear ?? '')
//                                 : _academicYearCtrl.text.trim(),
//                             _examStartDateCtrl.text.trim().isEmpty
//                                 ? _isoToDateOnly(exam.startDate)
//                                 : _examStartDateCtrl.text.trim(),
//                             _examEndDateCtrl.text.trim().isEmpty
//                                 ? _isoToDateOnly(exam.endDate)
//                                 : _examEndDateCtrl.text.trim(),
//                             _resultDateCtrl.text.trim().isEmpty
//                                 ? _isoToDateOnly(exam.resultDate)
//                                 : _resultDateCtrl.text.trim(),
//                             context,
//                           );
//                         }
//                         if (success) {
//                           nav.pop();
//                           examVm.examManagementApi(outerCtx);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ─── DELETE EXAM DIALOG ───────────────────────
//
//   void _showDeleteExamDialog(dynamic exam) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Icons.warning_rounded,
//                   color: Colors.red, size: 28),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text('Delete Exam?',
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//         content: Text(
//           "Are you sure you want to delete '${exam.examName}'?",
//           style: TextStyle(color: AppColor.softGreyText),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await Provider.of<DeleteExamViewModel>(
//                 context,
//                 listen: false,
//               ).deleteExamApi(exam.examId, context);
//               Provider.of<ExamManagementViewModel>(context, listen: false)
//                   .examManagementApi(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text('Delete',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── DELETE TIMETABLE ENTRY DIALOG ──────────
//
//   void _showDeleteTimetableDialog(TimetableData entry) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Icons.warning_rounded,
//                   color: Colors.red, size: 28),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text('Delete Entry?',
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//         content: RichText(
//           text: TextSpan(
//             style: TextStyle(
//                 color: AppColor.softGreyText, fontSize: 14),
//             children: [
//               const TextSpan(text: 'Are you sure you want to delete '),
//               TextSpan(
//                 text: entry.subjectName ?? 'this entry',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               const TextSpan(text: ' on '),
//               TextSpan(
//                 text: entry.dayOfWeek ?? '',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               const TextSpan(text: '? This action cannot be undone.'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await Provider.of<DeleteClassesTimeTableViewModel>(
//                 context,
//                 listen: false,
//               ).deleteClassesTimeTableApi(
//                 entry.timetableId,
//                 context,
//               );
//               // ✅ List refresh karo
//               if (_viewExamId != null &&
//                   _viewClassId != null &&
//                   _viewSectionId != null) {
//                 Provider.of<TimeTableViewModel>(context, listen: false)
//                     .getTimetable(
//                   examId: int.parse(_viewExamId!),
//                   classId: int.parse(_viewClassId!),
//                   sectionId: int.parse(_viewSectionId!),
//                   context: context,
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text('Delete',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String? _selectedTeacherId;
//   String? _selectedSubjectId;
//
//   // ─── ADD / EDIT TIMETABLE BOTTOM SHEET ───────
//   // ✅ entry pass karo toh edit mode, null toh add mode
//   // void _showTimetableBottomSheet({TimetableData? entry}) {
//   //   final isEdit = entry != null;
//   //
//   //   // ── Pre-fill controllers from existing entry ──
//   //   _ttStartTimeCtrl.text = isEdit ? (entry.startTime ?? '') : '';
//   //   _ttEndTimeCtrl.text = isEdit ? (entry.endTime ?? '') : '';
//   //   _ttRoomNoCtrl.text = isEdit ? (entry.roomNo ?? '') : '';
//   //   _ttMaxMarksCtrl.text =
//   //   isEdit ? (entry.maxMarks?.toString() ?? '') : '';
//   //   _ttMinPassingMarksCtrl.text =
//   //   isEdit ? (entry.minPassingMarks?.toString() ?? '') : '';
//   //   _ttInstructionsCtrl.text =
//   //   isEdit ? (entry.instructions ?? '') : '';
//   //   _selectedTTDay = isEdit ? entry.dayOfWeek : null;
//   //   _addClassId = isEdit ? entry.classId?.toString() : null;
//   //   _addSectionId = isEdit ? entry.sectionId?.toString() : null;
//   //   _selectedTeacherId = isEdit ? entry.teacherId?.toString() : null;
//   //   _selectedSubjectId = isEdit ? entry.subjectId?.toString() : null;
//   //
//   //   // ✅ Edit mode mein existing exam pre-select karo
//   //   String? _sheetExamId =
//   //   isEdit ? entry.examId?.toString() : _viewExamId;
//   //
//   //   Provider.of<AllTeachersListVieModel>(context, listen: false)
//   //       .allTeachersListApi(context);
//   //   Provider.of<AllSubjectsVieModel>(context, listen: false)
//   //       .allSubjectsApi(context);
//   //
//   //   // ✅ Agar edit mode aur class already set hai toh sections load karo
//   //   if (isEdit && _addClassId != null) {
//   //     context
//   //         .read<AllSectionsViewModel>()
//   //         .allSectionsApi(context, _addClassId!);
//   //   }
//   //
//   //   final exams =
//   //       Provider.of<ExamManagementViewModel>(context, listen: false)
//   //           .examManagementModel
//   //           ?.data ??
//   //           [];
//   //
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (_) => StatefulBuilder(
//   //       builder: (ctx, setSheet) => SafeArea(
//   //         child: Container(
//   //           padding: EdgeInsets.only(
//   //             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//   //           ),
//   //           decoration: BoxDecoration(
//   //             color: AppColor.cardWhite,
//   //             borderRadius:
//   //             const BorderRadius.vertical(top: Radius.circular(28)),
//   //           ),
//   //           child: SingleChildScrollView(
//   //             child: Padding(
//   //               padding: const EdgeInsets.all(24),
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   // ✅ Header — Add ya Edit
//   //                   _sheetHeader(
//   //                     isEdit
//   //                         ? 'Edit Timetable Entry'
//   //                         : 'Add Timetable Entry',
//   //                     isEdit
//   //                         ? Icons.edit_note_rounded
//   //                         : Icons.add_box_outlined,
//   //                     ctx,
//   //                   ),
//   //                   const SizedBox(height: 24),
//   //
//   //                   // ✅ Edit mode badge
//   //                   if (isEdit)
//   //                     Container(
//   //                       margin: const EdgeInsets.only(bottom: 16),
//   //                       padding: const EdgeInsets.symmetric(
//   //                           horizontal: 14, vertical: 10),
//   //                       decoration: BoxDecoration(
//   //                         color: Colors.blue.withOpacity(0.08),
//   //                         borderRadius: BorderRadius.circular(12),
//   //                         border: Border.all(
//   //                             color: Colors.blue.withOpacity(0.25)),
//   //                       ),
//   //                       child: Row(
//   //                         children: [
//   //                           Icon(Icons.info_outline_rounded,
//   //                               color: Colors.blue.shade400, size: 16),
//   //                           const SizedBox(width: 8),
//   //                           Expanded(
//   //                             child: Text(
//   //                               'Editing: ${entry.subjectName ?? ""} — ${entry.dayOfWeek ?? ""}. Empty fields will keep existing values.',
//   //                               style: TextStyle(
//   //                                 fontSize: 12,
//   //                                 color: Colors.blue.shade700,
//   //                                 fontWeight: FontWeight.w500,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //
//   //                   // ── EXAM DROPDOWN ──
//   //                   AppText.customText('Select Exam',
//   //                       size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Container(
//   //                     decoration: BoxDecoration(
//   //                       color: AppColor.pageBgColor,
//   //                       borderRadius: BorderRadius.circular(14),
//   //                       border: Border.all(
//   //                         color: _sheetExamId != null
//   //                             ? AppColor.lightBlueColor.withOpacity(0.5)
//   //                             : Colors.transparent,
//   //                         width: 1.5,
//   //                       ),
//   //                     ),
//   //                     child: DropdownButtonFormField<String>(
//   //                       value: _sheetExamId,
//   //                       isExpanded: true,
//   //                       icon: Icon(Icons.keyboard_arrow_down_rounded,
//   //                           color: AppColor.lightBlueColor),
//   //                       decoration: InputDecoration(
//   //                         hintText: exams.isEmpty
//   //                             ? 'No exams available'
//   //                             : 'Choose an exam',
//   //                         hintStyle: TextStyle(
//   //                             color: AppColor.softGreyText, fontSize: 13),
//   //                         filled: true,
//   //                         fillColor: Colors.transparent,
//   //                         prefixIcon: Icon(Icons.assignment_rounded,
//   //                             color: AppColor.lightBlueColor, size: 20),
//   //                         border: OutlineInputBorder(
//   //                           borderRadius: BorderRadius.circular(14),
//   //                           borderSide: BorderSide.none,
//   //                         ),
//   //                         contentPadding: const EdgeInsets.symmetric(
//   //                             horizontal: 16, vertical: 14),
//   //                       ),
//   //                       items: exams
//   //                           .map<DropdownMenuItem<String>>((exam) =>
//   //                           DropdownMenuItem<String>(
//   //                             value: exam.examId.toString(),
//   //                             child: Row(
//   //                               children: [
//   //                                 Container(
//   //                                   padding: const EdgeInsets.all(5),
//   //                                   decoration: BoxDecoration(
//   //                                     color: AppColor.lightBlueColor
//   //                                         .withOpacity(0.1),
//   //                                     borderRadius:
//   //                                     BorderRadius.circular(7),
//   //                                   ),
//   //                                   child: Icon(
//   //                                       Icons.assignment_outlined,
//   //                                       color: AppColor.lightBlueColor,
//   //                                       size: 15),
//   //                                 ),
//   //                                 const SizedBox(width: 10),
//   //                                 Flexible(
//   //                                   child: Text(
//   //                                     exam.examName ??
//   //                                         'Exam ${exam.examId}',
//   //                                     overflow: TextOverflow.ellipsis,
//   //                                     style: const TextStyle(
//   //                                         fontSize: 13,
//   //                                         fontWeight: FontWeight.w500),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ))
//   //                           .toList(),
//   //                       onChanged: (v) =>
//   //                           setSheet(() => _sheetExamId = v),
//   //                     ),
//   //                   ),
//   //
//   //                   if (_sheetExamId != null) ...[
//   //                     const SizedBox(height: 8),
//   //                     Container(
//   //                       padding: const EdgeInsets.symmetric(
//   //                           horizontal: 12, vertical: 7),
//   //                       decoration: BoxDecoration(
//   //                         color: Colors.green.withOpacity(0.08),
//   //                         borderRadius: BorderRadius.circular(10),
//   //                         border: Border.all(
//   //                             color: Colors.green.withOpacity(0.25)),
//   //                       ),
//   //                       child: Row(
//   //                         children: [
//   //                           Icon(Icons.check_circle_rounded,
//   //                               color: Colors.green, size: 15),
//   //                           const SizedBox(width: 7),
//   //                           Expanded(
//   //                             child: Text(
//   //                               'Exam selected: ${exams.firstWhere((e) => e.examId.toString() == _sheetExamId, orElse: () => exams.first).examName ?? ''}',
//   //                               style: TextStyle(
//   //                                   fontSize: 12,
//   //                                   color: Colors.green.shade700,
//   //                                   fontWeight: FontWeight.w500),
//   //                               overflow: TextOverflow.ellipsis,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   ],
//   //
//   //                   const SizedBox(height: 20),
//   //
//   //                   // ── Day ──
//   //                   AppText.customText('Day',
//   //                       size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   DropdownButtonFormField<String>(
//   //                     value: _selectedTTDay,
//   //                     decoration:
//   //                     _inputDeco('Select day', Icons.today),
//   //                     items: _days
//   //                         .map((d) => DropdownMenuItem(
//   //                         value: d, child: Text(d)))
//   //                         .toList(),
//   //                     onChanged: (v) =>
//   //                         setSheet(() => _selectedTTDay = v),
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Class & Section ──
//   //                   Row(
//   //                     children: [
//   //                       Flexible(
//   //                         child: Consumer<AllClassesViewModel>(
//   //                           builder: (context, vm, _) {
//   //                             final list = vm.allClassesModel?.data ?? [];
//   //                             return DropdownButtonFormField<String>(
//   //                               isExpanded: true,
//   //                               value: _addClassId,
//   //                               decoration: _inputDeco(
//   //                                   'Class', Icons.class_),
//   //                               items: list
//   //                                   .map((e) => DropdownMenuItem(
//   //                                 value: e.classId.toString(),
//   //                                 child:
//   //                                 Text(e.className ?? ''),
//   //                               ))
//   //                                   .toList(),
//   //                               onChanged: (v) {
//   //                                 setSheet(() {
//   //                                   _addClassId = v;
//   //                                   _addSectionId = null;
//   //                                 });
//   //                                 if (v != null) {
//   //                                   context
//   //                                       .read<AllSectionsViewModel>()
//   //                                       .allSectionsApi(context, v);
//   //                                 }
//   //                               },
//   //                             );
//   //                           },
//   //                         ),
//   //                       ),
//   //                       const SizedBox(width: 8),
//   //                       Flexible(
//   //                         child: Consumer<AllSectionsViewModel>(
//   //                           builder: (context, vm, _) {
//   //                             final list =
//   //                                 vm.allSectionsModel?.data ?? [];
//   //                             return DropdownButtonFormField<String>(
//   //                               isExpanded: true,
//   //                               value: _addSectionId,
//   //                               decoration: _inputDeco(
//   //                                   'Section', Icons.group),
//   //                               items: list
//   //                                   .map((e) => DropdownMenuItem(
//   //                                 value:
//   //                                 e.sectionId.toString(),
//   //                                 child:
//   //                                 Text(e.sectionName ?? ''),
//   //                               ))
//   //                                   .toList(),
//   //                               onChanged: (v) =>
//   //                                   setSheet(() => _addSectionId = v),
//   //                             );
//   //                           },
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Subject ──
//   //                   AppText.customText('Subject',
//   //                       size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Consumer<AllSubjectsVieModel>(
//   //                     builder: (context, vm, _) {
//   //                       final list = vm.allSubjectsModel?.data ?? [];
//   //                       return DropdownButtonFormField<String>(
//   //                         isExpanded: true,
//   //                         value: _selectedSubjectId,
//   //                         decoration: _inputDeco(
//   //                             'Select Subject', Icons.book),
//   //                         items: list
//   //                             .map((e) => DropdownMenuItem(
//   //                           value: e.subjectId.toString(),
//   //                           child: Text(e.subjectName ?? ''),
//   //                         ))
//   //                             .toList(),
//   //                         onChanged: (v) =>
//   //                             setSheet(() => _selectedSubjectId = v),
//   //                       );
//   //                     },
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Teacher ──
//   //                   AppText.customText('Teacher',
//   //                       size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Consumer<AllTeachersListVieModel>(
//   //                     builder: (context, vm, _) {
//   //                       final list =
//   //                           vm.allTeachersListModel?.data ?? [];
//   //                       return DropdownButtonFormField<String>(
//   //                         isExpanded: true,
//   //                         value: _selectedTeacherId,
//   //                         decoration: _inputDeco(
//   //                             'Select Teacher', Icons.person),
//   //                         items: list
//   //                             .map((e) => DropdownMenuItem(
//   //                           value: e.teacherId.toString(),
//   //                           child: Text(e.name ?? ''),
//   //                         ))
//   //                             .toList(),
//   //                         onChanged: (v) =>
//   //                             setSheet(() => _selectedTeacherId = v),
//   //                       );
//   //                     },
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Start & End Time ──
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: _labeledTimeField(ctx, 'Start Time',
//   //                             _ttStartTimeCtrl, Icons.access_time),
//   //                       ),
//   //                       const SizedBox(width: 12),
//   //                       Expanded(
//   //                         child: _labeledTimeField(
//   //                             ctx,
//   //                             'End Time',
//   //                             _ttEndTimeCtrl,
//   //                             Icons.access_time_filled),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Room No & Max Marks ──
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: _labeledField('Room No', _ttRoomNoCtrl,
//   //                             Icons.meeting_room, 'e.g., A-12'),
//   //                       ),
//   //                       const SizedBox(width: 12),
//   //                       Expanded(
//   //                         child: _labeledField(
//   //                             'Max Marks',
//   //                             _ttMaxMarksCtrl,
//   //                             Icons.score,
//   //                             'e.g., 100',
//   //                             keyboardType: TextInputType.number),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Min Passing Marks ──
//   //                   _labeledField(
//   //                     'Min Passing Marks',
//   //                     _ttMinPassingMarksCtrl,
//   //                     Icons.check_circle_outline,
//   //                     'e.g., 33',
//   //                     keyboardType: TextInputType.number,
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Instructions ──
//   //                   _labeledField(
//   //                     'Instructions',
//   //                     _ttInstructionsCtrl,
//   //                     Icons.info_outline,
//   //                     'e.g., Answer all questions',
//   //                     maxLines: 3,
//   //                   ),
//   //                   const SizedBox(height: 24),
//   //
//   //                   // ── Submit ──
//   //                   _submitButton(
//   //                     label: isEdit ? 'Update Entry' : 'Add Entry',
//   //                     onPressed: () {
//   //                       // ✅ Add mode mein sab required, Edit mein kuch bhi change karo
//   //                       if (!isEdit) {
//   //                         if (_sheetExamId == null) {
//   //                           Utils.show(
//   //                               'Please select an exam', context);
//   //                           return;
//   //                         }
//   //                         if (_selectedTTDay == null ||
//   //                             _addClassId == null ||
//   //                             _addSectionId == null ||
//   //                             _selectedSubjectId == null ||
//   //                             _selectedTeacherId == null ||
//   //                             _ttStartTimeCtrl.text.trim().isEmpty ||
//   //                             _ttEndTimeCtrl.text.trim().isEmpty) {
//   //                           Utils.show(
//   //                               'Please fill all required fields',
//   //                               context);
//   //                           return;
//   //                         }
//   //                       }
//   //
//   //                       final nav = Navigator.of(ctx);
//   //                       final ttVm = Provider.of<TimeTableViewModel>(
//   //                           context, listen: false);
//   //                       final outerCtx = context;
//   //
//   //                       // ✅ Existing values fallback (edit mode)
//   //                       final finalExamId = _sheetExamId ??
//   //                           entry?.timetableId?.toString();
//   //                       final finalClassId =
//   //                           _addClassId ?? entry?.classId?.toString();
//   //                       final finalSectionId = _addSectionId ??
//   //                           entry?.sectionId?.toString();
//   //                       final finalSubjectId = _selectedSubjectId ??
//   //                           entry?.subjectId?.toString();
//   //                       final finalTeacherId = _selectedTeacherId ??
//   //                           entry?.teacherId?.toString();
//   //                       final finalDay =
//   //                           _selectedTTDay ?? entry?.dayOfWeek;
//   //                       final finalStartTime =
//   //                       _ttStartTimeCtrl.text.trim().isNotEmpty
//   //                           ? _ttStartTimeCtrl.text
//   //                           : (entry?.startTime ?? '');
//   //                       final finalEndTime =
//   //                       _ttEndTimeCtrl.text.trim().isNotEmpty
//   //                           ? _ttEndTimeCtrl.text
//   //                           : (entry?.endTime ?? '');
//   //                       final finalRoomNo =
//   //                       _ttRoomNoCtrl.text.trim().isNotEmpty
//   //                           ? _ttRoomNoCtrl.text.trim()
//   //                           : (entry?.roomNo ?? '');
//   //                       final finalMaxMarks =
//   //                       _ttMaxMarksCtrl.text.trim().isNotEmpty
//   //                           ? int.tryParse(
//   //                           _ttMaxMarksCtrl.text.trim())
//   //                           : entry?.maxMarks;
//   //                       final finalMinMarks =
//   //                       _ttMinPassingMarksCtrl.text.trim().isNotEmpty
//   //                           ? int.tryParse(
//   //                           _ttMinPassingMarksCtrl.text.trim())
//   //                           : entry?.minPassingMarks;
//   //                       final finalInstructions =
//   //                       _ttInstructionsCtrl.text.trim().isNotEmpty
//   //                           ? _ttInstructionsCtrl.text.trim()
//   //                           : (entry?.instructions ?? '');
//   //
//   //                       Provider.of<CreateTimetableViewModel>(context,
//   //                           listen: false)
//   //                           .createExamTimeTableApi(
//   //                         _selectedExamTypeId,
//   //                         int.parse(finalClassId!),
//   //                         finalSectionId.toString(),
//   //                         int.parse(finalSubjectId!),
//   //                         int.parse(finalTeacherId!),
//   //                         finalDay,
//   //                         finalStartTime,
//   //                         finalEndTime,
//   //                         finalRoomNo,
//   //                         finalMaxMarks,
//   //                         finalMinMarks,
//   //                         finalInstructions,
//   //                         context,
//   //                       )
//   //                           .then((_) {
//   //                         if (finalExamId != null &&
//   //                             finalClassId != null &&
//   //                             finalSectionId != null) {
//   //                           ttVm.getTimetable(
//   //                             examId: int.parse(finalExamId),
//   //                             classId: int.parse(finalClassId),
//   //                             sectionId: int.parse(finalSectionId),
//   //                             context: outerCtx,
//   //                           );
//   //                         }
//   //                         setState(() {
//   //                           _viewExamId = finalExamId;
//   //                           _viewClassId = finalClassId;
//   //                           _viewSectionId = finalSectionId;
//   //                         });
//   //                       });
//   //
//   //                       nav.pop();
//   //                     },
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   // void _showTimetableBottomSheet({TimetableData? entry}) {
//   //   final isEdit = entry != null;
//   //
//   //   // ── Pre-fill controllers — sirf woh fields jo TimetableData mein hain ──
//   //   _ttStartTimeCtrl.text       = isEdit ? (entry.startTime ?? '') : '';
//   //   _ttEndTimeCtrl.text         = isEdit ? (entry.endTime   ?? '') : '';
//   //   _ttRoomNoCtrl.text          = ''; // model mein nahi hai
//   //   _ttMaxMarksCtrl.text        = ''; // model mein nahi hai
//   //   _ttMinPassingMarksCtrl.text = ''; // model mein nahi hai
//   //   _ttInstructionsCtrl.text    = ''; // model mein nahi hai
//   //
//   //   _selectedTTDay     = isEdit ? entry.dayOfWeek         : null;
//   //   _addClassId        = isEdit ? entry.classId?.toString(): null;
//   //   _addSectionId      = isEdit ? entry.sectionId?.toString(): null;
//   //   _selectedTeacherId = isEdit ? entry.teacherId?.toString(): null;
//   //   _selectedSubjectId = isEdit ? entry.subjectId?.toString(): null;
//   //
//   //   // ✅ examId — TimetableData mein jo field available ho usse use karo
//   //   // Agar examId nahi hai model mein toh _viewExamId fallback lelo
//   //   String? _sheetExamId = _viewExamId;
//   //
//   //   Provider.of<AllTeachersListVieModel>(context, listen: false)
//   //       .allTeachersListApi(context);
//   //   Provider.of<AllSubjectsVieModel>(context, listen: false)
//   //       .allSubjectsApi(context);
//   //
//   //   // ✅ Edit mode mein class ki sections load karo
//   //   if (isEdit && _addClassId != null) {
//   //     context.read<AllSectionsViewModel>().allSectionsApi(context, _addClassId!);
//   //   }
//   //
//   //   final exams =
//   //       Provider.of<ExamManagementViewModel>(context, listen: false)
//   //           .examManagementModel
//   //           ?.data ??
//   //           [];
//   //
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (_) => StatefulBuilder(
//   //       builder: (ctx, setSheet) => SafeArea(
//   //         child: Container(
//   //           padding: EdgeInsets.only(
//   //             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//   //           ),
//   //           decoration: BoxDecoration(
//   //             color: AppColor.cardWhite,
//   //             borderRadius:
//   //             const BorderRadius.vertical(top: Radius.circular(28)),
//   //           ),
//   //           child: SingleChildScrollView(
//   //             child: Padding(
//   //               padding: const EdgeInsets.all(24),
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   // ── Header ──
//   //                   _sheetHeader(
//   //                     isEdit ? 'Edit Timetable Entry' : 'Add Timetable Entry',
//   //                     isEdit ? Icons.edit_note_rounded : Icons.add_box_outlined,
//   //                     ctx,
//   //                   ),
//   //                   const SizedBox(height: 24),
//   //
//   //                   // ── Edit mode badge ──
//   //                   if (isEdit)
//   //                     Container(
//   //                       margin: const EdgeInsets.only(bottom: 16),
//   //                       padding: const EdgeInsets.symmetric(
//   //                           horizontal: 14, vertical: 10),
//   //                       decoration: BoxDecoration(
//   //                         color: Colors.blue.withOpacity(0.08),
//   //                         borderRadius: BorderRadius.circular(12),
//   //                         border: Border.all(color: Colors.blue.withOpacity(0.25)),
//   //                       ),
//   //                       child: Row(
//   //                         children: [
//   //                           Icon(Icons.info_outline_rounded,
//   //                               color: Colors.blue.shade400, size: 16),
//   //                           const SizedBox(width: 8),
//   //                           Expanded(
//   //                             child: Text(
//   //                               'Editing: ${entry.subjectName ?? ""} — ${entry.dayOfWeek ?? ""}',
//   //                               style: TextStyle(
//   //                                 fontSize: 12,
//   //                                 color: Colors.blue.shade700,
//   //                                 fontWeight: FontWeight.w500,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //
//   //                   // ── EXAM DROPDOWN ──
//   //                   AppText.customText('Select Exam',
//   //                       size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Container(
//   //                     decoration: BoxDecoration(
//   //                       color: AppColor.pageBgColor,
//   //                       borderRadius: BorderRadius.circular(14),
//   //                       border: Border.all(
//   //                         color: _sheetExamId != null
//   //                             ? AppColor.lightBlueColor.withOpacity(0.5)
//   //                             : Colors.transparent,
//   //                         width: 1.5,
//   //                       ),
//   //                     ),
//   //                     child: DropdownButtonFormField<String>(
//   //                       // ✅ Safe value
//   //                       value: exams.any((e) => e.examId.toString() == _sheetExamId)
//   //                           ? _sheetExamId
//   //                           : null,
//   //                       isExpanded: true,
//   //                       icon: Icon(Icons.keyboard_arrow_down_rounded,
//   //                           color: AppColor.lightBlueColor),
//   //                       decoration: InputDecoration(
//   //                         hintText: exams.isEmpty ? 'No exams available' : 'Choose an exam',
//   //                         hintStyle: TextStyle(color: AppColor.softGreyText, fontSize: 13),
//   //                         filled: true,
//   //                         fillColor: Colors.transparent,
//   //                         prefixIcon: Icon(Icons.assignment_rounded,
//   //                             color: AppColor.lightBlueColor, size: 20),
//   //                         border: OutlineInputBorder(
//   //                           borderRadius: BorderRadius.circular(14),
//   //                           borderSide: BorderSide.none,
//   //                         ),
//   //                         contentPadding: const EdgeInsets.symmetric(
//   //                             horizontal: 16, vertical: 14),
//   //                       ),
//   //                       items: exams
//   //                           .map<DropdownMenuItem<String>>((exam) =>
//   //                           DropdownMenuItem<String>(
//   //                             value: exam.examId.toString(),
//   //                             child: Row(
//   //                               children: [
//   //                                 Container(
//   //                                   padding: const EdgeInsets.all(5),
//   //                                   decoration: BoxDecoration(
//   //                                     color: AppColor.lightBlueColor.withOpacity(0.1),
//   //                                     borderRadius: BorderRadius.circular(7),
//   //                                   ),
//   //                                   child: Icon(Icons.assignment_outlined,
//   //                                       color: AppColor.lightBlueColor, size: 15),
//   //                                 ),
//   //                                 const SizedBox(width: 10),
//   //                                 Flexible(
//   //                                   child: Text(
//   //                                     exam.examName ?? 'Exam ${exam.examId}',
//   //                                     overflow: TextOverflow.ellipsis,
//   //                                     style: const TextStyle(
//   //                                         fontSize: 13, fontWeight: FontWeight.w500),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ))
//   //                           .toList(),
//   //                       onChanged: (v) => setSheet(() => _sheetExamId = v),
//   //                     ),
//   //                   ),
//   //
//   //                   if (_sheetExamId != null &&
//   //                       exams.any((e) => e.examId.toString() == _sheetExamId)) ...[
//   //                     const SizedBox(height: 8),
//   //                     Container(
//   //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//   //                       decoration: BoxDecoration(
//   //                         color: Colors.green.withOpacity(0.08),
//   //                         borderRadius: BorderRadius.circular(10),
//   //                         border: Border.all(color: Colors.green.withOpacity(0.25)),
//   //                       ),
//   //                       child: Row(
//   //                         children: [
//   //                           Icon(Icons.check_circle_rounded, color: Colors.green, size: 15),
//   //                           const SizedBox(width: 7),
//   //                           Expanded(
//   //                             child: Text(
//   //                               'Exam: ${exams.firstWhere((e) => e.examId.toString() == _sheetExamId).examName ?? ''}',
//   //                               style: TextStyle(
//   //                                   fontSize: 12,
//   //                                   color: Colors.green.shade700,
//   //                                   fontWeight: FontWeight.w500),
//   //                               overflow: TextOverflow.ellipsis,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   ],
//   //
//   //                   const SizedBox(height: 20),
//   //
//   //                   // ── Day ──
//   //                   AppText.customText('Day', size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   DropdownButtonFormField<String>(
//   //                     // ✅ Safe value
//   //                     value: _days.contains(_selectedTTDay) ? _selectedTTDay : null,
//   //                     decoration: _inputDeco('Select day', Icons.today),
//   //                     items: _days
//   //                         .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//   //                         .toList(),
//   //                     onChanged: (v) => setSheet(() => _selectedTTDay = v),
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Class & Section ──
//   //                   Row(
//   //                     children: [
//   //                       // ── Class ──
//   //                       Flexible(
//   //                         child: Consumer<AllClassesViewModel>(
//   //                           builder: (context, vm, _) {
//   //                             final list = vm.allClassesModel?.data ?? [];
//   //                             // ✅ Safe value
//   //                             final safeClassId = list.any(
//   //                                     (e) => e.classId.toString() == _addClassId)
//   //                                 ? _addClassId
//   //                                 : null;
//   //                             return DropdownButtonFormField<String>(
//   //                               isExpanded: true,
//   //                               value: safeClassId,
//   //                               decoration: _inputDeco('Class', Icons.class_),
//   //                               items: list
//   //                                   .map((e) => DropdownMenuItem(
//   //                                 value: e.classId.toString(),
//   //                                 child: Text(e.className ?? ''),
//   //                               ))
//   //                                   .toList(),
//   //                               onChanged: (v) {
//   //                                 setSheet(() {
//   //                                   _addClassId = v;
//   //                                   _addSectionId = null;
//   //                                 });
//   //                                 if (v != null) {
//   //                                   context
//   //                                       .read<AllSectionsViewModel>()
//   //                                       .allSectionsApi(context, v);
//   //                                 }
//   //                               },
//   //                             );
//   //                           },
//   //                         ),
//   //                       ),
//   //                       const SizedBox(width: 8),
//   //
//   //                       // ── Section ──
//   //                       Flexible(
//   //                         child: Consumer<AllSectionsViewModel>(
//   //                           builder: (context, vm, _) {
//   //                             final list = vm.allSectionsModel?.data ?? [];
//   //                             // ✅ Safe value
//   //                             final safeSectionId = list.any(
//   //                                     (e) => e.sectionId.toString() == _addSectionId)
//   //                                 ? _addSectionId
//   //                                 : null;
//   //                             return DropdownButtonFormField<String>(
//   //                               isExpanded: true,
//   //                               value: safeSectionId,
//   //                               decoration: _inputDeco('Section', Icons.group),
//   //                               items: list
//   //                                   .map((e) => DropdownMenuItem(
//   //                                 value: e.sectionId.toString(),
//   //                                 child: Text(e.sectionName ?? ''),
//   //                               ))
//   //                                   .toList(),
//   //                               onChanged: (v) =>
//   //                                   setSheet(() => _addSectionId = v),
//   //                             );
//   //                           },
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Subject ──
//   //                   AppText.customText('Subject', size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Consumer<AllSubjectsVieModel>(
//   //                     builder: (context, vm, _) {
//   //                       final list = vm.allSubjectsModel?.data ?? [];
//   //                       // ✅ Safe value
//   //                       final safeSubjectId = list.any(
//   //                               (e) => e.subjectId.toString() == _selectedSubjectId)
//   //                           ? _selectedSubjectId
//   //                           : null;
//   //                       return DropdownButtonFormField<String>(
//   //                         isExpanded: true,
//   //                         value: safeSubjectId,
//   //                         decoration: _inputDeco('Select Subject', Icons.book),
//   //                         items: list
//   //                             .map((e) => DropdownMenuItem(
//   //                           value: e.subjectId.toString(),
//   //                           child: Text(e.subjectName ?? ''),
//   //                         ))
//   //                             .toList(),
//   //                         onChanged: (v) => setSheet(() => _selectedSubjectId = v),
//   //                       );
//   //                     },
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Teacher ──
//   //                   AppText.customText('Teacher', size: 14, weight: FontWeight.w600),
//   //                   const SizedBox(height: 8),
//   //                   Consumer<AllTeachersListVieModel>(
//   //                     builder: (context, vm, _) {
//   //                       final list = vm.allTeachersListModel?.data ?? [];
//   //                       // ✅ Safe value
//   //                       final safeTeacherId = list.any(
//   //                               (e) => e.teacherId.toString() == _selectedTeacherId)
//   //                           ? _selectedTeacherId
//   //                           : null;
//   //                       return DropdownButtonFormField<String>(
//   //                         isExpanded: true,
//   //                         value: safeTeacherId,
//   //                         decoration: _inputDeco('Select Teacher', Icons.person),
//   //                         items: list
//   //                             .map((e) => DropdownMenuItem(
//   //                           value: e.teacherId.toString(),
//   //                           child: Text(e.name ?? ''),
//   //                         ))
//   //                             .toList(),
//   //                         onChanged: (v) => setSheet(() => _selectedTeacherId = v),
//   //                       );
//   //                     },
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Start & End Time ──
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: _labeledTimeField(
//   //                             ctx, 'Start Time', _ttStartTimeCtrl, Icons.access_time),
//   //                       ),
//   //                       const SizedBox(width: 12),
//   //                       Expanded(
//   //                         child: _labeledTimeField(
//   //                             ctx, 'End Time', _ttEndTimeCtrl, Icons.access_time_filled),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Room No & Max Marks ──
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: _labeledField(
//   //                             'Room No', _ttRoomNoCtrl, Icons.meeting_room, 'e.g., A-12'),
//   //                       ),
//   //                       const SizedBox(width: 12),
//   //                       Expanded(
//   //                         child: _labeledField(
//   //                             'Max Marks', _ttMaxMarksCtrl, Icons.score, 'e.g., 100',
//   //                             keyboardType: TextInputType.number),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Min Passing Marks ──
//   //                   _labeledField(
//   //                     'Min Passing Marks', _ttMinPassingMarksCtrl,
//   //                     Icons.check_circle_outline, 'e.g., 33',
//   //                     keyboardType: TextInputType.number,
//   //                   ),
//   //                   const SizedBox(height: 16),
//   //
//   //                   // ── Instructions ──
//   //                   _labeledField(
//   //                     'Instructions', _ttInstructionsCtrl,
//   //                     Icons.info_outline, 'e.g., Answer all questions',
//   //                     maxLines: 3,
//   //                   ),
//   //                   const SizedBox(height: 24),
//   //
//   //                   // ── Submit ──
//   //                   _submitButton(
//   //                     label: isEdit ? 'Update Entry' : 'Add Entry',
//   //                     onPressed: () {
//   //                       // ✅ Add mode mein sab required, Edit mein optional
//   //                       if (!isEdit) {
//   //                         if (_sheetExamId == null) {
//   //                           Utils.show('Please select an exam', context);
//   //                           return;
//   //                         }
//   //                         if (_selectedTTDay == null ||
//   //                             _addClassId == null ||
//   //                             _addSectionId == null ||
//   //                             _selectedSubjectId == null ||
//   //                             _selectedTeacherId == null ||
//   //                             _ttStartTimeCtrl.text.trim().isEmpty ||
//   //                             _ttEndTimeCtrl.text.trim().isEmpty) {
//   //                           Utils.show('Please fill all required fields', context);
//   //                           return;
//   //                         }
//   //                       }
//   //
//   //                       final nav = Navigator.of(ctx);
//   //                       final ttVm =
//   //                       Provider.of<TimeTableViewModel>(context, listen: false);
//   //                       final outerCtx = context;
//   //
//   //                       // ✅ Fallback to existing entry values in edit mode
//   //                       final finalExamId = _sheetExamId ?? _viewExamId;
//   //                       final finalClassId =
//   //                           _addClassId ?? entry?.classId?.toString();
//   //                       final finalSectionId =
//   //                           _addSectionId ?? entry?.sectionId?.toString();
//   //                       final finalSubjectId =
//   //                           _selectedSubjectId ?? entry?.subjectId?.toString();
//   //                       final finalTeacherId =
//   //                           _selectedTeacherId ?? entry?.teacherId?.toString();
//   //                       final finalDay = _selectedTTDay ?? entry?.dayOfWeek;
//   //                       final finalStartTime =
//   //                       _ttStartTimeCtrl.text.trim().isNotEmpty
//   //                           ? _ttStartTimeCtrl.text.trim()
//   //                           : (entry?.startTime ?? '');
//   //                       final finalEndTime =
//   //                       _ttEndTimeCtrl.text.trim().isNotEmpty
//   //                           ? _ttEndTimeCtrl.text.trim()
//   //                           : (entry?.endTime ?? '');
//   //
//   //                       // ✅ Null-safe parse karo
//   //                       if (finalClassId == null ||
//   //                           finalSectionId == null ||
//   //                           finalSubjectId == null ||
//   //                           finalTeacherId == null) {
//   //                         Utils.show('Some required fields are missing', context);
//   //                         return;
//   //                       }
//   //
//   //                       final int? classIdInt   = int.tryParse(finalClassId);
//   //                       final int? sectionIdInt = int.tryParse(finalSectionId);
//   //                       final int? subjectIdInt = int.tryParse(finalSubjectId);
//   //                       final int? teacherIdInt = int.tryParse(finalTeacherId);
//   //
//   //                       if (classIdInt == null ||
//   //                           sectionIdInt == null ||
//   //                           subjectIdInt == null ||
//   //                           teacherIdInt == null) {
//   //                         Utils.show('Invalid ID values, please reselect', context);
//   //                         return;
//   //                       }
//   //
//   //                       Provider.of<CreateTimetableViewModel>(context, listen: false)
//   //                           .createExamTimeTableApi(
//   //                         finalExamId,
//   //                         classIdInt,
//   //                         sectionIdInt.toString(),
//   //                         subjectIdInt,
//   //                         teacherIdInt,
//   //                         finalDay,
//   //                         finalStartTime,
//   //                         finalEndTime,
//   //                         _ttRoomNoCtrl.text.trim(),
//   //                         int.tryParse(_ttMaxMarksCtrl.text.trim()),
//   //                         int.tryParse(_ttMinPassingMarksCtrl.text.trim()),
//   //                         _ttInstructionsCtrl.text.trim(),
//   //                         context,
//   //                       )
//   //                           .then((_) {
//   //                         final refreshExamId = finalExamId != null
//   //                             ? int.tryParse(finalExamId)
//   //                             : null;
//   //                         if (refreshExamId != null) {
//   //                           ttVm.getTimetable(
//   //                             examId: refreshExamId,
//   //                             classId: classIdInt,
//   //                             sectionId: sectionIdInt,
//   //                             context: outerCtx,
//   //                           );
//   //                         }
//   //                         setState(() {
//   //                           _viewExamId    = finalExamId;
//   //                           _viewClassId   = finalClassId;
//   //                           _viewSectionId = finalSectionId;
//   //                         });
//   //                       });
//   //
//   //                       nav.pop();
//   //                     },
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   // ════════════════════════════════════════════════════════
// // CLASS LEVEL PAR YAAR CONTROLLER ADD KARO (dispose mein bhi)
// // ════════════════════════════════════════════════════════
// //    // ← add karo
// // dispose() mein: _ttExamDateCtrl.dispose();         // ← add karo
//
//   void _showTimetableBottomSheet({TimetableData? entry}) {
//     final isEdit = entry != null;
//
//     // ── Pre-fill controllers ──
//     _ttStartTimeCtrl.text       = isEdit ? (entry.startTime ?? '') : '';
//     _ttEndTimeCtrl.text         = isEdit ? (entry.endTime   ?? '') : '';
//     _ttExamDateCtrl.text        = ''; // exam date — fresh fill karo
//     _ttRoomNoCtrl.text          = '';
//     _ttMaxMarksCtrl.text        = '';
//     _ttMinPassingMarksCtrl.text = '';
//     _ttInstructionsCtrl.text    = '';
//
//     _selectedTTDay     = isEdit ? entry.dayOfWeek          : null;
//     _addClassId        = isEdit ? entry.classId?.toString() : null;
//     _addSectionId      = isEdit ? entry.sectionId?.toString(): null;
//     _selectedTeacherId = isEdit ? entry.teacherId?.toString(): null;
//     _selectedSubjectId = isEdit ? entry.subjectId?.toString(): null;
//
//     String? _sheetExamId = _viewExamId;
//
//     Provider.of<AllTeachersListVieModel>(context, listen: false)
//         .allTeachersListApi(context);
//     Provider.of<AllSubjectsVieModel>(context, listen: false)
//         .allSubjectsApi(context);
//
//     if (isEdit && _addClassId != null) {
//       context.read<AllSectionsViewModel>().allSectionsApi(context, _addClassId!);
//     }
//
//     final exams =
//         Provider.of<ExamManagementViewModel>(context, listen: false)
//             .examManagementModel
//             ?.data ??
//             [];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, setSheet) => SafeArea(
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(ctx).viewInsets.bottom,
//             ),
//             decoration: BoxDecoration(
//               color: AppColor.cardWhite,
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Header ──
//                     _sheetHeader(
//                       isEdit ? 'Edit Timetable Entry' : 'Add Timetable Entry',
//                       isEdit ? Icons.edit_note_rounded : Icons.add_box_outlined,
//                       ctx,
//                     ),
//                     const SizedBox(height: 24),
//
//                     // ── Edit badge ──
//                     if (isEdit)
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.blue.withOpacity(0.25)),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.info_outline_rounded,
//                                 color: Colors.blue.shade400, size: 16),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Editing: ${entry.subjectName ?? ""} — ${entry.dayOfWeek ?? ""}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.blue.shade700,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     // ── EXAM DROPDOWN ──
//                     AppText.customText('Select Exam',
//                         size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: AppColor.pageBgColor,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: _sheetExamId != null
//                               ? AppColor.lightBlueColor.withOpacity(0.5)
//                               : Colors.transparent,
//                           width: 1.5,
//                         ),
//                       ),
//                       child: DropdownButtonFormField<String>(
//                         value: exams.any((e) => e.examId.toString() == _sheetExamId)
//                             ? _sheetExamId
//                             : null,
//                         isExpanded: true,
//                         icon: Icon(Icons.keyboard_arrow_down_rounded,
//                             color: AppColor.lightBlueColor),
//                         decoration: InputDecoration(
//                           hintText: exams.isEmpty ? 'No exams available' : 'Choose an exam',
//                           hintStyle:
//                           TextStyle(color: AppColor.softGreyText, fontSize: 13),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           prefixIcon: Icon(Icons.assignment_rounded,
//                               color: AppColor.lightBlueColor, size: 20),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 14),
//                         ),
//                         items: exams
//                             .map<DropdownMenuItem<String>>((exam) =>
//                             DropdownMenuItem<String>(
//                               value: exam.examId.toString(),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.lightBlueColor
//                                           .withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(7),
//                                     ),
//                                     child: Icon(Icons.assignment_outlined,
//                                         color: AppColor.lightBlueColor, size: 15),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Flexible(
//                                     child: Text(
//                                       exam.examName ?? 'Exam ${exam.examId}',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ))
//                             .toList(),
//                         onChanged: (v) => setSheet(() => _sheetExamId = v),
//                       ),
//                     ),
//
//                     if (_sheetExamId != null &&
//                         exams.any((e) => e.examId.toString() == _sheetExamId)) ...[
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 7),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.green.withOpacity(0.25)),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.check_circle_rounded,
//                                 color: Colors.green, size: 15),
//                             const SizedBox(width: 7),
//                             Expanded(
//                               child: Text(
//                                 'Exam: ${exams.firstWhere((e) => e.examId.toString() == _sheetExamId).examName ?? ''}',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.green.shade700,
//                                     fontWeight: FontWeight.w500),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//
//                     const SizedBox(height: 20),
//
//                     // ── Day ──
//                     AppText.customText('Day', size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       value: _days.contains(_selectedTTDay) ? _selectedTTDay : null,
//                       decoration: _inputDeco('Select day', Icons.today),
//                       items: _days
//                           .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//                           .toList(),
//                       onChanged: (v) => setSheet(() => _selectedTTDay = v),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── ✅ EXAM DATE ──────────────────────────────────────────
//                     AppText.customText('Exam Date', size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: _ttExamDateCtrl,
//                       readOnly: true,
//                       decoration: _inputDeco('Select exam date', Icons.calendar_today),
//                       onTap: () async {
//                         final picked = await showDatePicker(
//                           context: ctx,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime(2035),
//                           builder: (c, child) => Theme(
//                             data: Theme.of(c).copyWith(
//                               colorScheme: ColorScheme.light(
//                                   primary: AppColor.lightBlueColor),
//                             ),
//                             child: child!,
//                           ),
//                         );
//                         if (picked != null) {
//                           setSheet(() {
//                             _ttExamDateCtrl.text =
//                             '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Class & Section ──
//                     Row(
//                       children: [
//                         // ── Class ──
//                         Flexible(
//                           child: Consumer<AllClassesViewModel>(
//                             builder: (context, vm, _) {
//                               final list = vm.allClassesModel?.data ?? [];
//                               final safeClassId = list.any(
//                                       (e) => e.classId.toString() == _addClassId)
//                                   ? _addClassId
//                                   : null;
//                               return DropdownButtonFormField<String>(
//                                 isExpanded: true,
//                                 value: safeClassId,
//                                 decoration: _inputDeco('Class', Icons.class_),
//                                 items: list
//                                     .map((e) => DropdownMenuItem(
//                                   value: e.classId.toString(),
//                                   child: Text(e.className ?? ''),
//                                 ))
//                                     .toList(),
//                                 onChanged: (v) {
//                                   setSheet(() {
//                                     _addClassId = v;
//                                     _addSectionId = null;
//                                   });
//                                   if (v != null) {
//                                     context
//                                         .read<AllSectionsViewModel>()
//                                         .allSectionsApi(context, v);
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//
//                         // ── Section ──
//                         Flexible(
//                           child: Consumer<AllSectionsViewModel>(
//                             builder: (context, vm, _) {
//                               final list = vm.allSectionsModel?.data ?? [];
//                               final safeSectionId = list.any(
//                                       (e) => e.sectionId.toString() == _addSectionId)
//                                   ? _addSectionId
//                                   : null;
//                               return DropdownButtonFormField<String>(
//                                 isExpanded: true,
//                                 value: safeSectionId,
//                                 decoration: _inputDeco('Section', Icons.group),
//                                 items: list
//                                     .map((e) => DropdownMenuItem(
//                                   value: e.sectionId.toString(),
//                                   child: Text(e.sectionName ?? ''),
//                                 ))
//                                     .toList(),
//                                 onChanged: (v) =>
//                                     setSheet(() => _addSectionId = v),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Subject ──
//                     AppText.customText('Subject', size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     Consumer<AllSubjectsVieModel>(
//                       builder: (context, vm, _) {
//                         final list = vm.allSubjectsModel?.data ?? [];
//                         final safeSubjectId = list.any(
//                                 (e) => e.subjectId.toString() == _selectedSubjectId)
//                             ? _selectedSubjectId
//                             : null;
//                         return DropdownButtonFormField<String>(
//                           isExpanded: true,
//                           value: safeSubjectId,
//                           decoration: _inputDeco('Select Subject', Icons.book),
//                           items: list
//                               .map((e) => DropdownMenuItem(
//                             value: e.subjectId.toString(),
//                             child: Text(e.subjectName ?? ''),
//                           ))
//                               .toList(),
//                           onChanged: (v) =>
//                               setSheet(() => _selectedSubjectId = v),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Teacher ──
//                     AppText.customText('Teacher', size: 14, weight: FontWeight.w600),
//                     const SizedBox(height: 8),
//                     Consumer<AllTeachersListVieModel>(
//                       builder: (context, vm, _) {
//                         final list = vm.allTeachersListModel?.data ?? [];
//                         final safeTeacherId = list.any(
//                                 (e) => e.teacherId.toString() == _selectedTeacherId)
//                             ? _selectedTeacherId
//                             : null;
//                         return DropdownButtonFormField<String>(
//                           isExpanded: true,
//                           value: safeTeacherId,
//                           decoration: _inputDeco('Select Teacher', Icons.person),
//                           items: list
//                               .map((e) => DropdownMenuItem(
//                             value: e.teacherId.toString(),
//                             child: Text(e.name ?? ''),
//                           ))
//                               .toList(),
//                           onChanged: (v) =>
//                               setSheet(() => _selectedTeacherId = v),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Start & End Time ──
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _labeledTimeField(ctx, 'Start Time',
//                               _ttStartTimeCtrl, Icons.access_time),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _labeledTimeField(ctx, 'End Time',
//                               _ttEndTimeCtrl, Icons.access_time_filled),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Room No & Max Marks ──
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _labeledField('Room No', _ttRoomNoCtrl,
//                               Icons.meeting_room, 'e.g., A-12'),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _labeledField(
//                               'Max Marks', _ttMaxMarksCtrl, Icons.score, 'e.g., 100',
//                               keyboardType: TextInputType.number),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Min Passing Marks ──
//                     _labeledField(
//                       'Min Passing Marks', _ttMinPassingMarksCtrl,
//                       Icons.check_circle_outline, 'e.g., 33',
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 16),
//
//                     // ── Instructions ──
//                     _labeledField(
//                       'Instructions', _ttInstructionsCtrl,
//                       Icons.info_outline, 'e.g., Answer all questions',
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 24),
//
//                     // ── Submit ──
//                     _submitButton(
//                       label: isEdit ? 'Update Entry' : 'Add Entry',
//                       // ── Submit button ka onPressed — exam screen mein replace karo ──
//                       onPressed: () {
//                         if (!isEdit) {
//                           if (_sheetExamId == null) {
//                             Utils.show('Please select an exam', context);
//                             return;
//                           }
//                           if (_ttExamDateCtrl.text.trim().isEmpty) {
//                             Utils.show('Please select exam date', context);
//                             return;
//                           }
//                           if (_addClassId == null ||
//                               _addSectionId == null ||
//                               _selectedSubjectId == null ||
//                               _ttStartTimeCtrl.text.trim().isEmpty ||
//                               _ttEndTimeCtrl.text.trim().isEmpty) {
//                             Utils.show('Please fill all required fields', context);
//                             return;
//                           }
//                         }
//
//                         final nav      = Navigator.of(ctx);
//                         final ttVm     = Provider.of<TimeTableViewModel>(context, listen: false);
//                         final outerCtx = context;
//
//                         final finalExamId    = _sheetExamId ?? _viewExamId;
//                         final finalClassId   = _addClassId  ?? entry?.classId?.toString();
//                         final finalSectionId = _addSectionId ?? entry?.sectionId?.toString();
//                         final finalSubjectId = _selectedSubjectId ?? entry?.subjectId?.toString();
//                         final finalStartTime = _ttStartTimeCtrl.text.trim().isNotEmpty
//                             ? _ttStartTimeCtrl.text.trim()
//                             : (entry?.startTime ?? '');
//                         final finalEndTime = _ttEndTimeCtrl.text.trim().isNotEmpty
//                             ? _ttEndTimeCtrl.text.trim()
//                             : (entry?.endTime ?? '');
//                         final finalExamDate = _ttExamDateCtrl.text.trim();
//
//                         if (finalExamId == null || finalClassId == null ||
//                             finalSectionId == null || finalSubjectId == null) {
//                           Utils.show('Some required fields are missing', context);
//                           return;
//                         }
//
//                         final int? examIdInt    = int.tryParse(finalExamId);
//                         final int? classIdInt   = int.tryParse(finalClassId);
//                         final int? sectionIdInt = int.tryParse(finalSectionId);
//                         final int? subjectIdInt = int.tryParse(finalSubjectId);
//
//                         if (examIdInt == null || classIdInt == null ||
//                             sectionIdInt == null || subjectIdInt == null) {
//                           Utils.show('Invalid ID values, please reselect', context);
//                           return;
//                         }
//
//                         // ✅ Sahi order — ViewModel ke signature se match karta hai
//                         Provider.of<CreateTimetableViewModel>(context, listen: false)
//                             .createExamTimeTableApi(
//                           examIdInt,                                       // int examId
//                           classIdInt,                                      // int classId
//                           sectionIdInt.toString(),                         // String sectionId
//                           subjectIdInt,                                    // int subjectId
//                           finalExamDate,                                   // String examDate ✅
//                           finalStartTime,                                  // String startTime
//                           finalEndTime,                                    // String endTime
//                           _ttRoomNoCtrl.text.trim(),                       // String roomNo
//                           int.tryParse(_ttMaxMarksCtrl.text.trim()),        // int? maxMarks
//                           int.tryParse(_ttMinPassingMarksCtrl.text.trim()), // int? minPassingMarks
//                           _ttInstructionsCtrl.text.trim(),                 // String instructions
//                           context,
//                         ).then((_) {
//                           if (examIdInt != null) {
//                             ttVm.getTimetable(
//                               examId:    examIdInt,
//                               classId:   classIdInt,
//                               sectionId: sectionIdInt,
//                               context:   outerCtx,
//                             );
//                           }
//                           setState(() {
//                             _viewExamId    = finalExamId;
//                             _viewClassId   = finalClassId;
//                             _viewSectionId = finalSectionId;
//                           });
//                         });
//
//                         nav.pop();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.pageBgColor,
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColor.lightBlueColor,
//         onPressed: () => _tabController.index == 0
//             ? _showExamBottomSheet()
//             : _showTimetableBottomSheet(),
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: AnimatedBuilder(
//           animation: _tabController,
//           builder: (_, __) => Text(
//             _tabController.index == 0 ? 'Add Exam' : 'Add Timetable',
//             style: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: Consumer2<ExamManagementViewModel, TimeTableViewModel>(
//         builder: (context, examVm, ttVm, _) {
//           final exams = examVm.examManagementModel?.data ?? [];
//           return Column(
//             children: [
//               _buildHeader(exams),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildExamsTab(examVm, exams),
//                     _buildTimetableTab(ttVm, exams),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // ─── HEADER ──────────────────────────────────
//
//   Widget _buildHeader(List exams) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
//       decoration: BoxDecoration(
//         gradient: AppColor.primaryGradient,
//         borderRadius:
//         const BorderRadius.vertical(bottom: Radius.circular(28)),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.blueShadow,
//               blurRadius: 18,
//               offset: const Offset(0, 10)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               InkWell(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: AppColor.glassWhite,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.arrow_back_ios_new_rounded,
//                       size: 18, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: AppText.customText('Exam Management',
//                     size: 20,
//                     weight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: AppColor.glassWhite,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: AppText.customText(
//                   exams.length.toString(),
//                   size: 15,
//                   weight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               _statCard('Total', exams.length.toString(),
//                   Icons.assignment, Colors.purple),
//               const SizedBox(width: 10),
//               _statCard(
//                   'Scheduled',
//                   exams
//                       .where((e) => e.status == 'scheduled')
//                       .length
//                       .toString(),
//                   Icons.schedule,
//                   Colors.blue),
//               const SizedBox(width: 10),
//               _statCard(
//                   'Cancelled',
//                   exams
//                       .where((e) => e.status == 'cancelled')
//                       .length
//                       .toString(),
//                   Icons.cancel,
//                   Colors.red),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             decoration: BoxDecoration(
//               color: AppColor.glassWhite,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelColor: AppColor.lightBlueColor,
//               unselectedLabelColor: Colors.white,
//               labelStyle: const TextStyle(
//                   fontWeight: FontWeight.bold, fontSize: 13),
//               dividerColor: Colors.transparent,
//               padding: const EdgeInsets.all(4),
//               tabs: const [
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.assignment, size: 16),
//                       SizedBox(width: 6),
//                       Text('Exams'),
//                     ],
//                   ),
//                 ),
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.table_chart, size: 16),
//                       SizedBox(width: 6),
//                       Text('Timetable'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   // ─── TAB 1: EXAMS ────────────────────────────
//
//   Widget _buildExamsTab(ExamManagementViewModel vm, List exams) {
//     if (vm.loading) return _shimmer();
//     if (exams.isEmpty) {
//       return _emptyView('No Exams Found',
//           'Tap + to add your first exam', Icons.assignment);
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
//       itemCount: exams.length,
//       itemBuilder: (_, i) => _animated(i, _examCard(exams[i])),
//     );
//   }
//
//   Widget _examCard(dynamic exam) {
//     final sc = _statusColor(exam.status);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: AppColor.cardWhite,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 10,
//               offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     gradient: AppColor.primaryGradient,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const Icon(Icons.assignment,
//                       color: Colors.white, size: 28),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(exam.examName ?? 'N/A',
//                           size: 16, weight: FontWeight.bold),
//                       const SizedBox(height: 4),
//                       _iconRow(Icons.calendar_today,
//                           _formatDate(exam.startDate)),
//                       const SizedBox(height: 2),
//                       _iconRow(
//                           Icons.school, exam.typeName ?? 'N/A'),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: sc.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: AppText.customText(
//                           (exam.status ?? 'N/A').toUpperCase(),
//                           size: 10,
//                           weight: FontWeight.bold,
//                           color: sc,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuButton(
//                   icon: const Icon(Icons.more_vert),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   itemBuilder: (_) => [
//                     PopupMenuItem(
//                       onTap: () => Future.delayed(Duration.zero,
//                               () => _showExamBottomSheet(exam: exam)),
//                       child: _menuRow(
//                           Icons.edit, 'Edit', Colors.blue),
//                     ),
//                     PopupMenuItem(
//                       onTap: () => Future.delayed(Duration.zero,
//                               () => _showDeleteExamDialog(exam)),
//                       child: _menuRow(
//                           Icons.delete, 'Delete', Colors.red),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Divider(height: 1, color: Colors.grey.shade200),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _chip(Icons.calendar_month,
//                     'Year: ${exam.academicYear ?? 'N/A'}'),
//                 _chip(Icons.event_available,
//                     'Result: ${_formatDate(exam.resultDate)}'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── TAB 2: TIMETABLE ────────────────────────
//
//   Widget _buildTimetableTab(TimeTableViewModel ttVm, List exams) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildExamDropdown(exams),
//           if (_viewExamId != null) _buildClassSectionFilterRow(),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 34,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               children: ['All', ..._days].map(_dayChip).toList(),
//             ),
//           ),
//           const SizedBox(height: 8),
//           if (_viewExamId == null)
//             _emptyView('Select an Exam',
//                 'Choose an exam above to view its timetable',
//                 Icons.assignment_outlined)
//           else if (_viewClassId == null || _viewSectionId == null)
//             _emptyView('Select Class & Section',
//                 'Choose class and section to load timetable',
//                 Icons.filter_list)
//           else if (ttVm.loading)
//               _shimmer()
//             else if (ttVm.filterByDay(_filterDay).isEmpty)
//                 _emptyView('No Timetable Entries',
//                     'Tap + to add a timetable entry', Icons.table_chart)
//               else
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
//                   itemCount: ttVm.filterByDay(_filterDay).length,
//                   itemBuilder: (_, i) => _animated(
//                       i,
//                       _timetableCard(
//                           ttVm.filterByDay(_filterDay)[i])),
//                 ),
//           SizedBox(height: screenHeight * 0.03),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExamDropdown(List exams) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//       decoration: BoxDecoration(
//         color: AppColor.cardWhite,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 12,
//               offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               gradient: AppColor.primaryGradient,
//               borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.assignment_rounded,
//                       color: Colors.white, size: 18),
//                 ),
//                 const SizedBox(width: 10),
//                 AppText.customText('Select Exam',
//                     size: 14,
//                     weight: FontWeight.bold,
//                     color: Colors.white),
//                 const Spacer(),
//                 if (_viewExamId != null)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.25),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: AppText.customText('Selected ✓',
//                         size: 11,
//                         weight: FontWeight.w600,
//                         color: Colors.white),
//                   ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: DropdownButtonFormField<String>(
//               value: _viewExamId,
//               isExpanded: true,
//               icon: Icon(Icons.keyboard_arrow_down_rounded,
//                   color: AppColor.lightBlueColor),
//               decoration: InputDecoration(
//                 hintText: 'Choose an exam to view timetable',
//                 hintStyle: TextStyle(
//                     color: AppColor.softGreyText, fontSize: 13),
//                 filled: true,
//                 fillColor: AppColor.pageBgColor,
//                 prefixIcon: Icon(Icons.search_rounded,
//                     color: AppColor.lightBlueColor),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 14),
//               ),
//               items: exams.map((exam) {
//                 return DropdownMenuItem<String>(
//                   value: exam.examId.toString(),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: AppColor.lightBlueColor
//                               .withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.assignment_outlined,
//                             color: AppColor.lightBlueColor,
//                             size: 16),
//                       ),
//                       const SizedBox(width: 10),
//                       Flexible(
//                         child: Text(
//                           exam.examName ?? 'Exam ${exam.examId}',
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (v) {
//                 setState(() {
//                   _viewExamId = v;
//                   _viewClassId = null;
//                   _viewSectionId = null;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClassSectionFilterRow() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
//       decoration: BoxDecoration(
//         color: AppColor.cardWhite,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 12,
//               offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: AppColor.lightBlueColor.withOpacity(0.08),
//               borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20)),
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppColor.lightBlueColor.withOpacity(0.15),
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.filter_alt_rounded,
//                     color: AppColor.lightBlueColor, size: 18),
//                 const SizedBox(width: 8),
//                 AppText.customText('Filter by Class & Section',
//                     size: 13,
//                     weight: FontWeight.w600,
//                     color: AppColor.lightBlueColor),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Consumer<AllClassesViewModel>(
//                     builder: (context, vm, _) {
//                       final list = vm.allClassesModel?.data ?? [];
//                       // ✅ Safe value
//                       final safeViewClassId = list.any(
//                               (e) => e.classId.toString() == _viewClassId)
//                           ? _viewClassId
//                           : null;
//                       return Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.class_rounded,
//                                   size: 13,
//                                   color: AppColor.lightBlueColor),
//                               const SizedBox(width: 4),
//                               AppText.customText('Class',
//                                   size: 12,
//                                   weight: FontWeight.w600,
//                                   color: AppColor.lightBlueColor),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           DropdownButtonFormField<String>(
//                             value: safeViewClassId,
//                             isExpanded: true,
//                             icon: Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: AppColor.lightBlueColor,
//                                 size: 20),
//                             decoration: InputDecoration(
//                               hintText: 'Select',
//                               hintStyle: TextStyle(
//                                   color: AppColor.softGreyText,
//                                   fontSize: 12),
//                               filled: true,
//                               fillColor: AppColor.pageBgColor,
//                               prefixIcon: Icon(Icons.class_outlined,
//                                   color: AppColor.lightBlueColor,
//                                   size: 18),
//                               border: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(14),
//                                 borderSide: BorderSide.none,
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(14),
//                                 borderSide: BorderSide(
//                                   color: _viewClassId != null
//                                       ? AppColor.lightBlueColor
//                                       .withOpacity(0.4)
//                                       : Colors.transparent,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               contentPadding:
//                               const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 12),
//                             ),
//                             items: list
//                                 .map((e) => DropdownMenuItem(
//                               value: e.classId.toString(),
//                               child: Text(
//                                   e.className ?? '',
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight:
//                                       FontWeight.w500)),
//                             ))
//                                 .toList(),
//                             onChanged: (v) {
//                               setState(() {
//                                 _viewClassId = v;
//                                 _viewSectionId = null;
//                               });
//                               if (v != null) {
//                                 context
//                                     .read<AllSectionsViewModel>()
//                                     .allSectionsApi(context, v);
//                               }
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 22, left: 8, right: 8),
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color:
//                       AppColor.lightBlueColor.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.arrow_forward_rounded,
//                         size: 14,
//                         color: AppColor.lightBlueColor),
//                   ),
//                 ),
//                 Expanded(
//                   child: Consumer<AllSectionsViewModel>(
//                     builder: (context, vm, _) {
//                       final list = vm.allSectionsModel?.data ?? [];
//                       // ✅ Safe value — items mein exist karna chahiye
//                       final safeViewSectionId = list.any(
//                               (e) => e.sectionId.toString() == _viewSectionId)
//                           ? _viewSectionId
//                           : null;
//                       return Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.group_rounded,
//                                   size: 13,
//                                   color: AppColor.lightBlueColor),
//                               const SizedBox(width: 4),
//                               AppText.customText('Section',
//                                   size: 12,
//                                   weight: FontWeight.w600,
//                                   color: AppColor.lightBlueColor),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           DropdownButtonFormField<String>(
//                             value: safeViewSectionId,
//                             isExpanded: true,
//                             icon: Icon(
//                               Icons.keyboard_arrow_down_rounded,
//                               color: _viewClassId != null
//                                   ? AppColor.lightBlueColor
//                                   : AppColor.softGreyText,
//                               size: 20,
//                             ),
//                             decoration: InputDecoration(
//                               hintText: _viewClassId == null
//                                   ? 'Pick class first'
//                                   : 'Select',
//                               hintStyle: TextStyle(
//                                   color: AppColor.softGreyText,
//                                   fontSize: 12),
//                               filled: true,
//                               fillColor: _viewClassId == null
//                                   ? AppColor.pageBgColor
//                                   .withOpacity(0.5)
//                                   : AppColor.pageBgColor,
//                               prefixIcon: Icon(
//                                   Icons.group_outlined,
//                                   color: _viewClassId != null
//                                       ? AppColor.lightBlueColor
//                                       : AppColor.softGreyText,
//                                   size: 18),
//                               border: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(14),
//                                 borderSide: BorderSide.none,
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(14),
//                                 borderSide: BorderSide(
//                                   color: _viewSectionId != null
//                                       ? AppColor.lightBlueColor
//                                       .withOpacity(0.4)
//                                       : Colors.transparent,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               contentPadding:
//                               const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 12),
//                             ),
//                             items: list
//                                 .map((e) => DropdownMenuItem(
//                               value:
//                               e.sectionId.toString(),
//                               child: Text(
//                                   e.sectionName ?? '',
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight:
//                                       FontWeight.w500)),
//                             ))
//                                 .toList(),
//                             onChanged: _viewClassId == null
//                                 ? null
//                                 : (v) {
//                               setState(() =>
//                               _viewSectionId = v);
//                               if (_viewExamId != null &&
//                                   _viewClassId != null &&
//                                   v != null) {
//                                 Provider.of<TimeTableViewModel>(
//                                     context, listen: false)
//                                     .getTimetable(
//                                   examId: int.parse(
//                                       _viewExamId!),
//                                   classId: int.parse(
//                                       _viewClassId!),
//                                   sectionId: int.parse(v),
//                                   context: context,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_viewClassId != null && _viewSectionId != null)
//             Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.08),
//                 borderRadius: const BorderRadius.vertical(
//                     bottom: Radius.circular(20)),
//                 border: Border(
//                   top: BorderSide(
//                       color: Colors.green.withOpacity(0.2),
//                       width: 1),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.check_circle_rounded,
//                       color: Colors.green, size: 16),
//                   const SizedBox(width: 6),
//                   AppText.customText(
//                     'Loading timetable for selected class & section…',
//                     size: 11,
//                     color: Colors.green.shade700,
//                     weight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Timetable card — edit button now passes entry data
//   Widget _timetableCard(TimetableData e) {
//     final dc = _dayColor(e.dayOfWeek);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: AppColor.cardWhite,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: AppColor.cardShadow,
//               blurRadius: 10,
//               offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: dc.withOpacity(0.1),
//               borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: dc,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     e.dayOfWeek ?? 'N/A',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12),
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.access_time, size: 14, color: dc),
//                 const SizedBox(width: 4),
//                 Text(
//                   '${_formatTime(e.startTime)} – ${_formatTime(e.endTime)}',
//                   style: TextStyle(
//                       color: dc,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     gradient: AppColor.primaryGradient,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.menu_book,
//                       color: Colors.white, size: 26),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(e.subjectName ?? 'N/A',
//                           size: 15, weight: FontWeight.bold),
//                       const SizedBox(height: 4),
//                       _iconRow(Icons.class_,
//                           '${e.className ?? 'N/A'} – ${e.sectionName ?? 'N/A'}'),
//                       const SizedBox(height: 2),
//                       _iconRow(
//                           Icons.person, e.teacherName ?? 'N/A'),
//                     ],
//                   ),
//                 ),
//                 PopupMenuButton(
//                   icon: const Icon(Icons.more_vert),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   itemBuilder: (_) => [
//                     // ✅ Entry data pass kar raha hai
//                     PopupMenuItem(
//                       onTap: () => Future.delayed(
//                         Duration.zero,
//                             () => _showTimetableBottomSheet(entry: e),
//                       ),
//                       child: _menuRow(
//                           Icons.edit, 'Edit', Colors.blue),
//                     ),
//                     PopupMenuItem(
//                       onTap: () => Future.delayed(
//                         Duration.zero,
//                             () => _showDeleteTimetableDialog(e),
//                       ),
//                       child: _menuRow(
//                           Icons.delete, 'Delete', Colors.red),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── REUSABLE WIDGETS ─────────────────────────
//
//   Widget _statCard(
//       String label, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
//         decoration: BoxDecoration(
//           color: AppColor.glassWhite,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(height: 5),
//             AppText.customText(value,
//                 size: 17,
//                 weight: FontWeight.bold,
//                 color: Colors.white),
//             AppText.customText(label, size: 10, color: Colors.white70),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _dayChip(String day) {
//     final sel = _filterDay == day;
//     return GestureDetector(
//       onTap: () => setState(() => _filterDay = day),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(right: 8),
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: sel ? AppColor.primaryGradient : null,
//           color: sel ? null : AppColor.cardWhite,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColor.cardShadow,
//                 blurRadius: 4,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Text(
//           day,
//           style: TextStyle(
//             color: sel ? Colors.white : AppColor.softGreyText,
//             fontWeight: sel ? FontWeight.bold : FontWeight.normal,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _iconRow(IconData icon, String label) {
//     return Row(
//       children: [
//         Icon(icon, size: 13, color: AppColor.softGreyText),
//         const SizedBox(width: 4),
//         Flexible(
//           child: AppText.customText(label,
//               size: 12, color: AppColor.softGreyText),
//         ),
//       ],
//     );
//   }
//
//   Widget _chip(IconData icon, String label) {
//     return Row(
//       children: [
//         Icon(icon, size: 15, color: AppColor.lightBlueColor),
//         const SizedBox(width: 5),
//         AppText.customText(label,
//             size: 11, color: AppColor.softGreyText),
//       ],
//     );
//   }
//
//   Widget _menuRow(IconData icon, String label, Color color) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: color),
//         const SizedBox(width: 8),
//         Text(label),
//       ],
//     );
//   }
//
//   Widget _emptyView(String title, String sub, IconData icon) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon,
//               size: 80,
//               color: AppColor.lightBlueColor.withOpacity(0.4)),
//           const SizedBox(height: 16),
//           AppText.customText(title,
//               size: 18, weight: FontWeight.bold),
//           const SizedBox(height: 8),
//           AppText.customText(sub,
//               size: 14, color: AppColor.softGreyText),
//         ],
//       ),
//     );
//   }
//
//   Widget _shimmer() {
//     return ListView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
//       itemCount: 5,
//       itemBuilder: (_, __) => Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           height: 140,
//           margin: const EdgeInsets.only(bottom: 14),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _animated(int i, Widget child) {
//     return AnimatedBuilder(
//       animation: _animController,
//       builder: (_, c) {
//         final delay = (i * 0.08).clamp(0.0, 0.9);
//         final raw =
//             (_animController.value - delay) / (1.0 - delay);
//         final val =
//         Curves.easeOut.transform(raw.clamp(0.0, 1.0));
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - val)),
//           child: Opacity(opacity: val, child: c),
//         );
//       },
//       child: child,
//     );
//   }
//
//   // ─── INPUT HELPERS ────────────────────────────
//
//   InputDecoration _inputDeco(String hint, IconData icon) =>
//       InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: AppColor.softGreyText),
//         filled: true,
//         fillColor: AppColor.pageBgColor,
//         prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16, vertical: 14),
//       );
//
//   Widget _sheetHeader(
//       String title, IconData icon, BuildContext ctx) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             gradient: AppColor.primaryGradient,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: Colors.white, size: 24),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: AppText.customText(title,
//               size: 18, weight: FontWeight.bold),
//         ),
//         IconButton(
//           onPressed: () => Navigator.pop(ctx),
//           icon: const Icon(Icons.close),
//         ),
//       ],
//     );
//   }
//
//   Widget _labeledField(
//       String label,
//       TextEditingController ctrl,
//       IconData icon,
//       String hint, {
//         TextInputType keyboardType = TextInputType.text,
//         int maxLines = 1,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText.customText(label, size: 14, weight: FontWeight.w600),
//         const SizedBox(height: 8),
//         TextField(
//           controller: ctrl,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           decoration: _inputDeco(hint, icon),
//         ),
//       ],
//     );
//   }
//
//   Widget _labeledDateField(
//       BuildContext ctx,
//       String label,
//       TextEditingController ctrl,
//       IconData icon,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText.customText(label, size: 14, weight: FontWeight.w600),
//         const SizedBox(height: 8),
//         TextField(
//           controller: ctrl,
//           readOnly: true,
//           decoration: _inputDeco('Select date', icon),
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: ctx,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2020),
//               lastDate: DateTime(2035),
//               builder: (c, child) => Theme(
//                 data: Theme.of(c).copyWith(
//                   colorScheme: ColorScheme.light(
//                       primary: AppColor.lightBlueColor),
//                 ),
//                 child: child!,
//               ),
//             );
//             if (picked != null)
//               ctrl.text = DateFormat('yyyy-MM-dd').format(picked);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _labeledTimeField(
//       BuildContext ctx,
//       String label,
//       TextEditingController ctrl,
//       IconData icon,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText.customText(label, size: 14, weight: FontWeight.w600),
//         const SizedBox(height: 8),
//         TextField(
//           controller: ctrl,
//           readOnly: true,
//           decoration: _inputDeco('Select time', icon),
//           onTap: () async {
//             final picked = await showTimePicker(
//               context: ctx,
//               initialTime: TimeOfDay.now(),
//               builder: (c, child) => Theme(
//                 data: Theme.of(c).copyWith(
//                   colorScheme: ColorScheme.light(
//                       primary: AppColor.lightBlueColor),
//                 ),
//                 child: child!,
//               ),
//             );
//             if (picked != null) ctrl.text = picked.format(ctx);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _submitButton({
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColor.lightBlueColor,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           elevation: 0,
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.white),
//         ),
//       ),
//     );
//   }
// }