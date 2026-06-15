import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/model/school_model/all_student_list_model.dart';
import 'package:school_pro/model/school_model/transport_model/route_model.dart';
import 'package:school_pro/model/school_model/transport_model/stop_model.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_student_transport_fee_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/discontinue_student_view_model.dart';

import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/all_classes_view_model.dart';
import '../../view_model/school_view_model/all_scetions_view_model.dart';


class TransportFeeScreen extends StatefulWidget {
  const TransportFeeScreen({super.key});

  @override
  State<TransportFeeScreen> createState() => _TransportFeeScreenState();
}

class _TransportFeeScreenState extends State<TransportFeeScreen> {

  final List<String> academicYears = ["2026-27", "2025-26", "2024-25"];
  String? selectedRouteId;
  String? selectedAcademicYear;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ Academic years load karo
      final academicVm = Provider.of<AcademicViewModel>(context, listen: false);
      await academicVm.academicApi(context);

      // ✅ Current year auto-select karo
      if (academicVm.currentYear != null) {
        setState(() {
          selectedAcademicYear = academicVm.currentYear!.yearName;
        });
      } else if (academicVm.years.isNotEmpty) {
        setState(() {
          selectedAcademicYear = academicVm.years.first.yearName;
        });
      }

      // Routes load karo
      final routeVm = Provider.of<GetRouteViewModel>(context, listen: false);
      await routeVm.getRouteApi(context);

      final routes = routeVm.routeModel?.data ?? [];
      if (routes.isNotEmpty) {
        setState(() {
          selectedRouteId = routes.first.transportRouteId.toString();
        });
        _fetchStudents();
      }
    });
  }

  void _fetchStudents() {
    if (selectedRouteId == null || selectedAcademicYear == null) return; // ✅
    Provider.of<GetRouteStudentsViewModel>(context, listen: false)
        .getRouteStudentsApi(selectedRouteId!, selectedAcademicYear!, context);
  }
  void _openAssignSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TransportFeeFormSheet(),
    );
  }

  // ── Discontinue popup ────────────────────────────────────────────────────
  void _openDiscontinueDialog({
    required dynamic studentId,
    required String studentName,
    required String academicYear,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DiscontinueDialog(
        studentId: studentId,
        studentName: studentName,
        academicYear: academicYear,
        onSuccess: _fetchStudents, // refresh list after discontinue
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [

          // ── HEADER ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: AppColor.blueShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        'Transport Fee',
                        size: 19,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 2),
                      AppText.customText(
                        'Route-wise student fee overview',
                        size: 12,
                        weight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColor.glassWhite,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.directions_bus_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── FILTER ROW ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Consumer<GetRouteViewModel>(
                    builder: (context, routeVm, _) {
                      if (routeVm.loading) return _shimmerBox(height: 52);
                      final routes = routeVm.routeModel?.data ?? [];
                      return _buildStyledDropdown(
                        icon: Icons.route_rounded,
                        iconBg: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF4A6CF7),
                        hint: "Select Route",
                        value: selectedRouteId,
                        items: routes.map((r) {
                          return DropdownMenuItem(
                            value: r.transportRouteId.toString(),
                            child: Text(r.routeName ?? "",
                                overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() => selectedRouteId = v.toString());
                          _fetchStudents();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Expanded(
                //   flex: 2,
                //   child: _buildStyledDropdown(
                //     icon: Icons.calendar_today_rounded,
                //     iconBg: const Color(0xFFECFDF5),
                //     iconColor: const Color(0xFF059669),
                //     hint: "Year",
                //     value: selectedAcademicYear,
                //     items: academicYears.map((y) {
                //       return DropdownMenuItem(value: y, child: Text(y));
                //     }).toList(),
                //     onChanged: (v) {
                //       setState(() => selectedAcademicYear = v.toString());
                //       _fetchStudents();
                //     },
                //   ),
                // ),
                // PEHLE (hardcoded):
                // Expanded(
                //   flex: 2,
                //   child: _buildStyledDropdown(
                //     icon: Icons.calendar_today_rounded,
                //     iconBg: const Color(0xFFECFDF5),
                //     iconColor: const Color(0xFF059669),
                //     hint: "Year",
                //     value: selectedAcademicYear,
                //     items: academicYears.map((y) {
                //       return DropdownMenuItem(value: y, child: Text(y));
                //     }).toList(),
                //     onChanged: (v) {
                //       setState(() => selectedAcademicYear = v.toString());
                //       _fetchStudents();
                //     },
                //   ),
                // ),

// ✅ BAAD (dynamic from API):
                Expanded(
                  flex: 2,
                  child: Consumer<AcademicViewModel>(
                    builder: (context, academicVm, _) {
                      if (academicVm.loading) return _shimmerBox(height: 52);
                      final years = academicVm.years;
                      return _buildStyledDropdown(
                        icon: Icons.calendar_today_rounded,
                        iconBg: const Color(0xFFECFDF5),
                        iconColor: const Color(0xFF059669),
                        hint: "Year",
                        value: selectedAcademicYear,
                        items: years.map((y) {
                          return DropdownMenuItem(
                            value: y.yearName,
                            child: Text(y.yearName ?? ""),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() => selectedAcademicYear = v.toString());
                          _fetchStudents();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── STUDENT LIST ─────────────────────────────────────────
          Expanded(
            child: Consumer<GetRouteStudentsViewModel>(
              builder: (context, vm, _) {
                if (vm.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColor.primaryGradient.colors.first),
                  );
                }

                final students = vm.routeStudentsModel?.data ?? [];
                if (students.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final data = students[index];
                    final isPending =
                        (data.feeStatus ?? "").toLowerCase() == "pending";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // top info
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14, 14, 14, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4A6CF7),
                                        Color(0xFF6A3DE8)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _initials(data.studentName ?? ""),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.studentName ?? "",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1F2937)),
                                      ),
                                      const SizedBox(height: 5),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          _pill(
                                            "Adm: ${data.admissionNo ?? ''}",
                                            const Color(0xFFEEF2FF),
                                            const Color(0xFF4A6CF7),
                                          ),
                                          _pill(
                                            "${data.className ?? ''} ${data.sectionName ?? ''}",
                                            const Color(0xFFF3E8FF),
                                            const Color(0xFF7C3AED),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _statusBadge(
                                    data.feeStatus ?? "", isPending),
                              ],
                            ),
                          ),

                          // stop row
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    size: 16, color: Color(0xFFF57C00)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data.stopName ?? "—",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF92400E),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // fee summary
                          Container(
                            margin:
                            const EdgeInsets.fromLTRB(14, 0, 14, 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade100, width: 1),
                            ),
                            child: Row(
                              children: [
                                _feeChip(
                                  label: "Assigned",
                                  amount: "₹${data.assignedAmount ?? 0}",
                                  color: const Color(0xFF374151),
                                ),
                                _verticalDivider(),
                                _feeChip(
                                  label: "Paid",
                                  amount: "₹${data.paidAmount ?? 0}",
                                  color: const Color(0xFF059669),
                                ),
                                _verticalDivider(),
                                _feeChip(
                                  label: "Pending",
                                  amount: "₹${data.pendingAmount ?? 0}",
                                  color: const Color(0xFFDC2626),
                                ),
                              ],
                            ),
                          ),

                          // ── ACTION BUTTONS ROW ──────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Row(
                              children: [
                                // Details button
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: open details
                                    },
                                    icon: const Icon(Icons.info_outline_rounded,
                                        size: 15),
                                    label: const Text("Details"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                      const Color(0xFF4A6CF7),
                                      side: const BorderSide(
                                          color: Color(0xFF4A6CF7),
                                          width: 1.2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // ── DISCONTINUE / STOP BUTTON ───────
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {

                                      if (!PermissionExtensions.canAccess(
                                          PermissionKeys.manageTransport)) {

                                        Utils.show(
                                          "You don't have permission to perform this action.",
                                          context,
                                        );

                                        return;
                                      }

                                      _openDiscontinueDialog(
                                        studentId: data.studentId,
                                        studentName:
                                        data.studentName ?? "Student",
                                        academicYear: selectedAcademicYear!,
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.stop_circle_outlined,
                                        size: 15),
                                    label: const Text("Discontinue"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFFFF4D6D),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          if (!PermissionExtensions.canAccess(
              PermissionKeys.manageTransport)) {

            Utils.show(
              "You don't have permission to perform this action.",
              context,
            );

            return;
          }

          _openAssignSheet();
        },
        backgroundColor: const Color(0xFF3F72FF),
        elevation: 6,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: AppText.customText(
          'Assign Transport',
          color: Colors.white,
          weight: FontWeight.bold,
          size: 14,
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "?";
  }

  Widget _buildStyledDropdown({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String hint,
    required String? value,
    required List<DropdownMenuItem> items,
    required ValueChanged onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton(
              value: value,
              hint: Text(hint,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500)),
              underline: const SizedBox(),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400, size: 20),
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF1F2937)),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _statusBadge(String status, bool isPending) {
    final color =
    isPending ? const Color(0xFFDC2626) : const Color(0xFF059669);
    final bg =
    isPending ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration:
              BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(status,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _feeChip({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(amount,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1,
    height: 32,
    color: Colors.grey.shade200,
  );

  Widget _shimmerBox({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14)),
      child: const Center(child: LinearProgressIndicator()),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF), shape: BoxShape.circle),
            child: const Icon(Icons.people_outline_rounded,
                size: 52, color: Color(0xFF4A6CF7)),
          ),
          const SizedBox(height: 20),
          const Text("No Students Found",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151))),
          const SizedBox(height: 8),
          Text(
            "Select a route and academic year\nto view transport fee details.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade500, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ─── Discontinue Dialog ───────────────────────────────────────────────────────

class _DiscontinueDialog extends StatefulWidget {
  final dynamic studentId;
  final String studentName;
  final String academicYear;
  final VoidCallback onSuccess;

  const _DiscontinueDialog({
    required this.studentId,
    required this.studentName,
    required this.academicYear,
    required this.onSuccess,
  });

  @override
  State<_DiscontinueDialog> createState() => _DiscontinueDialogState();
}

class _DiscontinueDialogState extends State<_DiscontinueDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discontinuedOnCtrl = TextEditingController();
  final TextEditingController _reasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // pre-fill today's date
    final now = DateTime.now();
    _discontinuedOnCtrl.text =
    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _discontinuedOnCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_discontinuedOnCtrl.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFFF57C00), onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _discontinuedOnCtrl.text =
      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = Provider.of<DiscontinueStudentViewModel>(context, listen: false);
    final success = await vm.discontinueStudentApi(
      widget.studentId,
      widget.academicYear,
      _discontinuedOnCtrl.text.trim(),
      _reasonCtrl.text.trim(),
      context,
    );

    if (success && mounted) {
      Navigator.pop(context);
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── HEADER ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF57C00), Color(0xFFFF9800)],
              ),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stop_circle_outlined,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Discontinue Transport",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15),
                      ),
                      Text(
                        widget.studentName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // ── FORM BODY ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFFFCC80), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            size: 16, color: Color(0xFFF57C00)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF7B4F00)),
                              children: [
                                TextSpan(text: "Transport will be "),
                                TextSpan(
                                  text: "discontinued",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFF57C00)),
                                ),
                                TextSpan(
                                    text:
                                    ", history will be preserved."),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Academic Year (read-only)
                  _fieldLabel("ACADEMIC YEAR"),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined,
                            size: 15, color: Color(0xFF6B7280)),
                        const SizedBox(width: 8),
                        Text(
                          widget.academicYear,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Discontinued On
                  _fieldLabel("DISCONTINUED ON", required: true),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _discontinuedOnCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Date is required'
                            : null,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937)),
                        decoration: _inputDecoration(
                          hint: 'YYYY-MM-DD',
                          suffixIcon: Icons.calendar_today_rounded,
                          suffixColor: const Color(0xFFF57C00),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Reason
                  _fieldLabel("REASON", required: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _reasonCtrl,
                    maxLines: 3,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Reason is required'
                        : null,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w500),
                    decoration: _inputDecoration(
                      hint:
                      'e.g. Student left school, Route changed...',
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Buttons
                  Consumer<DiscontinueStudentViewModel>(
                    builder: (context, vm, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: vm.loading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF57C00),
                                    Color(0xFFFF9800)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFFF57C00)
                                          .withOpacity(0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: vm.loading ? null : _confirm,
                                icon: vm.loading
                                    ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                )
                                    : const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: Colors.white),
                                label: Text(
                                  vm.loading ? "Please wait..." : "Confirm",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5),
        ),
        if (required)
          const Text(' *',
              style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 12)),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
          fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, size: 17, color: suffixColor)
          : null,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFF57C00), width: 1.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFFF4D6D), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFFF4D6D), width: 1.8)),
    );
  }
}

// ─── Bottom Sheet (Assign) — unchanged ───────────────────────────────────────

class _TransportFeeFormSheet extends StatefulWidget {
  const _TransportFeeFormSheet();

  @override
  State<_TransportFeeFormSheet> createState() =>
      _TransportFeeFormSheetState();
}

class _TransportFeeFormSheetState extends State<_TransportFeeFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _academicYearCtrl = TextEditingController();
  final TextEditingController _yearEndCtrl = TextEditingController();
  final TextEditingController _assignedOnCtrl = TextEditingController();
  String? _classId;
  String? _sectionId;
  String? _sectionError;
  StudentData? _selectedStudent;
  Data? _selectedRoute;
  StopData? _selectedStop;
  List<StopData> _filteredStops = [];
  String? _selectedAcademicYear;
  String? _selectedYearEnd;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllStudentListVieModel>(context, listen: false)
          .allStudentListApi(context);
      Provider.of<AllClassesViewModel>(context, listen: false).allClassesApi(context);
      Provider.of<GetRouteViewModel>(context, listen: false)
          .getRouteApi(context);
      final academicVm = Provider.of<AcademicViewModel>(context, listen: false);
      academicVm.academicApi(context).then((_) {
        if (academicVm.currentYear != null && mounted) {
          setState(() {
            _selectedAcademicYear = academicVm.currentYear!.yearName;
          });
        } else if (academicVm.years.isNotEmpty && mounted) {
          setState(() {
            _selectedAcademicYear = academicVm.years.first.yearName;
          });
        }
      });
    });

    final now = DateTime.now();
    _assignedOnCtrl.text =
    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _academicYearCtrl.dispose();
    _yearEndCtrl.dispose();
    _assignedOnCtrl.dispose();
    super.dispose();
  }

  void _onRouteChanged(Data? r) {
    setState(() {
      _selectedRoute = r;
      _selectedStop = null;
      _filteredStops = [];
    });
    if (r?.transportRouteId != null) {
      Provider.of<GetStopViewModel>(context, listen: false)
          .getStopApi(r!.transportRouteId.toString())
          .then((_) {
        final stops = Provider.of<GetStopViewModel>(context, listen: false)
            .stopModel
            .data ??
            [];
        setState(() => _filteredStops = stops);
      });
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(ctrl.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF3F72FF), onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text =
      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageTransport)) {

      Utils.show(
        "You don't have permission to perform this action.",
        context,
      );

      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null) {
      Utils.show('Please select a student', context);
      // _showError('Please select a student');
      return;
    }
    if (_selectedRoute == null) {
      Utils.show("Please select a route", context);
      // _showError('Please select a route');
      return;
    }
    if (_selectedStop == null) {
      Utils.show("Please select a stop", context);
      // _showError('Please select a stop');
      return;
    }

    final vm = Provider.of<CreateStudentTransportFeeViewModel>(
        context,
        listen: false);

    final success = await vm.createStudentTransportFeeApi(
      _selectedStudent!.studentId,
      _selectedRoute!.transportRouteId,
      _selectedStop!.transportRouteStopId,
      _academicYearCtrl.text.trim(),
      _yearEndCtrl.text.trim(),
      _assignedOnCtrl.text.trim(),
      context,
    );

    // if (success) Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFFF4D6D),
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Consumer3<CreateStudentTransportFeeViewModel, GetRouteViewModel,
        GetStopViewModel>(
      builder: (context, createVm, routeVm, stopVm, _) {
        final loading = createVm.loading;
        final routes = routeVm.routeModel?.data ?? [];
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF3F72FF),
                            Color(0xFF1A50D9),
                          ]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.directions_bus_rounded,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      AppText.customText(
                        'Assign Transport',
                        size: 17,
                        weight: FontWeight.w900,
                        color: const Color(0xFF1a2340),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Consumer2<AllClassesViewModel, AllSectionsViewModel>(
                    builder: (context, classVm, sectionVm, _) {
                      final allSections = sectionVm.allSectionsModel?.data ?? [];
                      return Row(
                        children: [
                          Expanded(
                            child: _label(
                              'Class *',
                              classVm.loading
                                  ? _buildPlaceholder('Loading...', showSpinner: true)
                                  : _sheetDrop(
                                hint: 'Select',
                                value: _classId,
                                items: (classVm.allClassesModel?.data ?? [])
                                    .map((c) => DropdownMenuItem(
                                    value: c.classId?.toString(),
                                    child: Text(c.className ?? '')))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _classId = v;
                                    _sectionId = null;
                                    _sectionError = null;
                                  });
                                  if (v != null) {
                                    Provider.of<AllSectionsViewModel>(context,
                                        listen: false)
                                        .allSectionsApi(context, v);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _label(
                              'Section *',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sheetDrop(
                                    hint: _classId != null && allSections.isEmpty
                                        ? '⚠ No sections'
                                        : 'Select',
                                    value: allSections.any(
                                            (s) => s.sectionId?.toString() == _sectionId)
                                        ? _sectionId
                                        : null,
                                    items: allSections
                                        .map((s) => DropdownMenuItem(
                                        value: s.sectionId?.toString(),
                                        child: Text(s.sectionName ?? '')))
                                        .toList(),
                                    onChanged: allSections.isEmpty
                                        ? null
                                        : (v) => setState(() {
                                      _sectionId = v;
                                      _sectionError = null;
                                    }),
                                    hasError: _sectionError != null,
                                    warningHint: _classId != null && allSections.isEmpty,
                                  ),
                                  if (_sectionError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 4),
                                      child: Text(_sectionError!,
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.red)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  _buildLabel('Student', Icons.person_rounded,
                      required: true),
                  const SizedBox(height: 6),
                  Consumer<AllStudentListVieModel>(
                    builder: (context, studentVm, _) {
                      final students =
                          studentVm.allStudentListModel?.data ?? [];
                      if (studentVm.loading) {
                        return _buildPlaceholder('Loading students...',
                            showSpinner: true);
                      }
                      if (students.isEmpty) {
                        return _buildPlaceholder('No students found');
                      }
                      return _buildSheetDropdown<StudentData>(
                        value: _selectedStudent,
                        hint: 'Select Student',
                        icon: Icons.person_rounded,
                        iconBg: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF3F72FF),
                        checkColor: const Color(0xFF3F72FF),
                        items: students,
                        itemLabel: (s) => s.name ?? '',
                        subLabel: (s) =>
                        s.admissionNo?.isNotEmpty == true
                            ? 'Adm: ${s.admissionNo}'
                            : '',
                        onChanged: (s) =>
                            setState(() => _selectedStudent = s),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('Route', Icons.route_rounded, required: true),
                  const SizedBox(height: 6),
                  routes.isEmpty
                      ? _buildPlaceholder('Loading routes...',
                      showSpinner: true)
                      : _buildSheetDropdown<Data>(
                    value: _selectedRoute,
                    hint: 'Select Route',
                    icon: Icons.route_rounded,
                    iconBg: const Color(0xFFEEF2FF),
                    iconColor: const Color(0xFF3F72FF),
                    checkColor: const Color(0xFF3F72FF),
                    items: routes,
                    itemLabel: (r) => r.routeName ?? '-',
                    subLabel: (r) => r.vehicleNo ?? '',
                    onChanged: _onRouteChanged,
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('Stop', Icons.location_on_rounded,
                      required: true),
                  const SizedBox(height: 6),
                  _selectedRoute == null
                      ? _buildPlaceholder('Select a route first')
                      : stopVm.loading
                      ? _buildPlaceholder('Loading stops...',
                      showSpinner: true)
                      : _filteredStops.isEmpty
                      ? _buildPlaceholder('No stops available')
                      : _buildSheetDropdown<StopData>(
                    value: _selectedStop,
                    hint: 'Select Stop',
                    icon: Icons.location_on_rounded,
                    iconBg: const Color(0xFFE6FAF7),
                    iconColor: const Color(0xFF00C9A7),
                    checkColor: const Color(0xFF00C9A7),
                    items: _filteredStops,
                    itemLabel: (s) => s.stopName ?? '-',
                    subLabel: (s) =>
                    (s.distanceKm?.isNotEmpty ?? false)
                        ? '${s.distanceKm} km'
                        : '',
                    onChanged: (s) =>
                        setState(() => _selectedStop = s),
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('Academic Year', Icons.school_rounded, required: true),
                  const SizedBox(height: 6),
                  Consumer<AcademicViewModel>(
                    builder: (context, academicVm, _) {
                      if (academicVm.loading) {
                        return _buildPlaceholder('Loading academic years...', showSpinner: true);
                      }
                      final years = academicVm.years;
                      if (years.isEmpty) {
                        return _buildPlaceholder('No academic years found');
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F5), width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedAcademicYear,
                            isExpanded: true,
                            hint: Text(
                              'Select Academic Year',
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            borderRadius: BorderRadius.circular(14),
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF8898c0)),
                            items: years.map((y) {
                              return DropdownMenuItem<String>(
                                value: y.yearName,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.calendar_today_rounded,
                                          size: 15, color: Color(0xFF059669)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      y.yearName ?? '',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1a2340)),
                                    ),
                                    const Spacer(),
                                    if (_selectedAcademicYear == y.yearName)
                                      const Icon(Icons.check_circle_rounded,
                                          size: 18, color: Color(0xFF059669)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => _selectedAcademicYear = v),
                          ),
                        ),
                      );
                    },
                  ),
                  // _FormField(
                  //   controller: _academicYearCtrl,
                  //   label: 'Academic Year',
                  //   hint: 'e.g. 2026-27',
                  //   icon: Icons.school_rounded,
                  //   required: true,
                  //   validator: (v) =>
                  //   (v == null || v.trim().isEmpty)
                  //       ? 'Academic year is required'
                  //       : null,
                  // ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          controller: _yearEndCtrl,
                          label: 'Year End Date',
                          required: true,
                          onTap: () => _pickDate(_yearEndCtrl),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateField(
                          controller: _assignedOnCtrl,
                          label: 'Assigned On',
                          required: true,
                          onTap: () => _pickDate(_assignedOnCtrl),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: loading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side:
                            BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14)),
                          ),
                          child: AppText.customText(
                            'Cancel',
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFF3F72FF),
                              Color(0xFF1A50D9),
                            ]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF3F72FF)
                                      .withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: loading ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14)),
                            ),
                            child: loading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white),
                            )
                                : AppText.customText(
                              'Assign',
                              size: 14,
                              weight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color checkColor,
    required List<T> items,
    required String Function(T) itemLabel,
    required String Function(T) subLabel,
    required void Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F5), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          borderRadius: BorderRadius.circular(14),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF8898c0)),
          selectedItemBuilder: (_) => items
              .map((item) => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              itemLabel(item),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a2340)),
            ),
          ))
              .toList(),
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, size: 16, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemLabel(item),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1a2340))),
                        if (subLabel(item).isNotEmpty)
                          Text(subLabel(item),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  if (value == item)
                    Icon(Icons.check_circle_rounded,
                        size: 18, color: checkColor),
                ],
              ),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String text, {bool showSpinner = false}) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F5), width: 1.5),
      ),
      child: Row(
        children: [
          if (showSpinner)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Color(0xFF3F72FF)),
            )
          else
            Icon(Icons.info_outline_rounded,
                size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ],
      ),
    );
  }
  Widget _label(String text, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3a4a6b))),
        const SizedBox(height: 6),
        child,
        const SizedBox(height: 14),
      ],
    );
  }
  Widget _sheetDrop({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    bool hasError = false,
    bool warningHint = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? const Color(0xFFFF4D6D)
              : const Color(0xFFE2E8F5),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: warningHint
                  ? const Color(0xFFF57C00)
                  : Colors.grey.shade400,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          borderRadius: BorderRadius.circular(14),
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: onChanged == null
                ? Colors.grey.shade300
                : const Color(0xFF8898c0),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
  Widget _buildLabel(String label, IconData icon, {bool required = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF5a6a8a)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3a4a6b))),
        if (required)
          const Text(' *',
              style:
              TextStyle(color: Color(0xFFFF4D6D), fontSize: 13)),
      ],
    );
  }
}

// ─── Date Picker Field ────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const _DateField({
    required this.controller,
    required this.label,
    required this.onTap,
    this.required = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 14, color: Color(0xFF5a6a8a)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3a4a6b))),
            ),
            if (required)
              const Text(' *',
                  style:
                  TextStyle(color: Color(0xFFFF4D6D), fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a2340)),
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
                suffixIcon: const Icon(Icons.calendar_month_rounded,
                    size: 18, color: Color(0xFF3F72FF)),
                filled: true,
                fillColor: const Color(0xFFF7F9FF),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 13),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFFE2E8F5), width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFFE2E8F5), width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF3F72FF), width: 1.8)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFFFF4D6D), width: 1.5)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFFFF4D6D), width: 1.8)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Reusable Form Field ──────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.required = false,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF5a6a8a)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3a4a6b))),
            if (required)
              const Text(' *',
                  style:
                  TextStyle(color: Color(0xFFFF4D6D), fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a2340)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF7F9FF),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F5), width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F5), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF3F72FF), width: 1.8)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFFF4D6D), width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFFF4D6D), width: 1.8)),
          ),
        ),
      ],
    );
  }
}