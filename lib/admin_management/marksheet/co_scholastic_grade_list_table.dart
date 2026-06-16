import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/school_model/co_scholastic_grade_model.dart';
import '../../res/app_color.dart';
import '../../view_model/school_view_model/co_scholastic_grade_view_model.dart';

class CoScholasticGradeListTable extends StatefulWidget {
  const CoScholasticGradeListTable({super.key});

  @override
  State<CoScholasticGradeListTable> createState() =>
      _CoScholasticGradeListTableState();
}

class _CoScholasticGradeListTableState
    extends State<CoScholasticGradeListTable> {
  String search = "";
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CoScholasticGradeViewModel>();
    final grades = vm.gradeModel?.data ?? [];

    final filtered = grades.where((e) {
      return (e.subjectName ?? "")
          .toLowerCase()
          .contains(search.toLowerCase());
    }).toList();

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
              // Header with icon and search
              Row(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [AppColor.primary, Color(0xFF6366F1)],
                  //     ),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: const Icon(
                  //     Icons.grade_rounded,
                  //     color: Colors.white,
                  //     size: 20,
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  // const Expanded(
                  //   child: Text(
                  //     "Grade Records",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w700,
                  //       color: Color(0xFF1A1A2E),
                  //     ),
                  //   ),
                  // ),
                  // Search Field
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search subject...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColor.primary,
                            size: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Table Content
              _buildTableContent(vm, filtered),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableContent(
      CoScholasticGradeViewModel vm,
      List<CoScholasticGradeData> filtered,
      ) {
    if (vm.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
              ),
              SizedBox(height: 16),
              Text(
                "Loading grades...",
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            children: [
              Icon(
                Icons.grade_outlined,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                "No grades found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Try adjusting your search or filters",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColor.primary),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
          dataTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
          columnSpacing: 20,
          horizontalMargin: 16,
          dividerThickness: 1,
          columns: const [
            DataColumn(
              label: Text("ROLL"),
              tooltip: "Roll Number",
            ),
            DataColumn(
              label: Text("STUDENT"),
              tooltip: "Student Name",
            ),
            DataColumn(
              label: Text("SUBJECT"),
              tooltip: "Subject Name",
            ),
            DataColumn(
              label: Text("TERM"),
              tooltip: "Academic Term",
            ),
            DataColumn(
              label: Text("GRADE"),
              tooltip: "Grade Obtained",
            ),
            DataColumn(
              label: Text("YEAR"),
              tooltip: "Academic Year",
            ),
            DataColumn(
              label: Text("ACTION"),
              tooltip: "Edit or Delete",
            ),
          ],
          rows: filtered.map((grade) => _buildRow(context, grade)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, CoScholasticGradeData grade) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grade.rollNo ?? "-",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5563),
                fontSize: 13,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            grade.studentName ?? "-",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        DataCell(
          Text(
            grade.subjectName ?? "-",
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        DataCell(_buildTermChip(grade.term ?? "-")),
        DataCell(_buildGradeChip(grade.grade ?? "-")),
        DataCell(
          Text(
            grade.academicYear ?? "-",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.edit_outlined,
                color: AppColor.primary,
                onPressed: () => _showEditDialog(context, grade),
                tooltip: "Edit Grade",
              ),
              const SizedBox(width: 4),
              _buildActionButton(
                icon: Icons.delete_outline,
                color: Colors.red.shade400,
                onPressed: _isDeleting ? null : () => _deleteGrade(context, grade),
                tooltip: "Delete Grade",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermChip(String term) {
    final colors = {
      'TERM 1': const Color(0xFF3B82F6),
      'TERM 2': const Color(0xFF8B5CF6),
      'FINAL': const Color(0xFF10B981),
    };

    final color = colors[term.toUpperCase()] ?? Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        term,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGradeChip(String grade) {
    final gradeColors = {
      'A1': Colors.green.shade700,
      'A2': Colors.teal.shade600,
      'B1': Colors.blue.shade600,
      'B2': Colors.deepPurple.shade500,
      'C1': Colors.orange.shade600,
      'C2': Colors.deepOrange.shade600,
      'D': Colors.red.shade600,
    };

    final color = gradeColors[grade] ?? Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        grade,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      CoScholasticGradeData grade,
      ) {

    String selectedGrade =
        grade.grade ?? "A1";

    showDialog(
      context: context,
      builder: (dialogContext) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text(
                "Update Grade",
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    grade.studentName ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    grade.subjectName ?? "",
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: selectedGrade,
                    items: const [

                      DropdownMenuItem(
                        value: "A1",
                        child: Text("A1"),
                      ),

                      DropdownMenuItem(
                        value: "A2",
                        child: Text("A2"),
                      ),

                      DropdownMenuItem(
                        value: "B1",
                        child: Text("B1"),
                      ),

                      DropdownMenuItem(
                        value: "B2",
                        child: Text("B2"),
                      ),

                      DropdownMenuItem(
                        value: "C1",
                        child: Text("C1"),
                      ),

                      DropdownMenuItem(
                        value: "C2",
                        child: Text("C2"),
                      ),

                      DropdownMenuItem(
                        value: "D",
                        child: Text("D"),
                      ),
                    ],

                    onChanged: (v) {

                      setDialogState(() {
                        selectedGrade = v!;
                      });
                    },
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {

                    final success =
                    await context
                        .read<
                        CoScholasticGradeViewModel>()
                        .updateGradeApi(
                      gradeId:
                      grade.coScholasticGradesId!,
                      grade:
                      selectedGrade,
                      context:
                      context,
                    );

                    if (success) {

                      Navigator.pop(
                        dialogContext,
                      );

                      await context
                          .read<
                          CoScholasticGradeViewModel>()
                          .getGradesApi(
                        studentId:
                        grade.studentId
                            .toString(),
                        academicYear:
                        grade.academicYear ??
                            "",
                        context:
                        context,
                      );

                      _showSnackBar(
                        "Grade updated successfully",
                        isError: false,
                      );
                    }
                  },
                  child: const Text(
                    "Update",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> _deleteGrade(
      BuildContext context,
      CoScholasticGradeData grade,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Grade",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to delete this grade?",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.grade_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${grade.subjectName} - ${grade.grade}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Delete",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {

      final success =
      await context
          .read<
          CoScholasticGradeViewModel>()
          .deleteGradeApi(
        gradeId:
        grade.coScholasticGradesId!,
        context: context,
      );

      if (success) {

        await context
            .read<
            CoScholasticGradeViewModel>()
            .getGradesApi(
          studentId:
          grade.studentId
              .toString(),
          academicYear:
          grade.academicYear ??
              "",
          context:
          context,
        );

        _showSnackBar(
          "Grade deleted successfully",
          isError: false,
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade600,
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