import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/all_scetions_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/edit_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/delete_class_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/create_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/update_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/delete_section_view_model.dart';
import 'package:school_pro/repo/school_repo/section/update_section_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Track which class cards are expanded
  final Set<int> _expandedClassIds = {};

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final classVM =
      Provider.of<AllClassesViewModel>(context, listen: false);
      await classVM.allClassesApi(context);

      // Load sections for all classes
      final classes = classVM.allClassesModel?.data ?? [];
      final sectionVM =
      Provider.of<AllSectionsViewModel>(context, listen: false);
      for (final c in classes) {
        sectionVM.allSectionsApi(context, c.classId.toString());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // Future<void> _onRefresh() async {
  //   _animationController.reset();
  //   final classVM =
  //   Provider.of<AllClassesViewModel>(context, listen: false);
  //   await classVM.allClassesApi(context);
  //
  //   final classes = classVM.allClassesModel?.data ?? [];
  //   final sectionVM =
  //   Provider.of<AllSectionsViewModel>(context, listen: false);
  //   for (final c in classes) {
  //     await sectionVM.allSectionsApi(context, c.classId.toString());
  //   }
  //   _animationController.forward();
  // }
  Future<void> _onRefresh() async {
    _animationController.reset();


    final classVM = Provider.of<AllClassesViewModel>(context, listen: false);
    final sectionVM = Provider.of<AllSectionsViewModel>(context, listen: false);

    // ✅ Pehle classes fetch karo
    await classVM.allClassesApi(context);

    // ✅ Sabhi classes ke sections ek saath fetch karo (parallel)
    final classes = classVM.allClassesModel?.data ?? [];
    await Future.wait(
      classes.map((c) => sectionVM.allSectionsApi(context, c.classId.toString())),
    );

    print(
      "REFRESH CLASSES => ${classes.length}",
    );
    // ✅ Expanded classes ke sections dobara explicitly fetch karo
    for (final classId in _expandedClassIds) {
      await sectionVM.allSectionsApi(context, classId.toString());
    }

    if (!mounted) return;

    _animationController.forward();
    setState(() {}); // ✅ Force rebuild
  }
  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(msg,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ]),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final classVM = Provider.of<AllClassesViewModel>(context);
    final sectionVM = Provider.of<AllSectionsViewModel>(context);
    final allClasses = classVM.allClassesModel?.data ?? [];

    final canViewClasses =
    PermissionExtensions.canAccess(
      PermissionKeys.viewClasses,
    );

    final filteredClasses = _searchQuery.isEmpty
        ? allClasses
        : allClasses
        .where((c) =>
    (c.className ?? '')
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()) ||
        (c.classCode ?? '')
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    if (!canViewClasses) {
      return Scaffold(
        body: Center(
          child: Text(
            "You don't have permission to view classes",
          ),
        ),
      );
    }

    print(
      "BUILD CLASSES => ${classVM.allClassesModel?.data?.length}",
    );

    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [
          // ── Header ──
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.customText(
                            "Classes & Sections",
                            size: 19,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          AppText.customText(
                            "Manage your school's classes and their sections",
                            size: 11,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                    AppText.customText(
                      "${filteredClasses.length}",
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Search Bar ──
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          onChanged: (v) =>
                              setState(() => _searchQuery = v),
                          decoration: const InputDecoration(
                            hintText: "Search classes...",
                            hintStyle: TextStyle(
                                color: Colors.white60, fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white70, size: 18),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── List ──
          Expanded(
            child: classVM.loading
                ? _shimmer()
                : filteredClasses.isEmpty
                    ? ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height *
                          0.5,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off,
                              size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No classes found",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight:
                                  FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      18, 8, 18, 100),
                  itemCount: filteredClasses.length,
                  itemBuilder: (context, index) {
                    final c = filteredClasses[index];
                    final classId = c.classId ?? 0;
                    final allSections =
                        sectionVM.allSectionsModel?.data ??
                            [];
                    final classSections = allSections
                        .where((s) =>
                    s.classId.toString() ==
                        classId.toString())
                        .toList();

                    return _animatedCard(
                        index, c, classSections, sectionVM);
                  },
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
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColor.cardWhite,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Animated wrapper
  // ─────────────────────────────────────────────
  Widget _animatedCard(int index, dynamic c, List<dynamic> classSections,
      AllSectionsViewModel sectionVM) {
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
      child: _classCard(c, classSections, sectionVM),
    );
  }

  // ─────────────────────────────────────────────
  //  Class Card (expandable)
  // ─────────────────────────────────────────────
  Widget _classCard(
      dynamic c, List<dynamic> classSections, AllSectionsViewModel sectionVM) {
    final classId = c.classId ?? 0;
    final isExpanded = _expandedClassIds.contains(classId);
    final color = Colors.primaries[classId % Colors.primaries.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColor.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Class Header Row ──
          InkWell(
            borderRadius: BorderRadius.circular(20),
            // onTap: () {
            //   setState(() {
            //     if (isExpanded) {
            //       _expandedClassIds.remove(classId);
            //     } else {
            //       _expandedClassIds.add(classId);
            //       // Fetch sections for this class if not already
            //       sectionVM.allSectionsApi(
            //           context, classId.toString());
            //     }
            //   });
            // },
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedClassIds.remove(classId);
                } else {
                  _expandedClassIds.add(classId);
                  // ✅ Expand hone par fresh fetch karo
                  Provider.of<AllSectionsViewModel>(context, listen: false)
                      .allSectionsApi(context, classId.toString())
                      .then((_) => setState(() {})); // ✅ Data aane par rebuild
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.school_rounded,
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Name + Code
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText.customText(
                              c.className ?? "",
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(width: 8),
                            // Section count badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColor.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${classSections.length} Sections",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        AppText.customText(
                          "Code: ${c.classCode ?? '—'}",
                          size: 12,
                          color: AppColor.softGreyText,
                        ),
                      ],
                    ),
                  ),

                  // Edit & Delete icons
                  _cardIconBtn(
                    icon: Icons.edit_note_rounded,
                    color: color,
                    bg: color.withOpacity(0.10),
                    onTap: () {

                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageClasses)) {

                        Utils.show(
                          "You don't have permission to edit classes",
                          context,
                        );

                        return;
                      }

                      _openEditClassSheet(c, color);
                    },
                  ),
                  const SizedBox(width: 6),
                  _cardIconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppColor.error,
                    bg: AppColor.error.withOpacity(0.08),
                    onTap: () async {
                      if (!PermissionExtensions.canAccess(
                          PermissionKeys.manageClasses)) {

                        Utils.show(
                          "You don't have permission to delete classes",
                          context,
                        );

                        return;
                      }

                      final confirmed =
                      await _showDeleteDialog(c.className ?? "", "Class");
                      if (confirmed) {
                        Provider.of<DeleteClassViewModel>(context,
                            listen: false)
                            .deleteClassApi(
                            classId.toString(), context);
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColor.softGreyText,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Sections ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _sectionsExpanded(classSections, c, color, sectionVM),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Expanded Sections panel
  // ─────────────────────────────────────────────
  Widget _sectionsExpanded(List<dynamic> sections, dynamic classData,
      Color classColor, AllSectionsViewModel sectionVM) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.pageBgColor,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                const Text("SECTION",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.softGreyText,
                        letterSpacing: 0.8)),
                const Spacer(),
                const Text("STUDENTS / CAPACITY",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.softGreyText,
                        letterSpacing: 0.8)),
                const SizedBox(width: 16),
                const Text("ACTIONS",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.softGreyText,
                        letterSpacing: 0.8)),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Section rows
          if (sectionVM.loading && sections.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (sections.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.view_agenda_outlined,
                        size: 36, color: Colors.grey.shade400),
                    const SizedBox(height: 6),
                    Text("No sections yet",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            )
          else
            ...sections
                .map((s) => _sectionRow(s, classColor, classData))
                .toList(),

          // Add Section button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: GestureDetector(
              onTap: () {

                if (!PermissionExtensions.canAccess(
                    PermissionKeys.manageSections)) {

                  Utils.show(
                    "You don't have permission to add sections",
                    context,
                  );

                  return;
                }

                _openAddSectionSheet(classData);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColor.primary.withOpacity(0.2),
                      width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        size: 18, color: AppColor.primary),
                    const SizedBox(width: 6),
                    Text("Add Section",
                        style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Section Row inside expanded card
  // ─────────────────────────────────────────────
  Widget _sectionRow(dynamic s, Color classColor, dynamic classData) {
    final bool isFull = (s.full ?? 0) == 1;
    final int current = s.currentStudents ?? 0;
    final int capacity = s.capacity ?? 0;
    final double fillPercent =
    capacity > 0 ? (current / capacity).clamp(0.0, 1.0) : 0.0;

    final progressColor = isFull
        ? AppColor.error
        : fillPercent > 0.75
        ? Colors.orange
        : AppColor.success;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              // Blue dot + Section name
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isFull ? AppColor.error : AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Section - ${s.sectionName ?? '?'}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    // Progress bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: LinearProgressIndicator(
                              value: fillPercent,
                              minHeight: 5,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  progressColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${(fillPercent * 100).toInt()}%",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: progressColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Students / capacity
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_outline_rounded,
                          size: 13, color: AppColor.softGreyText),
                      const SizedBox(width: 3),
                      Text("$current / $capacity",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.softGreyText)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isFull
                          ? AppColor.error.withOpacity(0.1)
                          : AppColor.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Cap - $capacity",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isFull
                                  ? AppColor.error
                                  : AppColor.success),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),

              // Vacant/Full badge
              Text(
                isFull ? "Full" : "Vacant",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color:
                    isFull ? AppColor.error : AppColor.success),
              ),
              const SizedBox(width: 8),

              // Edit & Delete
              _cardIconBtn(
                icon: Icons.edit_note_rounded,
                color: classColor,
                bg: classColor.withOpacity(0.10),
                onTap: () {

                  if (!PermissionExtensions.canAccess(
                      PermissionKeys.manageSections)) {

                    Utils.show(
                      "You don't have permission to edit sections",
                      context,
                    );

                    return;
                  }

                  _openEditSectionSheet(s, classColor);
                },
              ),
              const SizedBox(width: 4),
              _cardIconBtn(
                icon: Icons.delete_outline_rounded,
                color: AppColor.error,
                bg: AppColor.error.withOpacity(0.08),
                onTap: () async {
                  final confirmed = await _showDeleteDialog(
                      s.sectionName ?? "", "Section");
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
        ),
        const Divider(height: 1, thickness: 1, indent: 16),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Icon Button
  // ─────────────────────────────────────────────
  Widget _cardIconBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Delete Dialog
  // ─────────────────────────────────────────────
  Future<bool> _showDeleteDialog(String name, String type) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: AppColor.error.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline,
                    color: AppColor.error, size: 36),
              ),
              const SizedBox(height: 16),
              Text("Delete $type",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                      color: AppColor.sub,
                      fontSize: 14,
                      height: 1.5),
                  children: [
                    const TextSpan(
                        text: "Are you sure you want to delete "),
                    TextSpan(
                        text: '"$name"',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColor.text)),
                    const TextSpan(
                        text: "?\nThis action cannot be undone."),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        side:
                        const BorderSide(color: AppColor.sub),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                      ),
                      child: const Text("Cancel",
                          style: TextStyle(
                              color: AppColor.sub,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text("Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
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

  // ─────────────────────────────────────────────
  //  Edit Class Bottom Sheet
  // ─────────────────────────────────────────────
  void _openEditClassSheet(dynamic c, Color accentColor) {
    final nameCtrl =
    TextEditingController(text: c.className ?? "");
    final String classId = c.classId.toString();
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
                if (nameCtrl.text.trim().isEmpty) {
                  _snack(ctx, "Class name cannot be empty");
                  return;
                }
                setSheetState(() => isLoading = true);
                HapticFeedback.mediumImpact();
                final editClasses = Provider.of<EditClassesViewModel>(
                    context,
                    listen: false);
                bool success = await editClasses.editClassApi(
                    classId, nameCtrl.text.trim(), context);
                setSheetState(() => isLoading = false);
                if (success) Navigator.pop(ctx);
              }

              return _bottomSheetContainer(
                ctx: ctx,
                bottom: bottom,
                icon: Icons.edit_note_rounded,
                iconBg: accentColor,
                title: "Edit Class",
                subtitle: "Update class name",
                child: Column(
                  children: [
                    _sheetField(nameCtrl, "Class Name", "e.g. Class 10",
                        Icons.class_outlined),
                    const SizedBox(height: 28),
                    _sheetButtons(
                      ctx: ctx,
                      isLoading: isLoading,
                      onSave: handleUpdate,
                      saveLabel: "Update Class",
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
  //  Add Section Bottom Sheet
  // ─────────────────────────────────────────────
  void _openAddSectionSheet(dynamic classData) {
    final sectionNameCtrl = TextEditingController();
    final capacityCtrl = TextEditingController();
    final String classId = classData.classId.toString();
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
                if (sectionNameCtrl.text.trim().isEmpty) {
                  Utils.show("Please enter section name", context);
                  return;
                }
                if (capacityCtrl.text.trim().isEmpty) {
                  Utils.show("Please enter capacity", context);
                  return;
                }
                setSheetState(() => isLoading = true);
                HapticFeedback.mediumImpact();
                await Provider.of<CreateSectionViewModel>(context,
                    listen: false)
                    .createClassApi(classId,
                    sectionNameCtrl.text.trim(),
                    capacityCtrl.text.trim(), context);
                Provider.of<AllSectionsViewModel>(context,
                    listen: false)
                    .allSectionsApi(context, classId);
                setSheetState(() => isLoading = false);
                // Navigator.pop(ctx);
              }

              return _bottomSheetContainer(
                ctx: ctx,
                bottom: bottom,
                icon: Icons.add_circle_outline_rounded,
                iconBg: AppColor.primary,
                title: "Add Section",
                subtitle:
                "For class: ${classData.className ?? ''}",
                child: Column(
                  children: [
                    _sheetField(
                        sectionNameCtrl,
                        "Section Name",
                        "e.g. A, B, C or Rose",
                        Icons.sort_by_alpha_rounded),
                    const SizedBox(height: 14),
                    _sheetField(capacityCtrl, "Capacity", "e.g. 40",
                        Icons.people_outline_rounded,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    const SizedBox(height: 28),
                    _sheetButtons(
                      ctx: ctx,
                      isLoading: isLoading,
                      onSave: handleAdd,
                      saveLabel: "Add Section",
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
  //  Edit Section Bottom Sheet
  // ─────────────────────────────────────────────
  void _openEditSectionSheet(dynamic s, Color accentColor) {
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
                await Provider.of<UpdateSectionViewModel>(context,
                    listen: false)
                    .updateSectionApi(
                  context,
                  UpdateSectionRequest(
                    classId: int.parse(selectedClassId!),
                    sectionId: s.sectionId,
                    sectionName: sectionNameCtrl.text.trim(),
                    capacity:
                    int.parse(capacityCtrl.text.trim()),
                  ),
                );
                Provider.of<AllSectionsViewModel>(context,
                    listen: false)
                    .allSectionsApi(context, selectedClassId!);
                setSheetState(() => isLoading = false);
                Navigator.pop(ctx);
              }

              return _bottomSheetContainer(
                ctx: ctx,
                bottom: bottom,
                icon: Icons.edit_note_rounded,
                iconBg: accentColor,
                title: "Edit Section",
                subtitle: "Editing: Section ${s.sectionName ?? ''}",
                child: Column(
                  children: [
                    // Class Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Class",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.sub,
                                letterSpacing: 0.3)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: classes.any((c) =>
                          c.classId.toString() ==
                              selectedClassId)
                              ? selectedClassId
                              : null,
                          onChanged: (val) => setSheetState(
                                  () => selectedClassId = val),
                          hint: Text("Select Class",
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: AppColor.sub
                                      .withOpacity(0.6))),
                          items: classes
                              .map((c) => DropdownMenuItem<String>(
                            value: c.classId.toString(),
                            child: Text(c.className ?? ""),
                          ))
                              .toList(),
                          decoration: _dropdownDecoration(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _sheetField(sectionNameCtrl, "Section Name",
                        "e.g. A, B, C or Rose",
                        Icons.sort_by_alpha_rounded),
                    const SizedBox(height: 14),
                    _sheetField(capacityCtrl, "Capacity", "e.g. 40",
                        Icons.people_outline_rounded,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    const SizedBox(height: 28),
                    _sheetButtons(
                      ctx: ctx,
                      isLoading: isLoading,
                      onSave: handleUpdate,
                      saveLabel: "Save Changes",
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
  //  Bottom Sheet Container (shared)
  // ─────────────────────────────────────────────
  Widget _bottomSheetContainer({
    required BuildContext ctx,
    required double bottom,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                borderRadius: BorderRadius.circular(100)),
          ),
          const SizedBox(height: 10),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(14)),
                  child:
                  Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColor.text)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColor.sub)),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(Icons.close_rounded,
                      color: AppColor.sub),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 4, 20, bottom + 24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Sheet Buttons
  // ─────────────────────────────────────────────
  Widget _sheetButtons({
    required BuildContext ctx,
    required bool isLoading,
    required Future<void> Function() onSave,
    required String saveLabel,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColor.border.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColor.border, width: 1.5),
              ),
              child: const Center(
                child: Text("Cancel",
                    style: TextStyle(
                        color: AppColor.sub,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: AppButton(
            title: isLoading ? "Please wait..." : saveLabel,
            onTap: onSave,
            height: 54,
            radius: 16,
            gradient: AppColor.primaryGradient,
            textColor: Colors.white,
            loading: isLoading,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Sheet Text Field
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
                size: 18,
                color: AppColor.primary.withOpacity(0.7)),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColor.border, width: 1.2),
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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      prefixIcon: Icon(Icons.class_outlined,
          size: 18, color: AppColor.primary.withOpacity(0.7)),
      filled: true,
      fillColor: AppColor.primaryLight.withOpacity(0.5),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
        const BorderSide(color: AppColor.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
        const BorderSide(color: AppColor.primary, width: 1.8),
      ),
    );
  }
}