import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/school_view_model/permission/assign_role_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_error_message.dart';
import '../../utils/permission_keys.dart';
import '../../view_model/school_view_model/permission/remove_role_viewmodel.dart';
import '../../view_model/school_view_model/permission/select_role_view_model.dart';

class RolePermissionScreen extends StatefulWidget {
  const RolePermissionScreen({super.key});

  @override
  State<RolePermissionScreen> createState() => _RolePermissionScreenState();
}

class _RolePermissionScreenState extends State<RolePermissionScreen> {
  String selectedRole = "teacher";

  Map<int, bool> permissionLoading = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vm = Provider.of<SelectRoleViewModel>(context, listen: false);
      if (vm.permissionState.isEmpty) {
        await vm.loadRolePermissions(context, selectedRole);
      }
    });
  }

  void changeRole(String role) async {
    selectedRole = role;
    setState(() {});
    final vm = Provider.of<SelectRoleViewModel>(context, listen: false);
    await vm.loadRolePermissions(context, role);
  }

  String formatTitle(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (e) => e[0].toUpperCase() + e.substring(1),
    )
        .join(' ');
  }

  String getPermissionKey(int id) {
    final vm = Provider.of<SelectRoleViewModel>(context, listen: false);
    return vm.permissionDetails[id]?.key ?? "";
  }

  String getPermissionDescription(int id) {
    final vm = Provider.of<SelectRoleViewModel>(context, listen: false);
    return vm.permissionDetails[id]?.description ?? "";
  }

  Future<void> onPermissionTap(
      String section,
      int permId,
      bool newValue,
      ) async {
    permissionLoading[permId] = true;
    setState(() {});

    bool success = false;

    if (newValue) {
      success = await Provider.of<AssignRoleViewModel>(
        context,
        listen: false,
      ).assignRoleApi(context, selectedRole, [permId]);
    } else {
      success = await Provider.of<RemoveRoleViewModel>(
        context,
        listen: false,
      ).removeRoleApi(context, selectedRole, [permId]);
    }

    if (success) {
      final vm = Provider.of<SelectRoleViewModel>(context, listen: false);
      vm.permissionState[section]![permId] = newValue;
      vm.notifyListeners();
    }

    permissionLoading[permId] = false;
    setState(() {});
  }

  void callAssignApi() {
    final roleVM = Provider.of<SelectRoleViewModel>(context, listen: false);

    List<int> selectedIds = [];

    roleVM.permissionState.forEach((section, perms) {
      perms.forEach((id, selected) {
        if (selected) selectedIds.add(id);
      });
    });

    Provider.of<AssignRoleViewModel>(
      context,
      listen: false,
    ).assignRoleApi(context, selectedRole, selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.screenBg,
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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText.customText(
                      'role_permission.title'.tr(),
                      size: 19,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<SelectRoleViewModel>(
                builder: (context, vm, child) {
                  if (vm.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.permissionState.isEmpty) {
                    return Center(
                      child: Text('role_permission.no_permissions'.tr()),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      SizedBox(
                        height: screenHeight * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            roleChip("teacher"),
                            roleChip("student"),
                            roleChip("accountant"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(12),
                          children: vm.permissionState.entries.map((
                              sectionEntry,
                              ) {
                            String section = sectionEntry.key;

                            Map<int, bool> permissions = sectionEntry.value;

                            int selectedCount = permissions.values
                                .where((e) => e)
                                .length;

                            int totalCount = permissions.length;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// HEADER
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEEF4FF),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.admin_panel_settings_outlined,
                                            color: Color(0xff357ABD),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formatTitle(section),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'role_permission.permissions_selected'.tr()
                                                    .replaceAll('{count}', '$selectedCount')
                                                    .replaceAll('{total}', '$totalCount'),
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                child: LinearProgressIndicator(
                                                  value: totalCount == 0
                                                      ? 0
                                                      : selectedCount /
                                                      totalCount,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                  Colors.grey.shade200,
                                                  valueColor:
                                                  const AlwaysStoppedAnimation(
                                                    Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(color: Colors.grey.shade200, height: 1),

                                  /// PERMISSIONS
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      children: permissions.entries.map((
                                          permEntry,
                                          ) {
                                        int permId = permEntry.key;
                                        bool value = permEntry.value;

                                        bool loading =
                                            permissionLoading[permId] == true;

                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: value
                                                ? const Color(0xffF5F8FF)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            border: Border.all(
                                              color: value
                                                  ? const Color(0xff357ABD)
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              loading
                                                  ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                                  : SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Checkbox(
                                                  value: value,
                                                  activeColor: const Color(
                                                    0xff357ABD,
                                                  ),
                                                  checkColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      6,
                                                    ),
                                                  ),
                                                  side: BorderSide(
                                                    color: Colors
                                                        .grey
                                                        .shade400,
                                                  ),
                                                  onChanged: (val) {
                                                    onPermissionTap(
                                                      section,
                                                      permId,
                                                      val ?? false,
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getPermissionKey(permId),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      getPermissionDescription(
                                                        permId,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                        Colors.grey.shade600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roleChip(String role) {
    bool isSelected = selectedRole == role;

    final label = role == 'teacher' ? 'role_permission.teacher'.tr() :
    role == 'student' ? 'role_permission.student'.tr() :
    'role_permission.accountant'.tr();

    return GestureDetector(
      onTap: () => changeRole(role),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xff2563EB), Color(0xff3B82F6)],
          )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14
          ),
        ),
      ),
    );
  }
}