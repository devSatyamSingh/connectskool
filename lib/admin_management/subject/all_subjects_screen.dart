import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/school_view_model/subject/delete_subject_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/view_model/school_view_model/subject/all_subjects_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/add_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/edit_subject_view_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class AllSubjectsScreen extends StatefulWidget {
  const AllSubjectsScreen({super.key});

  @override
  State<AllSubjectsScreen> createState() => _AllSubjectsScreenState();
}

class _AllSubjectsScreenState extends State<AllSubjectsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllSubjectsVieModel>(context, listen: false)
          .allSubjectsApi(context);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Provider.of<AllSubjectsVieModel>(context, listen: false)
        .allSubjectsApi(context);

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllSubjectsVieModel>(context);
    final subjects = viewModel.allSubjectsModel?.data ?? [];

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.endFloat,

        floatingActionButton: SizedBox(
          width: 180,
          child: AppButton(
            title: 'all_subjects.add_subject'.tr(),
            icon: Icons.add_rounded,
            height: 56,
            radius: 18,
            onTap: () {
              if (!PermissionExtensions.canAccess(
                PermissionKeys.addSubject,
              )) {
                Utils.show(
                  'all_subjects.permission_add'.tr(),
                  context,
                );
                return;
              }

              _openSubjectSheet();
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blueShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
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
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText.customText(
                      'all_subjects.title'.tr(),
                      size: 19,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  AppText.customText(
                    "${subjects.length}",
                    size: 16,
                    weight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: viewModel.loading
                  ? _subjectShimmer()
                  : subjects.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.menu_book_outlined,
                        size: 50,
                        color: Colors.orange.shade300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'all_subjects.no_subjects_found'.tr(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'all_subjects.no_subjects_subtitle'.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColor.primary,
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
                displacement: 60,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                  const EdgeInsets.fromLTRB(18, 8, 18, 20),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final s = subjects[index];
                    return _subjectCard(index, {
                      "id": s.subjectId,
                      "name": s.subjectName ?? "",
                      "status": s.status,
                      "type": s.assessmentModel ?? "scholastic",
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _subjectShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 90,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColor.cardWhite,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        );
      },
    );
  }

  Widget _subjectCard(int index, Map<String, dynamic> s) {
    final viewModel =
    Provider.of<DeleteSubjectViewModel>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      s["type"] == "scholastic"
                          ? Icons.school_rounded
                          : Icons.palette_rounded,
                      size: 14,
                      color: s["type"] == "scholastic"
                          ? Colors.blue.shade400
                          : Colors.orange.shade400,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      s["type"] == "scholastic"
                          ? 'all_subjects.scholastic'.tr()
                          : 'all_subjects.co_scholastic'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: s["type"] == "scholastic"
                            ? Colors.blue.shade400
                            : Colors.orange.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (!PermissionExtensions.canAccess(
                      PermissionKeys.editSubject)) {
                    Utils.show(
                      'all_subjects.permission_edit'.tr(),
                      context,
                    );
                    return;
                  }
                  _openSubjectSheet(subject: s);
                },
                icon:
                const Icon(Icons.edit, color: Colors.grey, size: 22),
              ),
              IconButton(
                onPressed: () async {
                  if (!PermissionExtensions.canAccess(
                      PermissionKeys.deleteSubject)) {
                    Utils.show(
                      'all_subjects.permission_delete'.tr(),
                      context,
                    );
                    return;
                  }
                  bool confirmed = await _showDeleteDialog();
                  if (confirmed) {
                    await viewModel.deleteSubjectApi(
                        s["id"].toString(), context);
                  }
                },
                icon:
                const Icon(Icons.delete_forever, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'all_subjects.delete_subject'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'all_subjects.delete_confirmation'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'all_subjects.cancel'.tr(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'all_subjects.delete'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ??
        false;
  }

  void _openSubjectSheet({Map<String, dynamic>? subject}) {
    final isEdit = subject != null;
    final nameCtrl =
    TextEditingController(text: subject?["name"] ?? "");
    final type =
    ValueNotifier<String>(subject?["type"] ?? "scholastic");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.pageBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 25),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isEdit
                            ? 'all_subjects.edit_subject'.tr()
                            : 'all_subjects.add_subject_title'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'all_subjects.subject_name'.tr(),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      ValueListenableBuilder<String>(
                        valueListenable: type,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              await Future.delayed(const Duration(milliseconds: 200));

                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) {
                                  return SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 4,
                                            width: 40,
                                            margin: const EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          Text(
                                            'all_subjects.select_type'.tr(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ListTile(
                                            onTap: () {
                                              type.value = "scholastic";
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              Icons.school_rounded,
                                              color: Colors.blue.shade400,
                                            ),
                                            title: Text('all_subjects.scholastic'.tr()),
                                            trailing: value == "scholastic"
                                                ? Icon(Icons.check_circle,
                                                color: Colors.blue.shade400)
                                                : null,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              type.value = "co_scholastic";
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              Icons.palette_rounded,
                                              color: Colors.orange.shade400,
                                            ),
                                            title: Text('all_subjects.co_scholastic'.tr()),
                                            trailing: value == "co_scholastic"
                                                ? Icon(Icons.check_circle,
                                                color: Colors.orange.shade400)
                                                : null,
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    value == "scholastic"
                                        ? Icons.school_rounded
                                        : Icons.palette_rounded,
                                    color: value == "scholastic"
                                        ? Colors.blue.shade400
                                        : Colors.orange.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      value == "scholastic"
                                          ? 'all_subjects.scholastic'.tr()
                                          : 'all_subjects.co_scholastic'.tr(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey.shade500),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      AppButton(
                        title: isEdit
                            ? 'all_subjects.update_subject'.tr()
                            : 'all_subjects.add_subject'.tr(),
                        onTap: () async {
                          if (isEdit) {
                            if (!PermissionExtensions.canAccess(
                                PermissionKeys.editSubject)) {
                              Utils.show(
                                'all_subjects.permission_edit'.tr(),
                                context,
                              );
                              return;
                            }
                          } else {
                            if (!PermissionExtensions.canAccess(
                                PermissionKeys.addSubject)) {
                              Utils.show(
                                'all_subjects.permission_add'.tr(),
                                context,
                              );
                              return;
                            }
                          }
                          final vm = Provider.of<AddSubjectViewModel>(context, listen: false);
                          final editVm = Provider.of<EditSubjectsViewModel>(context, listen: false);
                          final listVm = Provider.of<AllSubjectsVieModel>(context, listen: false);

                          bool success = false;

                          if (isEdit) {
                            success = await editVm.editSubjectsApi(
                              subject!["id"].toString(),
                              nameCtrl.text,
                              type.value,
                              context,
                            );
                          } else {
                            success = await vm.addSubjectsApi(
                              nameCtrl.text,
                              type.value,
                              context,
                            );
                          }

                          if (success) {
                            await listVm.allSubjectsApi(context);
                            if (mounted) Navigator.pop(context);
                          }
                        },
                        height: 52,
                        radius: 16,
                        gradient: AppColor.primaryGradient,
                        textColor: Colors.white,
                        icon: isEdit ? Icons.edit : Icons.add_rounded,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}