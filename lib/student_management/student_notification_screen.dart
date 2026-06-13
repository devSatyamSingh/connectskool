import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/view_model/school_view_model/all_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_send_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_notification_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_notification_view_model.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/mark_as_all_read_notication_view_model.dart';

class StudentNotificationScreen extends StatefulWidget {
  const StudentNotificationScreen({super.key});

  @override
  State<StudentNotificationScreen> createState() =>
      _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen>
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

      if (!PermissionExtensions.canAccess(
          PermissionKeys.notificationView)) {

        Utils.show(
          "You don't have permission to view notifications",
          context,
        );

        Navigator.pop(context);
        return;
      }

      Provider.of<StudentNotificationViewModel>(
        context,
        listen: false,
      ).studentNotificationApi(context);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Animation card ────────────────────────────────────────
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

  // ── Snackbar ──────────────────────────────────────────────
  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: error ? AppColor.error : AppColor.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
  String _formatRole(String role) {
    switch (role) {
      case 'school_admin':
        return 'Admin';
      case 'accountant':
        return 'Accountant';
      case 'teacher':
        return 'Teacher';
      case 'student':
        return 'Student';
      default:
        return role
            .split('_')
            .map((w) => w[0].toUpperCase() + w.substring(1))
            .join(' ');
    }
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    // final markReadVM =
    // Provider.of<MarkAsAllReadNotificationViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      // floatingActionButton: _buildFAB(),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            // ✅ Uncomment
            child: _buildInbox(), // ✅ Direct inbox, no TabBarView needed
          ),
        ],
      ),
    );
  }

  // ─── FAB ─────────────────────────────────────────────────

  // ─── Header ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primary, AppColor.primary.withOpacity(0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Notifications",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      "Stay updated with all alerts",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  INBOX TAB
  // ════════════════════════════════════════════════════════
  Widget _buildInbox() {
    final vm = Provider.of<StudentNotificationViewModel>(context);
    final notifications =
        vm.studentNotificationModel?.data?.notifications ?? [];

    if (vm.loading) return _shimmerList();
    if (notifications.isEmpty) return _emptyState("No inbox notifications");

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => vm.studentNotificationApi(context),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          final bool isRead = (n.isRead ?? 1) == 1;
          // _buildInbox() ke itemBuilder mein — pura card replace karo:

          return _animCard(
            index: index,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  left: BorderSide(
                    color: isRead ? Colors.transparent : AppColor.primary,
                    width: 3,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon bubble
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.grey.shade100
                            : AppColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: isRead ? Colors.grey.shade400 : AppColor.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + unread dot
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  n.title ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isRead
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Description
                          Text(
                            n.description ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.sub,
                              height: 1.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Meta row
                          Row(
                            children: [
                              // Sender chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 11,
                                      color: AppColor.primary,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      n.senderName ?? "Unknown",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Type badge (Message / Alert etc.)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  "Message", // ya n.type ?? "Message"
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Time
                              Text(
                                _formatTime(n.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColor.sub,
                                ),
                              ),
                            ],
                          ),

                          // "Click to read →"
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 6),
                          //     child: Text(
                          //       "Click to read →",
                          //       style: TextStyle(
                          //         fontSize: 11,
                          //         color: AppColor.sub.withOpacity(0.7),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // return _animCard(
          //   index: index,
          //   child: Container(
          //     margin: const EdgeInsets.only(bottom: 12),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       border: isRead
          //           ? null
          //           : Border.all(
          //         color: AppColor.primary.withOpacity(0.25),
          //         width: 1.5,
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.05),
          //           blurRadius: 12,
          //           offset: const Offset(0, 4),
          //         ),
          //       ],
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // ── Icon Bubble ──
          //           Container(
          //             width: 44,
          //             height: 44,
          //             decoration: BoxDecoration(
          //               gradient: isRead
          //                   ? LinearGradient(colors: [
          //                 Colors.grey.shade200,
          //                 Colors.grey.shade300,
          //               ])
          //                   : AppColor.primaryGradient,
          //               borderRadius: BorderRadius.circular(14),
          //               boxShadow: isRead
          //                   ? []
          //                   : [
          //                 BoxShadow(
          //                   color: AppColor.primary.withOpacity(0.3),
          //                   blurRadius: 8,
          //                   offset: const Offset(0, 3),
          //                 ),
          //               ],
          //             ),
          //             child: Icon(
          //               isRead
          //                   ? Icons.mark_email_read_rounded
          //                   : Icons.mark_email_unread_rounded,
          //               color:
          //               isRead ? Colors.grey.shade500 : Colors.white,
          //               size: 20,
          //             ),
          //           ),
          //           const SizedBox(width: 14),
          //
          //           // ── Content ──
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 // Title + unread dot
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Expanded(
          //                       child: Text(
          //                         n.title ?? "",
          //                         style: TextStyle(
          //                           fontSize: 14.5,
          //                           fontWeight: isRead
          //                               ? FontWeight.w500
          //                               : FontWeight.w700,
          //                           color: AppColor.text,
          //                           letterSpacing: -0.2,
          //                         ),
          //                       ),
          //                     ),
          //                     if (!isRead)
          //                       Container(
          //                         margin: const EdgeInsets.only(
          //                             top: 4, left: 6),
          //                         width: 8,
          //                         height: 8,
          //                         decoration: BoxDecoration(
          //                           color: AppColor.primary,
          //                           shape: BoxShape.circle,
          //                         ),
          //                       ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 5),
          //
          //                 // Description
          //                 Text(
          //                   n.description ?? "",
          //                   style: const TextStyle(
          //                     fontSize: 13,
          //                     color: AppColor.sub,
          //                     height: 1.4,
          //                   ),
          //                   maxLines: 2,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //                 const SizedBox(height: 10),
          //
          //                 // Sender + Role + Time
          //                 Row(
          //                   children: [
          //                     // Sender chip
          //                     Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 8, vertical: 4),
          //                       decoration: BoxDecoration(
          //                         color: AppColor.primaryLight,
          //                         borderRadius: BorderRadius.circular(8),
          //                       ),
          //                       child: Row(
          //                         children: [
          //                           Icon(
          //                             Icons.person_outline_rounded,
          //                             size: 11,
          //                             color: AppColor.primary,
          //                           ),
          //                           const SizedBox(width: 4),
          //                           Text(
          //                             n.senderName ?? "Unknown",
          //                             style: TextStyle(
          //                               fontSize: 11,
          //                               fontWeight: FontWeight.w600,
          //                               color: AppColor.primary,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     const SizedBox(width: 6),
          //
          //                     // Role badge
          //                     Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 8, vertical: 4),
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xFFEFF6FF),
          //                         borderRadius: BorderRadius.circular(8),
          //                       ),
          //                       child: Text(
          //                         _formatRole(n.senderRole ?? ""), // ✅ Fixed
          //                         style: const TextStyle(
          //                           fontSize: 11,
          //                           fontWeight: FontWeight.w600,
          //                           color: Color(0xFF3B82F6),
          //                         ),
          //                       ),
          //                     ),
          //
          //                     const Spacer(),
          //
          //                     // Time
          //                     Text(
          //                       _formatTime(n.createdAt),
          //                       style: const TextStyle(
          //                         fontSize: 11,
          //                         color: AppColor.sub,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────
  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 48,
              color: AppColor.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: const TextStyle(
              color: AppColor.sub,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _targetChip({
    required String label,
    required IconData icon,
    required String value,
    required String selected,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColor.primaryGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColor.border,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColor.sub,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColor.sub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: maxLines == 1
                ? Icon(icon, size: 18, color: AppColor.primary.withOpacity(0.7))
                : null,
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
