import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS
import '../../res/app_button.dart';
import '../../res/app_color.dart';
import '../../view_model/auth_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../view_model/school_view_model/section/all_scetions_view_model.dart';
import '../../view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../view_model/school_view_model/subject/all_subjects_view_model.dart';
import '../../view_model/school_view_model/co_scholastic/co_scholastic_grade_view_model.dart';

class CoScholasticFilterCard extends StatefulWidget {
  final Function({
  required String classId,
  required String sectionId,
  required String academicYear,
  required String term,
  }) onLoad;

  const CoScholasticFilterCard({super.key, required this.onLoad});

  @override
  State<CoScholasticFilterCard> createState() => _CoScholasticFilterCardState();
}

class _CoScholasticFilterCardState extends State<CoScholasticFilterCard> {
  String? selectedClassId;
  String? selectedSectionId;
  String? selectedAcademicYear;
  String selectedTerm = "term1";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<AcademicViewModel>()
          .academicApi(context);

      await context
          .read<AllClassesViewModel>()
          .allClassesApi(context);

      final academicVm = context.read<AcademicViewModel>();

      if (academicVm.currentYear != null) {
        setState(() {
          selectedAcademicYear = academicVm.currentYear!.yearName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classVm = Provider.of<AllClassesViewModel>(context);
    final sectionVm = Provider.of<AllSectionsViewModel>(context);
    final academicVm = Provider.of<AcademicViewModel>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt_rounded, color: AppColor.primary),
              const SizedBox(width: 8),
              Text(
                'co_scholastic.filter_records'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Academic Year
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: selectedAcademicYear,
            decoration: _inputDecoration('co_scholastic.academic_year'.tr()),
            items: academicVm.years.map(
                  (e) => DropdownMenuItem<String>(
                value: e.yearName,
                child: Text(e.yearName ?? ""),
              ),
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedAcademicYear = value;
              });
            },
          ),
          const SizedBox(height: 12),

          /// Class
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: selectedClassId,
            decoration: _inputDecoration('co_scholastic.class'.tr()),
            items: (classVm.allClassesModel?.data ?? [])
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                value: e.classId.toString(),
                child: Text(e.className ?? ""),
              ),
            )
                .toList(),
            onChanged: (value) async {
              setState(() {
                selectedClassId = value;
                selectedSectionId = null;
              });

              if (value != null) {
                await context.read<AllSectionsViewModel>().allSectionsApi(
                  context,
                  value,
                );
              }
            },
          ),
          const SizedBox(height: 12),

          /// Section
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: selectedSectionId,
            decoration: _inputDecoration('co_scholastic.section'.tr()),
            items: (sectionVm.allSectionsModel?.data ?? [])
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                value: e.sectionId.toString(),
                child: Text(e.sectionName ?? ""),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSectionId = value;
              });
            },
          ),
          const SizedBox(height: 12),

          /// Term
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: selectedTerm,
            decoration: _inputDecoration('co_scholastic.term'.tr()),
            items: const [
              DropdownMenuItem(value: "term1", child: Text("Term 1")),  // ← Will fix below
              DropdownMenuItem(value: "term2", child: Text("Term 2")),
            ],
            onChanged: (value) {
              setState(() {
                selectedTerm = value!;
              });
            },
          ),
          const SizedBox(height: 18),

          AppButton(
            title: 'co_scholastic.load_students'.tr(),
            icon: Icons.search,
            loading: false,
            onTap: () async {
              if (selectedClassId == null ||
                  selectedSectionId == null ||
                  selectedAcademicYear == null) {
                return;
              }

              await context.read<AllStudentListVieModel>().allStudentListApi(
                context,
                classId: selectedClassId,
                sectionId: selectedSectionId,
              );

              await context.read<AllSubjectsVieModel>().allSubjectsApi(
                context,
              );

              final gradeVm = context.read<CoScholasticGradeViewModel>();
              gradeVm.clearGradeMaps();
              gradeVm.currentAcademicYear = selectedAcademicYear!;
              gradeVm.currentTerm = selectedTerm;
              gradeVm.setStudents(
                context
                    .read<AllStudentListVieModel>()
                    .allStudentListModel
                    ?.data ??
                    [],
              );
              gradeVm.setSubjects(
                context.read<AllSubjectsVieModel>().allSubjectsModel?.data ??
                    [],
              );

              final students = context
                  .read<AllStudentListVieModel>()
                  .allStudentListModel
                  ?.data ??
                  [];

              for (final student in students) {
                await gradeVm.getGradesApi(
                  studentId: student.studentId.toString(),
                  academicYear: selectedAcademicYear!,
                  context: context,
                );
              }

              widget.onLoad(
                classId: selectedClassId!,
                sectionId: selectedSectionId!,
                academicYear: selectedAcademicYear!,
                term: selectedTerm,
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}