import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../view_model/school_view_model/marksheet/generate_marksheet_view_model.dart';
import '../../view_model/auth_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../view_model/school_view_model/section/all_scetions_view_model.dart';
import '../../view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../view_model/auth_view_model/school_admin_profile_view_model.dart';
import 'chart_marksheet_preview_widget.dart';
import 'generate_chart_marksheet_pdf.dart';
import 'marksheet_preview_widget.dart';
// apne actual paths ke according adjust karein:
import 'marksheet_preview_pdf_service.dart';
import 'marksheet_screen.dart';

class GenerateMarksheetScreen extends StatefulWidget {
  const GenerateMarksheetScreen({super.key});

  @override
  State<GenerateMarksheetScreen> createState() => _GenerateMarksheetScreenState();
}

class _GenerateMarksheetScreenState extends State<GenerateMarksheetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Tab change hone par index track karo
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTabIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleDownload() async {
    final marksheetVm =
    Provider.of<GenerateMarksheetViewModel>(context, listen: false);
    final profileVm =
    Provider.of<SchoolAdminProfileViewModel>(context, listen: false);

    if (marksheetVm.marksheetModel == null) return;

    if (_currentTabIndex == 0) {
      await MarksheetPreviewPdfService.showOptions(
        context: context,
        marksheetData: marksheetVm.marksheetModel?.data,
        schoolData: profileVm.schoolAdminProfileModel?.data,
      );
    } else {
      final data        = marksheetVm.marksheetModel?.data;
      final studentInfo = data?.studentInfo;

      final grades = <_CoScholasticGradeProxy>[];

      final coScholastic = data?.coScholastic;
      if (coScholastic != null) {
        final term1  = Map<String, dynamic>.from(coScholastic['term1'] ?? {});
        final term2  = Map<String, dynamic>.from(coScholastic['term2'] ?? {});
        final allKeys = <String>{...term1.keys, ...term2.keys};

        for (final key in allKeys) {
          final t1 = term1[key];
          final t2 = term2[key];

          if (t1 != null) {
            grades.add(_CoScholasticGradeProxy(
              subjectName: t1['subject_name']?.toString() ?? key,
              grade:       t1['grade']?.toString() ?? '-',
              term:        'term1',
              studentName: studentInfo?.name          ?? '',
              className:   studentInfo?.className     ?? '',
              sectionName: studentInfo?.sectionName   ?? '',
              rollNo:      studentInfo?.rollNo?.toString() ?? '',
              dob:         studentInfo?.dob           ?? '',
              fatherName:  studentInfo?.fatherName    ?? '',
              motherName:  studentInfo?.motherName    ?? '',
              admissionNo: studentInfo?.admissionNo   ?? '',
            ));
          }

          if (t2 != null) {
            grades.add(_CoScholasticGradeProxy(
              subjectName: t2['subject_name']?.toString() ?? key,
              grade:       t2['grade']?.toString() ?? '-',
              term:        'term2',
              studentName: studentInfo?.name          ?? '',
              className:   studentInfo?.className     ?? '',
              sectionName: studentInfo?.sectionName   ?? '',
              rollNo:      studentInfo?.rollNo?.toString() ?? '',
              dob:         studentInfo?.dob           ?? '',
              fatherName:  studentInfo?.fatherName    ?? '',
              motherName:  studentInfo?.motherName    ?? '',
              admissionNo: studentInfo?.admissionNo   ?? '',
            ));
          }
        }
      }

      await ChartMarksheetPdfService.showOptions(
        context:       context,
        grades:        grades,
        schoolName:    profileVm.schoolAdminProfileModel?.data?.schoolName    ?? 'School Name',
        schoolAddress: profileVm.schoolAdminProfileModel?.data?.schoolAdrees  ?? 'School Address',
        affiliationNo: 'N/A',
        academicYear:  data?.academicYear?.toString() ?? '2026-27',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GenerateMarksheetViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 16,
              20,
              24,
            ),
            decoration: const BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.read<GenerateMarksheetViewModel>().clear();
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Generate Marksheet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Manage and generate student academic reports",
                        style: TextStyle(
                          color: Color(0xffE2ECFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// FILTER CARD
                  const MarksheetFilterCard(),

                  if (vm.marksheetModel != null) ...[
                    const SizedBox(height: 24),

                    /// ACTION BUTTONS — tab-aware label
                    _buildModernActionRow(),

                    const SizedBox(height: 24),

                    /// TAB BAR
                    _buildModernTabBar(),

                    const SizedBox(height: 20),
                  ],

                  /// PREVIEW AREA
                  if (vm.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                        ),
                      ),
                    )
                  else if (vm.marksheetModel != null)
                    SizedBox(
                      height: 1250,
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          MarksheetPreviewWidget(),
                          ChartMarksheetPreviewWidget(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernActionRow() {
    final isChartTab = _currentTabIndex == 1;
    final label = isChartTab ? "Chart Marksheet" : "Marksheet";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _handleDownload,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(
                "Download $label",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.2,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColor.primary,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_rounded, size: 16),
                SizedBox(width: 8),
                Text("Marksheet"),
              ],
            ),
          ),
          Tab(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insert_chart_rounded, size: 16),
                SizedBox(width: 8),
                Text("Chart Marksheet"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _CoScholasticGradeProxy {
  final String subjectName;
  final String grade;
  final String term;
  final String studentName;
  final String className;
  final String sectionName;
  final String rollNo;
  final String dob;
  final String fatherName;
  final String motherName;
  final String admissionNo;

  _CoScholasticGradeProxy({
    required this.subjectName,
    required this.grade,
    required this.term,
    required this.studentName,
    required this.className,
    required this.sectionName,
    required this.rollNo,
    required this.dob,
    required this.fatherName,
    required this.motherName,
    required this.admissionNo,
  });
}

class MarksheetFilterCard extends StatefulWidget {
  const MarksheetFilterCard({super.key});

  @override
  State<MarksheetFilterCard> createState() => _MarksheetFilterCardState();
}

class _MarksheetFilterCardState extends State<MarksheetFilterCard> {
  String? selectedAcademicYear;
  String? selectedClassId;
  String? selectedSectionId;
  int? selectedStudentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AcademicViewModel>().academicApi(context);
      await context.read<AllClassesViewModel>().allClassesApi(context);

      final academicVm = context.read<AcademicViewModel>();
      if (academicVm.currentYear != null) {
        setState(() => selectedAcademicYear = academicVm.currentYear!.yearName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final academicVm   = context.watch<AcademicViewModel>();
    final classVm      = context.watch<AllClassesViewModel>();
    final sectionVm    = context.watch<AllSectionsViewModel>();
    final studentVm    = context.watch<AllStudentListVieModel>();
    final marksheetVm  = context.watch<GenerateMarksheetViewModel>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.filter_alt_rounded, color: AppColor.primary, size: 22),
              SizedBox(width: 10),
              Text(
                "Filter Marksheet",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Academic Year
          DropdownButtonFormField<String>(
            value: selectedAcademicYear,
            decoration: _inputDecoration("Academic Year", Icons.calendar_month_rounded),
            items: academicVm.years
                .map((e) => DropdownMenuItem(value: e.yearName, child: Text(e.yearName ?? "")))
                .toList(),
            onChanged: (value) => setState(() => selectedAcademicYear = value),
          ),
          const SizedBox(height: 16),

          // Class + Section
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedClassId,
                  decoration: _inputDecoration("Class", Icons.school_rounded),
                  items: (classVm.allClassesModel?.data ?? [])
                      .map((e) => DropdownMenuItem<String>(
                    value: e.classId.toString(),
                    child: Text(e.className ?? ""),
                  ))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedClassId  = value;
                      selectedSectionId = null;
                      selectedStudentId = null;
                    });
                    context.read<AllStudentListVieModel>().clearStudents();
                    if (value != null) {
                      await context.read<AllSectionsViewModel>().allSectionsApi(context, value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSectionId,
                  decoration: _inputDecoration("Section", Icons.groups_rounded),
                  items: (sectionVm.allSectionsModel?.data ?? [])
                      .map((e) => DropdownMenuItem<String>(
                    value: e.sectionId.toString(),
                    child: Text(e.sectionName ?? ""),
                  ))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedSectionId = value;
                      selectedStudentId = null;
                    });
                    context.read<AllStudentListVieModel>().clearStudents();
                    if (selectedClassId != null && value != null) {
                      await context.read<AllStudentListVieModel>().allStudentListApi(
                        context,
                        classId: selectedClassId,
                        sectionId: value,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Student
          DropdownButtonFormField<int>(
            value: selectedStudentId,
            decoration: _inputDecoration("Student", Icons.person_rounded),
            disabledHint: const Text("Select Section First"),
            items: (studentVm.allStudentListModel?.data ?? [])
                .map((s) => DropdownMenuItem<int>(
              value: s.studentId,
              child: Text("${s.name} (${s.rollNo ?? "-"})"),
            ))
                .toList(),
            onChanged: selectedSectionId == null
                ? null
                : (value) => setState(() => selectedStudentId = value),
          ),
          const SizedBox(height: 24),

          AppButton(
            title: "Search Marksheet",
            icon: Icons.search_rounded,
            loading: marksheetVm.loading,
            onTap: () async {
              if (selectedAcademicYear == null) return _showError("Please select academic year");
              if (selectedClassId == null)      return _showError("Please select class");
              if (selectedSectionId == null)    return _showError("Please select section");
              if (selectedStudentId == null)    return _showError("Please select student");

              await marksheetVm.generateMarksheetApi(
                studentId:    selectedStudentId.toString(),
                academicYear: selectedAcademicYear!,
                context:      context,
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
      prefixIcon: Icon(icon, size: 20, color: AppColor.primary.withOpacity(0.7)),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}