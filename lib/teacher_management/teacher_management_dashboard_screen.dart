import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/teacher_view_model/teacher_profile_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../admin_management/attendance_widget/all_student_admin_attendance_screen.dart';
import '../repo/auth_repo/auth_repo.dart';
import '../utils/dashboard_module.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/permission_manager.dart';
import '../view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import '../view_model/school_view_model/teacher/all_teachers_view_model.dart';
import '../view_model/auth_view_model/user_view_model.dart';
import '../admin_management/settings/cms_screen.dart';
import '../admin_management/permission/manage_permission.dart';
import 'Teacher_school_timetable_screen.dart';

class TeacherManagementDashBoardScreen extends StatefulWidget {
  const TeacherManagementDashBoardScreen({super.key});

  @override
  State<TeacherManagementDashBoardScreen> createState() =>
      _TeacherManagementDashBoardScreenState();
}

class _TeacherManagementDashBoardScreenState
    extends State<TeacherManagementDashBoardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<Animation<double>> _tileAnimations;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProfileViewModel>(
        context,
        listen: false,
      ).teacherProfileApi(context);
      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);
      Provider.of<AllAccountantListVieModel>(
        context,
        listen: false,
      ).allAccountantListApi(context);
      if (PermissionExtensions.canAccess(
        PermissionKeys.viewOneTeacherProfile,
      )) {
        Provider.of<TeacherProfileViewModel>(
          context,
          listen: false,
        ).teacherProfileApi(context);
      }
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _tileAnimations = List.generate(DashboardModules.modules.length + 1, (i) {
      final start = i * 0.07;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _capitalize(String name) {
    if (name.isEmpty) return name;
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
          'teacher_dashboard.exit_app'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('teacher_dashboard.exit_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('teacher_dashboard.cancel'.tr()),
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
              'teacher_dashboard.exit'.tr(),
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
    final profile = Provider.of<TeacherProfileViewModel>(
      context,
    ).teacherProfileModel;
    final String teacherName = _capitalize(profile?.data?.name ?? 'Teacher');
    final String teacherEmail =
        profile?.data?.userEmail ?? 'teacher@schoolerp.com';
    final studentTotal =
        Provider.of<AllStudentListVieModel>(
          context,
        ).allStudentListModel?.pagination?.total?.toString() ??
            '...';
    final accountantTotal =
        Provider.of<AllAccountantListVieModel>(
          context,
        ).allAccountantListModel?.pagination?.total?.toString() ??
            '0';
    final teacherTotal =
        Provider.of<AllTeachersListVieModel>(
          context,
        ).allTeachersListModel?.pagination?.total?.toString() ??
            '...';

    return WillPopScope(
      onWillPop: () async => await _showExitPopup(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          drawer: _buildDrawer(context, teacherName, teacherEmail),
          body: Column(
            children: [
              _buildHeader(
                context,
                teacherName,
                studentTotal,
                accountantTotal,
                teacherTotal,
              ),
              const SizedBox(height: 7),
              Expanded(child: _buildGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      String name,
      String studentTotal,
      String accountantTotal,
      String teacherTotal,
      ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
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
                      'teacher_dashboard.title'.tr(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${'teacher_dashboard.hi'.tr()}, $name 👋',
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
              _statPill(studentTotal, 'teacher_dashboard.students'.tr()),
              const SizedBox(width: 10),
              _statPill(accountantTotal, 'teacher_dashboard.accountant'.tr()),
              const SizedBox(width: 10),
              _statPill(teacherTotal, 'teacher_dashboard.attendance'.tr()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
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

  Widget _buildGrid(BuildContext context) {
    final teacherModules = [
      DashboardModule(
        title: 'teacher_dashboard.my_profile'.tr(),
        titleKey: 'teacher_dashboard.my_profile',
        subTitle: 'teacher_dashboard.my_profile_sub'.tr(),
        subTitleKey: 'teacher_dashboard.my_profile_sub',
        icon: Icons.person_rounded,
        color: const Color(0xFF00897B),
        permission: PermissionKeys.viewOneTeacherProfile,
        route: RoutesName.teacherProfileScreen,
      ),
      ...DashboardModules.modules.where(
            (e) =>
        e.permission != PermissionKeys.managePermissions &&
            PermissionExtensions.canAccess(e.permission),
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: teacherModules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, i) {
        final module = teacherModules[i];
        final animIdx = i.clamp(0, _tileAnimations.length - 1);

        return AnimatedBuilder(
          animation: _tileAnimations[animIdx],
          builder: (_, child) {
            return Transform.scale(
              scale: _tileAnimations[animIdx].value,
              child: Opacity(
                opacity: _tileAnimations[animIdx].value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: _buildModuleTile(module),
        );
      },
    );
  }

  Widget _buildModuleTile(DashboardModule module) {
    return GestureDetector(
      onTap: () {
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
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(0)),
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
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 34,
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
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                  title: 'teacher_dashboard.help_support'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RoutesName.helpSupportScreen);
                  },
                ),
                const Divider(height: 16, indent: 20, endIndent: 20),
                _drawerItem(
                  icon: Icons.logout_rounded,
                  title: 'teacher_dashboard.logout'.tr(),
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
          color: iconBg ?? const Color(0xFFE3F0FF),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    'teacher_dashboard.logout'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'teacher_dashboard.logout_confirm'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              actions: [
                TextButton(
                  onPressed: isLoggingOut ? null : () => Navigator.pop(ctx),
                  child: Text(
                    'teacher_dashboard.cancel'.tr(),
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
                      final session = await userVM.getSubscribedSession();
                      final schoolId = session['schoolId'];
                      final role = session['role'];
                      final userId = session['userId'];
                      final classId = session['classId'];
                      final sectionId = session['sectionId'];

                      debugPrint(
                        "🔍 Teacher Logout => school=$schoolId | role=$role",
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
                        debugPrint("✅ Teacher unsubscribed: $topics");
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

                      debugPrint("✅ Teacher logout complete");
                    } catch (e) {
                      debugPrint("❌ Teacher logout error: $e");
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
                    'teacher_dashboard.logout_btn'.tr(),
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