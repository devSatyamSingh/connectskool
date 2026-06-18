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
import '../../view_model/school_view_model/fees/school_student_fee_view_model.dart';
import '../../view_model/school_view_model/transport_fee/discontinue_student_view_model.dart';

class StudentProfileFeesScreen extends StatefulWidget {
  final dynamic student;
  const StudentProfileFeesScreen({super.key, required this.student});

  @override
  State<StudentProfileFeesScreen> createState() =>
      _StudentProfileFeesScreenState();
}

class _StudentProfileFeesScreenState extends State<StudentProfileFeesScreen> {
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
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: accentColor.withOpacity(0.8),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: accentColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Updated: studentId aur academicYear pass ho raha hai
  void _showDiscontinueDialog(BuildContext context, FeeBreakdown fee) {
    final vm = Provider.of<StudentFeeViewModel>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => DiscontinueStudentViewModel(),
        child: _DiscontinueFeeDialog(
          fee: fee,
          studentId: vm.feeModel?.data?.studentInfo?.studentId,
          academicYear: vm.feeModel?.data?.currentAcademicYear,
        ),
      ),
    );
  }

  void _showCollectPaymentSheet(FeeBreakdown fee) {
    final vm = Provider.of<StudentFeeViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => CollectFeePaymentViewModel(),
        child: _CollectPaymentSheet(
          fee: fee,
          studentName: widget.student?.name ?? '',
          studentId: vm.feeModel?.data?.studentInfo?.studentId,
          onPaymentDone: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StudentFeeViewModel>(context);
    final student = widget.student;

    final summary = vm.summary?.currentYear;
    final feeList = vm.feeBreakdown;
    final history = vm.feeModel?.data?.paymentHistory ?? [];

    final totalFee = summary?.total ?? 0;
    final paidAmount = summary?.paid ?? 0;
    final pending = summary?.pending ?? 0;
    final fine = summary?.fine ?? 0;

    final double paidPercent = totalFee > 0
        ? (paidAmount / totalFee).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
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
                    decoration: const BoxDecoration(
                      color: Colors.white24,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Student Fee Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fee details & payment history",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────
          Expanded(
            child: vm.loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // ── Student Info Card ────────────────────────────
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
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
                                        colors: [
                                          Colors.green.shade300,
                                          Colors.green.shade600,
                                        ],
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
                                          color: Colors.white,
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
                                          student?.name ?? "No Name",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.badge_rounded,
                                              size: 13,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              student?.admissionNo ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.class_rounded,
                                              size: 13,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              student?.className ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: pending > 0
                                          ? Colors.orange.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: pending > 0
                                            ? Colors.orange.shade200
                                            : Colors.green.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      pending > 0 ? 'Due' : 'Cleared',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: pending > 0
                                            ? Colors.orange.shade700
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Progress",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${(paidPercent * 100).toStringAsFixed(0)}% paid",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: paidPercent,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Summary Cards ────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _summaryCard(
                                title: 'TOTAL FEE',
                                amount: '₹$totalFee',
                                subtitle: 'Standard annual curriculum',
                                bgColor: Colors.blue.shade50,
                                accentColor: Colors.blue.shade600,
                                icon: Icons.receipt_rounded,
                              ),
                              const SizedBox(width: 10),
                              _summaryCard(
                                title: 'PAID AMOUNT',
                                amount: '₹$paidAmount',
                                subtitle:
                                    '${(paidPercent * 100).toStringAsFixed(0)}% of total',
                                bgColor: Colors.green.shade50,
                                accentColor: Colors.green.shade600,
                                icon: Icons.check_circle_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _summaryCard(
                                title: 'PENDING',
                                amount: '₹$pending',
                                subtitle: pending > 0
                                    ? 'Next due: Soon'
                                    : 'All clear!',
                                bgColor: Colors.orange.shade50,
                                accentColor: Colors.orange.shade600,
                                icon: Icons.pending_actions_rounded,
                              ),
                              const SizedBox(width: 10),
                              _summaryCard(
                                title: 'LATE FINE',
                                amount: '₹$fine',
                                subtitle: fine > 0
                                    ? 'Fine applicable'
                                    : 'No fines',
                                bgColor: Colors.red.shade50,
                                accentColor: Colors.red.shade400,
                                icon: Icons.warning_amber_rounded,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Fee Breakdown ────────────────────────────────
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Fee Breakdown",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${feeList.length} items",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (feeList.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.receipt_long_rounded,
                                          size: 46,
                                          color: Colors.grey.shade300,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "No fees assigned",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "No fee records found for this student",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  itemCount: feeList.length,
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade100,
                                  ),
                                  itemBuilder: (context, index) {
                                    final FeeBreakdown fee = feeList[index];
                                    final isPaid = fee.status == "paid";
                                    final isPartial = fee.status == "partial";
                                    final feePending = fee.pendingAmount ?? 0;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row 1: icon + name + tags + buttons
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
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                ),
                                                child: Icon(
                                                  Icons.menu_book_rounded,
                                                  size: 17,
                                                  color: isPaid
                                                      ? Colors.green
                                                      : isPartial
                                                      ? Colors.orange
                                                      : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Wrap(
                                                  spacing: 6,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      fee.feeHeadName ?? '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    // Status chip
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isPaid
                                                            ? Colors
                                                                  .green
                                                                  .shade100
                                                            : isPartial
                                                            ? Colors
                                                                  .orange
                                                                  .shade100
                                                            : Colors
                                                                  .red
                                                                  .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        isPaid
                                                            ? 'PAID'
                                                            : isPartial
                                                            ? 'PARTIAL'
                                                            : 'PENDING',
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.5,
                                                          color: isPaid
                                                              ? Colors
                                                                    .green
                                                                    .shade700
                                                              : isPartial
                                                              ? Colors
                                                                    .orange
                                                                    .shade700
                                                              : Colors
                                                                    .red
                                                                    .shade600,
                                                        ),
                                                      ),
                                                    ),
                                                    if (fee.feeFrequency !=
                                                        null)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 7,
                                                              vertical: 3,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey
                                                              .shade100,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          fee.feeFrequency!,
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            color: Colors
                                                                .grey
                                                                .shade600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),

                                              // ✅ Collect Payment + Discontinue buttons
                                              if (!isPaid && feePending > 0)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    // Collect Payment button
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (!PermissionExtensions.canAccess(
                                                          PermissionKeys.collectPayment,
                                                        )) {
                                                          Utils.show(
                                                            "You don't have permission to perform this action.",
                                                            context,
                                                          );
                                                          return;
                                                        }

                                                        _showCollectPaymentSheet(
                                                          fee,
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 7,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          gradient: AppColor
                                                              .primaryGradient,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.blue
                                                                  .withOpacity(
                                                                    0.25,
                                                                  ),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    3,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Text(
                                                          'Collect Payment',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    // ✅ Discontinue button
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _showDiscontinueDialog(
                                                            context,
                                                            fee,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 7,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .red
                                                              .shade50,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors
                                                                .red
                                                                .shade300,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Discontinue',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .red
                                                                .shade600,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          // Row 2: Total | Paid | Pending
                                          Row(
                                            children: [
                                              _breakdownCell(
                                                'Total',
                                                '₹${fee.totalAmount ?? 0}',
                                                Colors.black87,
                                              ),
                                              _breakdownCell(
                                                'Paid',
                                                '₹${fee.paidAmount ?? 0}',
                                                Colors.green.shade600,
                                              ),
                                              _breakdownCell(
                                                'Pending',
                                                '₹$feePending',
                                                feePending > 0
                                                    ? Colors.red.shade500
                                                    : Colors.grey.shade400,
                                              ),
                                              if ((fee.fineAmount ?? 0) > 0)
                                                _breakdownCell(
                                                  'Fine',
                                                  '₹${fee.fineAmount}',
                                                  Colors.red.shade400,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Payment History ──────────────────────────────
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Payment History",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${history.length} records",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (history.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.history_rounded,
                                          size: 42,
                                          color: Colors.grey.shade300,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "No payment records",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  itemCount: history.length,
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade100,
                                  ),
                                  itemBuilder: (context, index) {
                                    final h = history[index];
                                    final hMap = h is Map
                                        ? Map<String, dynamic>.from(h)
                                        : <String, dynamic>{};
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.payments_rounded,
                                              size: 17,
                                              color: Colors.green.shade500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  hMap['fee_head_name']
                                                          ?.toString() ??
                                                      hMap['feeHeadName']
                                                          ?.toString() ??
                                                      'Fee Payment',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${hMap['paid_on'] ?? hMap['date'] ?? 'N/A'}  ·  ${hMap['payment_mode'] ?? hMap['paymentMode'] ?? 'CASH'}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '₹${hMap['amount'] ?? hMap['paid_amount'] ?? 0}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownCell(String label, String value, Color valueColor) =>
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
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  COLLECT PAYMENT BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════
class _CollectPaymentSheet extends StatefulWidget {
  final FeeBreakdown fee;
  final String studentName;
  final dynamic studentId;
  final VoidCallback onPaymentDone;

  const _CollectPaymentSheet({
    required this.fee,
    required this.studentName,
    required this.onPaymentDone,
    required this.studentId,
  });

  @override
  State<_CollectPaymentSheet> createState() => _CollectPaymentSheetState();
}

class _CollectPaymentSheetState extends State<_CollectPaymentSheet> {
  final Set<int> _selected = {};
  String _paymentMode = 'Cash';
  bool _loading = false;
  final _modes = ['Cash', 'Online', 'Cheque', 'DD'];

  // ✅ Controllers for additional fields
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _referenceNoController = TextEditingController();

  // ✅ Validation state
  String? _referenceError;

  List<Installment> get _installments => widget.fee.installments ?? [];

  double get _selectedTotal {
    double t = 0;
    for (final i in _selected) {
      t += double.tryParse(_installments[i].amount ?? '0') ?? 0;
    }
    return t;
  }

  bool _isPaid(Installment inst) {
    final s =
        inst.calculatedStatus?.toLowerCase() ??
        inst.status?.toLowerCase() ??
        '';
    return s == 'paid';
  }

  // ✅ Check if reference number is required (all except Cash)
  bool get isReferenceRequired => _paymentMode != 'Cash';

  // ✅ Validate form before submission
  bool _validateForm() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one installment'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return false;
    }

    // Validate reference number for non-cash modes
    if (isReferenceRequired && _referenceNoController.text.trim().isEmpty) {
      setState(() {
        _referenceError =
            'Reference number is required for ${_paymentMode} payment';
      });
      return false;
    }

    setState(() {
      _referenceError = null;
    });
    return true;
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;

    setState(() => _loading = true);

    final selectedIds = _selected
        .map((i) => _installments[i].id)
        .where((id) => id != null)
        .toList();

    final success =
        await Provider.of<CollectFeePaymentViewModel>(
          context,
          listen: false,
        ).collectFeePaymentApi(
          widget.studentId,
          selectedIds,
          _paymentMode,
          null,
          null,
          null,
          context,
        );

    setState(() => _loading = false);

    if (success && mounted) {
      final adminProfile = Provider.of<SchoolAdminProfileViewModel>(
        context,
        listen: false,
      ).schoolAdminProfileModel;

      final receiptData = FeeReceiptData(
        receiptNo: 'RCP-${DateTime.now().millisecondsSinceEpoch}',
        studentName: widget.studentName,
        admissionNo: '',
        classSection: '',
        schoolName: adminProfile?.data?.schoolName ?? '',
        schoolAddress: adminProfile?.data?.schoolAdrees ?? '',
        academicYear: '2026–27',
        paymentDate: DateFormat('d MMMM yyyy').format(DateTime.now()),
        paymentTime: DateFormat('hh:mm a').format(DateTime.now()),
        paymentMethod: _paymentMode,
        feeDescription: widget.fee.feeHeadName ?? '',
        installmentNo:
            (_selected.isNotEmpty
                ? _installments[_selected.first].installmentNo
                : 1) ??
            1,
        amount: _selectedTotal,
        amountInWords: 'Rupees ${_selectedTotal.toStringAsFixed(0)} Only',
      );

      widget.onPaymentDone();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => FeeReceiptScreen(receipt: receiptData),
        ),
      );
    }
  }

  @override
  void dispose() {
    _remarkController.dispose();
    _referenceNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.88,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payment_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Collect Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.fee.feeHeadName ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Select Installments',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(click to select)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _installments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            size: 46,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No installments found",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      itemCount: _installments.length,
                      itemBuilder: (context, index) {
                        final Installment inst = _installments[index];
                        final isPaid = _isPaid(inst);
                        final isSel = _selected.contains(index);

                        return GestureDetector(
                          onTap: isPaid
                              ? null
                              : () {
                                  setState(() {
                                    if (isSel)
                                      _selected.remove(index);
                                    else
                                      _selected.add(index);
                                  });
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? Colors.orange.shade50
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSel
                                    ? Colors.orange.shade300
                                    : Colors.grey.shade200,
                                width: isSel ? 1.5 : 1,
                              ),
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
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSel && !isPaid
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Installment #${inst.installmentNo ?? (index + 1)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isPaid
                                              ? Colors.grey.shade500
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: 11,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Due ${inst.startDueDate ?? inst.endDueDate ?? 'N/A'}'
                                              '${isPaid && inst.paidOn != null ? ' · Paid ${inst.paidOn}' : ''}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isPaid
                                                    ? Colors.green.shade500
                                                    : Colors.grey.shade500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  '₹${inst.amount ?? '0'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isPaid
                                        ? Colors.grey.shade400
                                        : Colors.black87,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPaid
                                        ? Colors.green.shade50
                                        : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isPaid ? 'PAID' : 'PENDING',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: isPaid
                                          ? Colors.green.shade600
                                          : Colors.orange.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Payment Mode Selection ──────────────────────────
                  Row(
                    children: [
                      Text(
                        'Mode:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ..._modes.map((mode) {
                        final sel = _paymentMode == mode;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _paymentMode = mode;
                              // Clear reference error when switching modes
                              _referenceError = null;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColor.lightBlueColor
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              mode,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Remark Field (Always visible) ───────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Remark',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _remarkController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Add any remarks...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.lightBlueColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Reference Number Field (Only for non-Cash modes) ──
                  if (isReferenceRequired) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Reference Number',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _referenceNoController,
                          style: const TextStyle(fontSize: 13),
                          keyboardType: TextInputType.text,
                          onChanged: (_) {
                            if (_referenceError != null) {
                              setState(() => _referenceError = null);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: _paymentMode == 'Online'
                                ? 'Enter Transaction ID / UTR No.'
                                : _paymentMode == 'Cheque'
                                ? 'Enter Cheque Number'
                                : 'Enter DD Number',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _referenceError != null
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _referenceError != null
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _referenceError != null
                                    ? Colors.red.shade400
                                    : AppColor.lightBlueColor,
                              ),
                            ),
                            errorText: _referenceError,
                            errorStyle: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Selected Installments Summary ───────────────────
                  if (_selected.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selected.length} installment(s) selected',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${_selectedTotal.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Submit Button ───────────────────────────────────
                  GestureDetector(
                    onTap: _loading ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _selected.isEmpty
                            ? null
                            : AppColor.primaryGradient,
                        color: _selected.isEmpty ? Colors.grey.shade200 : null,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _selected.isEmpty
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColor.lightBlueColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: _selected.isEmpty
                                        ? Colors.grey.shade400
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selected.isEmpty
                                        ? 'Select Installments'
                                        : 'Confirm Payment  ₹${_selectedTotal.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: _selected.isEmpty
                                          ? Colors.grey.shade500
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class _CollectPaymentSheet extends StatefulWidget {
//   final FeeBreakdown fee;
//   final String studentName;
//   final dynamic studentId;
//   final VoidCallback onPaymentDone;
//
//   const _CollectPaymentSheet({
//     required this.fee,
//     required this.studentName,
//     required this.onPaymentDone,
//     required this.studentId,
//   });
//
//   @override
//   State<_CollectPaymentSheet> createState() => _CollectPaymentSheetState();
// }
//
// class _CollectPaymentSheetState extends State<_CollectPaymentSheet> {
//   final Set<int> _selected = {};
//   String _paymentMode = 'Cash';
//   bool _loading = false;
//   final _modes = ['Cash', 'Online', 'Cheque', 'DD'];
//
//   List<Installment> get _installments => widget.fee.installments ?? [];
//
//   double get _selectedTotal {
//     double t = 0;
//     for (final i in _selected) {
//       t += double.tryParse(_installments[i].amount ?? '0') ?? 0;
//     }
//     return t;
//   }
//
//   bool _isPaid(Installment inst) {
//     final s = inst.calculatedStatus?.toLowerCase() ?? inst.status?.toLowerCase() ?? '';
//     return s == 'paid';
//   }
//
//   Future<void> _submit() async {
//     if (_selected.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('Please select at least one installment'),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ));
//       return;
//     }
//
//     setState(() => _loading = true);
//
//     final selectedIds = _selected
//         .map((i) => _installments[i].id)
//         .where((id) => id != null)
//         .toList();
//
//     final success = await Provider.of<CollectFeePaymentViewModel>(
//       context,
//       listen: false,
//     ).collectFeePaymentApi(
//       widget.studentId,
//       selectedIds,
//       _paymentMode,
//       null,
//       null,
//       null,
//       context,
//     );
//
//     setState(() => _loading = false);
//
//     if (success && mounted) {
//       final adminProfile = Provider.of<SchoolAdminProfileViewModel>(
//           context, listen: false)
//           .schoolAdminProfileModel;
//
//       final receiptData = FeeReceiptData(
//         receiptNo:      'RCP-${DateTime.now().millisecondsSinceEpoch}',
//         studentName:    widget.studentName,
//         admissionNo:    '',
//         classSection:   '',
//         schoolName:     adminProfile?.data?.schoolName ?? '',
//         schoolAddress:  adminProfile?.data?.schoolAdrees ?? '',
//         academicYear:   '2026–27',
//         paymentDate:    DateFormat('d MMMM yyyy').format(DateTime.now()),
//         paymentTime:    DateFormat('hh:mm a').format(DateTime.now()),
//         paymentMethod:  _paymentMode,
//         feeDescription: widget.fee.feeHeadName ?? '',
//         installmentNo:  (_selected.isNotEmpty
//             ? _installments[_selected.first].installmentNo
//             : 1) ?? 1,
//         amount:         _selectedTotal,
//         amountInWords:  'Rupees ${_selectedTotal.toStringAsFixed(0)} Only',
//       );
//
//       widget.onPaymentDone();
//
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => FeeReceiptScreen(receipt: receiptData),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//       child: Container(
//         color: Colors.white,
//         height: MediaQuery.of(context).size.height * 0.88,
//         child: Column(children: [
//
//           Center(
//             child: Container(
//               width: 40, height: 4,
//               margin: const EdgeInsets.only(top: 10),
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//             child: Row(children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     gradient: AppColor.primaryGradient,
//                     borderRadius: BorderRadius.circular(12)),
//                 child: const Icon(Icons.payment_rounded,
//                     color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Collect Payment',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       Text(widget.fee.feeHeadName ?? '',
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.grey.shade500)),
//                     ]),
//               ),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100, shape: BoxShape.circle),
//                     child: const Icon(Icons.close_rounded, size: 18)),
//               ),
//             ]),
//           ),
//
//           const SizedBox(height: 14),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               const Text('Select Installments',
//                   style:
//                   TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//               const SizedBox(width: 4),
//               Text('*',
//                   style: TextStyle(
//                       color: Colors.red.shade400,
//                       fontWeight: FontWeight.bold)),
//               const SizedBox(width: 6),
//               Text('(click to select)',
//                   style: TextStyle(
//                       fontSize: 12, color: Colors.grey.shade500)),
//             ]),
//           ),
//
//           const SizedBox(height: 10),
//
//           Expanded(
//             child: _installments.isEmpty
//                 ? Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.list_alt_rounded,
//                           size: 46, color: Colors.grey.shade300),
//                       const SizedBox(height: 12),
//                       Text("No installments found",
//                           style: TextStyle(
//                               fontSize: 14, color: Colors.grey.shade500)),
//                     ]))
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 4),
//               itemCount: _installments.length,
//               itemBuilder: (context, index) {
//                 final Installment inst = _installments[index];
//                 final isPaid = _isPaid(inst);
//                 final isSel  = _selected.contains(index);
//
//                 return GestureDetector(
//                   onTap: isPaid
//                       ? null
//                       : () {
//                     setState(() {
//                       if (isSel)
//                         _selected.remove(index);
//                       else
//                         _selected.add(index);
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isSel
//                           ? Colors.orange.shade50
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                           color: isSel
//                               ? Colors.orange.shade300
//                               : Colors.grey.shade200,
//                           width: isSel ? 1.5 : 1),
//                     ),
//                     child: Row(children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         width: 22, height: 22,
//                         decoration: BoxDecoration(
//                           color: isPaid
//                               ? Colors.grey.shade200
//                               : isSel
//                               ? Colors.orange
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(
//                               color: isPaid
//                                   ? Colors.grey.shade300
//                                   : isSel
//                                   ? Colors.orange
//                                   : Colors.grey.shade400,
//                               width: 1.5),
//                         ),
//                         child: isSel && !isPaid
//                             ? const Icon(Icons.check_rounded,
//                             color: Colors.white, size: 14)
//                             : null,
//                       ),
//
//                       const SizedBox(width: 12),
//
//                       Expanded(
//                         child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Installment #${inst.installmentNo ?? (index + 1)}',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13,
//                                     color: isPaid
//                                         ? Colors.grey.shade500
//                                         : Colors.black87),
//                               ),
//                               const SizedBox(height: 3),
//                               Row(
//                                 children: [
//                                   Icon(Icons.calendar_today_rounded, size: 11, color: Colors.grey.shade400),
//                                   const SizedBox(width: 4),
//                                   Flexible(
//                                     child: Text(
//                                       'Due ${inst.startDueDate ?? inst.endDueDate ?? 'N/A'}'
//                                           '${isPaid && inst.paidOn != null ? ' · Paid ${inst.paidOn}' : ''}',
//                                       style: TextStyle(fontSize: 11, color: isPaid ? Colors.green.shade500 : Colors.grey.shade500),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ]),
//                       ),
//
//                       Text('₹${inst.amount ?? '0'}',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: isPaid
//                                   ? Colors.grey.shade400
//                                   : Colors.black87)),
//
//                       const SizedBox(width: 10),
//
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: isPaid
//                               ? Colors.green.shade50
//                               : Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           isPaid ? 'PAID' : 'PENDING',
//                           style: TextStyle(
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                               color: isPaid
//                                   ? Colors.green.shade600
//                                   : Colors.orange.shade600),
//                         ),
//                       ),
//                     ]),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           Container(
//             padding: EdgeInsets.fromLTRB(
//                 20, 14, 20, MediaQuery.of(context).viewInsets.bottom + 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -4))
//               ],
//             ),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//               Row(children: [
//                 Text('Mode:',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey.shade600)),
//                 const SizedBox(width: 10),
//                 ..._modes.map((mode) {
//                   final sel = _paymentMode == mode;
//                   return GestureDetector(
//                     onTap: () => setState(() => _paymentMode = mode),
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: sel
//                             ? AppColor.lightBlueColor
//                             : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(mode,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: sel
//                                   ? Colors.white
//                                   : Colors.grey.shade600)),
//                     ),
//                   );
//                 }).toList(),
//               ]),
//
//               if (_selected.isNotEmpty) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.orange.shade200),
//                   ),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${_selected.length} installment(s) selected',
//                           style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.orange.shade700,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         Text('₹${_selectedTotal.toStringAsFixed(0)}',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orange.shade700)),
//                       ]),
//                 ),
//               ],
//
//               const SizedBox(height: 12),
//
//               GestureDetector(
//                 onTap: _loading ? null : _submit,
//                 child: Container(
//                   width: double.infinity,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     gradient:
//                     _selected.isEmpty ? null : AppColor.primaryGradient,
//                     color: _selected.isEmpty ? Colors.grey.shade200 : null,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: _selected.isEmpty
//                         ? []
//                         : [
//                       BoxShadow(
//                           color:
//                           AppColor.lightBlueColor.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 5))
//                     ],
//                   ),
//                   child: Center(
//                     child: _loading
//                         ? const SizedBox(
//                         width: 24, height: 24,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 2))
//                         : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.check_circle_rounded,
//                             color: _selected.isEmpty
//                                 ? Colors.grey.shade400
//                                 : Colors.white,
//                             size: 20),
//                         const SizedBox(width: 8),
//                         Text(
//                           _selected.isEmpty
//                               ? 'Select Installments'
//                               : 'Confirm Payment  ₹${_selectedTotal.toStringAsFixed(0)}',
//                           style: TextStyle(
//                               color: _selected.isEmpty
//                                   ? Colors.grey.shade500
//                                   : Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.06),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// ═══════════════════════════════════════════════════════════════════════════════
//  DISCONTINUE FEE DIALOG  ✅ API Integrated
// ═══════════════════════════════════════════════════════════════════════════════

class _DiscontinueFeeDialog extends StatefulWidget {
  final FeeBreakdown fee;
  final dynamic studentId; // ✅
  final dynamic academicYear; // ✅

  const _DiscontinueFeeDialog({
    required this.fee,
    required this.studentId,
    required this.academicYear,
  });

  @override
  State<_DiscontinueFeeDialog> createState() => _DiscontinueFeeDialogState();
}

class _DiscontinueFeeDialogState extends State<_DiscontinueFeeDialog> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedReason;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _reasons = [
    'Student Left School',
    'Service/ facility Stopped',
    'Scholarship Granted',
    'Relocated',
    'Other',
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
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.fee;
    final paidAmt = fee.paidAmount ?? 0;
    final pendingAmt = fee.pendingAmount ?? 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.block_rounded,
                      color: Colors.orange.shade600,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Discontinue Fee Service',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade500,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Fee Head + Financial Balance
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FEE HEAD',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            fee.feeHeadName ?? '—',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
                        Text(
                          'FINANCIAL BALANCE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '₹$paidAmt',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pending:',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '₹$pendingAmt',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Discontinue Date + Reason
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'DISCONTINUE DATE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    DateFormat(
                                      'MM/dd/yyyy',
                                    ).format(_selectedDate),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
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
                        Row(
                          children: [
                            Text(
                              'REASON',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select reason...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              value: _selectedReason,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey.shade500,
                              ),
                              items: _reasons
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(
                                        r,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedReason = val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Additional Notes
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'ADDITIONAL NOTES',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    TextSpan(
                      text: '  (Optional)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Provide detailed explanation for records...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      // ✅ API call with loading state
                      onPressed: () async {
                        if (_selectedReason == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please select a reason'),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        final success =
                            await Provider.of<DiscontinueStudentViewModel>(
                              context,
                              listen: false,
                            ).discontinueStudentApi(
                              widget.studentId, // ✅ student_id
                              widget.academicYear, // ✅ academic_year
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(_selectedDate), // ✅ discontinued_on
                              _selectedReason, // ✅ discontinue_reason
                              context,
                            );

                        if (success && mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      // ✅ Loading indicator inside button
                      child: Consumer<DiscontinueStudentViewModel>(
                        builder: (_, vm, __) => vm.loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Confirm Discontinuation',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
}
