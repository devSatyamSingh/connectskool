import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/student_profile_fees_screen.dart';
import '../res/app_color.dart';
import '../res/const_text.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/academic_view_model.dart';
import '../view_model/school_view_model/all_student_list_view_model.dart';
import '../view_model/school_view_model/school_student_fee_view_model.dart';

class SchoolCollectFeesScreen extends StatefulWidget {
  const SchoolCollectFeesScreen({super.key});

  @override
  State<SchoolCollectFeesScreen> createState() =>
      _SchoolCollectFeesScreenState();
}

class _SchoolCollectFeesScreenState extends State<SchoolCollectFeesScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await Provider.of<AcademicViewModel>(
        context,
        listen: false,
      ).academicApi(context);

      await Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    final studentList =
        Provider.of<AllStudentListVieModel>(context).allStudentListModel;

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,

      body: Column(
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [

                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AppText.customText(
                    "Collect Fees",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: studentList?.data?.length ?? 0,
              itemBuilder: (context, index) {

                final s = studentList?.data?[index];

                if (s == null) return const SizedBox();

                return GestureDetector(

                    onTap: () async {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageFees)) {

                        Utils.show(
                          "You don't have permission to collect fees.",
                          context,
                        );
                        return;
                      }

                      final academicVm =
                      Provider.of<AcademicViewModel>(
                        context,
                        listen: false,
                      );

                      final academicYear =
                          academicVm.currentYear?.yearName;

                      if (academicYear == null ||
                          academicYear.isEmpty) {

                        Utils.show(
                          "Academic year not found",
                          context,
                        );
                        return;
                      }

                      final vm =
                      Provider.of<StudentFeeViewModel>(
                        context,
                        listen: false,
                      );

                      await vm.fetchStudentFees(
                        studentId: s.studentId!,
                        academicYear: academicYear,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudentProfileFeesScreen(student: s),
                        ),
                      );
                    },

                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6),
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(
                      children: [

                        CircleAvatar(
                          child: Text(
                            s.name.substring(0,1).toUpperCase(),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                s.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),

                              Text(
                                s.admissionNo,
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6),

                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius:
                            BorderRadius.circular(6),
                          ),

                          child: const Text(
                            "View Profile",
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),        ],
      ),
    );
  }
}