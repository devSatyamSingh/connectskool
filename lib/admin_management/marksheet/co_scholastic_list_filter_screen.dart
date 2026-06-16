import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/app_color.dart';
import '../../view_model/school_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/all_classes_view_model.dart';
import '../../view_model/school_view_model/all_scetions_view_model.dart';
import '../../view_model/school_view_model/all_student_list_view_model.dart';
import '../../view_model/school_view_model/co_scholastic_grade_view_model.dart';

class CoScholasticListFilterCard extends StatefulWidget {
  const CoScholasticListFilterCard({super.key});

  @override
  State<CoScholasticListFilterCard> createState() =>
      _CoScholasticListFilterCardState();
}

class _CoScholasticListFilterCardState
    extends State<CoScholasticListFilterCard> {
  String? selectedAcademicYear;
  String? selectedClassId;
  String? selectedSectionId;
  int? selectedStudentId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AcademicViewModel>().academicApi(context);
      await context.read<AllClassesViewModel>().allClassesApi(context);
      final academicVm = context.read<AcademicViewModel>();
      if (academicVm.currentYear != null) {
        setState(() {
          selectedAcademicYear = academicVm.currentYear?.yearName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final academicVm = context.watch<AcademicViewModel>();
    final classVm = context.watch<AllClassesViewModel>();
    final sectionVm = context.watch<AllSectionsViewModel>();
    final studentVm = context.watch<AllStudentListVieModel>();

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
         color: Colors.grey.shade200
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColor.primary, Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Filter Grades",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedAcademicYear,
                      decoration: _inputDecoration("Academic Year", Icons.calendar_today_rounded),
                      items: academicVm.years
                          .map(
                            (e) => DropdownMenuItem<String>(
                          value: e.yearName,
                          child: Text(
                            e.yearName ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAcademicYear = value;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColor.primary,
                        size: 22,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedClassId,
                      decoration: _inputDecoration("Class", Icons.class_rounded),
                      items: classVm.allClassesModel?.data
                          ?.map(
                            (e) => DropdownMenuItem<String>(
                          value: e.classId.toString(),
                          child: Text(
                            e.className ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          .toList() ??
                          [],
                      onChanged: (value) async {
                        setState(() {
                          selectedClassId = value;
                          selectedSectionId = null;
                          selectedStudentId = null;
                        });
                        if (value != null) {
                          await sectionVm.allSectionsApi(context, value);
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColor.primary,
                        size: 22,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Section Dropdown
              DropdownButtonFormField<String>(
                value: selectedSectionId,
                decoration: _inputDecoration("Section", Icons.view_agenda_rounded),
                items: sectionVm.allSectionsModel?.data
                    ?.map(
                      (e) => DropdownMenuItem<String>(
                    value: e.sectionId.toString(),
                    child: Text(
                      e.sectionName ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    .toList() ??
                    [],
                onChanged: (value) async {
                  setState(() {
                    selectedSectionId = value;
                    selectedStudentId = null;
                  });
                  if (selectedClassId != null && value != null) {
                    await studentVm.allStudentListApi(
                      context,
                      classId: selectedClassId,
                      sectionId: value,
                    );
                  }
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColor.primary,
                  size: 22,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(height: 16),
              // Student & Load Button Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: selectedStudentId,
                      decoration: _inputDecoration(
                        "Student",
                        Icons.person_rounded,
                      ),
                      items: studentVm.allStudentListModel?.data
                          ?.map(
                            (student) => DropdownMenuItem<int>(
                          value: student.studentId,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              "${student.name} (${student.rollNo ?? "-"})",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      )
                          .toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {
                          selectedStudentId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _loadGrades,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  label: Text(
                    _isLoading
                        ? "Loading..."
                        : "Load Student Grades",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColor.primary,
        size: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColor.primary.withOpacity(0.4),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  Future<void> _loadGrades() async {
    if (selectedStudentId == null || selectedAcademicYear == null) {
      _showSnackBar("Please select both student and academic year");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final vm = context.read<CoScholasticGradeViewModel>();
      await vm.getGradesApi(
        studentId: selectedStudentId.toString(),
        academicYear: selectedAcademicYear!,
        context: context,
      );
    } catch (e) {
      _showSnackBar("Failed to load grades. Please try again.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}