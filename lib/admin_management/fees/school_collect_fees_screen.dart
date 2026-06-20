import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/fees/student_profile_fees_screen.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/auth_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../view_model/school_view_model/fees/school_student_fee_view_model.dart';

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
    final studentList = Provider.of<AllStudentListVieModel>(
      context,
    ).allStudentListModel;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
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
            Expanded(
              child: (studentList?.data?.isEmpty ?? true)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Students Found",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: studentList?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final s = studentList?.data?[index];
                        if (s == null) return const SizedBox();
                        return GestureDetector(
                          onTap: () async {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                "You don't have permission to collect fees.",
                                context,
                              );
                              return;
                            }

                            final academicVm = Provider.of<AcademicViewModel>(
                              context,
                              listen: false,
                            );

                            final academicYear =
                                academicVm.currentYear?.yearName;

                            if (academicYear == null || academicYear.isEmpty) {
                              Utils.show("Academic year not found", context);
                              return;
                            }

                            final vm = Provider.of<StudentFeeViewModel>(
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
                              horizontal: 14,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.primary,
                                        AppColor.primary.withOpacity(.7),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      s.name.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Text(
                                          "Adm: ${s.admissionNo}",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColor.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.visibility_outlined,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}
