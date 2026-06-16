import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/app_color.dart';
import '../../view_model/school_view_model/co_scholastic_grade_view_model.dart';

class CoScholasticTable extends StatelessWidget {
  const CoScholasticTable({super.key});

  static const List<String> grades = ["A1", "A2", "B1", "B2", "C1", "C2", "D"];

  @override
  Widget build(BuildContext context) {
    return Consumer<CoScholasticGradeViewModel>(
      builder: (context, vm, child) {
        if (vm.students.isEmpty) {
          return Container(
            height: 250,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 50, color: Colors.grey),

                SizedBox(height: 10),

                Text("Select filters and load students"),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffE5E7EB)),
          ),
          child: Column(
            children: [
              /// HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.white),

                    SizedBox(width: 10),

                    Text(
                      "Co-Scholastic Grades",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              /// TABLE
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 25,

                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xffF8FAFC),
                  ),

                  columns: [
                    const DataColumn(
                      label: Text(
                        "Student",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    ...vm.subjects.map(
                      (subject) => DataColumn(
                        label: SizedBox(
                          width: 130,
                          child: Text(subject.subjectName ?? "", maxLines: 2),
                        ),
                      ),
                    ),
                  ],

                  rows: vm.students.map((student) {
                    return DataRow(
                      cells: [
                        /// STUDENT NAME
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Text(
                                  student.admissionNo ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// SUBJECTS
                        ...vm.subjects.map((subject) {
                          final grade = vm.getGrade(
                            studentId: student.studentId!,
                            subjectId: subject.subjectId!,
                          );

                          return DataCell(
                            SizedBox(
                              width: 110,
                              child: DropdownButtonFormField<String>(
                                value: grade,

                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                items: grades
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),

                                onChanged: (value) {
                                  vm.updateGrade(
                                    studentId: student.studentId!,
                                    subjectId: subject.subjectId!,
                                    grade: value!,
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),

              /// SAVE BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: vm.loading
                        ? null
                        : () {
                            vm.saveAllGrades(context);
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                    ),

                    icon: vm.loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: Text(vm.loading ? "Saving..." : "Save Grades"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
