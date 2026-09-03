import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/delete_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/edit_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';

class FeesHeadManagementScreen extends StatefulWidget {
  const FeesHeadManagementScreen({super.key});

  @override
  State<FeesHeadManagementScreen> createState() =>
      _FeesHeadManagementScreenState();
}

class _FeesHeadManagementScreenState extends State<FeesHeadManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController _headNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeesHeadManagementViewModel>(
        context,
        listen: false,
      ).feesHeadManagementApi(context);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _headNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showEditFeeHeadBottomSheet(dynamic head) {
    _headNameController.text = head.headName ?? "";
    _descriptionController.text = head.description ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColor.cardWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText.customText(
                          'fees_head.edit_fee_head'.tr(),
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  AppText.customText(
                    'fees_head.head_name'.tr(),
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _headNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.pageBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  AppText.customText(
                    'fees_head.description'.tr(),
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.pageBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: 'fees_head.update_fee_head'.tr(),
                      onTap: () {
                        if (_headNameController.text.trim().isEmpty) {
                          Utils.show(
                            'fees_head.head_name_required_edit'.tr(),
                            context,
                          );
                          return;
                        }

                        Provider.of<EditFeesHeadViewModel>(
                              context,
                              listen: false,
                            )
                            .editFeesHeadApi(
                              head.feeHeadId,
                              _headNameController.text.trim(),
                              _descriptionController.text.trim(),
                              context,
                            )
                            .then((_) {
                              Navigator.pop(context);
                              Provider.of<FeesHeadManagementViewModel>(
                                context,
                                listen: false,
                              ).feesHeadManagementApi(context);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(dynamic head) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 35,
                    color: Colors.red.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'fees_head.delete_fee_head'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'fees_head.confirm_delete'.tr() +
                      '\n\n' +
                      'fees_head.action_undo'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                if ((head.headName ?? "").isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 18,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            head.headName ?? "",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'fees_head.cancel'.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<DeleteFeesHeadViewModel>(
                        builder: (_, vm, __) {
                          return ElevatedButton(
                            onPressed: vm.loading
                                ? null
                                : () async {
                                    final result = await vm.deleteFeesHeadApi(
                                      head.feeHeadId,
                                      context,
                                    );
                                    if (!mounted) return;
                                    Navigator.pop(dialogContext);
                                    Utils.show(
                                      result["message"] ??
                                          'fees_head.something_wrong'.tr(),
                                      context,
                                    );
                                    if (result["success"] == true) {
                                      await Provider.of<
                                            FeesHeadManagementViewModel
                                          >(context, listen: false)
                                          .feesHeadManagementApi(context);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: vm.loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'fees_head.delete'.tr(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddFeeHeadBottomSheet() {
    _headNameController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColor.cardWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText.customText(
                          'fees_head.add_new_fee_head'.tr(),
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  AppText.customText(
                    'fees_head.head_name'.tr(),
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _headNameController,
                    decoration: InputDecoration(
                      hintText: 'fees_head.head_name_hint'.tr(),
                      hintStyle: TextStyle(color: AppColor.softGreyText),
                      filled: true,
                      fillColor: AppColor.pageBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppText.customText(
                    'fees_head.description'.tr(),
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'fees_head.description_hint'.tr(),
                      hintStyle: TextStyle(color: AppColor.softGreyText),
                      filled: true,
                      fillColor: AppColor.pageBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: 'fees_head.add_fee_head_btn'.tr(),
                      onTap: () {
                        final createHead = Provider.of<CreateFeesHeadViewModel>(
                          context,
                          listen: false,
                        );
                        if (_headNameController.text.trim().isEmpty) {
                          Utils.show(
                            'fees_head.head_name_required'.tr(),
                            context,
                          );
                          return;
                        }

                        createHead.createFeesHeadApi(
                          _headNameController.text.trim(),
                          _descriptionController.text.trim(),
                          context,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        floatingActionButton: SizedBox(
          width: 180,
          child: AppButton(
            title: 'fees_head.add_fee_head'.tr(),
            icon: Icons.add_rounded,
            height: 56,
            radius: 18,
            onTap: _showAddFeeHeadBottomSheet,
          ),
        ),
        body: Consumer<FeesHeadManagementViewModel>(
          builder: (context, vm, _) {
            final feeHeads = vm.feesHeadManagementModel?.data?.feeHeads ?? [];

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 22),
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
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText.customText(
                          'fees_head.title'.tr(),
                          size: 19,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.glassWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText.customText(
                          feeHeads.length.toString(),
                          size: 15,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Expanded(
                  child: vm.loading
                      ? _shimmer()
                      : feeHeads.isEmpty
                      ? _emptyView()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
                          itemCount: feeHeads.length,
                          itemBuilder: (context, index) {
                            return _animatedCard(index, feeHeads[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _feeHeadCard(dynamic head) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.category, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(
                    head.headName ?? "",
                    size: 17,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(height: 6),
                  AppText.customText(
                    head.description ?? 'fees_head.no_description'.tr(),
                    size: 12,
                    color: AppColor.softGreyText,
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () {
                    _showEditFeeHeadBottomSheet(head);
                  },
                  icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteDialog(head);
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedCard(int index, dynamic head) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_controller.value - delay).clamp(0.0, 1.0) / (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _feeHeadCard(head),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category, size: 60, color: AppColor.lightBlueColor),
          const SizedBox(height: 16),
          AppText.customText(
            'fees_head.no_fee_heads'.tr(),
            size: 16,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 130,
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
