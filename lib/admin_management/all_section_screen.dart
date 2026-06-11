import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/create_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_section_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import '../repo/school_repo/update_section_repo.dart';
import '../res/app_button.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/all_scetions_view_model.dart';
import '../view_model/school_view_model/delete_section_view_model.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({super.key});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // ── Selected class filter for list ──
  String? selectedFilterClassId;
  late AllClassesViewModel _classesVm;
  late AllSectionsViewModel _sectionsVm;

  @override
  void initState() {
    super.initState();

    _classesVm = Provider.of<AllClassesViewModel>(context, listen: false);
    _sectionsVm = Provider.of<AllSectionsViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _classesVm.allClassesApi(context);

      // 2️⃣ First class id nikalo
      if (_classesVm.allClassesModel?.data != null &&
          _classesVm.allClassesModel!.data!.isNotEmpty) {
        final firstClassId =
            _classesVm.allClassesModel!.data!.first.classId;

        // 3️⃣ Pass classId to section API
        _sectionsVm.allSectionsApi(context, firstClassId.toString());
      }
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

  Future<void> _onRefresh() async {
    final classId = selectedFilterClassId ??
        (_classesVm.allClassesModel?.data?.isNotEmpty == true
            ? _classesVm.allClassesModel!.data!.first.classId.toString()
            : null);

    if (classId != null) {
      await _sectionsVm.allSectionsApi(context, classId);
    }
    _animationController.reset();
    _animationController.forward();
  }

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // void _snack(BuildContext ctx, String msg) {
  //   ScaffoldMessenger.of(ctx).showSnackBar(
  //     SnackBar(
  //       content: Row(children: [
  //         const Icon(Icons.info_outline_rounded,
  //             color: Colors.white, size: 18),
  //         const SizedBox(width: 8),
  //         Expanded(
  //             child: Text(msg,
  //                 style:
  //                 const TextStyle(fontWeight: FontWeight.w500))),
  //       ]),
  //       backgroundColor: AppColor.error,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12)),
  //       margin: const EdgeInsets.all(16),
  //     ),
  //   );
  // }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final sectionVM = Provider.of<AllSectionsViewModel>(context);
    final classVM = Provider.of<AllClassesViewModel>(context);
    final classes = classVM.allClassesModel?.data ?? [];
    final allSections = sectionVM.allSectionsModel?.data ?? [];

    // Filter sections by selected class
    final sections = selectedFilterClassId == null
        ? allSections
        : allSections
        .where((s) =>
    s.classId.toString() == selectedFilterClassId)
        .toList();

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primary,
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Section',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
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
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText.customText(
                        "Sections",
                        size: 19,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AppText.customText(
                      "${sections.length}",
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _openAddSheet,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.glassWhite,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Class Filter Dropdown ──
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilterClassId,
                      isExpanded: true,
                      dropdownColor: AppColor.primary,
                      icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white70),
                      hint: const Row(
                        children: [
                          Icon(Icons.filter_list_rounded,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Filter by Class (All)",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      items: [
                        ...classes.map((c) => DropdownMenuItem<String>(
                          value: c.classId.toString(),
                          child: Text(
                            c.className ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                      ],
                      onChanged: (val) {
                        setState(() => selectedFilterClassId = val);
                        if (val != null) {
                          // ✅ Class change hone par fresh API call
                          Provider.of<AllSectionsViewModel>(context,
                              listen: false)
                              .allSectionsApi(context, val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: sectionVM.loading
                ? _shimmer()
                : sections.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_agenda_outlined,
                      size: 60,
                      color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    "No Sections Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
            // ✅ Pull to Refresh wrapped ListView
                : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.primary,
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              displacement: 60,
              child: ListView.builder(
                // ✅ Zaruri: list choti ho tab bhi pull kaam kare
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(18, 8, 18, 100),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final s = sections[index];
                  return _animatedCard(index, s);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Shimmer
  // ─────────────────────────────────────────────
  Widget _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColor.cardWhite,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Animated card wrapper
  // ─────────────────────────────────────────────
  Widget _animatedCard(int index, dynamic s) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) /
              (1 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _sectionCard(s),
    );
  }

  // ─────────────────────────────────────────────
  //  Section card
  // ─────────────────────────────────────────────
  Widget _sectionCard(dynamic s) {
    final w = MediaQuery.of(context).size.width;
    final color = Colors.primaries[
    (s.sectionId ?? 0) % Colors.primaries.length];

    // ✅ Full status
    final bool isFull = (s.full ?? 0) == 1;
    final int current = s.currentStudents ?? 0;
    final int capacity = s.capacity ?? 0;
    final double fillPercent =
    capacity > 0 ? (current / capacity).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                // ── Section Letter Avatar ──
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isFull ? Colors.grey : color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      (s.sectionName ?? "?")
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.035),

                // ── Info ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section name + Full badge
                      Row(
                        children: [
                          AppText.customText(
                            "Section ${s.sectionName ?? ""}",
                            size: 17,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(width: 8),
                          // ✅ Full / Vacant badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isFull
                                  ? AppColor.error.withOpacity(0.12)
                                  : AppColor.success.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isFull ? "Full" : "Vacant",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isFull
                                    ? AppColor.error
                                    : AppColor.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // ✅ display_name from API
                      AppText.customText(
                        s.displayName ?? "",
                        size: 12,
                        color: AppColor.softGreyText,
                      ),

                      const SizedBox(height: 5),

                      // ✅ Students count
                      Row(
                        children: [
                          const Icon(Icons.people_outline_rounded,
                              size: 14, color: AppColor.softGreyText),
                          const SizedBox(width: 4),
                          AppText.customText(
                            "$current / $capacity students",
                            size: 12,
                            color: AppColor.softGreyText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Edit & Delete ──
                Column(
                  children: [
                    _cardIconBtn(
                      icon: Icons.edit_note_rounded,
                      color: color,
                      bg: color.withOpacity(0.10),
                      onTap: () => _openEditSheet(s, color),
                    ),
                    const SizedBox(height: 6),
                    _cardIconBtn(
                      icon: Icons.delete_outline_rounded,
                      color: AppColor.error,
                      bg: AppColor.error.withOpacity(0.08),
                      onTap: () async {
                        final confirmed =
                        await _showDeleteDialog(s.sectionName ?? "");
                        if (confirmed) {
                          Provider.of<DeleteSectionViewModel>(context,
                              listen: false)
                              .deleteSectionApi(
                              s.sectionId.toString(), context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            // ✅ Progress bar — fill level
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Occupancy",
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColor.softGreyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${(fillPercent * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isFull
                            ? AppColor.error
                            : fillPercent > 0.75
                            ? Colors.orange
                            : AppColor.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: fillPercent,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isFull
                          ? AppColor.error
                          : fillPercent > 0.75
                          ? Colors.orange
                          : AppColor.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardIconBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Delete Dialog
  // ─────────────────────────────────────────────
  Future<bool> _showDeleteDialog(String sectionName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Icon (Same everywhere)
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColor.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColor.error,
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                "Delete Section",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColor.sub,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                        text: "Are you sure you want to delete "),
                    TextSpan(
                      text: "\"Section $sectionName\"",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColor.text,
                      ),
                    ),
                    const TextSpan(
                        text:
                        "?\nThis action cannot be undone."),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buttons (Same everywhere)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColor.sub),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColor.sub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
    ) ??
        false;
  }
  // Future<bool> _showDeleteDialog(String sectionName) async {
  //   return await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20)),
  //       title: const Row(
  //         children: [
  //           Icon(Icons.warning_amber_rounded,
  //               color: AppColor.error, size: 26),
  //           SizedBox(width: 8),
  //           Text("Delete Section",
  //               style: TextStyle(
  //                   fontSize: 17, fontWeight: FontWeight.w700)),
  //         ],
  //       ),
  //       content: RichText(
  //         text: TextSpan(
  //           style: const TextStyle(
  //               color: AppColor.sub, fontSize: 14),
  //           children: [
  //             const TextSpan(
  //                 text: "Are you sure you want to delete "),
  //             TextSpan(
  //               text: "Section $sectionName",
  //               style: const TextStyle(
  //                   fontWeight: FontWeight.w700,
  //                   color: AppColor.text),
  //             ),
  //             const TextSpan(
  //                 text: "? This action cannot be undone."),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text("Cancel",
  //               style: TextStyle(
  //                   color: AppColor.sub,
  //                   fontWeight: FontWeight.w600)),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColor.error,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text("Delete",
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600)),
  //         ),
  //       ],
  //     ),
  //   ) ??
  //       false;
  // }

  // ─────────────────────────────────────────────
  //  ADD Section Bottom Sheet
  // ─────────────────────────────────────────────
  void _openAddSheet() {
    final classVM =
    Provider.of<AllClassesViewModel>(context, listen: false);
    final classes = classVM.allClassesModel?.data ?? [];

    String? selectedClassId;
    final sectionNameCtrl = TextEditingController();
    final capacityCtrl = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              final bottom = MediaQuery.of(ctx).viewInsets.bottom;

              Future<void> handleAdd() async {
                if (selectedClassId == null) {
                  Utils.show("Please select a class", context);
                  // _snack(ctx, "Please select a class");
                  return;
                }
                if (sectionNameCtrl.text.trim().isEmpty) {
                  Utils.show("Please enter section name", context);
                  // _snack(ctx, "Please enter section name");
                  return;
                }
                if (capacityCtrl.text.trim().isEmpty) {
                  Utils.show("Please enter capacity", context);
                  // _snack(ctx, "Please enter capacity");
                  return;
                }

                setSheetState(() => isLoading = true);
                HapticFeedback.mediumImpact();

                await Provider.of<CreateSectionViewModel>(
                  context,
                  listen: false,
                ).createClassApi(
                  selectedClassId!,
                  sectionNameCtrl.text.trim(),
                  capacityCtrl.text.trim(),
                  context,
                );

                Provider.of<AllSectionsViewModel>(
                  context,
                  listen: false,
                ).allSectionsApi(context, selectedClassId!);

                setSheetState(() => isLoading = false);
                Navigator.pop(ctx);
              }

              return Container(
                decoration: const BoxDecoration(
                  color: AppColor.bg,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // Drag handle
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.border,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ── Header ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          20, 14, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: AppColor.primaryGradient,
                              borderRadius:
                              BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.primary
                                      .withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add Section",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.text,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Fill in the details below",
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: AppColor.sub),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.border
                                    .withOpacity(0.6),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColor.sub),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Fields ──
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                            20, 4, 20, bottom + 24),
                        child: Column(
                          children: [
                            // ── Section Info Card ──
                            _formSectionCard(
                              icon: Icons.view_agenda_outlined,
                              title: "Section Info",
                              color: AppColor.primary,
                              children: [
                                // ── Class Dropdown ──
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Class",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.sub,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: selectedClassId,
                                      onChanged: (val) =>
                                          setSheetState(() =>
                                          selectedClassId = val),
                                      hint: Text(
                                        "Select Class",
                                        style: TextStyle(
                                            fontSize: 13.5,
                                            color: AppColor.sub
                                                .withOpacity(0.6)),
                                      ),
                                      items: classes
                                          .map((c) =>
                                          DropdownMenuItem<String>(
                                            value: c.classId
                                                .toString(),
                                            child: Text(
                                                c.className ?? ""),
                                          ))
                                          .toList(),
                                      icon: const Icon(
                                          Icons
                                              .keyboard_arrow_down_rounded,
                                          color: AppColor.sub,
                                          size: 20),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.text,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.class_outlined,
                                          size: 18,
                                          color: AppColor.primary
                                              .withOpacity(0.7),
                                        ),
                                        filled: true,
                                        fillColor: AppColor.primaryLight
                                            .withOpacity(0.5),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12),
                                        enabledBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: AppColor.border,
                                              width: 1.2),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: AppColor.primary,
                                              width: 1.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // ── Section Name ──
                                _sheetField(
                                  sectionNameCtrl,
                                  "Section Name",
                                  "e.g. A, B, C or Rose",
                                  Icons.sort_by_alpha_rounded,
                                ),

                                const SizedBox(height: 14),

                                // ── Capacity ──
                                _sheetField(
                                  capacityCtrl,
                                  "Capacity",
                                  "e.g. 40",
                                  Icons.people_outline_rounded,
                                  keyboard: TextInputType.number,
                                  formatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // ── Buttons ──
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.pop(ctx),
                                    child: Container(
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: AppColor.border
                                            .withOpacity(0.4),
                                        borderRadius:
                                        BorderRadius.circular(
                                            16),
                                        border: Border.all(
                                            color: AppColor.border,
                                            width: 1.5),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.close_rounded,
                                              size: 18,
                                              color: AppColor.sub),
                                          SizedBox(width: 6),
                                          Text("Cancel",
                                              style: TextStyle(
                                                  color: AppColor.sub,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight
                                                      .w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: AppButton(
                                    title: isLoading
                                        ? "Adding..."
                                        : "Add Section",
                                    onTap: handleAdd,
                                    height: 54,
                                    radius: 16,
                                    gradient:
                                    AppColor.primaryGradient,
                                    textColor: Colors.white,
                                    icon: isLoading
                                        ? null
                                        : Icons
                                        .add_circle_outline_rounded,
                                    loading: isLoading,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  EDIT Section Bottom Sheet
  // ─────────────────────────────────────────────
  void _openEditSheet(dynamic s, Color accentColor) {
    final classVM =
    Provider.of<AllClassesViewModel>(context, listen: false);
    final classes = classVM.allClassesModel?.data ?? [];

    String? selectedClassId = s.classId?.toString();
    final sectionNameCtrl =
    TextEditingController(text: s.sectionName ?? '');
    final capacityCtrl =
    TextEditingController(text: s.capacity?.toString() ?? '');
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              final bottom = MediaQuery.of(ctx).viewInsets.bottom;

              Future<void> handleUpdate() async {
                if (selectedClassId == null) {
                  _snack(ctx, "Please select a class");
                  return;
                }
                if (sectionNameCtrl.text.trim().isEmpty) {
                  _snack(ctx, "Please enter section name");
                  return;
                }
                if (capacityCtrl.text.trim().isEmpty) {
                  _snack(ctx, "Please enter capacity");
                  return;
                }

                setSheetState(() => isLoading = true);
                HapticFeedback.mediumImpact();
                await Provider.of<UpdateSectionViewModel>(
                  context,
                  listen: false,
                ).updateSectionApi(
                  context,
                  UpdateSectionRequest(
                    classId: int.parse(selectedClassId!),
                    sectionId: s.sectionId,
                    sectionName: sectionNameCtrl.text.trim(),
                    capacity: int.parse(capacityCtrl.text.trim()),
                  ),
                );

                Provider.of<AllSectionsViewModel>(
                  context,
                  listen: false,
                ).allSectionsApi(context, selectedClassId!);

                setSheetState(() => isLoading = false);
                Navigator.pop(ctx);
              }

              return Container(
                decoration: const BoxDecoration(
                  color: AppColor.bg,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.border,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          20, 14, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius:
                              BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  accentColor.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Edit Section",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.text,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Editing: Section ${s.sectionName ?? ''}",
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColor.sub),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.border
                                    .withOpacity(0.6),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColor.sub),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit info banner
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColor.success.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                              AppColor.success.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16,
                                color:
                                AppColor.success.withOpacity(0.8)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColor.sub),
                                  children: [
                                    const TextSpan(
                                        text: "Editing: "),
                                    TextSpan(
                                      text:
                                      "Section ${s.sectionName ?? ''}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fields
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                            20, 4, 20, bottom + 24),
                        child: Column(
                          children: [
                            _formSectionCard(
                              icon: Icons.view_agenda_outlined,
                              title: "Section Info",
                              color: accentColor,
                              children: [
                                // Class Dropdown
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Class",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.sub,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: classes.any((c) =>
                                      c.classId.toString() ==
                                          selectedClassId)
                                          ? selectedClassId
                                          : null,
                                      onChanged: (val) =>
                                          setSheetState(() =>
                                          selectedClassId = val),
                                      hint: Text(
                                        "Select Class",
                                        style: TextStyle(
                                            fontSize: 13.5,
                                            color: AppColor.sub
                                                .withOpacity(0.6)),
                                      ),
                                      items: classes
                                          .map((c) =>
                                          DropdownMenuItem<String>(
                                            value: c.classId
                                                .toString(),
                                            child: Text(
                                                c.className ?? ""),
                                          ))
                                          .toList(),
                                      icon: const Icon(
                                          Icons
                                              .keyboard_arrow_down_rounded,
                                          color: AppColor.sub,
                                          size: 20),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.text,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      dropdownColor: Colors.white,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.class_outlined,
                                          size: 18,
                                          color: AppColor.primary
                                              .withOpacity(0.7),
                                        ),
                                        filled: true,
                                        fillColor: AppColor.primaryLight
                                            .withOpacity(0.5),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12),
                                        enabledBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: AppColor.border,
                                              width: 1.2),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: AppColor.primary,
                                              width: 1.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                _sheetField(
                                  sectionNameCtrl,
                                  "Section Name",
                                  "e.g. A, B, C or Rose",
                                  Icons.sort_by_alpha_rounded,
                                ),

                                const SizedBox(height: 14),

                                _sheetField(
                                  capacityCtrl,
                                  "Capacity",
                                  "e.g. 40",
                                  Icons.people_outline_rounded,
                                  keyboard: TextInputType.number,
                                  formatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.pop(ctx),
                                    child: Container(
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: AppColor.border
                                            .withOpacity(0.4),
                                        borderRadius:
                                        BorderRadius.circular(
                                            16),
                                        border: Border.all(
                                            color: AppColor.border,
                                            width: 1.5),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.close_rounded,
                                              size: 18,
                                              color: AppColor.sub),
                                          SizedBox(width: 6),
                                          Text("Cancel",
                                              style: TextStyle(
                                                  color: AppColor.sub,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight
                                                      .w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: AppButton(
                                    title: isLoading
                                        ? "Saving..."
                                        : "Save Changes",
                                    onTap: handleUpdate,
                                    height: 54,
                                    radius: 16,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.editGradA,
                                        AppColor.editGradB,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    textColor: Colors.white,
                                    icon: isLoading
                                        ? null
                                        : Icons
                                        .check_circle_outline_rounded,
                                    loading: isLoading,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  Sheet Field
  // ─────────────────────────────────────────────
  Widget _sheetField(
      TextEditingController ctrl,
      String label,
      String hint,
      IconData icon, {
        TextInputType keyboard = TextInputType.text,
        List<TextInputFormatter>? formatters,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
                letterSpacing: 0.3)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          inputFormatters: formatters,
          maxLines: maxLines,
          style: const TextStyle(
              fontSize: 14,
              color: AppColor.text,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 13.5,
                color: AppColor.sub.withOpacity(0.6)),
            prefixIcon: Icon(icon,
                size: 18, color: AppColor.primary.withOpacity(0.7)),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Form Section Card
  // ─────────────────────────────────────────────
  Widget _formSectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
              border: Border(
                  bottom: BorderSide(color: color.withOpacity(0.12))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.2)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
          ),
        ],
      ),
    );
  }
}