import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/create_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_head_management_view_model.dart';
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

  // Controllers for bottom sheet
  final TextEditingController _headNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeesHeadManagementViewModel>(context, listen: false)
          .feesHeadManagementApi(context);
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

                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText.customText(
                          "Edit Fee Head",
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

                  /// HEAD NAME
                  AppText.customText("Head Name",
                      size: 14, weight: FontWeight.w600),
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

                  /// DESCRIPTION
                  AppText.customText("Description",
                      size: 14, weight: FontWeight.w600),
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

                  /// UPDATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: "Update Fee Head",
                      onTap: () {
                        if (_headNameController.text.trim().isEmpty) {
                          Utils.show("Head name required", context);
                          return;
                        }

                        Provider.of<EditFeesHeadViewModel>(
                          context,
                          listen: false,
                        ).editFeesHeadApi(
                           head. feeHeadId,
                          _headNameController.text.trim(),
                          _descriptionController.text.trim(),
                          context,
                        ).then((_) {
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
  // void _showDeleteDialog(dynamic head) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Delete Fee Head"),
  //         content: const Text(
  //           "Are you sure you want to delete this fee head?",
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //
  //               Provider.of<DeleteFeesHeadViewModel>(
  //                 context,
  //                 listen: false,
  //               ).deleteFeesHeadApi(
  //                 head.feeHeadId,
  //                 context,
  //               ).then((_) {
  //                 Provider.of<FeesHeadManagementViewModel>(
  //                   context,
  //                   listen: false,
  //                 ).feesHeadManagementApi(context);
  //               });
  //             },
  //             child: const Text(
  //               "Delete",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showDeleteDialog(dynamic head) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Fee Head"),
          content: const Text(
            "Are you sure you want to delete this fee head?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // dialog close first ✅

                final success =
                await Provider.of<DeleteFeesHeadViewModel>(
                  context,
                  listen: false,
                ).deleteFeesHeadApi(head.feeHeadId);

                if (!mounted) return; // 🔥 MOST IMPORTANT LINE

                if (success) {
                  Utils.show(
                      "Fee head deleted successfully", context);

                  Provider.of<FeesHeadManagementViewModel>(
                    context,
                    listen: false,
                  ).feesHeadManagementApi(context);
                } else {
                  Utils.show("Delete failed", context);
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddFeeHeadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false, // 👈 important for bottom sheet
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
                  /// Header
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
                          "Add New Fee Head",
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

                  /// Head Name
                  AppText.customText(
                    "Head Name",
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _headNameController,
                    decoration: InputDecoration(
                      hintText: "e.g., Transport Fee",
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

                  /// Description
                  AppText.customText(
                    "Description",
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "e.g., Monthly transport fee",
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

                  /// Submit
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: 'Add Fee Head',
                      onTap: () {
                        final createHead = Provider.of<CreateFeesHeadViewModel>(context,listen: false);
                        if (_headNameController.text.trim().isEmpty) {
                          Utils.show("Please enter head name", context);
                          return;
                        }

                        // final body = {
                        //   "head_name": _headNameController.text.trim(),
                        //   "description":
                        //   _descriptionController.text.trim(),
                        // };
                        createHead.createFeesHeadApi(
                            _headNameController.text.trim(),
                            _descriptionController.text.trim(),
                            context);

                        // API call yahin se
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
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightBlueColor,
        onPressed: _showAddFeeHeadBottomSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Fee Head",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Consumer<FeesHeadManagementViewModel>(
        builder: (context, vm, _) {
          final feeHeads = vm.feesHeadManagementModel?.data?.feeHeads ?? [];

          return Column(
            children: [
              /// ===== HEADER =====
              Container(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 22),
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
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
                        "Fees Head Management",
                        size: 19,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
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

              /// ===== LIST =====
              Expanded(
                child: vm.loading
                    ? _shimmer()
                    : feeHeads.isEmpty
                    ? _emptyView()
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(18, 8, 18, 90),
                  itemCount: feeHeads.length,
                  itemBuilder: (context, index) {
                    return _animatedCard(
                        index, feeHeads[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ===== CARD =====
  Widget _feeHeadCard(dynamic head) {
    final isActive = head.status == 1;

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
            /// ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.category,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(
                    head.headName ?? "",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 6),
                  AppText.customText(
                    head.description ?? "No description available",
                    size: 12,
                    color: AppColor.softGreyText,
                  ),
                  const SizedBox(height: 10),

                  // /// STATUS
                  // Container(
                  //   padding:
                  //   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: isActive
                  //         ? Colors.green.withOpacity(0.15)
                  //         : Colors.red.withOpacity(0.15),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: AppText.customText(
                  //     isActive ? "ACTIVE" : "INACTIVE",
                  //     size: 10,
                  //     weight: FontWeight.bold,
                  //     color: isActive ? Colors.green : Colors.red,
                  //   ),
                  // ),
                ],
              ),
            ),

            /// ACTION
            /// ACTION
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    _showEditFeeHeadBottomSheet(head);
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteDialog(head);
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            // IconButton(
            //   onPressed: () {
            //     _showEditFeeHeadBottomSheet(head);
            //   },
            //   icon: const Icon(Icons.edit_rounded,
            //       color: Colors.blue),
            // ),
          ],
        ),
      ),
    );
  }

  /// ===== ANIMATION =====
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

  /// ===== EMPTY =====
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category,
              size: 60, color: AppColor.lightBlueColor),
          const SizedBox(height: 16),
          AppText.customText(
            "No Fee Heads Found",
            size: 16,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  /// ===== SHIMMER =====
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