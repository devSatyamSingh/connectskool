import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/setting_widget/fee_recept_screen.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/auth_view_model/school_admin_profile_view_model.dart';
import '../../model/school_model/fees/school_student_fee_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/fees/collect_fee_payment_view_model.dart';
import '../../view_model/school_view_model/fees/discontinue_student_fee_viewmodel.dart';
import '../../view_model/school_view_model/fees/school_student_fee_view_model.dart';
import '../../view_model/school_view_model/transport_fee/discontinue_student_view_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helper: parse date string to DateTime
// ─────────────────────────────────────────────────────────────────────────────
DateTime? _tryParseDate(String? s) {
  if (s == null || s.isEmpty || s == '0000-00-00') return null;
  try {
    return DateTime.parse(s);
  } catch (_) {
    return null;
  }
}

String _formatDate(String? s) {
  final d = _tryParseDate(s);
  if (d == null) return 'Invalid Date';
  return DateFormat('d MMM yyyy').format(d);
}

String _resolveStatus(String? calculatedStatus, String? status) {
  final cs = calculatedStatus?.toLowerCase() ?? '';
  final s = status?.toLowerCase() ?? '';
  if (cs == 'paid' || s == 'paid') return 'paid';
  if (cs == 'overdue') return 'overdue';
  return 'pending';
}

class StudentProfileFeesScreen extends StatefulWidget {
  final dynamic student;
  const StudentProfileFeesScreen({super.key, required this.student});

  @override
  State<StudentProfileFeesScreen> createState() =>
      _StudentProfileFeesScreenState();
}

class _StudentProfileFeesScreenState extends State<StudentProfileFeesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDiscontinueDialog(BuildContext context, FeeBreakdown fee) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => DiscontinueStudentViewModel(),
        child: _DiscontinueFeeDialog(
          fee: fee,
          studentId: Provider.of<StudentFeeViewModel>(context, listen: false)
              .feeModel?.data?.studentInfo?.studentId,
          studentFeeId: fee.studentFeeId,
        ),
      ),
    );
  }

  void _showCollectPaymentSheet(BuildContext context) {
    final vm = Provider.of<StudentFeeViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => CollectFeePaymentViewModel(),
        child: _CollectPaymentSheet(
          feeBreakdowns: vm.feeBreakdown,
          transportBreakdowns: vm.transportFeeBreakdown,
          studentName: widget.student?.name ?? '',
          studentId: vm.feeModel?.data?.studentInfo?.studentId,
          academicYear: vm.currentAcademicYear ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StudentFeeViewModel>(context);
    final student = widget.student;
    final summary = vm.summary?.currentYear;

    final num totalFee = summary?.total ?? 0;
    final num paidAmount = summary?.paid ?? 0;
    final num pending = summary?.pending ?? 0;
    final num fine = summary?.fine ?? 0;

    final double paidPercent =
    totalFee > 0 ? (paidAmount / totalFee).clamp(0.0, 1.0) : 0.0;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('student_fee.title'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text('student_fee.subtitle'.tr(),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.collectPayment)) {
                        Utils.show('student_fee.permission_denied'.tr(), context);
                        return;
                      }
                      _showCollectPaymentSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payment_rounded,
                              color: AppColor.lightBlueColor, size: 16),
                          const SizedBox(width: 6),
                          Text('student_fee.collect'.tr(),
                              style: TextStyle(
                                  color: AppColor.lightBlueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: vm.loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                color: AppColor.lightBlueColor,
                onRefresh: () async {
                  final info = vm.studentInfo;
                  final year = vm.currentAcademicYear;
                  if (info?.studentId != null && year != null) {
                    await vm.refresh(info!.studentId!, year);
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      _buildStudentCard(
                          student, paidPercent, pending),

                      const SizedBox(height: 14),

                      _buildSummaryCards(
                          totalFee, paidAmount, paidPercent,
                          pending, fine),

                      const SizedBox(height: 16),

                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius:
                                const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: AppColor.lightBlueColor,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                indicatorSize:
                                TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor:
                                Colors.grey.shade600,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                                dividerColor: Colors.transparent,
                                padding: const EdgeInsets.all(6),
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.menu_book_rounded,
                                            size: 15),
                                        const SizedBox(width: 6),
                                        Text(
                                            '${'student_fee.academic'.tr()} (${vm.feeBreakdown.length})'),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.directions_bus_rounded,
                                            size: 15),
                                        const SizedBox(width: 6),
                                        Text(
                                            '${'student_fee.transport'.tr()} (${vm.transportFeeBreakdown.length})'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildAcademicFeeList(vm),
                                  _buildTransportFeeList(vm),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildPaymentHistory(vm),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      dynamic student, double paidPercent, num pending) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (student?.name ?? 'S')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student?.name ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.badge_rounded,
                            size: 13, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(student?.admissionNo ?? '',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600)),
                        const SizedBox(width: 8),
                        Icon(Icons.class_rounded,
                            size: 13, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                            '${student?.className ?? ''} – ${student?.sectionName ?? ''}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: pending > 0
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: pending > 0
                          ? Colors.orange.shade200
                          : Colors.green.shade200),
                ),
                child: Text(
                  pending > 0 ? 'student_fee.due'.tr() : 'student_fee.cleared'.tr(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: pending > 0
                          ? Colors.orange.shade700
                          : Colors.green.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('student_fee.payment_progress'.tr(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500)),
              Text('${(paidPercent * 100).toStringAsFixed(0)}% ${'student_fee.paid_label'.tr()}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: paidPercent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(num totalFee, num paidAmount, double paidPercent,
      num pending, num fine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _summaryCard(
                  title: 'student_fee.total_fee'.tr(),
                  amount: '₹$totalFee',
                  subtitle: 'student_fee.annual_curriculum'.tr(),
                  bgColor: Colors.blue.shade50,
                  accentColor: Colors.blue.shade600,
                  icon: Icons.receipt_rounded),
              const SizedBox(width: 10),
              _summaryCard(
                  title: 'student_fee.paid_amount'.tr(),
                  amount: '₹$paidAmount',
                  subtitle: 'student_fee.paid_percent'.tr().replaceAll('{percent}', '${(paidPercent * 100).toStringAsFixed(0)}'),
                  bgColor: Colors.green.shade50,
                  accentColor: Colors.green.shade600,
                  icon: Icons.check_circle_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _summaryCard(
                  title: 'student_fee.pending'.tr(),
                  amount: '₹$pending',
                  subtitle: pending > 0 ? 'student_fee.due_soon'.tr() : 'student_fee.all_clear'.tr(),
                  bgColor: Colors.orange.shade50,
                  accentColor: Colors.orange.shade600,
                  icon: Icons.pending_actions_rounded),
              const SizedBox(width: 10),
              _summaryCard(
                  title: 'student_fee.late_fine'.tr(),
                  amount: '₹$fine',
                  subtitle: fine > 0 ? 'student_fee.fine_applicable'.tr() : 'student_fee.no_fines'.tr(),
                  bgColor: Colors.red.shade50,
                  accentColor: Colors.red.shade400,
                  icon: Icons.warning_amber_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String amount,
    required String subtitle,
    required Color bgColor,
    required Color accentColor,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 16),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor.withOpacity(0.8),
                    letterSpacing: 0.3)),
            const SizedBox(height: 4),
            Text(amount,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 10, color: accentColor.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicFeeList(StudentFeeViewModel vm) {
    final fees = vm.feeBreakdown;
    if (fees.isEmpty) {
      return _emptyState(
          'student_fee.no_academic_fees'.tr(), Icons.menu_book_outlined);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: fees.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final fee = fees[index];
        return _academicFeeItem(context, fee);
      },
    );
  }

  Widget _academicFeeItem(BuildContext context, FeeBreakdown fee) {
    final isPaid = fee.status == 'paid';
    final isPartial = fee.status == 'partial';
    final feePending = fee.pendingAmount ?? 0;
    final fine = fee.fineAmount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.green.shade50
                      : isPartial
                      ? Colors.orange.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.menu_book_rounded,
                    size: 17,
                    color: isPaid
                        ? Colors.green
                        : isPartial
                        ? Colors.orange
                        : Colors.red),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fee.feeHeadName ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _statusBadge(isPaid
                            ? 'student_fee.status_paid'.tr()
                            : isPartial
                            ? 'student_fee.status_partial'.tr()
                            : 'student_fee.status_pending'.tr(),
                            isPaid
                                ? Colors.green
                                : isPartial
                                ? Colors.orange
                                : Colors.red),
                        const SizedBox(width: 6),
                        if (fee.feeFrequency != null)
                          _statusBadge(fee.feeFrequency!.toUpperCase(),
                              Colors.grey.shade500),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isPaid && feePending > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!PermissionExtensions.canAccess(
                            PermissionKeys.collectPayment)) {
                          Utils.show('student_fee.permission_denied_collect'.tr(), context);
                          return;
                        }
                        _showCollectPaymentSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('student_fee.collect_payment'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          _showDiscontinueDialog(context, fee),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border:
                          Border.all(color: Colors.red.shade300),
                        ),
                        child: Text('student_fee.discontinue'.tr(),
                            style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _breakdownCell('student_fee.total'.tr(), '₹${fee.totalAmount ?? 0}',
                  Colors.black87),
              _breakdownCell('student_fee.paid'.tr(), '₹${fee.paidAmount ?? 0}',
                  Colors.green.shade600),
              _breakdownCell('student_fee.pending_status'.tr(), '₹$feePending',
                  feePending > 0
                      ? Colors.red.shade500
                      : Colors.grey.shade400),
              if (fine > 0)
                _breakdownCell('student_fee.fine'.tr(), '₹$fine', Colors.red.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransportFeeList(StudentFeeViewModel vm) {
    final fees = vm.transportFeeBreakdown;
    if (fees.isEmpty) {
      return _emptyState(
          'student_fee.no_transport_fees'.tr(), Icons.directions_bus_outlined);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: fees.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final fee = fees[index];
        return _transportFeeItem(context, fee);
      },
    );
  }

  Widget _transportFeeItem(
      BuildContext context, TransportFeeBreakdown fee) {
    final isPaid = fee.status == 'paid';
    final isPartial = fee.status == 'partial';
    final feePending = fee.pendingAmount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.green.shade50
                      : isPartial
                      ? Colors.orange.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.directions_bus_rounded,
                    size: 17,
                    color: isPaid
                        ? Colors.green
                        : isPartial
                        ? Colors.orange
                        : Colors.red),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fee.feeHeadName ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    if (fee.routeName != null)
                      Row(
                        children: [
                          Icon(Icons.route_rounded,
                              size: 11, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text('${'student_fee.route'.tr()}: ${fee.routeName!}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600)),
                          ),
                        ],
                      ),
                    if (fee.stopName != null)
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 11, color: Colors.green.shade400),
                          const SizedBox(width: 4),
                          Text(
                              '${'student_fee.stop'.tr()}: ${fee.stopName} · ${fee.distanceKm} ${'student_fee.km'.tr()}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600)),
                        ],
                      ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _statusBadge(
                            isPaid
                                ? 'student_fee.status_paid'.tr()
                                : isPartial
                                ? 'student_fee.status_partial'.tr()
                                : 'student_fee.status_pending'.tr(),
                            isPaid
                                ? Colors.green
                                : isPartial
                                ? Colors.orange
                                : Colors.red),
                        const SizedBox(width: 6),
                        if (fee.feeFrequency != null)
                          _statusBadge(
                              fee.feeFrequency!.toUpperCase(),
                              Colors.grey.shade500),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isPaid && feePending > 0)
                GestureDetector(
                  onTap: () {
                    if (!PermissionExtensions.canAccess(
                        PermissionKeys.collectPayment)) {
                      Utils.show('student_fee.permission_denied_collect'.tr(), context);
                      return;
                    }
                    _showCollectPaymentSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('student_fee.collect_payment'.tr(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _breakdownCell('student_fee.total'.tr(), '₹${fee.totalAmount ?? 0}',
                  Colors.black87),
              _breakdownCell('student_fee.paid'.tr(), '₹${fee.paidAmount ?? 0}',
                  Colors.green.shade600),
              _breakdownCell('student_fee.pending_status'.tr(), '₹$feePending',
                  feePending > 0
                      ? Colors.red.shade500
                      : Colors.grey.shade400),
              if ((fee.fineAmount ?? 0) > 0)
                _breakdownCell('student_fee.fine'.tr(), '₹${fee.fineAmount}',
                    Colors.red.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(StudentFeeViewModel vm) {
    final history = vm.paymentHistory;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('student_fee.payment_history'.tr(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${history.length} ${'student_fee.records'.tr()}',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          if (history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.history_rounded,
                        size: 42, color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text('student_fee.no_payment_records'.tr(),
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: history.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final h = history[index];
                final hMap = h is Map
                    ? Map<String, dynamic>.from(h)
                    : <String, dynamic>{};
                final amt = hMap['amount'] ?? hMap['paid_amount'] ?? 0;
                final fine =
                    double.tryParse(hMap['fine_amount']?.toString() ?? '0') ??
                        0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.payments_rounded,
                            size: 17, color: Colors.green.shade500),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                hMap['fee_head_name']?.toString() ??
                                    'Fee Payment',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                                '${hMap['paid_on'] ?? 'N/A'}  ·  ${(hMap['payment_mode'] ?? 'CASH').toString().toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('₹$amt',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600)),
                          if (fine > 0)
                            Text('+₹${fine.toStringAsFixed(0)} ${'student_fee.fine'.tr()}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 0.5)),
  );

  Widget _breakdownCell(String label, String value, Color valueColor) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Text(value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: valueColor)),
          ],
        ),
      );

  Widget _emptyState(String msg, IconData icon) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(msg,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// COLLECT PAYMENT SHEET — unified academic + transport
// ═════════════════════════════════════════════════════════════════════════════

class _SelectableInstallment {
  final int id;
  final int installmentNo;
  final bool isTransport;
  final String amount;
  final String? startDueDate;
  final String? endDueDate;
  final String calculatedStatus;
  final num fineAmount;
  final num totalAmount;

  const _SelectableInstallment({
    required this.id,
    required this.installmentNo,
    required this.isTransport,
    required this.amount,
    this.startDueDate,
    this.endDueDate,
    required this.calculatedStatus,
    required this.fineAmount,
    required this.totalAmount,
  });

  bool get isPaid => calculatedStatus == 'paid';
  bool get isOverdue => calculatedStatus == 'overdue';
}

class _CollectPaymentSheet extends StatefulWidget {
  final List<FeeBreakdown> feeBreakdowns;
  final List<TransportFeeBreakdown> transportBreakdowns;
  final String studentName;
  final dynamic studentId;
  final String academicYear;

  const _CollectPaymentSheet({
    required this.feeBreakdowns,
    required this.transportBreakdowns,
    required this.studentName,
    required this.studentId,
    required this.academicYear,
  });

  @override
  State<_CollectPaymentSheet> createState() => _CollectPaymentSheetState();
}

class _CollectPaymentSheetState extends State<_CollectPaymentSheet> {
  final Set<int> _selectedIdx = {};
  String _paymentMode = 'Cash';
  final _modes = ['Cash', 'Online', 'Cheque', 'DD'];
  final _remarkCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  String? _refError;

  late final List<_SelectableInstallment> _allInstallments;

  @override
  void initState() {
    super.initState();
    _allInstallments = _buildInstallments();
  }

  @override
  void dispose() {
    _remarkCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  List<_SelectableInstallment> _buildInstallments() {
    final result = <_SelectableInstallment>[];

    for (final fb in widget.feeBreakdowns) {
      for (final inst in (fb.installments ?? [])) {
        if (inst.id == null) continue;
        result.add(_SelectableInstallment(
          id: inst.id!,
          installmentNo: inst.installmentNo ?? 0,
          isTransport: false,
          amount: inst.amount ?? '0',
          startDueDate: inst.startDueDate,
          endDueDate: inst.endDueDate,
          calculatedStatus: _resolveStatus(
              inst.calculatedStatus, inst.status),
          fineAmount: inst.fineAmount ?? 0,
          totalAmount: inst.totalAmount ?? 0,
        ));
      }
    }

    for (final tb in widget.transportBreakdowns) {
      for (final inst in (tb.installments ?? [])) {
        if (inst.studentTransportInstallmentId == null) continue;
        result.add(_SelectableInstallment(
          id: inst.studentTransportInstallmentId!,
          installmentNo: inst.installmentNo ?? 0,
          isTransport: true,
          amount: inst.amount ?? '0',
          startDueDate: inst.startDueDate,
          endDueDate: inst.endDueDate ?? inst.dueDate,
          calculatedStatus: _resolveStatus(
              inst.calculatedStatus, inst.status),
          fineAmount: inst.fineAmount ?? 0,
          totalAmount: inst.totalAmount ?? 0,
        ));
      }
    }

    return result;
  }

  double get _selectedTotal {
    double t = 0;
    for (final i in _selectedIdx) {
      t += (double.tryParse(_allInstallments[i].amount) ?? 0) +
          (_allInstallments[i].fineAmount.toDouble());
    }
    return t;
  }

  bool get _isRefRequired => _paymentMode != 'Cash';

  bool _validate() {
    if (_selectedIdx.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text('student_fee.select_installment_hint'.tr()),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ));
      return false;
    }
    if (_isRefRequired && _refCtrl.text.trim().isEmpty) {
      setState(() => _refError =
          'student_fee.reference_required'.tr().replaceAll('{mode}', _paymentMode));
      return false;
    }
    setState(() => _refError = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final normalIds = <int>[];
    final transportIds = <int>[];
    for (final i in _selectedIdx) {
      final inst = _allInstallments[i];
      if (inst.isTransport) {
        transportIds.add(inst.id);
      } else {
        normalIds.add(inst.id);
      }
    }

    final success =
    await Provider.of<CollectFeePaymentViewModel>(context,
        listen: false)
        .collectFeePaymentApi(
      studentId: widget.studentId,
      installmentIds: normalIds,
      transportInstallmentIds: transportIds,
      paymentMode: _paymentMode,
      transactionRef: _refCtrl.text.trim().isEmpty
          ? null
          : _refCtrl.text.trim(),
      remarks: _remarkCtrl.text.trim().isEmpty
          ? null
          : _remarkCtrl.text.trim(),
      context: context,
    );

    if (success && mounted) {
      final vm = Provider.of<CollectFeePaymentViewModel>(context,
          listen: false);
      final receiptApiData = vm.lastReceiptData;

      if (receiptApiData != null) {
        final receiptData = FeeReceiptData.fromApiResponse(receiptApiData);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => FeeReceiptScreen(receipt: receiptData),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(28)),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.92,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.payment_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('student_fee.collect_payment'.tr(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.studentName,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('student_fee.select_installments'.tr(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('*',
                        style: TextStyle(
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(
                        '${_allInstallments.where((e) => !e.isPaid).length} ${'student_fee.installment_due'.tr()}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade600,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: _allInstallments.isEmpty
                    ? Center(
                    child: Text('No installments',
                        style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  itemCount: _allInstallments.length,
                  itemBuilder: (ctx, i) {
                    final inst = _allInstallments[i];
                    final isSel = _selectedIdx.contains(i);
                    return _installmentTile(inst, i, isSel);
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    MediaQuery.of(context).viewInsets.bottom + 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('${'student_fee.mode'.tr()}:',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600)),
                        const SizedBox(width: 8),
                        ..._modes.map((mode) {
                          final sel = _paymentMode == mode;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _paymentMode = mode;
                              _refError = null;
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColor.lightBlueColor
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(mode,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: sel
                                          ? Colors.white
                                          : Colors.grey.shade600)),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _remarkCtrl,
                      style: const TextStyle(fontSize: 13),
                      decoration: _fieldDeco('student_fee.remarks'.tr(),
                          Icons.note_alt_outlined),
                    ),
                    const SizedBox(height: 10),

                    if (_isRefRequired) ...[
                      TextField(
                        controller: _refCtrl,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (_) =>
                            setState(() => _refError = null),
                        decoration: _fieldDeco(
                            _paymentMode == 'Online'
                                ? 'student_fee.transaction_id'.tr()
                                : _paymentMode == 'Cheque'
                                ? 'student_fee.cheque_number'.tr()
                                : 'student_fee.dd_number'.tr(),
                            Icons.confirmation_number_outlined,
                            error: _refError),
                      ),
                      const SizedBox(height: 10),
                    ],

                    if (_selectedIdx.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border:
                          Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${_selectedIdx.length} installment(s) selected',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                '₹${_selectedTotal.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    Consumer<CollectFeePaymentViewModel>(
                      builder: (_, vm, __) => GestureDetector(
                        onTap: vm.loading ? null : _submit,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: _selectedIdx.isEmpty
                                ? null
                                : AppColor.primaryGradient,
                            color: _selectedIdx.isEmpty
                                ? Colors.grey.shade200
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _selectedIdx.isEmpty
                                ? []
                                : [
                              BoxShadow(
                                  color: AppColor.lightBlueColor
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Center(
                            child: vm.loading
                                ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2))
                                : Text(
                              _selectedIdx.isEmpty
                                  ? 'student_fee.select_installments'.tr()
                                  : 'student_fee.confirm_payment'.tr().replaceAll('{amount}', '${_selectedTotal.toStringAsFixed(0)}'),
                              style: TextStyle(
                                  color: _selectedIdx.isEmpty
                                      ? Colors.grey.shade500
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _installmentTile(
      _SelectableInstallment inst, int i, bool isSel) {
    final isPaid = inst.isPaid;
    final isOverdue = inst.isOverdue;
    final fine = inst.fineAmount;

    Color statusColor = isPaid
        ? Colors.green
        : isOverdue
        ? Colors.red
        : Colors.orange;
    String statusLabel =
    isPaid ? 'PAID' : isOverdue ? 'OVERDUE' : 'PENDING';

    final dueDateStr = _formatDate(inst.endDueDate);

    return GestureDetector(
      onTap: isPaid
          ? null
          : () {
        setState(() {
          if (isSel)
            _selectedIdx.remove(i);
          else
            _selectedIdx.add(i);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSel ? Colors.orange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSel
                  ? Colors.orange.shade300
                  : isOverdue && !isPaid
                  ? Colors.red.shade200
                  : Colors.grey.shade200,
              width: isSel ? 1.5 : 1),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isPaid
                    ? Colors.grey.shade200
                    : isSel
                    ? Colors.orange
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: isPaid
                        ? Colors.grey.shade300
                        : isSel
                        ? Colors.orange
                        : Colors.grey.shade400,
                    width: 1.5),
              ),
              child: isSel && !isPaid
                  ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 14)
                  : null,
            ),

            const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: inst.isTransport
                    ? Colors.teal.shade50
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                      inst.isTransport
                          ? Icons.directions_bus_rounded
                          : Icons.menu_book_rounded,
                      size: 10,
                      color: inst.isTransport
                          ? Colors.teal.shade600
                          : Colors.blue.shade600),
                  const SizedBox(width: 3),
                  Text(
                      inst.isTransport ? 'student_fee.transport'.tr() : 'student_fee.academic'.tr(),
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: inst.isTransport
                              ? Colors.teal.shade600
                              : Colors.blue.shade600)),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Installment #${inst.installmentNo}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isPaid
                              ? Colors.grey.shade500
                              : Colors.black87)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 11, color: Colors.grey.shade400),
                      const SizedBox(width: 3),
                      Text('Due $dueDateStr',
                          style: TextStyle(
                              fontSize: 11,
                              color: isOverdue && !isPaid
                                  ? Colors.red.shade400
                                  : Colors.grey.shade500)),
                    ],
                  ),
                  if (fine > 0 && !isPaid)
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 11, color: Colors.red.shade400),
                        const SizedBox(width: 3),
                        Text('+₹$fine ${'student_fee.fine'.tr()}',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.red.shade500,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${inst.amount}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isPaid
                            ? Colors.grey.shade400
                            : Colors.black87)),
                if (fine > 0 && !isPaid)
                  Text(
                      '₹${(double.tryParse(inst.amount) ?? 0 + fine.toDouble()).toStringAsFixed(0)} total',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(statusLabel,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: statusColor)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDeco(String hint, IconData icon,
      {String? error}) =>
      InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(fontSize: 13, color: Colors.grey.shade400),
        prefixIcon:
        Icon(icon, color: AppColor.lightBlueColor, size: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
        errorText: error,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: error != null
                    ? Colors.red.shade300
                    : Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: error != null
                    ? Colors.red.shade400
                    : AppColor.lightBlueColor)),
      );
}

// ═════════════════════════════════════════════════════════════════════════════
// DISCONTINUE FEE DIALOG
// ═════════════════════════════════════════════════════════════════════════════
class _DiscontinueFeeDialog extends StatefulWidget {
  final FeeBreakdown fee;
  final dynamic studentId;
  final dynamic studentFeeId;

  const _DiscontinueFeeDialog({
    required this.fee,
    required this.studentId,
    required this.studentFeeId,
  });

  @override
  State<_DiscontinueFeeDialog> createState() =>
      _DiscontinueFeeDialogState();
}

class _DiscontinueFeeDialogState extends State<_DiscontinueFeeDialog> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedReason;
  final _notesController = TextEditingController();

  String? _apiMessage;
  bool? _apiSuccess;

  final List<String> _reasons = [
    'student_fee.student_left'.tr(),
    'student_fee.service_stopped'.tr(),
    'student_fee.scholarship_granted'.tr(),
    'student_fee.relocated'.tr(),
    'student_fee.other'.tr(),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
              primary: Colors.orange.shade500),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.fee;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.block_rounded,
                        color: Colors.orange.shade600, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('student_fee.discontinue_fee'.tr(),
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close_rounded,
                        color: Colors.grey.shade500, size: 22),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (_apiMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _apiSuccess == true
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _apiSuccess == true
                            ? Colors.green.shade300
                            : Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _apiSuccess == true
                            ? Icons.check_circle_outline_rounded
                            : Icons.error_outline_rounded,
                        color: _apiSuccess == true
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _apiMessage!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _apiSuccess == true
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Row(
                children: [
                  Expanded(child: _infoBlock('student_fee.fee_head'.tr(),
                      fee.feeHeadName ?? '—')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey.shade200)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('student_fee.paid'.tr(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500)),
                                Text('₹${fee.paidAmount ?? 0}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color:
                                        Colors.green.shade600)),
                              ],
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('student_fee.due'.tr(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500)),
                                Text('₹${fee.pendingAmount ?? 0}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('student_fee.date'.tr()),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius:
                                BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.shade300)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(_selectedDate),
                                      style: const TextStyle(
                                          fontSize: 13)),
                                ),
                                Icon(Icons.calendar_today_rounded,
                                    size: 16,
                                    color: Colors.grey.shade500),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('student_fee.reason'.tr()),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('student_fee.select_reason'.tr(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500)),
                              value: _selectedReason,
                              dropdownColor: Colors.white,
                              items: _reasons
                                  .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r,
                                      style: const TextStyle(
                                          fontSize: 12))))
                                  .toList(),
                              onChanged: (v) => setState(
                                      () => _selectedReason = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _label('student_fee.notes'.tr()),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'student_fee.notes_hint'.tr(),
                  hintStyle: TextStyle(
                      fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.orange.shade400)),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        side:
                        BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('student_fee.cancel'.tr(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Consumer<DiscontinueStudentFeeViewModel>(
                      builder: (ctx, vm, _) => ElevatedButton(
                        onPressed: vm.loading
                            ? null
                            : () async {
                          if (_selectedReason == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  'student_fee.reason_required'.tr()),
                              backgroundColor:
                              Colors.red.shade400,
                              behavior:
                              SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      10)),
                            ));
                            return;
                          }

                          final notes =
                          _notesController.text.trim();
                          final fullReason = notes.isNotEmpty
                              ? '$_selectedReason. $notes'
                              : _selectedReason!;

                          final success =
                          await vm.discontinueStudentFeeApi(
                            studentId: widget.studentId,
                            studentFeeId: widget.studentFeeId,
                            discontinuedOn: DateFormat(
                                'yyyy-MM-dd')
                                .format(_selectedDate),
                            discontinueReason: fullReason,
                            context: context,
                          );

                          if (success && mounted) {
                            Future.delayed(
                              const Duration(
                                  milliseconds: 800),
                                  () {
                                if (mounted)
                                  Navigator.pop(context);
                              },
                            );
                          } else {
                            setState(() {
                              _apiMessage = vm.lastMessage;
                              _apiSuccess = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade500,
                          disabledBackgroundColor:
                          Colors.orange.shade200,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: vm.loading
                            ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2))
                            : Text('student_fee.confirm_discontinue'.tr(),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
    );
  }

  Widget _infoBlock(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      const SizedBox(height: 6),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200)),
        child: Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    ],
  );

  Widget _label(String text) => Text(text,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.8));
}