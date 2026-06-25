import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fine_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fine_rule_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../view_model/school_view_model/fees/fees_head_management_view_model.dart';

class FineManagementScreen extends StatefulWidget {
  const FineManagementScreen({super.key});

  @override
  State<FineManagementScreen> createState() => _FineManagementScreenState();
}

class _FineManagementScreenState extends State<FineManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FineRuleViewModel>(
        context,
        listen: false,
      ).fineRuleApi(context);
      Provider.of<FeesHeadManagementViewModel>(
        context,
        listen: false,
      ).feesHeadManagementApi(context);
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

  // ── Add / Edit Bottom Sheet ───────────────────────────────────────────────
  void _openAddEditFineSheet({
    bool isEdit = false,
    String? ruleId,
    String? ruleName,
    String? amount,
    String? fineType,
    String? graceDays,
    String? maxFineCap,
    String? applicableTo,
    String? feeHeadId,
  }) {
    final nameController = TextEditingController(text: ruleName);
    final amountController = TextEditingController(text: amount);
    final graceController = TextEditingController(text: graceDays);
    final maxCapController = TextEditingController(text: maxFineCap);

    final selectedType = ValueNotifier<String>(fineType ?? "per_day");
    // _openAddEditFineSheet me
    final selectedApplicable = ValueNotifier<String>(
      (applicableTo == "specific_fee" || applicableTo == "specific_fee_head")
          ? "specific_fee"
          : applicableTo ?? "all_fees",
    );
    // final selectedApplicable = ValueNotifier<String>(applicableTo ?? "all_fees");
    final selectedFeeHead = ValueNotifier<String?>(feeHeadId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.pageBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (ctx, setSheetState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Title ─────────────────────────────────────────
                      AppText.customText(
                        isEdit ? "Edit Fine Rule" : "Add Fine Rule",
                        size: 18,
                        weight: FontWeight.bold,
                      ),

                      const SizedBox(height: 20),

                      // ── Rule Name ─────────────────────────────────────
                      _buildTextField(
                        nameController,
                        "Rule Name",
                        Icons.label_outline,
                      ),

                      const SizedBox(height: 14),

                      // ── Fine Type Dropdown ────────────────────────────
                      AppText.customText(
                        "Fine Type",
                        size: 13,
                        color: AppColor.softGreyText,
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedType,
                        builder: (_, type, __) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: DropdownMenu<String>(
                              initialSelection: type,

                              width: double.infinity,

                              menuHeight: 250,

                              leadingIcon: Icon(
                                Icons.gavel_rounded,
                                color: AppColor.lightBlueColor,
                                size: 20,
                              ),

                              textStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),

                              inputDecorationTheme: InputDecorationTheme(
                                filled: true,
                                fillColor: Colors.white,

                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AppColor.lightBlueColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),

                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "per_day",
                                  label: "Per Day Fine",
                                ),
                              ],
                              onSelected: (value) {
                                if (value != null) {
                                  selectedType.value = value;
                                }
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      // ── Fine Amount ───────────────────────────────────
                      _buildTextField(
                        amountController,
                        "Fine Amount (₹)",
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      // ── Grace Period (Optional) ───────────────────────
                      _buildTextField(
                        graceController,
                        "Grace Period (Days) — Optional",
                        Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      // ── Max Fine Cap (Optional) ───────────────────────
                      _buildTextField(
                        maxCapController,
                        "Maximum Fine Cap (₹) — Optional",
                        Icons.security,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      AppText.customText(
                        "Applicable To",
                        size: 13,
                        color: AppColor.softGreyText,
                      ),
                      const SizedBox(height: 8),

                      ValueListenableBuilder<String>(
                        valueListenable: selectedApplicable,
                        builder: (_, applicable, __) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTypeChip(
                                      "All Fees",
                                      "all_fees",
                                      applicable,
                                      Icons.all_inclusive,
                                      () {
                                        setSheetState(() {
                                          selectedApplicable.value = "all_fees";
                                          selectedFeeHead.value = null;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTypeChip(
                                      "Specific Fee",
                                      "specific_fee",
                                      applicable,
                                      Icons.category,
                                      () => setSheetState(
                                        () => selectedApplicable.value =
                                            "specific_fee",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (applicable == "specific_fee") ...[
                                const SizedBox(height: 12),
                                Consumer<FeesHeadManagementViewModel>(
                                  builder: (context, feeHeadVM, _) {
                                    if (feeHeadVM.loading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final feeHeads =
                                        feeHeadVM
                                            .feesHeadManagementModel
                                            ?.data
                                            ?.feeHeads ??
                                        [];

                                    return DropdownButtonFormField<String>(
                                      value: selectedFeeHead.value,
                                      hint: Text("Select Fee Head", style: GoogleFonts.poppins(),),
                                      items: feeHeads.map((e) {
                                        return DropdownMenuItem(
                                          value: e.feeHeadId.toString(),
                                          child: Text(e.headName ?? "", style: GoogleFonts.poppins(),),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        selectedFeeHead.value = val;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      AppButton(
                        title: isEdit ? "Update Rule" : "Add Rule",
                        // onTap: () {
                        //   // Validation
                        //   if (nameController.text.trim().isEmpty ||
                        //       amountController.text.trim().isEmpty) {
                        //     Utils.show(
                        //         "Rule name and amount required", context);
                        //     return;
                        //   }
                        //
                        //   // specific_fee select kiya but fee head nahi chuna
                        //   if (selectedApplicable.value == "specific_fee" &&
                        //       selectedFeeHead.value == null) {
                        //     Utils.show("Please select a fee head", context);
                        //     return;
                        //   }
                        //
                        //   // Optional fields — null bhejo agar empty ho
                        //   final graceDays =
                        //   graceController.text.trim().isEmpty
                        //       ? null
                        //       : graceController.text.trim();
                        //
                        //   final maxCap =
                        //   maxCapController.text.trim().isEmpty
                        //       ? null
                        //       : maxCapController.text.trim();
                        //
                        //   Provider.of<CreateFineViewModel>(context,
                        //       listen: false)
                        //       .createFineApi(
                        //     nameController.text.trim(),
                        //     selectedType.value,
                        //     amountController.text.trim(),
                        //     graceDays,
                        //     maxCap,
                        //     selectedApplicable.value,
                        //     selectedApplicable.value == "specific_fee"
                        //         ? selectedFeeHead.value
                        //         : null,
                        //     context,
                        //   );
                        // },
                        onTap: () {
                          if (nameController.text.trim().isEmpty ||
                              amountController.text.trim().isEmpty) {
                            Utils.show(
                              "Rule name and amount required",
                              context,
                            );
                            return;
                          }

                          if (selectedApplicable.value == "specific_fee" &&
                              selectedFeeHead.value == null) {
                            Utils.show("Please select a fee head", context);
                            return;
                          }

                          final graceDays = graceController.text.trim().isEmpty
                              ? null
                              : graceController.text.trim();

                          final maxCap = maxCapController.text.trim().isEmpty
                              ? null
                              : maxCapController.text.trim();

                          final vm = Provider.of<CreateFineViewModel>(
                            context,
                            listen: false,
                          );

                          if (isEdit) {
                            vm.updateFineApi(
                              ruleId,
                              nameController.text.trim(),
                              selectedType.value,
                              amountController.text.trim(),
                              graceDays,
                              maxCap,
                              selectedApplicable.value,
                              selectedApplicable.value == "specific_fee"
                                  ? selectedFeeHead.value
                                  : null,
                              context,
                            );
                          } else {
                            vm.createFineApi(
                              nameController.text.trim(),
                              selectedType.value,
                              amountController.text.trim(),
                              graceDays,
                              maxCap,
                              selectedApplicable.value,
                              selectedApplicable.value == "specific_fee"
                                  ? selectedFeeHead.value
                                  : null,
                              context,
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColor.lightBlueColor, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2),
        ),
      ),
    );
  }

  // ── Chip Builder ──────────────────────────────────────────────────────────
  Widget _buildTypeChip(
    String label,
    String value,
    String currentValue,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isSelected = currentValue == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColor.primaryGradient : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            AppText.customText(
              label,
              size: 13,
              weight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String ruleId, String ruleName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Text("Delete Fine Rule", style: GoogleFonts.poppins(),),
          ],
        ),
        content: Text(
          "Are you sure you want to delete '$ruleName'? This action cannot be undone.",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.customText("Cancel", size: 14, color: Colors.black),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await Provider.of<CreateFineViewModel>(
                context,
                listen: false,
              ).deleteFineApi(ruleId, context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FineRuleViewModel>(context);
    final loading = vm.loading;
    final fineRules = vm.fineRuleModel?.data?.fineRules ?? [];

    final totalRules = fineRules.length;
    final totalAmount = fineRules.fold<double>(
      0,
      (sum, rule) => sum + (double.tryParse(rule.fineAmount.toString()) ?? 0),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.endFloat,

        floatingActionButton: SizedBox(
          width: 160,
          child: AppButton(
            title: "Add Rule",
            icon: Icons.add_rounded,
            height: 56,
            radius: 18,
            onTap: () {
              if (!PermissionExtensions.canAccess(
                PermissionKeys.manageFees,
              )) {
                Utils.show(
                  "You don't have permission to perform this action.",
                  context,
                );
                return;
              }

              _openAddEditFineSheet();
            },
          ),
        ),
        body: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
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
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText.customText(
                      "Fine Rules",
                      size: 19,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.glassWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText.customText(
                      totalRules.toString(),
                      size: 15,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ── Total Amount Card ─────────────────────────────────────────
            if (totalRules > 0)
              Container(
                margin: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColor.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                          "Total Fine Amount",
                          size: 12,
                          color: AppColor.softGreyText,
                        ),
                        const SizedBox(height: 4),
                        AppText.customText(
                          "₹${totalAmount.toStringAsFixed(2)}",
                          size: 20,
                          weight: FontWeight.w500,
                          color: AppColor.lightBlueColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: loading
                  ? _fineShimmer()
                  : fineRules.isEmpty
                  ? _emptyView()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 90),
                      physics: const BouncingScrollPhysics(),
                      itemCount: fineRules.length,
                      itemBuilder: (context, index) {
                        final f = fineRules[index];
                        final isSpecific =
                            f.applicableTo == "specific_fee" ||
                            f.applicableTo == "specific_fee_head" ||
                            (f.feeHeadId != null &&
                                f.feeHeadId.toString().isNotEmpty &&
                                f.feeHeadId.toString() != "null" &&
                                f.feeHeadId.toString() != "0");
                        final applicableText = isSpecific
                            ? (f.feeHeadName != null &&
                                      f.feeHeadName.toString().isNotEmpty
                                  ? f.feeHeadName.toString()
                                  : "Fee Head #${f.feeHeadId ?? '-'}")
                            : "All Fees";

                        // ✅ Debug — API se kya aa raha hai dekho
                        debugPrint(
                          "Rule: ${f.ruleName} | applicableTo: ${f.applicableTo} | feeHeadId: ${f.feeHeadId} | feeHeadName: ${f.feeHeadName}",
                        );

                        return _animatedFineCard(
                          index,
                          fineRuleId: f.fineRuleId,
                          ruleName: f.ruleName ?? "-",
                          fineType: f.fineType ?? "per_day",
                          amount: f.fineAmount?.toString() ?? "0",
                          grace: f.gracePeriodDays?.toString() ?? "0",
                          applicable: applicableText,
                          isSpecific: isSpecific,
                          feeHeadId: f.feeHeadId?.toString(),
                          maxFineCap: f.maxFineCap?.toString(),
                          applicableTo: f.applicableTo?.toString(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Animated Card Wrapper ─────────────────────────────────────────────────
  Widget _animatedFineCard(
    int index, {
    required String ruleName,
    required String fineType,
    required String amount,
    required String grace,
    required String applicable,
    required bool isSpecific,
    required dynamic fineRuleId,
    required String? feeHeadId,
    required String? maxFineCap,
    required String? applicableTo,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 25 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _fineCard(
        fineRuleId: fineRuleId,
        ruleName: ruleName,
        fineType: fineType,
        amount: amount,
        grace: grace,
        applicable: applicable,
        isSpecific: isSpecific,
        feeHeadId: feeHeadId,
        maxFineCap: maxFineCap,
        applicableTo: applicableTo,
      ),
    );
  }

  // ── Fine Rule Card ────────────────────────────────────────────────────────
  Widget _fineCard({
    required dynamic fineRuleId,
    required String ruleName,
    required String fineType,
    required String amount,
    required String grace,
    required String applicable,
    required bool isSpecific,
    required String? feeHeadId,
    required String? maxFineCap,
    required String? applicableTo,
  }) {
    final w = MediaQuery.of(context).size.width;
    final isPerDay = fineType.toLowerCase() == "per_day";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left icon ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPerDay
                      ? [Colors.blue.shade400, Colors.blue.shade200]
                      : [Colors.green.shade400, Colors.green.shade200],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isPerDay ? Icons.today_rounded : Icons.attach_money,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: w * 0.024),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText.customText(
                          ruleName,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),

                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: AppColor.lightBlueColor.withOpacity(.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.lightBlueColor.withOpacity(.15),
                          ),
                        ),
                        child: PopupMenuButton<String>(
                          color: Colors.white,
                          padding: EdgeInsets.zero,
                          elevation: 4,
                          tooltip: "Actions",

                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: AppColor.lightBlueColor,
                            size: 20,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),

                          onSelected: (value) {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                "You don't have permission to perform this action.",
                                context,
                              );
                              return;
                            }
                            if (value == "edit") {
                              _openAddEditFineSheet(
                                isEdit: true,
                                ruleId: fineRuleId.toString(),
                                ruleName: ruleName,
                                amount: amount,
                                fineType: fineType,
                                graceDays: grace,
                                maxFineCap: maxFineCap,
                                applicableTo: applicableTo,
                                feeHeadId: feeHeadId,
                              );
                            }
                            if (value == "delete") {
                              _confirmDelete(fineRuleId.toString(), ruleName);
                            }
                          },

                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      size: 16,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 10),
                                  Text(
                                    "Edit Rule",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 15,
                                      color: Colors.red.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    "Delete Rule",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
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

                  const SizedBox(height: 8),

                  // Amount
                  _infoRow(
                    Icons.currency_rupee,
                    "Amount",
                    "₹$amount",
                    AppColor.lightBlueColor,
                  ),

                  // Grace Period
                  _infoRow(
                    Icons.calendar_today,
                    "Grace Period",
                    "$grace days",
                    Colors.orange.shade700,
                  ),

                  // ✅ Applicable To — fee head name dikhega specific_fee mein
                  _infoRow(
                    isSpecific ? Icons.receipt_long : Icons.all_inclusive,
                    "Applicable To",
                    applicable,
                    isSpecific ? Colors.deepPurple : Colors.purple.shade700,
                  ),

                  const SizedBox(height: 6),

                  // ── Badges ──────────────────────────────────────────
                  Row(
                    children: [
                      // Fine type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPerDay
                              ? Colors.blue.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText.customText(
                          fineType,
                          size: 11,
                          weight: FontWeight.w600,
                          color: isPerDay
                              ? Colors.blue.shade700
                              : Colors.green.shade700,
                        ),
                      ),

                      // ✅ "Specific Fee" badge — sirf tab dikhe
                      if (isSpecific) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText.customText(
                            "Specific Fee",
                            size: 11,
                            weight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info Row ──────────────────────────────────────────────────────────────
  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          AppText.customText(
            "$label: ",
            size: 12,
            color: AppColor.softGreyText,
          ),
          Expanded(
            child: AppText.customText(
              value,
              size: 12,
              weight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rule_rounded,
              size: 60,
              color: AppColor.lightBlueColor,
            ),
          ),
          const SizedBox(height: 20),
          AppText.customText(
            "No fine rules found",
            size: 16,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          AppText.customText(
            "Tap the + button to add your first rule",
            size: 13,
            color: AppColor.softGreyText,
          ),
        ],
      ),
    );
  }

  // ── Shimmer ───────────────────────────────────────────────────────────────
  Widget _fineShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
