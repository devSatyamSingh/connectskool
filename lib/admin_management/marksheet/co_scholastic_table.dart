import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_color.dart';
import '../../view_model/school_view_model/co_scholastic/co_scholastic_grade_view_model.dart';

class CoScholasticTable extends StatefulWidget {
  const CoScholasticTable({super.key});

  @override
  State<CoScholasticTable> createState() => _CoScholasticTableState();
}

class _CoScholasticTableState extends State<CoScholasticTable> {
  static const List<String> grades = [
    "A1",
    "A2",
    "B1",
    "B2",
    "C1",
    "C2",
    "D",
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns a color for each grade level
  Color _gradeColor(String? grade) {
    switch (grade) {
      case "A1":
        return const Color(0xFF4CAF50); // green
      case "A2":
        return const Color(0xFF8BC34A); // light green
      case "B1":
        return const Color(0xFF9C27B0); // purple
      case "B2":
        return const Color(0xFFAB47BC); // light purple
      case "C1":
        return const Color(0xFFFF9800); // orange
      case "C2":
        return const Color(0xFFFFB74D); // light orange
      case "D":
        return const Color(0xFFF44336); // red
      default:
        return const Color(0xFFBDBDBD); // grey for unset
    }
  }

  /// Colored avatar based on initials
  Widget _buildAvatar(String name) {
    final colors = [
      const Color(0xFF9C27B0),
      const Color(0xFF3F51B5),
      const Color(0xFF2196F3),
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
      const Color(0xFFFF5722),
      const Color(0xFF795548),
    ];
    final initials = name.trim().isEmpty
        ? "?"
        : name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase();
    final color = colors[name.codeUnitAt(0) % colors.length];

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Grade pill widget
  Widget _buildGradePill(String? grade) {
    final color = _gradeColor(grade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Text(
        grade ?? "—",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoScholasticGradeViewModel>(
      builder: (context, vm, child) {
        if (vm.students.isEmpty) {
          return Container(
            height: 260,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    size: 44,
                    color: Color(0xFF9DB2CE),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'co_scholastic_table.no_data_loaded'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'co_scholastic_table.no_data_subtitle'.tr(),
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                ),
              ],
            ),
          );
        }

        final filteredStudents = vm.students.where((s) {
          final q = _searchQuery.toLowerCase();
          return (s.name ?? "").toLowerCase().contains(q) ||
              (s.admissionNo ?? "").toLowerCase().contains(q);
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ─── SEARCH + META ROW ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'co_scholastic_table.search_hint'.tr(),
                          hintStyle: const TextStyle(
                            color: Color(0xFFADB5BD),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                            color: Color(0xFFADB5BD),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Consumer<CoScholasticGradeViewModel>(
                    builder: (_, vm, __) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'co_scholastic_table.students_count'.tr(
                          namedArgs: {'count': filteredStudents.length.toString()},
                        ),
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// ─── TABLE ────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColor.primary),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        /// HEADER ROW
                        Container(
                          color: AppColor.primary,
                          child: Row(
                            children: [
                              _headerCell('co_scholastic_table.roll_no'.tr(), width: 70),
                              _headerCell('co_scholastic_table.student_name'.tr(), width: 180),
                              ...vm.subjects.map(
                                    (s) => _headerCell(
                                  (s.subjectName ?? "").toUpperCase(),
                                  width: 130,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DATA ROWS
                        ...filteredStudents.asMap().entries.map((entry) {
                          final i = entry.key;
                          final student = entry.value;
                          final isEven = i % 2 == 0;

                          return Container(
                            color: isEven
                                ? Colors.white
                                : const Color(0xFFFAFBFC),
                            child: Row(
                              children: [
                                /// ROLL NO
                                _dataCell(
                                  width: 70,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      student.rollNo ?? "—",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                ),

                                /// STUDENT NAME
                                _dataCell(
                                  width: 180,
                                  child: Row(
                                    children: [
                                      _buildAvatar(student.name ?? ""),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          student.name ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Color(0xFF111827),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// SUBJECT GRADE DROPDOWNS
                                ...vm.subjects.map((subject) {
                                  final grade = vm.getGrade(
                                    studentId: student.studentId!,
                                    subjectId: subject.subjectId!,
                                  );

                                  return _dataCell(
                                    width: 130,
                                    child: _GradeDropdown(
                                      grades: grades,
                                      value: grade,
                                      gradeColor: _gradeColor(grade),
                                      onChanged: (v) => vm.updateGrade(
                                        studentId: student.studentId!,
                                        subjectId: subject.subjectId!,
                                        grade: v!,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// PAGINATION-STYLE FOOTER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'co_scholastic_table.showing_records'.tr(
                    namedArgs: {
                      'showing': filteredStudents.length.toString(),
                      'total': vm.students.length.toString(),
                    },
                  ),
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerCell(String label, {required double width}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: .5,
          ),
        ),
      ),
    );
  }

  Widget _dataCell({required double width, required Widget child}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: child,
      ),
    );
  }
}

/// ─── GRADE DROPDOWN ──────────────────────────────────────────────────────────
class _GradeDropdown extends StatelessWidget {
  final List<String> grades;
  final String? value;
  final Color gradeColor;
  final ValueChanged<String?> onChanged;

  const _GradeDropdown({
    required this.grades,
    required this.value,
    required this.gradeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: value != null
            ? gradeColor.withOpacity(0.10)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value != null
              ? gradeColor.withOpacity(0.4)
              : const Color(0xFFD1D5DB),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text(
            "—",
            style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 13),
          ),
          isDense: true,
          isExpanded: true,
          icon: Icon(
            Icons.expand_more_rounded,
            size: 16,
            color: value != null ? gradeColor : const Color(0xFFD1D5DB),
          ),
          style: TextStyle(
            color: gradeColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          items: grades
              .map(
                (g) => DropdownMenuItem(
              value: g,
              child: Text(
                g,
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}