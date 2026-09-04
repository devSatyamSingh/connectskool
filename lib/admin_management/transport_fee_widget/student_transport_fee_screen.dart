import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../view_model/auth_view_model/academic_view_model.dart';
import '../../view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../view_model/school_view_model/transport_fee/get_student_transport_view_model.dart';

class StudentTransportFeeScreen extends StatefulWidget {
  const StudentTransportFeeScreen({super.key});

  @override
  State<StudentTransportFeeScreen> createState() =>
      _StudentTransportFeeScreenState();
}

class _StudentTransportFeeScreenState
    extends State<StudentTransportFeeScreen> {
  String? selectedStudent;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<AllStudentListVieModel>(context, listen: false)
          .allStudentListApi(context);

      final academicVm = Provider.of<AcademicViewModel>(context, listen: false);
      await academicVm.academicApi(context);

      if (mounted && academicVm.currentYear != null) {
        setState(() {
          selectedYear = academicVm.currentYear!.yearName;
        });
      } else if (mounted && academicVm.years.isNotEmpty) {
        setState(() {
          selectedYear = academicVm.years.first.yearName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 52, 20, 24),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
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
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        'student_transport.title'.tr(),
                        size: 20,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 2),
                      AppText.customText(
                        'student_transport.subtitle'.tr(),
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
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_bus_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Consumer<AllStudentListVieModel>(
                  builder: (context, vm, child) {
                    if (vm.loading) {
                      return _buildShimmerDropdown();
                    }
                    final students = vm.allStudentListModel?.data ?? [];
                    return _buildDropdown(
                      icon: Icons.person_search_rounded,
                      iconColor: const Color(0xFF4A6CF7),
                      iconBg: const Color(0xFFEEF2FF),
                      hint: 'student_transport.select_student'.tr(),
                      value: selectedStudent,
                      items: students
                          .map(
                            (e) => DropdownMenuItem(
                          value: e.studentId.toString(),
                          child: Text(
                            "${e.name} (${e.admissionNo})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (v) {
                        setState(() => selectedStudent = v.toString());
                      },
                    );
                  },
                ),

                const SizedBox(height: 12),

                Consumer<AcademicViewModel>(
                  builder: (context, academicVm, _) {
                    if (academicVm.loading) return _buildShimmerDropdown();
                    final years = academicVm.years;
                    return _buildDropdown(
                      icon: Icons.calendar_today_rounded,
                      iconColor: const Color(0xFF00B894),
                      iconBg: const Color(0xFFECFDF5),
                      hint: 'student_transport.select_academic_year'.tr(),
                      value: selectedYear,
                      items: years
                          .map((e) => DropdownMenuItem(
                        value: e.yearName,
                        child: Text(e.yearName ?? ""),
                      ))
                          .toList(),
                      onChanged: (v) {
                        setState(() => selectedYear = v.toString());
                        if (selectedStudent != null && selectedYear != null) {
                          Provider.of<GetStudentTransportViewModel>(context, listen: false)
                              .getStudentTransportApi(selectedStudent!, selectedYear!, context);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Consumer<GetStudentTransportViewModel>(
              builder: (context, vm, child) {
                if (vm.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (vm.transportModel == null ||
                    vm.transportModel!.data == null) {
                  return _buildEmptyState();
                }

                final data = vm.transportModel!.data!;

                return ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  children: [
                    _sectionCard(
                      child: Column(
                        children: [
                          _infoTile(
                            icon: Icons.route_rounded,
                            iconBg: const Color(0xFFEEF2FF),
                            iconColor: const Color(0xFF4A6CF7),
                            label: 'student_transport.route'.tr(),
                            value: data.routeName ?? "—",
                            bold: true,
                          ),
                          _divider(),
                          _infoTile(
                            icon: Icons.location_on_rounded,
                            iconBg: const Color(0xFFFFF3E0),
                            iconColor: const Color(0xFFF57C00),
                            label: 'student_transport.stop'.tr(),
                            value: data.stopName ?? "—",
                          ),
                          _divider(),
                          _infoTile(
                            icon: Icons.directions_bus_rounded,
                            iconBg: const Color(0xFFE8F5E9),
                            iconColor: const Color(0xFF43A047),
                            label: 'student_transport.vehicle_no'.tr(),
                            value: data.vehicleNo ?? "—",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _sectionCard(
                      header: _cardHeader(
                        icon: Icons.person_pin_circle_rounded,
                        label: 'student_transport.driver_info'.tr(),
                        color: const Color(0xFF7C3AED),
                      ),
                      child: Column(
                        children: [
                          _infoTile(
                            icon: Icons.badge_rounded,
                            iconBg: const Color(0xFFF3E8FF),
                            iconColor: const Color(0xFF7C3AED),
                            label: 'student_transport.driver_name'.tr(),
                            value: data.driverName ?? "—",
                          ),
                          _divider(),
                          _infoTile(
                            icon: Icons.phone_rounded,
                            iconBg: const Color(0xFFE0F7FA),
                            iconColor: const Color(0xFF00838F),
                            label: 'student_transport.driver_phone'.tr(),
                            value: data.driverPhone ?? "—",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _sectionCard(
                      header: _cardHeader(
                        icon: Icons.info_outline_rounded,
                        label: 'student_transport.route_details'.tr(),
                        color: const Color(0xFF0284C7),
                      ),
                      child: Column(
                        children: [
                          _infoTile(
                            icon: Icons.straighten_rounded,
                            iconBg: const Color(0xFFE0F2FE),
                            iconColor: const Color(0xFF0284C7),
                            label: 'student_transport.distance'.tr(),
                            value: "${data.distanceKm ?? 0} ${'student_transport.km'.tr()}",
                          ),
                          _divider(),
                          _infoTile(
                            icon: Icons.repeat_rounded,
                            iconBg: const Color(0xFFFFF1F2),
                            iconColor: const Color(0xFFE11D48),
                            label: 'student_transport.fee_frequency'.tr(),
                            value: data.feeFrequency ?? "—",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _sectionCard(
                      header: _cardHeader(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'student_transport.fee_summary'.tr(),
                        color: const Color(0xFF059669),
                      ),
                      child: Column(
                        children: [
                          _feeRow('student_transport.base_amount'.tr(), data.baseAmount,
                              const Color(0xFF374151)),
                          _divider(),
                          _feeRow('student_transport.assigned_amount'.tr(), data.assignedAmount,
                              const Color(0xFF374151)),
                          _divider(),
                          _feeRow('student_transport.paid_amount'.tr(), data.paidAmount,
                              const Color(0xFF059669)),
                          _divider(),
                          _feeRow('student_transport.pending_amount'.tr(), data.pendingAmount,
                              const Color(0xFFDC2626),
                              bold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _sectionCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'student_transport.assigned_on'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                data.assignedOn ?? "—",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                          _statusBadge(data.feeStatus ?? ""),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── HELPERS ────────────────────────────────────────────────────────

  Widget _buildDropdown({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String hint,
    required String? value,
    required List<DropdownMenuItem> items,
    required ValueChanged onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              underline: const SizedBox(),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerDropdown() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(child: LinearProgressIndicator()),
    );
  }

  Widget _sectionCard({Widget? header, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: header,
            ),
            const Divider(height: 22, thickness: 0.8),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _cardHeader(
      {required IconData icon,
        required String label,
        required Color color}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF1F2937),
                    fontWeight:
                    bold ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feeRow(String label, dynamic amount, Color valueColor,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            "₹${amount ?? 0}",
            style: TextStyle(
              fontSize: bold ? 15 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    thickness: 0.6,
    color: Colors.grey.shade100,
  );

  Widget _statusBadge(String status) {
    final statusLower = status.toLowerCase();
    final isPending = statusLower == "pending";
    final isPaid = statusLower == "paid";
    final isPartial = statusLower == "partial";

    Color color;
    Color bgColor;
    String label;

    if (isPaid) {
      color = const Color(0xFF059669);
      bgColor = const Color(0xFFD1FAE5);
      label = 'student_transport.status_paid'.tr();
    } else if (isPartial) {
      color = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFEF3C7);
      label = 'student_transport.status_partial'.tr();
    } else {
      color = const Color(0xFFDC2626);
      bgColor = const Color(0xFFFEE2E2);
      label = 'student_transport.status_pending'.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              size: 52,
              color: Color(0xFF4A6CF7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'student_transport.no_transport_assigned'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'student_transport.no_transport_desc'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}