
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import '../repo/school_repo/all_sections_repo.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../view_model/school_view_model/all_classes_view_model.dart';
import '../view_model/school_view_model/Exam_management_view_model.dart';
import '../view_model/school_view_model/generate_admit_card_view_model.dart';
import 'marksheet/admit_card_pdf_service.dart';
import 'marksheet/generate_id_card_service.dart';

class SchoolAdmitCardScreen extends StatefulWidget {
  const SchoolAdmitCardScreen({super.key});

  @override
  State<SchoolAdmitCardScreen> createState() => _SchoolAdmitCardScreenState();
}

class _SchoolAdmitCardScreenState extends State<SchoolAdmitCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText.customText(
                      'Admit & ID Card',
                      size: 20,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.picture_as_pdf_rounded, size: 18),
                      text: 'Admit Card',
                    ),
                    Tab(
                      icon: Icon(Icons.badge_rounded, size: 18),
                      text: 'ID Card',
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_AdmitCardTab(), _IdCardTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFilterForm extends StatefulWidget {
  final Future<void> Function(
      String examId,
      String classId,
      String sectionId,
      String studentId,
      ) onGenerate;
  final String buttonLabel;
  final IconData buttonIcon;
  final bool loading;

  const _CardFilterForm({
    required this.onGenerate,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.loading,
  });

  @override
  State<_CardFilterForm> createState() => _CardFilterFormState();
}

class _CardFilterFormState extends State<_CardFilterForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _classes  = <Map<String, dynamic>>[];
  final _sections = <Map<String, dynamic>>[];
  final _exams    = <Map<String, dynamic>>[];
  final _students = <Map<String, dynamic>>[];

  bool _sectionsLoading = false;
  bool _studentsLoading = false;

  String? _selectedClassId;
  String? _selectedSectionId;
  String? _selectedExamId;
  String? _selectedStudentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    final classVm =
    Provider.of<AllClassesViewModel>(context, listen: false);
    await classVm.allClassesApi(context);
    if (!mounted) return;
    setState(() {
      _classes
        ..clear()
        ..addAll(
          (classVm.allClassesModel?.data ?? []).map(
                (e) => {
              'class_id': e.classId.toString(),
              'class_name': e.className,
            },
          ),
        );
    });

    final examVm =
    Provider.of<ExamManagementViewModel>(context, listen: false);
    await examVm.examManagementApi(context);
    if (!mounted) return;
    setState(() {
      _exams
        ..clear()
        ..addAll(
          (examVm.examManagementModel?.data ?? []).map(
                (e) => {
              'exam_id': e.examId.toString(),
              'exam_name': e.examName,
            },
          ),
        );
    });
  }

  Future<void> _loadSections(String classId) async {
    setState(() {
      _sectionsLoading    = true;
      _sections.clear();
      _selectedSectionId  = null;
      _selectedStudentId  = null;
      _students.clear();
    });

    final res = await AllSectionsRepository().allSectionsApi(classId);
    if (res['success'] == true && mounted) {
      setState(() {
        _sections.addAll(List<Map<String, dynamic>>.from(res['data']));
      });
    }
    if (mounted) setState(() => _sectionsLoading = false);
  }

  Future<void> _loadStudents(String classId, String sectionId) async {
    setState(() {
      _studentsLoading   = true;
      _students.clear();
      _selectedStudentId = null;
    });

    final studentVm =
    Provider.of<AllStudentListVieModel>(context, listen: false);
    await studentVm.allStudentListApi(
      context,
      classId: classId,
      sectionId: sectionId,
    );
    if (!mounted) return;

    setState(() {
      _students
        ..clear()
        ..addAll(
          (studentVm.allStudentListModel?.data ?? []).map(
                (e) => {
              'student_id': e.studentId.toString(),
              'name': e.name,
            },
          ),
        );
      _studentsLoading = false;
    });
  }

  Future<void> _handleGenerate() async {
    if (_selectedClassId == null ||
        _selectedSectionId == null ||
        _selectedExamId == null ||
        _selectedStudentId == null) {
      Utils.show(
        'Please select all filters',
        context,
        type: 'warning',
      );
      return;
    }
    await widget.onGenerate(
      _selectedExamId!,
      _selectedClassId!,
      _selectedSectionId!,
      _selectedStudentId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _Dropdown(
          hint: 'Class',
          value: _selectedClassId,
          items: _classes
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem(
              value: e['class_id'].toString(),
              child: Text(e['class_name']),
            ),
          )
              .toList(),
          onChanged: (v) async {
            setState(() {
              _selectedClassId   = v;
              _selectedSectionId = null;
              _selectedStudentId = null;
              _sections.clear();
              _students.clear();
            });
            if (v != null) await _loadSections(v);
          },
        ),
        const SizedBox(height: 10),
        _Dropdown(
          hint: 'Section',
          value: _selectedSectionId,
          loading: _sectionsLoading,
          items: _sections
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem(
              value: e['section_id'].toString(),
              child: Text(e['section_name']),
            ),
          )
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedSectionId = v;
              _selectedStudentId = null;
              _students.clear();
            });
            if (v != null && _selectedClassId != null) {
              _loadStudents(_selectedClassId!, v);
            }
          },
        ),
        const SizedBox(height: 10),
        _Dropdown(
          hint: 'Exam',
          value: _selectedExamId,
          items: _exams
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem(
              value: e['exam_id'].toString(),
              child: Text(e['exam_name']),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() => _selectedExamId = v),
        ),
        const SizedBox(height: 10),
        _Dropdown(
          hint: 'Student',
          loading: _studentsLoading,
          value: _students.any(
                  (e) => e['student_id'].toString() == _selectedStudentId)
              ? _selectedStudentId
              : null,
          items: _students
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem(
              value: e['student_id'].toString(),
              child: Text(e['name']),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() => _selectedStudentId = v),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
              disabledBackgroundColor:
              AppColor.lightBlueColor.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: widget.loading ? null : _handleGenerate,
            icon: widget.loading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : Icon(widget.buttonIcon,
                color: Colors.white, size: 18),
            label: Text(
              widget.loading ? 'Generating...' : widget.buttonLabel,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}


class _Dropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final bool loading;

  const _Dropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColor.cardShadow, blurRadius: 6)
        ],
      ),
      child: loading
          ? const SizedBox(
        height: 48,
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Loading...',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      )
          : DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Text(hint,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _AdmitCardTab extends StatefulWidget {
  const _AdmitCardTab();

  @override
  State<_AdmitCardTab> createState() => _AdmitCardTabState();
}

class _AdmitCardTabState extends State<_AdmitCardTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _generate(
      String examId,
      String classId,
      String sectionId,
      String studentId,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.generateAdmitCard)) {

      Utils.show(
        "You don't have permission to perform this action",
        context,
      );

      return;
    }
    final vm =
    Provider.of<GenerateAdmitCardViewModel>(context, listen: false);
    await vm.getAdmitCard(
      int.parse(examId),
      int.parse(classId),
      int.parse(sectionId),
      int.parse(studentId),
      context
    );
    if (!mounted) return;

    if (vm.admitCardModel == null ||
        (vm.admitCardModel!.data?.students?.isEmpty ?? true)) {
      Utils.show('No admit card data received', context, type: 'error');
      return;
    }

    AdmitCardPdfService.showOptions(
        context: context, model: vm.admitCardModel!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vm = Provider.of<GenerateAdmitCardViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      child: Column(
        children: [
          _CardFilterForm(
            buttonLabel: 'Generate Admit Card',
            buttonIcon: Icons.picture_as_pdf_rounded,
            loading: vm.loading,
            onGenerate: _generate,
          ),

          const SizedBox(height: 20),
          if (vm.admitCardModel?.data?.students?.isNotEmpty == true)
            _AdmitCardPreview(
              model: vm.admitCardModel!,
              onAction: () async {
                final s = vm.admitCardModel?.data?.students?.firstOrNull;
                if (s == null) return;
                AdmitCardPdfService.showOptions(
                    context: context, model: vm.admitCardModel!);
              },
            ),
        ],
      ),
    );
  }
}

class _AdmitCardPreview extends StatelessWidget {
  final dynamic model; // GenerateAdmitCardModel
  final VoidCallback onAction;

  const _AdmitCardPreview({required this.model, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final data      = model.data;
    final student   = data?.students?[0];
    final examInfo  = data?.examInfo;
    final classInfo = data?.classInfo;
    final school    = data?.schoolInfo;

    String dob = student?.dob ?? '—';
    if (dob.contains('T')) dob = dob.split('T').first;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06), blurRadius: 12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: AppText.customText(
                      (school?.schoolName ?? 'S').substring(0, 1),
                      size: 20,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        school?.schoolName ?? '',
                        size: 13,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      AppText.customText(
                        examInfo?.examName ?? '',
                        size: 10,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      AppText.customText('Ready',
                          size: 10,
                          weight: FontWeight.bold,
                          color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StudentPhoto(photoUrl: student?.studentPhoto, size: 72),
                const SizedBox(width: 12),
                // Fields
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        student?.name ?? '',
                        size: 15,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      _InfoRow(
                          label: 'Class',
                          value:
                          '${classInfo?.className ?? ''} ${classInfo?.sectionName ?? ''}'),
                      _InfoRow(
                          label: 'Roll No',
                          value: '${student?.rollNo ?? '—'}'),
                      _InfoRow(
                          label: 'Reg. No',
                          value: student?.regNo ?? '—'),
                      _InfoRow(label: 'D.O.B.', value: dob),
                      _InfoRow(
                          label: 'Subjects',
                          value:
                          '${student?.examSchedule?.length ?? 0}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if ((student?.examSchedule?.isNotEmpty) == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 4),
                  AppText.customText('Exam Schedule',
                      size: 11,
                      weight: FontWeight.bold,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 6),
                  ...((student?.examSchedule ?? [])
                      .take(3)
                      .map((s) => _ScheduleChip(schedule: s))),
                  if ((student?.examSchedule?.length ?? 0) > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppText.customText(
                        '+ ${(student?.examSchedule?.length ?? 0) - 3} more subjects',
                        size: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.lightBlueColor,
                      side: BorderSide(color: AppColor.lightBlueColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.share_rounded,
                        size: 16, color: Colors.white),
                    label: const Text('Share / Print',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightBlueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdCardTab extends StatefulWidget {
  const _IdCardTab();

  @override
  State<_IdCardTab> createState() => _IdCardTabState();
}

class _IdCardTabState extends State<_IdCardTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  dynamic _idCardModel;

  Future<void> _generate(
      String examId,
      String classId,
      String sectionId,
      String studentId,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.generateAdmitCard)) {

      Utils.show(
        "You don't have permission to perform this action",
        context,
      );

      return;
    }
    final vm =
    Provider.of<GenerateAdmitCardViewModel>(context, listen: false);
    await vm.getAdmitCard(
      int.parse(examId),
      int.parse(classId),
      int.parse(sectionId),
      int.parse(studentId),
      context
    );
    if (!mounted) return;

    if (vm.admitCardModel == null ||
        (vm.admitCardModel!.data?.students?.isEmpty ?? true)) {
      Utils.show('No ID card data received', context, type: 'error');
      return;
    }
    setState(() => _idCardModel = vm.admitCardModel);

    IdCardPdfService.showOptions(
        context: context, model: vm.admitCardModel!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vm = Provider.of<GenerateAdmitCardViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      child: Column(
        children: [
          _CardFilterForm(
            buttonLabel: 'Generate ID Card',
            buttonIcon: Icons.badge_rounded,
            loading: vm.loading,
            onGenerate: _generate,
          ),

          const SizedBox(height: 20),
          if (_idCardModel != null)
            _IdCardPreview(
              model: _idCardModel!,
              onAction: () {
                IdCardPdfService.showOptions(
                    context: context, model: _idCardModel!);
              },
            ),
        ],
      ),
    );
  }
}

class _IdCardPreview extends StatelessWidget {
  final dynamic model;
  final VoidCallback onAction;

  const _IdCardPreview({required this.model, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final data      = model.data;
    final student   = data?.students?[0];
    final classInfo = data?.classInfo;
    final school    = data?.schoolInfo;
    final examInfo  = data?.examInfo;

    String dob = student?.dob ?? '—';
    if (dob.contains('T')) dob = dob.split('T').first;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06), blurRadius: 12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFCC0000),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: AppText.customText(
                            (school?.schoolName ?? 'S').substring(0, 1),
                            size: 18,
                            weight: FontWeight.bold,
                            color: const Color(0xFFCC0000),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              school?.schoolName ?? '',
                              size: 11,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            AppText.customText(
                              school?.address ?? '',
                              size: 8,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText.customText('ID CARD',
                            size: 8,
                            weight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _StudentPhoto(
                          photoUrl: student?.studentPhoto, size: 80),
                      const SizedBox(height: 10),
                      AppText.customText(
                        (student?.name ?? '').toUpperCase(),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      if ((examInfo?.academicYear ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        AppText.customText(
                          examInfo?.academicYear ?? '',
                          size: 10,
                          color: Colors.grey.shade500,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Divider(
                          color: Colors.grey.shade200, height: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _InfoRow(
                                    label: 'Class-Sec',
                                    value:
                                    '${classInfo?.className ?? ''} ${classInfo?.sectionName ?? ''}'),
                                _InfoRow(
                                    label: 'D.O.B.', value: dob),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                _InfoRow(
                                    label: 'Roll No',
                                    value:
                                    '${student?.rollNo ?? '—'}'),
                                _InfoRow(
                                    label: 'Reg. No',
                                    value: student?.regNo ?? '—'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _InfoRow(
                          label: 'Father',
                          value: student?.fatherName ?? '—'),
                      _InfoRow(
                          label: 'Mother',
                          value: student?.motherName ?? '—'),
                      _InfoRow(
                          label: 'Address',
                          value: student?.address ?? '—'),
                      const SizedBox(height: 10),
                      Divider(
                          color: Colors.grey.shade200, height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          _SignatureBox(label: 'Student Signature'),
                          _SignatureBox(
                              label: 'Principal Signature'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFCC0000),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(14)),
                  ),
                  child: Center(
                    child: AppText.customText(
                      (school?.phone ?? '').isNotEmpty
                          ? 'School Contact # ${school?.phone}'
                          : school?.schoolName ?? '',
                      size: 10,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFCC0000),
                      side: const BorderSide(color: Color(0xFFCC0000)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.share_rounded,
                        size: 16, color: Colors.white),
                    label: const Text('Share / Print',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC0000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentPhoto extends StatelessWidget {
  final String? photoUrl;
  final double size;

  const _StudentPhoto({this.photoUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: hasPhoto
          ? ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderIcon(),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey.shade400),
              ),
            );
          },
        ),
      )
          : _placeholderIcon(),
    );
  }

  Widget _placeholderIcon() => Center(
    child: Icon(Icons.person_rounded,
        size: size * 0.52, color: Colors.grey.shade400),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: AppText.customText(label,
                size: 9.5, color: Colors.red.shade600),
          ),
          AppText.customText(' : ',
              size: 9.5, color: Colors.grey.shade500),
          Expanded(
            child: AppText.customText(value,
                size: 9.5, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  final dynamic schedule;

  const _ScheduleChip({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.lightBlueColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppColor.lightBlueColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded,
              size: 11, color: AppColor.lightBlueColor),
          const SizedBox(width: 6),
          Expanded(
            child: AppText.customText(
              '${schedule.day ?? ''} ${schedule.examDate ?? ''}',
              size: 10,
              weight: FontWeight.w600,
            ),
          ),
          AppText.customText(
            schedule.subjectName ?? '',
            size: 10,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

class _SignatureBox extends StatelessWidget {
  final String label;

  const _SignatureBox({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 28,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade400, width: 0.8)),
          ),
        ),
        const SizedBox(height: 4),
        AppText.customText(label, size: 8, color: Colors.grey.shade600),
      ],
    );
  }
}