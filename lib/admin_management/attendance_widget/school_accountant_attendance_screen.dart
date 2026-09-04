import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import 'package:school_pro/view_model/accountant_attendance_view_model/accountant_attendance_view_model.dart';
import 'package:school_pro/view_model/accountant_attendance_view_model/create_accountant_attendance_view_model.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_button.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/attendance/update_accountant_aatendance_view_model.dart';

class _AccountantRow {
  final String id;
  final String name;
  final String qualification;
  final String activeStatus;
  String? attendanceStatus;
  String? attendanceId;
  bool alreadyMarked = false;
  bool isEditing = false;
  final TextEditingController remarksCtrl;

  _AccountantRow({
    required this.id,
    required this.name,
    required this.qualification,
    required this.activeStatus,
    this.attendanceStatus,
    this.alreadyMarked = false,
    this.isEditing = false,
  }) : remarksCtrl = TextEditingController();

  void dispose() => remarksCtrl.dispose();
}

class SchoolAccountantAttendanceScreen extends StatefulWidget {
  const SchoolAccountantAttendanceScreen({super.key});

  @override
  State<SchoolAccountantAttendanceScreen> createState() =>
      _SchoolAccountantAttendanceScreenState();
}

class _SchoolAccountantAttendanceScreenState
    extends State<SchoolAccountantAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  List<_AccountantRow> _rows = [];
  bool _saving = false;

  String get _apiDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
  String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);

  static const _statuses = [
    {'code': 'P', 'full': 'status_present'},
    {'code': 'A', 'full': 'status_absent'},
    {'code': 'L', 'full': 'status_late'},
    {'code': 'H', 'full': 'status_half_day'},
    {'code': 'OL', 'full': 'status_on_leave'},
  ];

  Color _statusColor(String? code) {
    switch (code) {
      case 'P':  return const Color(0xFF22C55E);
      case 'A':  return const Color(0xFFEF4444);
      case 'L':  return const Color(0xFFF59E0B);
      case 'H':  return const Color(0xFF3B82F6);
      case 'OL': return const Color(0xFFA855F7);
      default:   return Colors.grey;
    }
  }

  String _statusLabel(String? code) {
    switch (code) {
      case 'P':  return 'accountant_attendance.status_present'.tr();
      case 'A':  return 'accountant_attendance.status_absent'.tr();
      case 'L':  return 'accountant_attendance.status_late'.tr();
      case 'H':  return 'accountant_attendance.status_half_day'.tr();
      case 'OL': return 'accountant_attendance.status_on_leave'.tr();
      default:   return code ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!PermissionExtensions.canAccess(PermissionKeys.viewAccountants)) {
        Utils.show('accountant_attendance.permission_view'.tr(), context);
        Navigator.pop(context);
        return;
      }
      await Provider.of<AllAccountantListVieModel>(context, listen: false)
          .allAccountantListApi(context);
      await _fetchAndApplyExisting();
    });
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchAndApplyExisting() async {
    await context
        .read<AccountantAttendanceViewModel>()
        .getAccountantAttendance(_apiDate);

    final existing = Provider.of<AccountantAttendanceViewModel>(
      context,
      listen: false,
    ).attendanceList;

    final Map<String, Map<String, String>> markedMap = {
      for (final r in existing)
        if (r.accountantId != null)
          r.accountantId.toString(): {
            'status': r.status ?? '',
            'attendanceId': r.attendanceId?.toString() ?? '',
          },
    };

    setState(() {
      for (final row in _rows) {
        if (markedMap.containsKey(row.id)) {
          row.alreadyMarked = true;
          row.isEditing = false;
          row.attendanceStatus = markedMap[row.id]!['status'];
          row.attendanceId = markedMap[row.id]!['attendanceId'];
        } else {
          row.alreadyMarked = false;
          row.isEditing = false;
          row.attendanceId = null;
        }
      }
    });
  }

  void _buildRows(List accountants) {
    if (_rows.length == accountants.length) return;
    for (final r in _rows) {
      r.dispose();
    }
    _rows = accountants
        .map(
          (a) => _AccountantRow(
        id: a.accountantId.toString(),
        name: a.name ?? '',
        qualification: a.qualification ?? '',
        activeStatus: (a.status == 1)
            ? 'accountant_attendance.active'.tr()
            : 'accountant_attendance.inactive'.tr(),
      ),
    )
        .toList();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      await _fetchAndApplyExisting();
    }
  }

  Future<void> _onRefresh() async {
    for (final r in _rows) r.dispose();
    _rows = [];
    await Provider.of<AllAccountantListVieModel>(context, listen: false)
        .allAccountantListApi(context);
    await _fetchAndApplyExisting();
  }

  Future<void> _saveAll() async {
    if (!PermissionExtensions.canAccess(PermissionKeys.markTeacherAttendance)) {
      Utils.show('accountant_attendance.permission_mark'.tr(), context);
      return;
    }
    final pending = _rows.where((r) => !r.alreadyMarked).toList();

    if (pending.isEmpty) {
      Utils.show('accountant_attendance.attendance_already_marked'.tr(), context);
      return;
    }

    final incomplete = pending.where((r) => r.attendanceStatus == null);
    if (incomplete.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'accountant_attendance.status_not_selected'.tr(
            namedArgs: {'count': incomplete.length.toString()}
        ),
        Colors.orange,
        Icons.warning_rounded,
      ));
      return;
    }

    setState(() => _saving = true);
    int successCount = 0;

    final createVm = Provider.of<CreateAccountantAttendanceViewModel>(
      context,
      listen: false,
    );

    for (final row in pending) {
      final ok = await createVm.createAccountantAttendanceApi(
        int.parse(row.id),
        _apiDate,
        row.attendanceStatus!,
        row.remarksCtrl.text.trim(),
        context,
      );
      if (ok) {
        successCount++;
        setState(() {
          row.alreadyMarked = true;
          row.isEditing = false;
        });
      }
    }

    setState(() => _saving = false);
    if (!mounted) return;

    if (successCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'accountant_attendance.saved_success'.tr(
            namedArgs: {
              'saved': successCount.toString(),
              'total': pending.length.toString()
            }
        ),
        Colors.green,
        Icons.check_circle_rounded,
      ));
    }
  }

  Future<void> _updateAttendance(_AccountantRow row, StateSetter setRow) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.markTeacherAttendance)) {
      Utils.show('accountant_attendance.permission_update'.tr(), context);
      return;
    }
    if (row.attendanceStatus == null) {
      Utils.show('accountant_attendance.please_select_status'.tr(), context);
      return;
    }

    if (row.attendanceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'accountant_attendance.attendance_id_not_found'.tr(),
        Colors.red,
        Icons.error_rounded,
      ));
      return;
    }

    setState(() => _saving = true);

    final updateVm = Provider.of<UpdateAccountantAttendanceViewModel>(
      context,
      listen: false,
    );

    final ok = await updateVm.updateAccountantAttendanceApi(
      int.parse(row.attendanceId!),
      row.attendanceStatus!,
      row.remarksCtrl.text.trim(),
      context,
    );

    setState(() => _saving = false);

    if (ok) {
      setRow(() {
        row.alreadyMarked = true;
        row.isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_snack(
          'accountant_attendance.update_success'.tr(),
          Colors.green,
          Icons.check_circle_rounded,
        ));
      }
    }
  }

  SnackBar _snack(String msg, Color color, IconData icon) => SnackBar(
    content: Row(children: [
      Icon(icon, color: Colors.white, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(msg)),
    ]),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<AllAccountantListVieModel>(
              builder: (context, vm, _) {
                if (vm.loading ?? false) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColor.lightBlueColor),
                  );
                }

                final accountants = vm.allAccountantListModel?.data ?? [];
                if (accountants.isEmpty) {
                  return Center(
                    child: AppText.customText(
                        'accountant_attendance.no_accountants_found'.tr(),
                        size: 16,
                        weight: FontWeight.bold
                    ),
                  );
                }

                _buildRows(accountants);

                final alreadyCount =
                    _rows.where((r) => r.alreadyMarked).length;
                final pendingCount = _rows.length - alreadyCount;

                return Column(
                  children: [
                    _buildCountBar(alreadyCount, pendingCount),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppColor.lightBlueColor,
                        backgroundColor: Colors.white,
                        strokeWidth: 2.5,
                        child: ListView.builder(
                          padding:
                          const EdgeInsets.fromLTRB(16, 4, 16, 120),
                          itemCount: _rows.length,
                          itemBuilder: (_, i) => _buildRow(_rows[i]),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Consumer<AllAccountantListVieModel>(
        builder: (context, vm, _) {
          final accountants = vm.allAccountantListModel?.data ?? [];
          _buildRows(accountants);
          final hasPending = _rows.any((r) => !r.alreadyMarked);
          if (!hasPending) return const SizedBox();

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              title: _saving
                  ? 'accountant_attendance.saving'.tr()
                  : 'accountant_attendance.save_all_attendance'.tr(),
              icon: _saving
                  ? null
                  : Icons.save_rounded,
              height: 56,
              radius: 16,
              loading: _saving,
              onTap: _saveAll,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: AppColor.blueShadow,
              blurRadius: 18,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColor.glassWhite, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText.customText(
                  'accountant_attendance.title'.tr(),
                  size: 19,
                  weight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ]),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.calendar_month_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                            'accountant_attendance.selected_date'.tr(),
                            size: 11,
                            color: Colors.white70
                        ),
                        AppText.customText(_displayDate,
                            size: 15,
                            weight: FontWeight.bold,
                            color: Colors.white),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Icon(Icons.edit_calendar_rounded,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    AppText.customText(
                        'accountant_attendance.change'.tr(),
                        size: 11,
                        color: Colors.white
                    ),
                  ]),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 14),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statuses.map((s) {
                final code = s['code']!;
                final color = _statusColor(code);
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text('$code = ${_statusLabel(code)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBar(int alreadyCount, int pendingCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(children: [
        if (alreadyCount > 0) ...[
          _countPill(
              'accountant_attendance.already_marked_count'.tr(
                  namedArgs: {'count': alreadyCount.toString()}
              ),
              Colors.green,
              Icons.check_circle_rounded
          ),
          const SizedBox(width: 8),
        ],
        if (pendingCount > 0)
          _countPill(
              'accountant_attendance.pending_count'.tr(
                  namedArgs: {'count': pendingCount.toString()}
              ),
              Colors.orange,
              Icons.pending_rounded
          ),
      ]),
    );
  }

  Widget _countPill(String label, Color color, IconData icon) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _buildRow(_AccountantRow row) {
    if (!row.alreadyMarked && row.attendanceStatus == null) {
      row.attendanceStatus = _statuses.first['code'];
    }

    return StatefulBuilder(builder: (context, setRow) {
      final isLocked = row.alreadyMarked && !row.isEditing;

      final borderColor = row.isEditing
          ? AppColor.lightBlueColor.withOpacity(0.5)
          : isLocked
          ? Colors.green.withOpacity(0.4)
          : (row.attendanceStatus != null
          ? _statusColor(row.attendanceStatus).withOpacity(0.3)
          : Colors.grey.shade200);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: row.isEditing
              ? AppColor.lightBlueColor.withOpacity(0.02)
              : isLocked
              ? Colors.green.withOpacity(0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: AppColor.cardShadow,
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: row.isEditing
                          ? AppColor.lightBlueColor.withOpacity(0.15)
                          : isLocked
                          ? Colors.green.withOpacity(0.12)
                          : AppColor.lightBlueColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        row.name.isNotEmpty
                            ? row.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: row.isEditing
                              ? AppColor.lightBlueColor
                              : isLocked
                              ? Colors.green
                              : AppColor.lightBlueColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.customText(
                            row.name.isNotEmpty
                                ? row.name[0].toUpperCase() +
                                row.name.substring(1)
                                : '',
                            size: 13,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(height: 2),
                          AppText.customText(
                              'accountant_attendance.id_label'.tr(
                                  namedArgs: {'id': row.id}
                              ),
                              size: 11,
                              color: AppColor.softGreyText
                          ),
                        ]),
                  ),

                  Expanded(
                    flex: 2,
                    child: AppText.customText(row.qualification,
                        size: 12, color: AppColor.softGreyText),
                  ),

                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _pill(row.activeStatus, Colors.green),

                        if (isLocked) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(row.attendanceStatus)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _statusColor(row.attendanceStatus)
                                      .withOpacity(0.4)),
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_rounded,
                                      size: 10,
                                      color: _statusColor(
                                          row.attendanceStatus)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${_statusLabel(row.attendanceStatus)} • ${'accountant_attendance.marked'.tr()}',
                                    style: TextStyle(
                                      color: _statusColor(
                                          row.attendanceStatus),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              if (!PermissionExtensions.canAccess(
                                  PermissionKeys.markTeacherAttendance)) {
                                Utils.show(
                                  'accountant_attendance.permission_edit'.tr(),
                                  context,
                                );
                                return;
                              }
                              setRow(() => row.isEditing = true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.lightBlueColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColor.lightBlueColor
                                        .withOpacity(0.4)),
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        size: 10,
                                        color: AppColor.lightBlueColor),
                                    const SizedBox(width: 3),
                                    Text(
                                      'accountant_attendance.edit'.tr(),
                                      style: TextStyle(
                                          color: AppColor.lightBlueColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ]),
                            ),
                          ),
                        ],

                        if (row.isEditing) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                              AppColor.lightBlueColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColor.lightBlueColor
                                      .withOpacity(0.4)),
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_rounded,
                                      size: 10,
                                      color: AppColor.lightBlueColor),
                                  const SizedBox(width: 3),
                                  Text(
                                    'accountant_attendance.editing'.tr(),
                                    style: TextStyle(
                                        color: AppColor.lightBlueColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => setRow(() {
                              row.isEditing = false;
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.red.withOpacity(0.4)),
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.close_rounded,
                                        size: 10, color: Colors.red),
                                    const SizedBox(width: 3),
                                    Text(
                                      'accountant_attendance.cancel'.tr(),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ]),
                ]),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    AppText.customText(
                        'accountant_attendance.attendance_status'.tr(),
                        size: 10,
                        weight: FontWeight.bold,
                        color: AppColor.softGreyText
                    ),
                    if (row.isEditing) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.lightBlueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'accountant_attendance.edit_mode'.tr(),
                          style: TextStyle(
                              color: AppColor.lightBlueColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: _statuses.map((s) {
                      final code = s['code']!;
                      final selected = row.attendanceStatus == code;
                      final color = _statusColor(code);
                      return Expanded(
                        child: GestureDetector(
                          onTap: isLocked
                              ? null
                              : () => setRow(() => row.attendanceStatus =
                          selected ? null : code),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 6),
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withOpacity(0.15)
                                  : (isLocked
                                  ? Colors.grey.shade100
                                  : Colors.grey.shade50),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: selected
                                      ? color
                                      : Colors.grey.shade200,
                                  width: selected ? 1.5 : 1),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: selected
                                              ? color
                                              : Colors.grey.shade400,
                                          width: 1.5),
                                    ),
                                    child: selected
                                        ? Center(
                                        child: Container(
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: color)))
                                        : null,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(code,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: selected
                                            ? color
                                            : (isLocked
                                            ? Colors.grey.shade400
                                            : AppColor.softGreyText),
                                      )),
                                ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
            child: TextField(
              controller: row.remarksCtrl,
              enabled: !isLocked,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                hintText: isLocked
                    ? 'accountant_attendance.already_marked'.tr()
                    : row.isEditing
                    ? 'accountant_attendance.update_remarks'.tr()
                    : 'accountant_attendance.enter_remarks'.tr(),
                hintStyle: TextStyle(
                    color: isLocked
                        ? Colors.green.withOpacity(0.6)
                        : AppColor.softGreyText,
                    fontSize: 12),
                filled: true,
                fillColor: row.isEditing
                    ? AppColor.lightBlueColor.withOpacity(0.04)
                    : isLocked
                    ? Colors.green.withOpacity(0.05)
                    : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                prefixIcon: isLocked
                    ? const Icon(Icons.lock_rounded,
                    size: 14, color: Colors.green)
                    : row.isEditing
                    ? Icon(Icons.edit_note_rounded,
                    size: 14, color: AppColor.lightBlueColor)
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: row.isEditing
                            ? AppColor.lightBlueColor.withOpacity(0.3)
                            : Colors.grey.shade200)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.2))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: AppColor.lightBlueColor, width: 1.5)),
              ),
            ),
          ),

          if (row.isEditing)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _saving
                      ? null
                      : () => _updateAttendance(row, setRow),
                  icon: _saving
                      ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_rounded,
                      color: Colors.white, size: 18),
                  label: Text(
                    _saving
                        ? 'accountant_attendance.saving'.tr()
                        : 'accountant_attendance.update_attendance'.tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.lightBlueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
        ]),
      );
    });
  }

  Widget _pill(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600)),
  );
}