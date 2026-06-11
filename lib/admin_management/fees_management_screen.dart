import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/admin_management/fine_screen.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_fees_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_management_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';

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
      Provider.of<FeesManagementViewModel>(context, listen: false)
          .feesManagementApi(context);
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
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
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Consumer<FeesManagementViewModel>(
        builder: (context, viewModel, child) {
          final allFees = viewModel.feesManagementModel?.data?.fees ?? [];

          final totalFees      = allFees.length;
          final monthlyCount   = allFees.where((f) => f.feeFrequency?.toLowerCase() == 'monthly').length;
          final yearlyCount    = allFees.where((f) => f.feeFrequency?.toLowerCase() == 'yearly').length;
          final oneTimeCount   = allFees.where((f) => f.feeFrequency?.toLowerCase() == 'one_time').length;
          final totalAmount    = allFees.fold<double>(
            0, (sum, f) => sum + (double.tryParse(f.totalAmount ?? '0') ?? 0),
          );

          return Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                  boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppText.customText('Fee Management', size: 19, weight: FontWeight.bold, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColor.glassWhite, borderRadius: BorderRadius.circular(20)),
                          child: AppText.customText(totalFees.toString(), size: 16, weight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats Row
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Monthly',   monthlyCount.toString(),  Icons.calendar_month, Colors.blue.shade100)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatCard('Yearly',    yearlyCount.toString(),   Icons.calendar_today, Colors.green.shade100)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatCard('One Time',  oneTimeCount.toString(),  Icons.payment,        Colors.orange.shade100)),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ──────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [

                      // ── Total Amount card ──────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.cardWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.lightBlueColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.account_balance_wallet, color: AppColor.lightBlueColor, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.customText('Total Fee Structure Amount', size: 12, color: AppColor.softGreyText),
                                const SizedBox(height: 4),
                                AppText.customText(
                                  '₹${totalAmount.toStringAsFixed(2)}',
                                  size: 20, weight: FontWeight.bold, color: AppColor.lightBlueColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Fee Heads ──────────────────────────────────────
                      _menuCard(
                        icon: Icons.category,
                        iconBg: Colors.blue.shade50,
                        iconColor: AppColor.lightBlueColor,
                        title: 'Fee Heads',
                        subtitle: 'Create & manage fee categories',
                        btnLabel: 'Open',
                        btnColor: AppColor.lightBlueColor,
                        onTap: () => Navigator.pushNamed(context, RoutesName.feesHeadManagementScreen),
                      ),
                       SizedBox(height: 10),
                      _menuCard(
                        icon: Icons.category,
                        iconBg: Colors.blue.shade50,
                        iconColor: AppColor.lightBlueColor,
                        title: 'Fine Rule',
                        subtitle: 'Create & manage Fine Rules',
                        btnLabel: 'Open',
                        btnColor: AppColor.success,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FineManagementScreen()));
                        }
                            // Navigator.pushNamed(context, RoutesName.fine),
                      ),
                      const SizedBox(height: 10),
                      // ── Fee Structure ──────────────────────────────────
                      _menuCard(
                        icon: Icons.receipt_long,
                        iconBg: Colors.green.shade50,
                        iconColor: Colors.green.shade600,
                        title: 'Fee Structure',
                        subtitle: 'Create & manage fee structures',
                        btnLabel: 'Add',
                        btnColor: Colors.green.shade600,
                        onTap: () => Navigator.pushNamed(context, RoutesName.adminViewFeesStructureScreen),
                      ),
                      const SizedBox(height: 10),

                      // ── Collect Fee ────────────────────────────────────
                      _menuCard(
                        icon: Icons.payments_rounded,
                        iconBg: Colors.purple.shade50,
                        iconColor: Colors.purple.shade600,
                        title: 'Collect Fee',
                        subtitle: 'Record & collect student payments',
                        btnLabel: 'Collect',
                        btnColor: Colors.purple.shade600,
                        onTap: () => Navigator.pushNamed(context, RoutesName.schoolCollectFeesScreen),
                      ),
                      const SizedBox(height: 10),

                      // ── View Fee Structure ─────────────────────────────
                      // ── View Fee Structure ─────────────────────────────
                      _menuCard(
                        icon: Icons.list_alt_rounded,
                        iconBg: Colors.orange.shade50,
                        iconColor: Colors.orange.shade700,
                        title: 'View Fee Structure',
                        subtitle: 'Browse all existing fee structures',
                        btnLabel: 'View',
                        btnColor: Colors.orange.shade700,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RoutesName.adminViewFeesStructureScreen,
                          arguments: {'initialTab': 1}, // ✅ View All tab index
                        ),
                      ),
                      // _menuCard(
                      //   icon: Icons.list_alt_rounded,
                      //   iconBg: Colors.orange.shade50,
                      //   iconColor: Colors.orange.shade700,
                      //   title: 'View Fee Structure',
                      //   subtitle: 'Browse all existing fee structures',
                      //   btnLabel: 'View',
                      //   btnColor: Colors.orange.shade700,
                      //   onTap: () => Navigator.pushNamed(context, RoutesName.adminViewFeesStructureScreen),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Menu card ────────────────────────────────────────────────────────────
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
        boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText(title, size: 15, weight: FontWeight.bold),
                const SizedBox(height: 4),
                AppText.customText(subtitle, size: 12, color: AppColor.softGreyText),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
            child: Text(btnLabel, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Stat card ─────────────────────────────────────────────────────────────
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade700),
          const SizedBox(height: 4),
          AppText.customText(value, size: 16, weight: FontWeight.bold, color: Colors.blue.shade700),
          AppText.customText(title, size: 10, color: Colors.blue.shade700),
        ],
      ),
    );
  }
}