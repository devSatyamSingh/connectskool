import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/fees/fine_screen.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fees_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_management_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';

class FeesManagementScreen extends StatefulWidget {
  const FeesManagementScreen({super.key});

  @override
  State<FeesManagementScreen> createState() => _FeesManagementScreenState();
}

class _FeesManagementScreenState extends State<FeesManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? selectedAcademicYear;
  List<dynamic> academicYears = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeesManagementViewModel>(
        context,
        listen: false,
      ).feesManagementApi(context);
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        body: Consumer<FeesManagementViewModel>(
          builder: (context, viewModel, child) {
            final allFees = viewModel.feesManagementModel?.data?.fees ?? [];

            final totalFees = allFees.length;
            final monthlyCount = allFees
                .where((f) => f.feeFrequency?.toLowerCase() == 'monthly')
                .length;
            final yearlyCount = allFees
                .where((f) => f.feeFrequency?.toLowerCase() == 'yearly')
                .length;
            final oneTimeCount = allFees
                .where((f) => f.feeFrequency?.toLowerCase() == 'one_time')
                .length;
            final totalAmount = allFees.fold<double>(
              0,
                  (sum, f) => sum + (double.tryParse(f.totalAmount ?? '0') ?? 0),
            );

            return Column(
              children: [
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
                  child: Column(
                    children: [
                      Row(
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
                              'fees_management.title'.tr(),
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
                              totalFees.toString(),
                              size: 16,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'fees_management.monthly'.tr(),
                              monthlyCount.toString(),
                              Icons.calendar_month,
                              Colors.blue.shade100,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'fees_management.yearly'.tr(),
                              yearlyCount.toString(),
                              Icons.calendar_today,
                              Colors.green.shade100,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'fees_management.one_time'.tr(),
                              oneTimeCount.toString(),
                              Icons.payment,
                              Colors.orange.shade100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColor.lightBlueColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: AppColor.lightBlueColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.customText(
                                    'fees_management.total_fee_structure_amount'.tr(),
                                    size: 12,
                                    color: AppColor.softGreyText,
                                  ),
                                  const SizedBox(height: 4),
                                  AppText.customText(
                                    '₹${totalAmount.toStringAsFixed(2)}',
                                    size: 20,
                                    weight: FontWeight.bold,
                                    color: AppColor.lightBlueColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        _menuCard(
                          icon: Icons.category,
                          iconBg: Colors.blue.shade50,
                          iconColor: AppColor.lightBlueColor,
                          title: 'fees_management.fee_heads'.tr(),
                          subtitle: 'fees_management.fee_heads_sub'.tr(),
                          btnLabel: 'fees_management.open'.tr(),
                          btnColor: AppColor.lightBlueColor,
                          onTap: () {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                'fees_management.permission_denied'.tr(),
                                context,
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              RoutesName.feesHeadManagementScreen,
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        _menuCard(
                          icon: Icons.category,
                          iconBg: Colors.blue.shade50,
                          iconColor: AppColor.lightBlueColor,
                          title: 'fees_management.fine_rule'.tr(),
                          subtitle: 'fees_management.fine_rule_sub'.tr(),
                          btnLabel: 'fees_management.open'.tr(),
                          btnColor: AppColor.success,
                          onTap: () {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                'fees_management.permission_denied'.tr(),
                                context,
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FineManagementScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        _menuCard(
                          icon: Icons.receipt_long,
                          iconBg: Colors.green.shade50,
                          iconColor: Colors.green.shade600,
                          title: 'fees_management.fee_structure'.tr(),
                          subtitle: 'fees_management.fee_structure_sub'.tr(),
                          btnLabel: 'fees_management.add'.tr(),
                          btnColor: Colors.green.shade600,
                          onTap: () {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                'fees_management.permission_denied'.tr(),
                                context,
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              RoutesName.adminViewFeesStructureScreen,
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        _menuCard(
                          icon: Icons.payments_rounded,
                          iconBg: Colors.purple.shade50,
                          iconColor: Colors.purple.shade600,
                          title: 'fees_management.collect_fee'.tr(),
                          subtitle: 'fees_management.collect_fee_sub'.tr(),
                          btnLabel: 'fees_management.collect'.tr(),
                          btnColor: Colors.purple.shade600,
                          onTap: () {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                'fees_management.permission_denied'.tr(),
                                context,
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              RoutesName.schoolCollectFeesScreen,
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        _menuCard(
                          icon: Icons.list_alt_rounded,
                          iconBg: Colors.orange.shade50,
                          iconColor: Colors.orange.shade700,
                          title: 'fees_management.view_fee_structure'.tr(),
                          subtitle: 'fees_management.view_fee_structure_sub'.tr(),
                          btnLabel: 'fees_management.view'.tr(),
                          btnColor: Colors.orange.shade700,
                          onTap: () {
                            if (!PermissionExtensions.canAccess(
                              PermissionKeys.manageFees,
                            )) {
                              Utils.show(
                                'fees_management.permission_denied'.tr(),
                                context,
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              RoutesName.adminViewFeesStructureScreen,
                              arguments: {
                                'initialTab': 1,
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String btnLabel,
    required Color btnColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText(title, size: 15, weight: FontWeight.bold),
                const SizedBox(height: 4),
                AppText.customText(
                  subtitle,
                  size: 12,
                  color: AppColor.softGreyText,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
            child: Text(
              btnLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade700),
          const SizedBox(height: 4),
          AppText.customText(
            value,
            size: 16,
            weight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
          AppText.customText(title, size: 10, color: Colors.blue.shade700),
        ],
      ),
    );
  }
}