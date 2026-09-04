import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/student_management/student_fees_screen.dart';
import 'package:school_pro/student_management/timetable_screen.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import '../admin_management/settings/cms_screen.dart';
import '../admin_management/timetable/school_timetable_screen.dart';
import '../repo/auth_repo/auth_repo.dart';
import '../res/app_color.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_manager.dart';
import '../view_model/auth_view_model/academic_view_model.dart';
import '../view_model/school_view_model/permission/user_permission_view_model.dart';
import '../view_model/student_view_model/student_fee_view_model.dart';
import '../view_model/student_view_model/student_profile_view_model.dart';
import '../view_model/auth_view_model/user_view_model.dart';
import 'exam_timetable_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<Animation<double>> _tileAnimations;

  bool _permissionsLoaded = false;

  static const List<_DashTile> _tiles = [
    _DashTile(
      'student_dashboard.my_profile',
      Icons.person_rounded,
      Color(0xFF1976D2),
      'student_dashboard.my_profile_sub',
      'view_one_student_profile',
    ),
    _DashTile(
      'student_dashboard.attendance',
      Icons.fact_check_rounded,
      Color(0xFF00897B),
      'student_dashboard.attendance_sub',
      'view_one_student_attendance',
    ),
    _DashTile(
      'student_dashboard.homework',
      Icons.auto_stories_rounded,
      Color(0xFFF57C00),
      'student_dashboard.homework_sub',
      'submit_homework',
    ),
    _DashTile(
      'student_dashboard.fees',
      Icons.receipt_long_rounded,
      Color(0xFF1565C0),
      'student_dashboard.fees_sub',
      'view_fees',
    ),
    _DashTile(
      'student_dashboard.notifications',
      Icons.notifications_active_outlined,
      Color(0xFFC62828),
      'student_dashboard.notifications_sub',
      'notification_view',
    ),
    _DashTile(
      'student_dashboard.school_timetable',
      Icons.schedule_rounded,
      Color(0xFF6D28D9),
      'student_dashboard.school_timetable_sub',
      'view_timetable',
    ),
    _DashTile(
      'student_dashboard.exam_timetable',
      Icons.event_note_rounded,
      Colors.indigoAccent,
      'student_dashboard.exam_timetable_sub',
      'view_exam_timetable',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _tileAnimations = List.generate(_tiles.length, (i) {
      final start = (i * 0.08).clamp(0.0, 0.6);
      final end = (start + 0.45).clamp(0.0, 1.0);

      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _restorePermissions();

        if (!mounted) return;

        final userVm = Provider.of<UserViewModel>(context, listen: false);

        final token = await userVm.getToken();

        if (token == null || token.isEmpty) {
          debugPrint("❌ TOKEN NOT FOUND");
          return;
        }

        final profileVm = Provider.of<StudentProfileViewModel>(
          context,
          listen: false,
        );

        await profileVm.studentProfileApi(context);
        final academicVm = Provider.of<AcademicViewModel>(
          context,
          listen: false,
        );

        await academicVm.academicApi(context);

        final academicYear =
            academicVm.currentYear?.yearName ?? '';

        await Provider.of<StudentFeesViewModel>(
          context,
          listen: false,
        ).fetchFees(
          academicYear: academicYear,
        );

        debugPrint("✅ STUDENT DASHBOARD READY");
      } catch (e, s) {
        debugPrint("❌ STUDENT DASHBOARD ERROR => $e");
        debugPrint(s.toString());
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _restorePermissions() async {
    final permissions =
    await UserViewModel().getPermissions();

    print("RESTORED => $permissions");
    print("COUNT => ${permissions.length}");

    PermissionManager.setPermissions(
      permissions,
    );

    debugPrint(
      "RESTORED PERMISSIONS => $permissions",
    );

    if (mounted) {
      setState(() {
        _permissionsLoaded = true;
      });
    }
  }

  String _capitalize(String? name) {
    if (name == null || name.isEmpty) return 'Student';
    return name[0].toUpperCase() + name.substring(1);
  }

  void _onTileTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(
          context,
          RoutesName.studentProfileScreen,
        );
        break;

      case 1:
        Navigator.pushNamed(
          context,
          RoutesName.studentAttendanceScreen,
        );
        break;

      case 2:
        Navigator.pushNamed(
          context,
          RoutesName.studentHomeworkScreen,
        );
        break;

      case 3:
        final academicVm =
        Provider.of<AcademicViewModel>(
          context,
          listen: false,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentFeesScreen(
              yearName:
              academicVm.currentYear?.yearName ?? '',
            ),
          ),
        );
        break;

      case 4:
        Navigator.pushNamed(
          context,
          RoutesName.studentNotificationScreen,
        );
        break;

      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const SchoolTimetableView(),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ExamTimetableScreen(),
          ),
        );
        break;
    }
  }

  String _fmt(double v) {
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}k';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<StudentProfileViewModel>(
      context,
    ).studentProfileModel;
    final String studentName = _capitalize(profile?.data?.name);
    final String studentEmail =
        profile?.data?.userEmail ?? 'student@school.com';
    final String studentClass = profile?.data?.classId?.toString() ?? 'Class X';
    if (!_permissionsLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F4FF),
          drawer: _buildDrawer(context, studentName, studentEmail, studentClass),
          body: Column(
            children: [
              _buildHeader(context, studentName, studentClass),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String studentClass) {
    final feesVm = Provider.of<StudentFeesViewModel>(context);
    final bool loading = feesVm.isLoading;
    final String totalStr = loading ? '...' : _fmt(feesVm.totalAmount);
    final String paidStr = loading ? '...' : _fmt(feesVm.paidAmount);
    final String pendingStr = loading ? '...' : _fmt(feesVm.pendingAmount);
    final int pendingCount = feesVm.pendingInstallments.length + feesVm.pendingTransportInstallments.length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        28,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'student_dashboard.student_portal'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.55),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'student_dashboard.hi'.tr(namedArgs: {'name': name}),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _infoCard(
                Icons.account_balance_wallet_rounded,
                totalStr,
                'student_dashboard.total_fee'.tr(),
              ),
              const SizedBox(width: 10),
              _infoCard(
                Icons.check_circle_outline_rounded,
                paidStr,
                'student_dashboard.paid_amount'.tr(),
              ),
              const SizedBox(width: 10),
              _infoCard(Icons.pending_actions_rounded, pendingStr, 'student_dashboard.pending'.tr()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.22),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    if (!_permissionsLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final visibleTiles = _tiles
        .asMap()
        .entries
        .where((e) => PermissionExtensions.canAccess(e.value.permKey))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemCount: visibleTiles.length,
      itemBuilder: (ctx, i) {
        final entry = visibleTiles[i];
        final originalIdx = entry.key;
        final tile = entry.value;

        final animIdx = i.clamp(0, _tileAnimations.length - 1);

        return AnimatedBuilder(
          animation: _tileAnimations[animIdx],
          builder: (_, child) => Transform.scale(
            scale: _tileAnimations[animIdx].value,
            child: Opacity(
              opacity: _tileAnimations[animIdx].value.clamp(0.0, 1.0),
              child: child,
            ),
          ),
          child: GestureDetector(
            onTap: () => _onTileTap(originalIdx),
            child: _buildTile(tile),
          ),
        );
      },
    );
  }

  Widget _buildTile(_DashTile tile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tile.color, tile.color.withValues(alpha: 0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: tile.color.withValues(alpha: 0.32),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -8,
            left: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(tile.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  tile.label.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tile.sub.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
      BuildContext context,
      String name,
      String email,
      String studentClass,
      ) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 24,
              20,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _drawerItem(
                  icon: Icons.shield_outlined,
                  title: 'cms.privacy_policy'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CmsScreen(
                          pageType: "privacy_policy",
                          title: 'cms.privacy_policy'.tr(),
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.description_outlined,
                  title: 'cms.terms_conditions'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CmsScreen(
                          pageType: "terms_conditions",
                          title: 'cms.terms_conditions'.tr(),
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'cms.about_us'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CmsScreen(
                          pageType: "about_us",
                          title: 'cms.about_us'.tr(),
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'student_dashboard.help_support'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      RoutesName.helpSupportScreen,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Divider(),
                ),
                _drawerItem(
                  icon: Icons.logout_rounded,
                  title: 'student_dashboard.logout'.tr(),
                  iconColor: Colors.red.shade700,
                  titleColor: Colors.red.shade700,
                  iconBg: Colors.red.shade50,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    Color? iconBg,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg ?? const Color(0xFFE3EEFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? const Color(0xFF1565C0),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor ?? Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade300,
        size: 22,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isLoggingOut = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    'student_dashboard.logout_title'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                'student_dashboard.logout_confirm'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              actions: [
                TextButton(
                  onPressed: isLoggingOut ? null : () => Navigator.pop(ctx),
                  child: Text(
                    'student_dashboard.cancel'.tr(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(90, 40),
                  ),
                  onPressed: isLoggingOut
                      ? null
                      : () async {
                    setDialogState(() => isLoggingOut = true);

                    final userVM = UserViewModel();

                    try {
                      final session =
                      await userVM.getSubscribedSession();
                      final schoolId = session['schoolId'];
                      final role = session['role'];
                      final userId = session['userId'];
                      final classId = session['classId'];
                      final sectionId = session['sectionId'];

                      debugPrint(
                        "🔍 Student Logout => school=$schoolId | role=$role",
                      );

                      if (schoolId != null &&
                          schoolId.isNotEmpty &&
                          role != null &&
                          role.isNotEmpty) {
                        final topics = <String>[
                          "school_$schoolId",
                          "school_${schoolId}_role_$role",
                        ];

                        if (userId != null && userId.isNotEmpty) {
                          topics.add("user_$userId");
                        }

                        if (role == "student") {
                          if (classId != null && classId.isNotEmpty) {
                            topics.add(
                              "school_${schoolId}_class_$classId",
                            );
                          }
                          if (classId != null &&
                              classId.isNotEmpty &&
                              sectionId != null &&
                              sectionId.isNotEmpty) {
                            topics.add(
                              "school_${schoolId}_class_${classId}_section_$sectionId",
                            );
                          }
                        }

                        final messaging = FirebaseMessaging.instance;
                        await Future.wait(
                          topics.map(
                                (t) => messaging.unsubscribeFromTopic(t),
                          ),
                          eagerError: false,
                        );
                        debugPrint("✅ Student unsubscribed: $topics");
                      }

                      await FirebaseMessaging.instance.deleteToken();
                      debugPrint("✅ FCM Token deleted");

                      try {
                        final repo = AuthRepository();
                        await repo.logoutApi({
                          "device_type": "android",
                        });
                        debugPrint("✅ Backend logout done");
                      } catch (e) {
                        debugPrint("⚠️ Backend logout error: $e");
                      }

                      await userVM.clearSubscribedSession();

                      await userVM.clearUser();
                      PermissionManager.clear();

                      debugPrint("✅ Student logout complete");
                    } catch (e) {
                      debugPrint("❌ Student logout error: $e");
                      await userVM.clearSubscribedSession();
                      await userVM.clearUser();
                      PermissionManager.clear();
                    }

                    if (ctx.mounted) Navigator.pop(ctx);

                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.splash,
                            (route) => false,
                      );
                    }
                  },
                  child: isLoggingOut
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    'student_dashboard.logout'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DashTile {
  final String label;
  final IconData icon;
  final Color color;
  final String sub;
  final String permKey;

  const _DashTile(this.label, this.icon, this.color, this.sub, this.permKey);
}