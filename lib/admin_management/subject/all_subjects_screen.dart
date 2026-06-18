import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/school_view_model/subject/delete_subject_view_model.dart';
import 'package:shimmer/shimmer.dart';

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

  // ── Pull to Refresh ──────────────────────────
  Future<void> _onRefresh() async {
    await Provider.of<AllSubjectsVieModel>(context, listen: false)
        .allSubjectsApi(context);

    // Animation reset karo taaki cards dobara animate hon
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllSubjectsVieModel>(context);
    final subjects = viewModel.allSubjectsModel?.data ?? [];

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        onPressed: () {

          if (!PermissionExtensions.canAccess(
              PermissionKeys.addSubject)) {

            Utils.show(
              "You don't have permission to add subject",
              context,
            );

            return;
          }

          _openSubjectSheet();
        },
        icon: Icon(Icons.add_rounded, color: AppColor.white),
        label: const Text(
          "Add Subject",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.white),
        ),
      ),

      body: Column(
        children: [
          /// ===== HEADER =====
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
                    "All Subjects",
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

          /// ===== LIST =====
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
                    "No Subjects Found",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Subjects will appear here once added",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
            // ✅ Pull to Refresh wrapped ListView
                : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.primary,
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              displacement: 60,
              child: ListView.builder(
                // ✅ Zaruri: list choti ho tab bhi pull kaam kare
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(18, 8, 18, 20),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final s = subjects[index];
                  return // ✅ FIX - type add karo
                    _subjectCard(index, {
                      "id": s.subjectId,
                      "name": s.subjectName ?? "",
                      "status": s.status,
                      "type": s.assessmentModel ?? "scholastic", // 👈 YEH ADD KARO
                    });
                  //   _subjectCard(index, {
                  //   "id": s.subjectId,
                  //   "name": s.subjectName ?? "",
                  //   "status": s.status,
                  // });
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
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
                // Row(
                //   children: [
                //     Container(
                //       height: 8,
                //       width: 8,
                //       decoration: BoxDecoration(
                //         color:
                //         s["status"] == 1 ? Colors.green : Colors.red,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 6),
                //     Text(
                //       s["status"] == 1 ? "Active Subject" : "Inactive",
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: Colors.grey.shade600,
                //       ),
                //     ),
                //   ],
                // ),
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
                      s["type"] == "scholastic" ? "Scholastic" : "Co-Scholastic",
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
                      "You don't have permission to edit subject",
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
                      "You don't have permission to delete subject",
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

  // ── Delete Dialog ────────────────────────────
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
              // Top Icon
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

              // Title
              const Text(
                "Delete Subject",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              const Text(
                "Are you sure you want to delete this subject?\nThis action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
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
                        "Cancel",
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
                      child: const Text(
                        "Delete",
                        style: TextStyle(
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
                        isEdit ? "Edit Subject" : "Add Subject",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Subject Name
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: "Subject Name",
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

                      /// Dropdown
                      // ValueListenableBuilder<String>(
                      //   valueListenable: type,
                      //   builder: (context, value, child) {
                      //     return Container(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 12),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(14),
                      //       ),
                      //       child: DropdownButtonFormField<String>(
                      //         value: value,
                      //         isExpanded: true,
                      //         menuMaxHeight: 200,
                      //         decoration: const InputDecoration(
                      //             border: InputBorder.none),
                      //         items: const [
                      //           DropdownMenuItem(
                      //             value: "scholastic",
                      //             child: Text("Scholastic"),
                      //           ),
                      //           DropdownMenuItem(
                      //             value: "co_scholastic",
                      //             child: Text("Co Scholastic"),
                      //           ),
                      //         ],
                      //         onChanged: (v) {
                      //           type.value = v!;
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                      /// Dropdown
                      ValueListenableBuilder<String>(
                        valueListenable: type,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () async {
                              // Pehle keyboard band karo
                              FocusScope.of(context).unfocus();
                              await Future.delayed(const Duration(milliseconds: 200));

                              // Phir type selection bottom sheet kholo
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
                                          // Handle bar
                                          Container(
                                            height: 4,
                                            width: 40,
                                            margin: const EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),

                                          const Text(
                                            "Select Subject Type",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          // Option 1
                                          ListTile(
                                            onTap: () {
                                              type.value = "scholastic";
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              Icons.school_rounded,
                                              color: Colors.blue.shade400,
                                            ),
                                            title: const Text("Scholastic"),
                                            trailing: value == "scholastic"
                                                ? Icon(Icons.check_circle,
                                                color: Colors.blue.shade400)
                                                : null,
                                          ),

                                          // Option 2
                                          ListTile(
                                            onTap: () {
                                              type.value = "co_scholastic";
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              Icons.palette_rounded,
                                              color: Colors.orange.shade400,
                                            ),
                                            title: const Text("Co Scholastic"),
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
                                      value == "scholastic" ? "Scholastic" : "Co Scholastic",
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

                      /// Button
                      AppButton(
                        title:
                        isEdit ? "Update Subject" : "Add Subject",
                        // onTap: () {
                        //   final vm = Provider.of<AddSubjectViewModel>(
                        //       context,
                        //       listen: false);
                        //   final editVm =
                        //   Provider.of<EditSubjectsViewModel>(
                        //       context,
                        //       listen: false);
                        //
                        //   if (isEdit) {
                        //     editVm.editSubjectsApi(
                        //       subject!["id"].toString(),
                        //       nameCtrl.text,
                        //       type.value,
                        //       context,
                        //     );
                        //   } else {
                        //     vm.addSubjectsApi(
                        //       nameCtrl.text,
                        //       type.value,
                        //       context,
                        //     );
                        //   }
                        //
                        //   Navigator.pop(context);
                        // },
                        onTap: () async {
                          if (isEdit) {

                            if (!PermissionExtensions.canAccess(
                                PermissionKeys.editSubject)) {

                              Utils.show(
                                "You don't have permission to edit subject",
                                context,
                              );

                              return;
                            }

                          } else {

                            if (!PermissionExtensions.canAccess(
                                PermissionKeys.addSubject)) {

                              Utils.show(
                                "You don't have permission to add subject",
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
                            await listVm.allSubjectsApi(context); // ✅ AUTO REFRESH
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
