import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/all_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_send_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../repo/school_repo/all_sections_repo.dart';
import '../view_model/school_view_model/mark_as_all_read_notication_view_model.dart';

// ── Target Audience types ──
enum _TargetType { schoolWide, classBased, classSection, roleBased }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllNotificationViewModel>(context, listen: false)
          .allNotificationApi(context);
      Provider.of<GetSendNotificationViewModel>(context, listen: false)
          .getSendNotificationApi(context);
      Provider.of<MarkAsAllReadNotificationViewModel>(context, listen: false)
          .markAsAllReadNotificationApi(context);
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Widget _animCard({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (_, __) {
        final delay = (index * 0.07).clamp(0.0, 0.6);
        final t = Curves.easeOut.transform(
          ((_animCtrl.value - delay) / (1 - delay)).clamp(0, 1),
        );
        return Transform.translate(
          offset: Offset(0, 30 * (1 - t)),
          child: Opacity(opacity: t, child: child),
        );
      },
    );
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(error ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
      backgroundColor: error ? AppColor.error : AppColor.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final markReadVM = Provider.of<MarkAsAllReadNotificationViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      floatingActionButton: _buildFAB(),
      body: Column(children: [
        _buildHeader(markReadVM),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [_buildInbox(), _buildSent()],
          ),
        ),
      ]),
    );
  }

  // ─── FAB ─────────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColor.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: _openNotificationSheet,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Send Notification",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────
  Widget _buildHeader(MarkAsAllReadNotificationViewModel markReadVM) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primary, AppColor.primary.withOpacity(0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
              color: AppColor.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Notifications",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4)),
              Text("Stay updated with all alerts",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ]),
          ),
          if (markReadVM.readCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
                ],
              ),
              child: Row(children: [
                Container(
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                        color: AppColor.error, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text("${markReadVM.readCount} new",
                    style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ]),
            ),
        ]),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColor.primary,
            unselectedLabelColor: Colors.white,
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
            tabs: [
              Tab(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inbox_rounded, size: 16),
                      SizedBox(width: 6),
                      Text("Inbox"),
                    ]),
              ),
              Tab(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.send_rounded, size: 16),
                      SizedBox(width: 6),
                      Text("Sent"),
                    ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ]),
    );
  }

  // ═══ INBOX ═══════════════════════════════════════════════
  Widget _buildInbox() {
    final vm = Provider.of<AllNotificationViewModel>(context);
    final notifications = vm.allNotificationModel?.data?.notifications ?? [];
    if (vm.loading) return _shimmerList();
    if (notifications.isEmpty) return _emptyState("No inbox notifications");
    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => vm.allNotificationApi(context),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return _animCard(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.notifications_rounded,
                            color: AppColor.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title ?? "",
                                  style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text,
                                      letterSpacing: -0.2)),
                              if ((n.description ?? '').isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(n.description ?? '',
                                    style: const TextStyle(
                                        fontSize: 13, color: AppColor.sub),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ]),
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══ SENT ════════════════════════════════════════════════
  Widget _buildSent() {
    final vm = Provider.of<GetSendNotificationViewModel>(context);
    final notifications = vm.getSendNotificationModel?.data ?? [];
    if (vm.loading) return _shimmerList();
    if (notifications.isEmpty) return _emptyState("No sent notifications");
    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => vm.getSendNotificationApi(context),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return _animCard(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: const Icon(Icons.notifications_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title ?? "",
                                  style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.text,
                                      letterSpacing: -0.2)),
                              const SizedBox(height: 10),
                              Row(children: [
                                _statChip(
                                    icon: Icons.people_alt_rounded,
                                    label: "${n.recipientsCount ?? 0} Recipients",
                                    color: const Color(0xFF3B82F6)),
                                const SizedBox(width: 8),
                                _statChip(
                                    icon: Icons.visibility_rounded,
                                    label: "${n.readCount ?? 0} Read",
                                    color: AppColor.success),
                              ]),
                            ]),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(n.notificationId),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.delete_outline_rounded,
                              color: AppColor.error, size: 20),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statChip(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _shimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: AppColor.primaryLight, shape: BoxShape.circle),
          child: Icon(Icons.notifications_off_rounded,
              size: 48, color: AppColor.primary.withOpacity(0.5)),
        ),
        const SizedBox(height: 16),
        Text(msg,
            style: const TextStyle(
                color: AppColor.sub,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════
  //  SEND NOTIFICATION BOTTOM SHEET — Web UI matched
  // ════════════════════════════════════════════════════════
  void _openNotificationSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isLoading = false;

    _TargetType targetType = _TargetType.schoolWide;

    // Class/Section state
    String? selectedClassId;
    String? selectedClassName;
    String? selectedSectionId;
    String? selectedSectionName;
    List<Map<String, dynamic>> sheetSections = [];

    // Role Based state
    String selectedRole = 'student'; // student | teacher | both

    final classesVm =
    Provider.of<AllClassesViewModel>(context, listen: false);
    final classList = classesVm.allClassesModel?.data ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: StatefulBuilder(
          builder: (ctx, setSheet) {
            final bottom = MediaQuery.of(ctx).viewInsets.bottom;

            // ── Build recipients from current state ──
            // List<Map<String, dynamic>> _buildRecipients() {
            //   switch (targetType) {
            //     case _TargetType.schoolWide:
            //       return [
            //         {"target_type": "role_based", "role": "student"},
            //         {"target_type": "role_based", "role": "teacher"},
            //       ];
            //     case _TargetType.classBased:
            //       return [
            //         {
            //           "target_type": "class",
            //           "class_id": int.tryParse(selectedClassId ?? '') ?? 0,
            //         }
            //       ];
            //     case _TargetType.classSection:
            //       return [
            //         {
            //           "target_type": "class_section",
            //           "class_id": int.tryParse(selectedClassId ?? '') ?? 0,
            //           "section_id": int.tryParse(selectedSectionId ?? '') ?? 0,
            //         }
            //       ];
            //     case _TargetType.roleBased:
            //       if (selectedRole == 'both') {
            //         return [
            //           {"target_type": "role_based", "role": "student"},
            //           {"target_type": "role_based", "role": "teacher"},
            //         ];
            //       }
            //       print("══════════════════════════════");
            //       print("🎯 TARGET TYPE: $targetType");
            //       print("🏫 Selected Class ID: $selectedClassId");
            //       print("📚 Selected Section ID: $selectedSectionId");
            //       print("👤 Selected Role: $selectedRole");
            //       // print("📦 RECIPIENTS BUILT: $recipients");
            //       print("══════════════════════════════");
            //       return [
            //         {"target_type": "role_based", "role": selectedRole}
            //       ];
            //   }
            // }
            List<Map<String, dynamic>> _buildRecipients() {

              List<Map<String, dynamic>> recipients = [];

              switch (targetType) {

                case _TargetType.schoolWide:
                  recipients = [
                    {"target_type": "role_based", "role": "student"},
                    {"target_type": "role_based", "role": "teacher"},
                  ];
                  break;

                case _TargetType.classBased:
                  recipients = [
                    {
                      "target_type": "class",
                      "class_id": int.tryParse(selectedClassId ?? '') ?? 0,
                    }
                  ];
                  break;

                case _TargetType.classSection:
                  recipients = [
                    {
                      "target_type": "class_section",
                      "class_id": int.tryParse(selectedClassId ?? '') ?? 0,
                      "section_id": int.tryParse(selectedSectionId ?? '') ?? 0,
                    }
                  ];
                  break;

                case _TargetType.roleBased:
                  if (selectedRole == 'both') {
                    recipients = [
                      {"target_type": "role_based", "role": "student"},
                      {"target_type": "role_based", "role": "teacher"},
                    ];
                  } else {
                    recipients = [
                      {"target_type": "role_based", "role": selectedRole}
                    ];
                  }
                  break;
              }

              // 🔥 PRINT HERE (SWITCH KE BAAD)
              print("══════════════════════════════");
              print("🎯 TARGET TYPE: $targetType");
              print("🏫 Selected Class ID: $selectedClassId");
              print("📚 Selected Section ID: $selectedSectionId");
              print("👤 Selected Role: $selectedRole");
              print("📦 RECIPIENTS BUILT: $recipients");
              print("══════════════════════════════");

              return recipients;
            }
            // ── Recipients preview chip ──
            Widget _recipientPreview() {
              List<_RecipientChipData> chips = [];
              switch (targetType) {
                case _TargetType.schoolWide:
                  chips = [
                    _RecipientChipData(Icons.groups_rounded, 'All School',
                        AppColor.primary)
                  ];
                  break;
                case _TargetType.classBased:
                  chips = selectedClassId == null
                      ? []
                      : [
                    _RecipientChipData(Icons.class_rounded,
                        selectedClassName ?? 'Class', Colors.teal)
                  ];
                  break;
                case _TargetType.classSection:
                  if (selectedClassId != null)
                    chips.add(_RecipientChipData(Icons.class_rounded,
                        selectedClassName ?? 'Class', Colors.teal));
                  if (selectedSectionId != null)
                    chips.add(_RecipientChipData(Icons.dashboard_rounded,
                        selectedSectionName ?? 'Section', Colors.indigo));
                  break;
                case _TargetType.roleBased:
                  if (selectedRole == 'student' || selectedRole == 'both')
                    chips.add(_RecipientChipData(
                        Icons.school_rounded, 'Students', Colors.green));
                  if (selectedRole == 'teacher' || selectedRole == 'both')
                    chips.add(_RecipientChipData(
                        Icons.person_rounded, 'Teachers', Colors.orange));
                  break;
              }
              if (chips.isEmpty) {
                return Text('No recipients selected',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColor.sub.withOpacity(0.7)));
              }
              return Wrap(
                spacing: 8,
                runSpacing: 6,
                children: chips
                    .map((c) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: c.color.withOpacity(0.3)),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, size: 14, color: c.color),
                        const SizedBox(width: 6),
                        Text(c.label,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: c.color)),
                      ]),
                ))
                    .toList(),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6FB),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 12),
                // Handle
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100)),
                ),
                // Sheet Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColor.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.primary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: const Icon(Icons.campaign_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Create New Notification",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.text,
                                    letterSpacing: -0.3)),
                            SizedBox(height: 2),
                            Text(
                                "Compose and dispatch messages to specific groups",
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.sub)),
                          ]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: AppColor.sub),
                      ),
                    ),
                  ]),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Notification Title ──
                          _fieldLabel('Notification Title', required: true),
                          const SizedBox(height: 6),
                          _sheetField(
                            ctrl: titleCtrl,
                            hint: 'e.g. Annual Sports Meet 2024',
                            icon: Icons.title_rounded,
                          ),
                          const SizedBox(height: 16),

                          // ── Description ──
                          _fieldLabel('Description', required: true),
                          const SizedBox(height: 6),
                          _sheetField(
                            ctrl: descCtrl,
                            hint: 'Enter the details of your notification here...',
                            icon: Icons.message_outlined,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 20),

                          // ── Target Audience ──
                          _fieldLabel('Target Audience'),
                          const SizedBox(height: 10),
                          Row(children: [
                            _audienceCard(
                              icon: Icons.groups_rounded,
                              label: 'School Wide',
                              value: _TargetType.schoolWide,
                              current: targetType,
                              onTap: () => setSheet(() {
                                targetType = _TargetType.schoolWide;
                                selectedClassId = null;
                                selectedSectionId = null;
                              }),
                            ),
                            const SizedBox(width: 8),
                            _audienceCard(
                              icon: Icons.menu_book_rounded,
                              label: 'Class',
                              value: _TargetType.classBased,
                              current: targetType,
                              onTap: () => setSheet(() {
                                targetType = _TargetType.classBased;
                                selectedSectionId = null;
                              }),
                            ),
                            const SizedBox(width: 8),
                            _audienceCard(
                              icon: Icons.layers_rounded,
                              label: 'Class + Section',
                              value: _TargetType.classSection,
                              current: targetType,
                              onTap: () => setSheet(
                                      () => targetType = _TargetType.classSection),
                            ),
                            const SizedBox(width: 8),
                            _audienceCard(
                              icon: Icons.shield_rounded,
                              label: 'Role Based',
                              value: _TargetType.roleBased,
                              current: targetType,
                              onTap: () => setSheet(
                                      () => targetType = _TargetType.roleBased),
                            ),
                          ]),

                          const SizedBox(height: 20),

                          // ── Conditional sub-fields ──
                          if (targetType == _TargetType.classBased ||
                              targetType == _TargetType.classSection) ...[
                            _fieldLabel('Select Class'),
                            const SizedBox(height: 8),
                            _dropdownField(
                              hint: 'Choose a class',
                              value: selectedClassId,
                              items: classList
                                  .map((e) => DropdownMenuItem<String>(
                                value: e.classId.toString(),
                                child: Text(e.className ?? ''),
                              ))
                                  .toList(),
                              onChanged: (val) async {
                                setSheet(() {
                                  selectedClassId = val;
                                  selectedClassName = classList
                                      .firstWhere(
                                          (e) => e.classId.toString() == val,
                                      orElse: () => classList.first)
                                      .className;
                                  selectedSectionId = null;
                                  sheetSections = [];
                                });
                                if (val != null &&
                                    targetType == _TargetType.classSection) {
                                  final res = await AllSectionsRepository()
                                      .allSectionsApi(val);
                                  if (res['success'] == true) {
                                    setSheet(() => sheetSections =
                                    List<Map<String, dynamic>>.from(
                                        res['data']));
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (targetType == _TargetType.classSection) ...[
                            _fieldLabel('Select Section'),
                            const SizedBox(height: 8),
                            _dropdownField(
                              hint: 'Choose a section',
                              value: selectedSectionId,
                              items: sheetSections
                                  .map((e) => DropdownMenuItem<String>(
                                value: e['section_id'].toString(),
                                child: Text(
                                    e['section_name']?.toString() ??
                                        ''),
                              ))
                                  .toList(),
                              onChanged: (val) => setSheet(() {
                                selectedSectionId = val;
                                selectedSectionName = sheetSections
                                    .firstWhere(
                                        (e) =>
                                    e['section_id'].toString() == val,
                                    orElse: () => {})['section_name']
                                    ?.toString();
                              }),
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (targetType == _TargetType.roleBased) ...[
                            _fieldLabel('Select Role'),
                            const SizedBox(height: 10),
                            Row(children: [
                              _roleChip(
                                  label: 'Students',
                                  icon: Icons.school_rounded,
                                  value: 'student',
                                  selected: selectedRole,
                                  color: Colors.green,
                                  onTap: () => setSheet(
                                          () => selectedRole = 'student')),
                              const SizedBox(width: 10),
                              _roleChip(
                                  label: 'Teachers',
                                  icon: Icons.person_rounded,
                                  value: 'teacher',
                                  selected: selectedRole,
                                  color: Colors.orange,
                                  onTap: () => setSheet(
                                          () => selectedRole = 'teacher')),
                              const SizedBox(width: 10),
                              _roleChip(
                                  label: 'Both',
                                  icon: Icons.groups_rounded,
                                  value: 'both',
                                  selected: selectedRole,
                                  color: Colors.purple,
                                  onTap: () =>
                                      setSheet(() => selectedRole = 'both')),
                            ]),
                            const SizedBox(height: 16),
                          ],

                          // ── Selected Recipients preview ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColor.border, width: 1.2),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('SELECTED RECIPIENTS',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.sub,
                                          letterSpacing: 0.5)),
                                  const SizedBox(height: 10),
                                  _recipientPreview(),
                                ]),
                          ),

                          const SizedBox(height: 28),

                          // ── Send Button ──
                          AppButton(
                            title: isLoading
                                ? "Sending..."
                                : "Send Notification",
                            onTap: () async {
                              if (titleCtrl.text.trim().isEmpty) {
                                Utils.show("Please enter a title", context);
                                // _snack("Please enter a title", error: true);
                                return;
                              }
                              if (descCtrl.text.trim().isEmpty) {
                                Utils.show("Please enter a description", context);
                                // _snack("Please enter a description",
                                //     error: true);
                                return;
                              }
                              if (targetType == _TargetType.classBased &&
                                  selectedClassId == null) {
                                Utils.show("Please select a class", context);
                                // _snack("Please select a class", error: true);
                                return;
                              }
                              if (targetType == _TargetType.classSection &&
                                  (selectedClassId == null ||
                                      selectedSectionId == null)) {
                                Utils.show("Please select class and section", context);
                                // _snack("Please select class and section",
                                //     error: true);
                                return;
                              }

                              setSheet(() => isLoading = true);
                              HapticFeedback.mediumImpact();

                              final success = await Provider.of<
                                  CreateNotificationViewModel>(
                                  context, listen: false)
                                  .createNotificationApi(
                                titleCtrl.text.trim(),
                                descCtrl.text.trim(),
                                _buildRecipients(),
                                context,
                              );

                              setSheet(() => isLoading = false);

                              if (success) {
                                Navigator.pop(ctx);
                                Provider.of<AllNotificationViewModel>(context,
                                    listen: false)
                                    .allNotificationApi(context);
                                Provider.of<GetSendNotificationViewModel>(
                                    context, listen: false)
                                    .getSendNotificationApi(context);
                                tabController.animateTo(1);
                                _snack("Notification sent successfully!");
                              } else {
                                _snack("Failed to send notification",
                                    error: true);
                              }
                            },
                            height: 54,
                            radius: 16,
                            gradient: AppColor.primaryGradient,
                            textColor: Colors.white,
                            icon: isLoading ? null : Icons.send_rounded,
                            loading: isLoading,
                          ),
                          const SizedBox(height: 8),
                        ]),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  // ── Audience card (School Wide / Class / Class+Section / Role Based) ──
  Widget _audienceCard({
    required IconData icon,
    required String label,
    required _TargetType value,
    required _TargetType current,
    required VoidCallback onTap,
  }) {
    final bool sel = current == value;
    // return Expanded(
    //   child: GestureDetector(
    //     onTap: onTap,
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 200),
    //       curve: Curves.easeOut,
    //       padding: const EdgeInsets.symmetric(vertical: 14),
    //       decoration: BoxDecoration(
    //         color: sel ? AppColor.primary.withOpacity(0.08) : Colors.white,
    //         borderRadius: BorderRadius.circular(14),
    //         border: Border.all(
    //           color: sel ? AppColor.primary : AppColor.border,
    //           width: sel ? 2 : 1.2,
    //         ),
    //       ),
    //       child: Column(children: [
    //         Icon(icon,
    //             size: 22,
    //             color: sel ? AppColor.primary : AppColor.sub),
    //         const SizedBox(height: 6),
    //         Text(
    //           label,
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontSize: 10,
    //             fontWeight: FontWeight.w600,
    //             color: sel ? AppColor.primary : AppColor.sub,
    //           ),
    //         ),
    //       ]),
    //     ),
    //   ),
    // );
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: screenHeight*0.1,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: sel ? AppColor.primary.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: sel ? AppColor.primary : AppColor.border,
              width: sel ? 2 : 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 🔥 Center content
            children: [
              Icon(
                icon,
                size: 22,
                color: sel ? AppColor.primary : AppColor.sub,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2, // 🔥 Prevent height expand
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: sel ? AppColor.primary : AppColor.sub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Role chip ──
  Widget _roleChip({
    required String label,
    required IconData icon,
    required String value,
    required String selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool sel = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sel ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: sel ? color : AppColor.border,
                width: sel ? 2 : 1.2),
          ),
          child: Column(children: [
            Icon(icon, size: 20, color: sel ? color : AppColor.sub),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sel ? color : AppColor.sub)),
          ]),
        ),
      ),
    );
  }

  // ── Dropdown field ──
  Widget _dropdownField({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: value != null
                ? AppColor.primary
                : AppColor.border,
            width: value != null ? 1.8 : 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(
                  color: AppColor.sub.withOpacity(0.7), fontSize: 13.5)),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColor.primary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Row(children: [
      Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.text)),
      if (required) ...[
        const SizedBox(width: 3),
        const Text('*',
            style: TextStyle(color: Colors.red, fontSize: 13)),
      ],
    ]);
  }

  Widget _sheetField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(
          fontSize: 14, color: AppColor.text, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 13.5, color: AppColor.sub.withOpacity(0.6)),
        prefixIcon: maxLines == 1
            ? Icon(icon, size: 18, color: AppColor.primary.withOpacity(0.7))
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
        ),
      ),
    );
  }

  // ─── DELETE DIALOG ───────────────────────────────────────
  void _showDeleteDialog(int? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColor.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.delete_forever_rounded,
                color: AppColor.error, size: 22),
          ),
          const SizedBox(width: 12),
          const Text("Delete",
              style:
              TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ]),
        content: const Text(
          "Are you sure you want to delete this notification? This action cannot be undone.",
          style: TextStyle(color: AppColor.sub, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel",
                style: TextStyle(
                    color: AppColor.sub, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              HapticFeedback.mediumImpact();
              final deleteVM = Provider.of<DeleteNotificationViewModel>(
                  context, listen: false);
              final allVM = Provider.of<AllNotificationViewModel>(
                  context, listen: false);
              final success = await deleteVM.deleteNotificationApi(id);
              if (success) {
                allVM.removeNotification(id);
                _snack("Notification deleted");
              }
            },
            child: const Text("Delete",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── Helper data class ──
class _RecipientChipData {
  final IconData icon;
  final String label;
  final Color color;
  _RecipientChipData(this.icon, this.label, this.color);
}
