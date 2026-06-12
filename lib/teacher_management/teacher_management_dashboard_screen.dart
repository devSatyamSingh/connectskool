import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import 'package:school_pro/view_model/teacher_view_model/teacher_profile_view_model.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../admin_management/attendance_widget/all_student_admin_attendance_screen.dart';
import '../repo/auth_repo/auth_repo.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_manager.dart';
import '../view_model/school_view_model/all_accountant_list_view_model.dart';
import '../view_model/school_view_model/all_teachers_view_model.dart';
import '../view_model/school_view_model/user_permission_view_model.dart';
import '../view_model/user_view_model.dart';
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

  final List<_DashTile> _tiles = [
    _DashTile(
      label: 'My Profile',
      sub: 'View & edit',
      icon: Icons.person_rounded,
      color: const Color(0xFF00897B),
      route: null,
      permKey: 'view_all_teacher',
    ),

    _DashTile(
      label: 'Attendance',
      sub: 'Mark today',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF1976D2),
      route: null,
      permKey: 'mark_student_attendance',
    ),

    _DashTile(
      label: 'Marksheet',
      sub: 'View results',
      icon: Icons.description_rounded,
      color: const Color(0xFF3949AB),
      route: null,
      permKey: 'view_marks',
    ),

    _DashTile(
      label: 'Timetable',
      sub: 'This week',
      icon: Icons.schedule_rounded,
      color: const Color(0xFF7B1FA2),
      route: null,
      permKey: 'view_timetable',
    ),

    _DashTile(
      label: 'Exams',
      sub: 'Schedule',
      icon: Icons.assignment_turned_in_rounded,
      color: const Color(0xFF2E7D32),
      route: null,
      permKey: 'view_exam',
    ),

    _DashTile(
      label: 'Homework',
      sub: 'Assign & view',
      icon: Icons.menu_book_rounded,
      color: const Color(0xFFF57C00),
      route: null,
      permKey: 'teacher_create_homework',
    ),

    _DashTile(
      label: 'Notifications',
      sub: 'Stay updated',
      icon: Icons.notifications_active_rounded,
      color: const Color(0xFFFFA000),
      route: null,
      permKey: 'notification_view',
      isWide: true,
      badge: '3 new',
    ),
  ];
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
      Provider.of<AllTeachersListVieModel>(
        context,
        listen: false,
      ).allTeachersListApi(context);
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _tileAnimations = List.generate(_tiles.length, (i) {
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
            title: const Text(
              'Exit App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onTileTap(BuildContext ctx, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(ctx, RoutesName.teacherProfileScreen);
        break;

      case 1:
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => AllStudentAdminAttendanceScreen()),
        );
        break;
      case 2:
        Navigator.pushNamed(ctx, RoutesName.marksheetScreen);
        break;
      case 3:
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => TeacherSchoolTimetableScreen()),
        );
        break;
      case 4:
        Navigator.pushNamed(ctx, RoutesName.examScreen);
        break;
      case 5:
        Navigator.pushNamed(ctx, RoutesName.allHomeWorkScreen);
        break;
      case 6:
        Navigator.pushNamed(ctx, RoutesName.notificationScreen);
        break;
    }
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
            Expanded(child: _buildGrid(context)),
            // _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────────────────

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
          // Top row
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
                      'TEACHER DASHBOARD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hi, $name 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification bell
              // Stack(
              //   children: [
              //     Container(
              //       width: 42,
              //       height: 42,
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.15),
              //         shape: BoxShape.circle,
              //       ),
              //       child: const Icon(
              //         Icons.notifications_outlined,
              //         color: Colors.white,
              //         size: 22,
              //       ),
              //     ),
              //     Positioned(
              //       top: 8,
              //       right: 8,
              //       child: Container(
              //         width: 9,
              //         height: 9,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFFFFD54F),
              //           shape: BoxShape.circle,
              //           border: Border.all(
              //             color: const Color(0xFF0D47A1),
              //             width: 1.5,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 20),
          // Stat pills
          Row(
            children: [
              _statPill(studentTotal, 'Students'),
              const SizedBox(width: 10),
              _statPill(accountantTotal, 'Accountant'),
              const SizedBox(width: 10),
              _statPill(teacherTotal, 'Attendance'),
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

  // ─── GRID ────────────────────────────────────────────────────────────────────

  // Widget _buildGrid(BuildContext context) {
  //   // Separate normal tiles from wide tiles
  //   final normalTiles = _tiles.where((t) => !t.isWide).toList();
  //   final wideTiles = _tiles.where((t) => t.isWide).toList();
  //
  //   return ListView(
  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
  //     children: [
  //       GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           mainAxisSpacing: 14,
  //           crossAxisSpacing: 14,
  //           childAspectRatio: 1.05,
  //         ),
  //         itemCount: normalTiles.length,
  //         itemBuilder: (ctx, i) {
  //           final tile = normalTiles[i];
  //           final globalIndex = _tiles.indexOf(tile);
  //           return AnimatedBuilder(
  //             animation: _tileAnimations[globalIndex],
  //             builder: (_, child) => Transform.scale(
  //               scale: _tileAnimations[globalIndex].value,
  //               child: Opacity(
  //                 opacity: _tileAnimations[globalIndex].value.clamp(0.0, 1.0),
  //                 child: child,
  //               ),
  //             ),
  //             child: _normalCard(ctx, tile, globalIndex),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 14),
  //       ...wideTiles.map((tile) {
  //         final globalIndex = _tiles.indexOf(tile);
  //         return Padding(
  //           padding: const EdgeInsets.only(bottom: 10),
  //           child: Column(
  //             children: [
  //               AnimatedBuilder(
  //                 animation: _tileAnimations[globalIndex],
  //                 builder: (_, child) => Transform.scale(
  //                   scale: _tileAnimations[globalIndex].value,
  //                   child: Opacity(
  //                     opacity: _tileAnimations[globalIndex].value.clamp(
  //                       0.0,
  //                       1.0,
  //                     ),
  //                     child: child,
  //                   ),
  //                 ),
  //                 child: SizedBox(
  //                   height: 80,
  //                   child: _wideCard(context, tile, globalIndex),
  //                 ),
  //               ),
  //               SizedBox(height: 40),
  //             ],
  //           ),
  //         );
  //       }),
  //     ],
  //   );
  // }
  Widget _buildGrid(BuildContext context) {
    final permVm = Provider.of<GetUserPermissionViewModel>(
      context,
      listen: false,
    );

    final filteredTiles = _tiles.where(
          (t) => permVm.canAccess(
        t.permKey,
      ),
    ).toList();

    final normalTiles = filteredTiles.where((t) => !t.isWide).toList();
    final wideTiles = filteredTiles.where((t) => t.isWide).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemCount: normalTiles.length,
          itemBuilder: (ctx, i) {
            final tile = normalTiles[i];
            final globalIndex = _tiles.indexOf(
              tile,
            ); // ✅ original index for _onTileTap

            final animIdx = globalIndex.clamp(0, _tileAnimations.length - 1);

            return AnimatedBuilder(
              animation: _tileAnimations[animIdx],
              builder: (_, child) => Transform.scale(
                scale: _tileAnimations[animIdx].value,
                child: Opacity(
                  opacity: _tileAnimations[animIdx].value.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
              child: _normalCard(ctx, tile, globalIndex),
            );
          },
        ),
        const SizedBox(height: 14),
        ...wideTiles.map((tile) {
          final globalIndex = _tiles.indexOf(tile);
          final animIdx = globalIndex.clamp(0, _tileAnimations.length - 1);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _tileAnimations[animIdx],
                  builder: (_, child) => Transform.scale(
                    scale: _tileAnimations[animIdx].value,
                    child: Opacity(
                      opacity: _tileAnimations[animIdx].value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                  child: SizedBox(
                    height: 80,
                    child: _wideCard(context, tile, globalIndex),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _normalCard(BuildContext ctx, _DashTile tile, int index) {
    return GestureDetector(
      onTap: () => _onTileTap(ctx, index),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tile.color, tile.color.withOpacity(0.82)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: tile.color.withOpacity(0.38),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -16,
              right: -16,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -12,
              right: 12,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
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
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(tile.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    tile.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tile.sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
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

  Widget _wideCard(BuildContext ctx, _DashTile tile, int index) {
    // Spans 2 columns — wrap in a SizedBox with full width
    return SizedBox(
      // GridView will size this; span is handled below via itemBuilder check
      child: GestureDetector(
        onTap: () => _onTileTap(ctx, index),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [tile.color, tile.color.withOpacity(0.82)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: tile.color.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(tile.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tile.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      tile.sub,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              if (tile.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tile.badge!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
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
          // Drawer header
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
                  title: 'Privacy Policy',
                  onTap: () => Navigator.pushNamed(
                    context,
                    RoutesName.schoolAdminPrivacyPolicyScreen,
                  ),
                ),
                _drawerItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => Navigator.pop(context),
                ),
                _drawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () => Navigator.pop(context),
                ),
                _drawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => Navigator.pop(context),
                ),
                _drawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(height: 16, indent: 20, endIndent: 20),
                _drawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
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
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          /// CANCEL
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),

          /// LOGOUT
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            onPressed: () async {
              // dialog close
              Navigator.pop(ctx);

              try {
                final repo = AuthRepository();
                final userVM = UserViewModel();

                // API logout
                await repo.logoutApi({"device_type": "android"});

                // delete firebase token
                await FirebaseMessaging.instance.deleteToken();

                // clear all local data
                await userVM.clearUser();

                PermissionManager.clear();

                print("✅ USER LOGOUT SUCCESS");

                // go to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.loginScreen,
                  (route) => false,
                );
              } catch (e) {
                print("Logout Error => $e");

                // error aaye tab bhi clear karo
                await UserViewModel().clearUser();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.loginScreen,
                  (route) => false,
                );
              }
            },

            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  // void _showLogoutDialog(BuildContext context) {

  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: Row(
  //         children: const [
  //           Icon(Icons.logout_rounded, color: Colors.red),
  //           SizedBox(width: 10),
  //           Text(
  //             'Logout',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       content: const Text(
  //         'Are you sure you want to logout?',
  //         style: TextStyle(fontSize: 14, color: Colors.black54),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
  //         ),
  //         // ElevatedButton(
  //         //   style: ElevatedButton.styleFrom(
  //         //     backgroundColor: Colors.red,
  //         //     shape: RoundedRectangleBorder(
  //         //       borderRadius: BorderRadius.circular(10),
  //         //     ),
  //         //   ),
  //         //   // onPressed: () async {
  //         //   //   await UserViewModel().removeUser();
  //         //   //   Navigator.pushNamedAndRemoveUntil(
  //         //   //     context,
  //         //   //     RoutesName.splash,
  //         //   //     (route) => false,
  //         //   //   );
  //         //   // },
  //         //   onPressed: () async {
  //         //     final userVM = UserViewModel();
  //         //     final role = await userVM.getRole();
  //         //     final schoolId = await userVM.getSchoolId();
  //         //     if (role != null && schoolId != null) {
  //         //       await FirebaseMessaging.instance
  //         //           .unsubscribeFromTopic("school_$schoolId");
  //         //       await FirebaseMessaging.instance
  //         //           .unsubscribeFromTopic("school_${schoolId}_role_$role");
  //         //       print("✅ Unsubscribed: school_$schoolId");
  //         //       print("✅ Unsubscribed: school_${schoolId}_role_$role");
  //         //     }
  //         //
  //         //     await userVM.removeUser();
  //         //     await userVM.removeToken();
  //         //     await userVM.removeRole();
  //         //     await userVM.removeStudentId();
  //         //     await userVM.removeSchoolId();
  //         //
  //         //     Navigator.pushNamedAndRemoveUntil(
  //         //       context,
  //         //       RoutesName.splash,
  //         //           (route) => false,
  //         //     );
  //         //   },
  //         //   child: const Text('Logout', style: TextStyle(color: Colors.white)),
  //         // ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.red,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           onPressed: () async {
  //             final userVM = UserViewModel();
  //
  //             final role = await userVM.getRole();
  //             final schoolId = await userVM.getSchoolId();
  //             final classId = await userVM.getClassId();
  //             final sectionId = await userVM.getSectionId();
  //
  //             final messaging = FirebaseMessaging.instance;
  //
  //             // 🔥 1️⃣ Unsubscribe School Topic
  //             if (schoolId != null) {
  //               await messaging.unsubscribeFromTopic("school_$schoolId");
  //               print("✅ Unsubscribed school_$schoolId");
  //             }
  //
  //             // 🔥 2️⃣ Unsubscribe Role Topic
  //             if (schoolId != null && role != null) {
  //               await messaging.unsubscribeFromTopic(
  //                 "school_${schoolId}_role_$role",
  //               );
  //               print("✅ Unsubscribed role topic");
  //             }
  //
  //             // 🔥 3️⃣ Student Specific Topics
  //             if (role == "student") {
  //               if (schoolId != null && classId != null && classId.isNotEmpty) {
  //                 await messaging.unsubscribeFromTopic(
  //                   "school_${schoolId}_class_$classId",
  //                 );
  //               }
  //
  //               if (schoolId != null &&
  //                   classId != null &&
  //                   sectionId != null &&
  //                   classId.isNotEmpty &&
  //                   sectionId.isNotEmpty) {
  //                 await messaging.unsubscribeFromTopic(
  //                   "school_${schoolId}_class_${classId}_section_$sectionId",
  //                 );
  //               }
  //             }
  //
  //             // 🔥 4️⃣ Delete FCM Token (VERY IMPORTANT)
  //             await FirebaseMessaging.instance.deleteToken();
  //             print("🔥 FCM Token Deleted");
  //
  //             // 🔥 5️⃣ Clear All Local Data
  //             await userVM.clearUser();
  //
  //             // 🔥 6️⃣ Navigate to Splash
  //             Navigator.pushNamedAndRemoveUntil(
  //               context,
  //               RoutesName.splash,
  //               (route) => false,
  //             );
  //           },
  //           child: const Text('Logout', style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// ─── DATA MODELS ────────────────────────────────────────────────────────────────

class _DashTile {
  final String label;
  final String sub;
  final IconData icon;
  final Color color;
  final String? route;
  final bool isWide;
  final String? badge;
  final String permKey; // ✅ new

  const _DashTile({
    required this.label,
    required this.sub,
    required this.icon,
    required this.color,
    required this.route,
    required this.permKey, // ✅ new
    this.isWide = false,
    this.badge,
  });
}
