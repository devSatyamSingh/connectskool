import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/school_model/user_permission_model.dart';
import '../model/school_model/user_role_model.dart';
import '../utils/permission_error_message.dart';
import '../utils/permission_keys.dart';
import '../view_model/school_view_model/save_permission_view_model.dart';
import '../view_model/school_view_model/user_permission_view_model.dart';
import '../view_model/school_view_model/user_role_view_model.dart';

// ─── Colors ──────────────────────────────────────────────────────────────────

const _accent = Color(0xFF2563EB);
const _accentLight = Color(0xFFEFF6FF);
final _primaryGrad = const LinearGradient(
  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const _screenBg = Color(0xFFF1F5F9);
const _white = Colors.white;
const _textDark = Color(0xFF0F172A);
const _textMid = Color(0xFF64748B);
const _textLight = Color(0xFF94A3B8);
const _divider = Color(0xFFE2E8F0);
const _greenAllow = Color(0xFF16A34A);
const _greenBg = Color(0xFFF0FDF4);
const _redDeny = Color(0xFFDC2626);
const _redBg = Color(0xFFFEF2F2);
const _shadowColor = Color(0xFFCBD5E1);

// ─── Screen ───────────────────────────────────────────────────────────────────

class UserPermissionsScreen extends StatefulWidget {
  const UserPermissionsScreen({super.key});

  @override
  State<UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  String _selectedRole = 'student';

  // ── Role options matching the screenshot ─────────────────────────────
  final List<Map<String, dynamic>> _roles = [
    {'key': 'teacher', 'label': 'Teacher', 'icon': Icons.person_rounded},
    {'key': 'student', 'label': 'Student', 'icon': Icons.school_rounded},
    {
      'key': 'accountant',
      'label': 'Accountant',
      'icon': Icons.account_balance_rounded,
    },
  ];


  @override
  void initState() {
    super.initState();
    final usersVm = Provider.of<GetUsersByRoleViewModel>(
      context,
      listen: false,
    );

    if (usersVm.users.isEmpty) {
      Future.microtask(() => _fetchUsersByRole(_selectedRole));
    }
  }

  void _fetchUsersByRole(String role) async {
    // if (!PermissionGuard.check(
    //   context,
    //   PermissionKeys.managePermissions,
    //   "Manage Permissions",
    // )) {
    //   return;
    // }
    setState(() => _selectedRole = role);

    final usersVm = Provider.of<GetUsersByRoleViewModel>(
      context,
      listen: false,
    );
    await usersVm.getUsersByRoleApi(context: context, role: role);

    if (usersVm.selectedUser != null) {
      _fetchPermissions(usersVm);
    }
  }

  // ─── Step 2: Fetch permissions for selected user ──────────────────────

  void _fetchPermissions(GetUsersByRoleViewModel usersVm) {
    final userId =
        int.tryParse(usersVm.selectedUser?.userId?.toString() ?? '0') ?? 0;

    Provider.of<GetUserPermissionViewModel>(
      context,
      listen: false,
    ).getUserPermissionApi(
      context: context,
      userId: userId,
      role: _selectedRole,
      isCurrentUser: false,
    );
  }

  // ─── User dropdown changed ────────────────────────────────────────────

  void _onUserChanged(UserByRole user) {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.managePermissions,
      "Manage Permissions",
    )) {
      return;
    }
    final usersVm = Provider.of<GetUsersByRoleViewModel>(
      context,
      listen: false,
    );
    usersVm.setSelectedUser(user);
    _fetchPermissions(usersVm);
  }

  // ─── Reset ────────────────────────────────────────────────────────────

  void _resetAll() => Provider.of<GetUserPermissionViewModel>(
    context,
    listen: false,
  ).resetAll();


  void _saveChanges() async {
    // ✅ Pattern A - Button click guard
    if (!PermissionGuard.check(
      context,
      PermissionKeys.managePermissions,
      "Manage Permissions",
    )) {
      return;
    }

    final permVm = Provider.of<GetUserPermissionViewModel>(
      context,
      listen: false,
    );

    final usersVm = Provider.of<GetUsersByRoleViewModel>(
      context,
      listen: false,
    );

    final saveVm = Provider.of<SaveUserPermissionViewModel>(
      context,
      listen: false,
    );

    final userId =
        int.tryParse(usersVm.selectedUser?.userId?.toString() ?? '0') ?? 0;

    bool success = await saveVm.saveUserPermissionApi(
      context: context,
      userId: userId,
      permissionStateMap: permVm.permissionStateMap,
    );

    if (success) {
      // fresh reload after save
      await permVm.getUserPermissionApi(
        context: context,
        userId: userId,
        role: _selectedRole,
        isCurrentUser: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save permissions")),
      );
    }
  } // ─── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: _screenBg,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer2<GetUsersByRoleViewModel, GetUserPermissionViewModel>(
                builder: (context, usersVm, permVm, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Page subtitle ─────────────────────────────
                        const Text(
                          'Manage individual user permission overrides on top of their role',
                          style: TextStyle(fontSize: 12.5, color: _textMid),
                        ),
                        const SizedBox(height: 16),

                        // ── Role Dropdown ─────────────────────────────
                        _buildLabel('SELECT ROLE'),
                        const SizedBox(height: 6),
                        _buildRoleDropdown(),
                        const SizedBox(height: 14),

                        // ── User Dropdown ─────────────────────────────
                        _buildLabel('SELECT USER'),
                        const SizedBox(height: 6),
                        _buildUserDropdown(usersVm),
                        const SizedBox(height: 18),

                        // ── Permissions + Summary ─────────────────────
                        _buildBody(usersVm, permVm),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 20),
      decoration: BoxDecoration(
        gradient: _primaryGrad,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Permissions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Settings  ›  User Permissions',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Save button in header
          GestureDetector(
            onTap: _saveChanges,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: _accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Label ────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: _textMid,
        letterSpacing: 0.6,
      ),
    );
  }

  // ─── Role Dropdown ────────────────────────────────────────────────────

  Widget _buildRoleDropdown() {
    final current = _roles.firstWhere(
      (r) => r['key'] == _selectedRole,
      orElse: () => _roles.first,
    );

    return _dropdownContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          dropdownColor: _white,
          iconEnabledColor: _accent,
          style: const TextStyle(
            color: _textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          selectedItemBuilder: (_) => _roles.map((r) {
            return Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: _accentLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(r['icon'] as IconData, size: 14, color: _accent),
                ),
                const SizedBox(width: 10),
                Text(
                  r['label'] as String,
                  style: const TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) _fetchUsersByRole(val);
          },
          items: _roles.map((r) {
            final isSelected = r['key'] == _selectedRole;
            return DropdownMenuItem<String>(
              value: r['key'] as String,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        r['icon'] as IconData,
                        size: 16,
                        color: isSelected ? _white : _textMid,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        r['label'] as String,
                        style: TextStyle(
                          color: isSelected ? _white : _textDark,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── User Dropdown ────────────────────────────────────────────────────

  Widget _buildUserDropdown(GetUsersByRoleViewModel usersVm) {
    if (usersVm.loading) {
      return _dropdownContainer(
        child: const SizedBox(
          height: 44,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: _accent),
            ),
          ),
        ),
      );
    }

    if (usersVm.users.isEmpty) {
      return _dropdownContainer(
        child: Row(
          children: [
            const Icon(Icons.person_off_rounded, color: _textLight, size: 16),
            const SizedBox(width: 8),
            Text(
              'No users found for this role',
              style: const TextStyle(color: _textMid, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdownContainer(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserByRole>(
              value: usersVm.selectedUser,
              isExpanded: true,
              dropdownColor: _white,
              iconEnabledColor: _accent,
              style: const TextStyle(
                color: _textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              selectedItemBuilder: (_) => usersVm.users.map((u) {
                final initial = (u.name?.isNotEmpty == true)
                    ? u.name![0].toUpperCase()
                    : '?';
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: _accentLight,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: _accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      u.name?.toString() ?? '',
                      style: const TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }).toList(),
              onChanged: (user) {
                if (user != null) _onUserChanged(user);
              },
              items: usersVm.users.map((u) {
                final initial = (u.name?.isNotEmpty == true)
                    ? u.name![0].toUpperCase()
                    : '?';
                return DropdownMenuItem<UserByRole>(
                  value: u,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: _accentLight,
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: _accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u.name?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: _textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (u.userEmail != null)
                            Text(
                              u.userEmail.toString(),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: _textLight,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (usersVm.selectedUser?.userEmail != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              usersVm.selectedUser!.userEmail.toString(),
              style: const TextStyle(fontSize: 11, color: _textLight),
            ),
          ),
        ],
      ],
    );
  }

  // ─── Dropdown Container helper ────────────────────────────────────────

  Widget _dropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _divider),
        boxShadow: [
          BoxShadow(
            color: _shadowColor.withOpacity(0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────

  Widget _buildBody(
    GetUsersByRoleViewModel usersVm,
    GetUserPermissionViewModel permVm,
  ) {
    if (usersVm.loading || permVm.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: _accent),
        ),
      );
    }

    if (permVm.model == null || permVm.sections.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_open_rounded, size: 48, color: _textLight),
              const SizedBox(height: 12),
              Text(
                'No permissions found',
                style: const TextStyle(color: _textMid, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Count stats
    int totalCount = 0;
    int allowedCount = 0;
    int deniedCount = 0;
    for (final s in permVm.sections) {
      for (final item in permVm.getItemsForSection(s)) {
        totalCount++;
        final st = permVm.getState(item.permissionId ?? 0);
        if (st == 'allowed') allowedCount++;
        if (st == 'denied') deniedCount++;
      }
    }
    final defaultCount = totalCount - allowedCount - deniedCount;

    return Column(
      children: [
        // ── Permissions Summary Card ──────────────────────────────────
        _buildSummaryCard(totalCount, allowedCount, deniedCount, defaultCount),
        const SizedBox(height: 16),

        // ── Permission sections ───────────────────────────────────────
        ...permVm.sections.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSectionCard(permVm, s),
          ),
        ),

        // ── Footer buttons ────────────────────────────────────────────
        _buildFooter(),
      ],
    );
  }

  // ─── Summary Card ─────────────────────────────────────────────────────

  Widget _buildSummaryCard(int total, int allowed, int denied, int def) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Permissions Summary',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Total', total, const Color(0xFF2563EB), total, total),
          const SizedBox(height: 8),
          _summaryRow('Allowed', allowed, _greenAllow, allowed, total),
          const SizedBox(height: 8),
          _summaryRow('Denied', denied, _redDeny, denied, total),
          const SizedBox(height: 8),
          _summaryRow('Default (Role)', def, _textLight, def, total),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, int count, Color color, int value, int max) {
    final pct = max == 0 ? 0.0 : value / max;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12.5, color: _textMid),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: _divider,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  // ─── Section Card ──────────────────────────────────────────────────────

  Widget _buildSectionCard(GetUserPermissionViewModel vm, String section) {
    final items = vm.getItemsForSection(section);
    return _card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _accentLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_sectionIcon(section), size: 16, color: _accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        section.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _screenBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${items.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: _textMid,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Select All
                GestureDetector(
                  onTap: () => vm.selectAllInSection(section, 'allowed'),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          border: Border.all(color: _divider, width: 1.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Select All',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _textMid,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: _divider, height: 1),
          ...items.map((item) => _buildPermRow(vm, item)),
        ],
      ),
    );
  }

  // ─── Permission Row ───────────────────────────────────────────────────

  Widget _buildPermRow(GetUserPermissionViewModel vm, PermissionItem item) {
    final permId = item.permissionId ?? 0;
    final currentState = vm.getState(permId);

    // dot color
    Color dotColor;
    if (currentState == 'allowed')
      dotColor = _greenAllow;
    else if (currentState == 'denied')
      dotColor = _redDeny;
    else
      dotColor = _divider;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Status dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Key + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.key ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    if ((item.description ?? '').isNotEmpty)
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _textLight,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Allowed / Denied / Default buttons
              Row(
                children: [
                  _permBtn(
                    'Allowed',
                    currentState == 'allowed',
                    _greenAllow,
                    _greenBg,
                    () => vm.updatePermissionState(
                      permId,
                      currentState == 'allowed' ? 'default' : 'allowed',
                    ),
                  ),
                  const SizedBox(width: 5),
                  _permBtn(
                    'Denied',
                    currentState == 'denied',
                    _redDeny,
                    _redBg,
                    () => vm.updatePermissionState(
                      permId,
                      currentState == 'denied' ? 'default' : 'denied',
                    ),
                  ),
                  const SizedBox(width: 5),
                  _permBtn(
                    'Default',
                    currentState == 'default',
                    _accent,
                    _accentLight,
                    () => vm.updatePermissionState(permId, 'default'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: _divider, height: 1),
      ],
    );
  }

  Widget _permBtn(
    String label,
    bool active,
    Color activeColor,
    Color activeBg,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: active ? activeBg : _white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? activeColor.withOpacity(0.5) : _divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? activeColor : _textMid,
          ),
        ),
      ),
    );
  }

  // ─── Section icon ──────────────────────────────────────────────────────

  IconData _sectionIcon(String section) => switch (section) {
    'students' => Icons.school_rounded,
    'teachers' => Icons.person_rounded,
    'fees' || 'payments' => Icons.payments_rounded,
    'classes' || 'sections' => Icons.class_rounded,
    'subjects' => Icons.menu_book_rounded,
    'timetable' => Icons.schedule_rounded,
    'notices' => Icons.campaign_rounded,
    'homework' => Icons.assignment_rounded,
    'reports' => Icons.bar_chart_rounded,
    'settings' => Icons.settings_rounded,
    'notification' => Icons.notifications_rounded,
    'accountant' => Icons.account_balance_rounded,
    'school' => Icons.apartment_rounded,
    'teacher' => Icons.person_pin_rounded,
    'attendance' => Icons.fact_check_rounded,
    _ => Icons.lock_rounded,
  };

  // ─── Footer ───────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _resetAll,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: _divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.refresh_rounded,
                size: 15,
                color: _textMid,
              ),
              label: const Text(
                'Reset to Default',
                style: TextStyle(
                  color: _textMid,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: _primaryGrad,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.save_rounded, size: 15, color: _white),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: _white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Card helper ──────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _shadowColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
