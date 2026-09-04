import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_button.dart';
import '../../view_model/school_view_model/co_scholastic/co_scholastic_grade_view_model.dart';
import '../../res/app_color.dart';
import '../../view_model/auth_view_model/school_admin_profile_view_model.dart';
import 'co_scholastic_filter_card.dart';
import 'co_scholastic_list_screen.dart';
import 'co_scholastic_table.dart';

class CoScholasticScreen extends StatefulWidget {
  const CoScholasticScreen({super.key});

  @override
  State<CoScholasticScreen> createState() => _CoScholasticScreenState();
}

class _CoScholasticScreenState extends State<CoScholasticScreen> {
  static const Color _gold = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  CoScholasticFilterCard(
                    onLoad: ({
                      required classId,
                      required sectionId,
                      required academicYear,
                      required term,
                    }) async {
                      final gradeVm = context.read<CoScholasticGradeViewModel>();
                      gradeVm.currentAcademicYear = academicYear;
                      gradeVm.currentTerm = term;
                    },
                  ),
                  const SizedBox(height: 16),
                  const CoScholasticTable(),
                  const SizedBox(height: 20),
                  const SaveGradesButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final adminProfile = Provider.of<SchoolAdminProfileViewModel>(
      context,
    ).schoolAdminProfileModel;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        18,
      ),
      decoration: const BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          /// TOP BAR
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'co_scholastic_screen.title'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'co_scholastic_screen.subtitle'.tr(),
                      style: const TextStyle(color: Color(0xFFD7E7F7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CoScholasticGradesListScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.list_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'co_scholastic_screen.grades_list'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          /// SCHOOL INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fact_check_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adminProfile?.data?.schoolName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'co_scholastic_screen.school_subtitle'.tr(),
                      style: const TextStyle(color: Color(0xFFAEC6E8), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// INFO BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.groups_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'co_scholastic_screen.class_wise'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                  child: VerticalDivider(color: Colors.white38, thickness: 1),
                ),
                Row(
                  children: [
                    const Icon(Icons.grade_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'co_scholastic_screen.grade_scale'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                  child: VerticalDivider(color: Colors.white38, thickness: 1),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.fact_check_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'co_scholastic_screen.assessment'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
}

class SaveGradesButton extends StatelessWidget {
  const SaveGradesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoScholasticGradeViewModel>(
      builder: (context, vm, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppButton(
            title: vm.loading
                ? 'co_scholastic_screen.saving_grades'.tr()
                : 'co_scholastic_screen.save_all_grades'.tr(),
            icon: Icons.save_rounded,
            loading: vm.loading,
            onTap: () async {
              await vm.saveAllGrades(context);
            },
          ),
        );
      },
    );
  }
}