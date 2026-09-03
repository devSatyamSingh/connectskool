import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';
import 'package:school_pro/view_model/auth_view_model/school_admin_profile_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../localization/language_selection_screen.dart';
import '../repo/auth_repo/auth_repo.dart';
import '../utils/dashboard_module.dart';
import '../utils/permission_error_message.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/permission_manager.dart';
import '../view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import '../view_model/school_view_model/settings/cms_viewmodel.dart';
import '../view_model/school_view_model/permission/user_permission_view_model.dart';
import '../view_model/auth_view_model/user_view_model.dart';
import 'settings/cms_screen.dart';
import 'permission/manage_permission.dart';

class SchoolManagementDashboardScreen extends StatefulWidget {
  const SchoolManagementDashboardScreen({super.key});

  @override
  State<SchoolManagementDashboardScreen> createState() =>
      _SchoolManagementDashboardScreenState();
}

class _SchoolManagementDashboardScreenState
    extends State<SchoolManagementDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<Animation<double>> _tileAnimations;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchoolAdminProfileViewModel>(
        context,
        listen: false,
      ).schoolAdminProfileApi(context);
      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
      Provider.of<AllTeachersListVieModel>(
        context,
        listen: false,
      ).allTeachersListApi(context);
      Provider.of<AllAccountantListVieModel>(
        context,
        listen: false,
      ).allAccountantListApi(context);
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _tileAnimations = List.generate(
        DashboardModules.modules.length,
            (i) {
          final start = (i * 0.05).clamp(0.0, 0.7);
          final end = (start + 0.4).clamp(0.0, 1.0);
          return CurvedAnimation(
            parent: _animController,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          );
        });

    _animController.forward();
    Future.microtask(() {
      context.read<CmsViewModel>().getCmsPages();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _capitalize(String? name) {
    if (name == null || name.isEmpty) return 'Admin';
    return name[0].toUpperCase() + name.substring(1);
  }

  Future<bool> _showExitPopup() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'common.exit_app'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('common.are_you_sure_exit'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              'common.exit'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<SchoolAdminProfileViewModel>(
      context,
    ).schoolAdminProfileModel;
    final String adminName = _capitalize(profile?.data?.name);
    final String adminEmail = profile?.data?.userEmail ?? 'admin@schoolpro.com';

    final studentTotal = Provider.of<AllStudentListVieModel>(
      context,
    ).allStudentListModel?.pagination?.total?.toString() ??
        '...';
    final teacherTotal = Provider.of<AllTeachersListVieModel>(
      context,
    ).allTeachersListModel?.pagination?.total?.toString() ??
        '...';
    final accountantTotal = Provider.of<AllAccountantListVieModel>(
      context,
    ).allAccountantListModel?.pagination?.total?.toString() ??
        '0';

    return WillPopScope(
      onWillPop: () async => await _showExitPopup(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F3FA),
          drawer: _buildDrawer(context, adminName, adminEmail),
          body: Column(
            children: [
              _buildHeader(
                context,
                adminName,
                studentTotal,
                teacherTotal,
                accountantTotal,
              ),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────

  Widget _buildHeader(
      BuildContext context,
      String name,
      String studentTotal,
      String teacherTotal,
      String accountantTotal,
      ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
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
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
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
                      'dashboard.school_admin'.tr(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.55),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${'dashboard.hi'.tr()}, $name 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
              _statPill(
                Icons.people_rounded,
                studentTotal,
                'dashboard.students'.tr(),
                const Color(0xFF6C5CE7),
              ),
              const SizedBox(width: 10),
              _statPill(
                Icons.person_rounded,
                teacherTotal,
                'dashboard.teachers'.tr(),
                const Color(0xFF00B894),
              ),
              const SizedBox(width: 10),
              _statPill(
                Icons.calculate_rounded,
                accountantTotal,
                'dashboard.accountants'.tr(),
                const Color(0xFFFF6B6B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(IconData icon, String value, String label, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final visibleTiles = DashboardModules.modules
        .where((e) => PermissionExtensions.canAccess(e.permission))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.08,
      ),
      itemCount: visibleTiles.length,
      itemBuilder: (ctx, i) {
        final module = visibleTiles[i];
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
          child: _buildModuleTile(module),
        );
      },
    );
  }

  Widget _buildModuleTile(DashboardModule module) {
    return GestureDetector(
      onTap: () {
        if (!PermissionGuard.check(context, module.permission, module.title)) {
          return;
        }
        Navigator.pushNamed(context, module.route);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [module.color, module.color.withOpacity(0.78)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: module.color.withOpacity(0.32),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -14,
              right: -14,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.11),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(module.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    module.localizedTitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String name, String email) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.lightBlueColor,
                  AppColor.lightBlueColor.withValues(alpha: 0.85),
                ],
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
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    '🏫  ${'dashboard.school_administrator'.tr()}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                // In drawer items:
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
                  title: 'common.help_support'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutesName.helpSupportScreen);
                  },
                ),
                _drawerItem(
                  icon: Icons.settings_outlined,
                  title: 'common.settings'.tr(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagePermission()),
                  ),
                ),
                _drawerItem(
                  icon: Icons.language_rounded,
                  title: 'common.language'.tr(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Divider(),
                ),
                _drawerItem(
                  icon: Icons.logout_rounded,
                  title: 'common.logout'.tr(),
                  iconColor: Colors.red.shade700,
                  titleColor: Colors.red.shade700,
                  iconBg: Colors.red.shade50,
                  onTap: () {
                    Navigator.pop(context);
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
        child: Icon(icon, size: 20, color: iconColor ?? const Color(0xFF1565C0)),
      ),
      title: Text(
        title,
        style: TextStyle(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    'common.logout'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                'common.are_you_sure_logout'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              actions: [
                TextButton(
                  onPressed: isLoggingOut ? null : () => Navigator.pop(ctx),
                  child: Text('common.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(90, 40),
                  ),
                  onPressed: isLoggingOut
                      ? null
                      : () async {
                    setDialogState(() => isLoggingOut = true);

                    final userVM = UserViewModel();

                    try {
                      final session = await userVM.getSubscribedSession();
                      final schoolId = session['schoolId'];
                      final role = session['role'];
                      final userId = session['userId'];
                      final classId = session['classId'];
                      final sectionId = session['sectionId'];

                      debugPrint("🔍 Logout => school=$schoolId | role=$role");

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
                            topics.add("school_${schoolId}_class_$classId");
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
                          topics.map((t) => messaging.unsubscribeFromTopic(t)),
                          eagerError: false,
                        );
                        debugPrint("✅ Unsubscribed: $topics");
                      }

                      await FirebaseMessaging.instance.deleteToken();
                      debugPrint("✅ FCM Token deleted");

                      try {
                        final repo = AuthRepository();
                        await repo.logoutApi({"device_type": "android"});
                        debugPrint("✅ Backend logout done");
                      } catch (e) {
                        debugPrint("⚠️ Backend logout error: $e");
                      }

                      await userVM.clearSubscribedSession();
                      await userVM.clearUser();
                      PermissionManager.clear();

                      debugPrint("✅ Logout complete");
                    } catch (e) {
                      debugPrint("❌ Logout error: $e");
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
                      : Text('common.logout'.tr(), style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}