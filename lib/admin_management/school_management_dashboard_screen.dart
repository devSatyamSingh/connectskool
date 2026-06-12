import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_admin_profile_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart'; // ✅ added
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../repo/auth_repo/auth_repo.dart';
import '../utils/dashboard_module.dart';
import '../utils/permission_error_message.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../view_model/school_view_model/all_accountant_list_view_model.dart';
import '../view_model/school_view_model/cms_viewmodel.dart';
import '../view_model/school_view_model/user_permission_view_model.dart';
import '../view_model/user_view_model.dart';
import 'cms_screen.dart';
import 'manage_permission.dart';

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
  int _selectedNavIndex = 0;

  // // ─── Tile Data ───────────────────────────────────────────────────────────────
  // // static const List<_DashTile> _tiles = [
  // //   _DashTile(
  // //     'All Students',
  // //     Icons.people_alt_rounded,
  // //     Color(0xFF1976D2),
  // //     'Manage students',
  // //   ),
  // //   _DashTile(
  // //     'All Teachers',
  // //     Icons.school_rounded,
  // //     Color(0xFF00897B),
  // //     'Staff list',
  // //   ),
  // //   _DashTile(
  // //     'All Accountants',
  // //     Icons.account_balance_rounded,
  // //     Color(0xFFF57C00),
  // //     'Finance team',
  // //   ),
  // //   _DashTile(
  // //     'Classes',
  // //     Icons.layers_rounded,
  // //     Color(0xFF7B1FA2),
  // //     'View classes',
  // //   ),
  // //   _DashTile(
  // //     'Timetable',
  // //     Icons.schedule_rounded,
  // //     Color(0xFF2E7D32),
  // //     'Weekly schedule',
  // //   ),
  // //   // _DashTile('Sections',       Icons.view_module_rounded,         Color(0xFF6A1B9A), 'Manage sections'),
  // //   _DashTile(
  // //     'Subject',
  // //     Icons.menu_book_rounded,
  // //     Color(0xFF00695C),
  // //     'All subjects',
  // //   ),
  // //   // _DashTile('Fine',           Icons.currency_rupee_rounded,      Color(0xFF8E44AD), 'Fine records'),
  // //   _DashTile(
  // //     'Fees',
  // //     Icons.receipt_long_rounded,
  // //     Color(0xFF27AE60),
  // //     'Fee collection',
  // //   ),
  // //   _DashTile(
  // //     'Transport Fee',
  // //     Icons.directions_bus_rounded,
  // //     Color(0xFF0097A7),
  // //     'Bus fees',
  // //   ),
  // //   _DashTile(
  // //     'Exams',
  // //     Icons.assignment_turned_in_rounded,
  // //     Color(0xFFD4A017),
  // //     'Exam schedule',
  // //   ),
  // //   _DashTile(
  // //     'Marksheet',
  // //     Icons.description_rounded,
  // //     Color(0xFF1565C0),
  // //     'View marks',
  // //   ),
  // //   _DashTile(
  // //     'Admit Card',
  // //     Icons.badge_rounded,
  // //     Color(0xFFC62828),
  // //     'Generate cards',
  // //   ),
  // //   _DashTile(
  // //     'Attendance',
  // //     Icons.fact_check_rounded,
  // //     Color(0xFF0288D1),
  // //     'Daily attendance',
  // //   ),
  // //   _DashTile(
  // //     'Homework',
  // //     Icons.auto_stories_rounded,
  // //     Color(0xFF00796B),
  // //     'Assignments',
  // //   ),
  // //   _DashTile(
  // //     'Notifications',
  // //     Icons.notifications_active_rounded,
  // //     Color(0xFFE65100),
  // //     'Alerts & updates',
  // //   ),
  // //   _DashTile(
  // //     'Exam Marks',
  // //     Icons.grading_rounded,
  // //     Color(0xFF558B2F),
  // //     'Enter marks',
  // //   ),
  // //   _DashTile(
  // //     'Permission',
  // //     Icons.admin_panel_settings_rounded,
  // //     Color(0xFF4527A0),
  // //     'Access control',
  // //   ),
  // // ];
  // static const List<_DashTile> _tiles = [
  //   _DashTile(
  //     'All Students',
  //     Icons.people_alt_rounded,
  //     Color(0xFF1976D2),
  //     'Manage students',
  //     PermissionKeys.viewAllStudent,
  //   ),
  //
  //   _DashTile(
  //     'All Teachers',
  //     Icons.school_rounded,
  //     Color(0xFF00897B),
  //     'Staff list',
  //     PermissionKeys.viewAllTeacher,
  //   ),
  //
  //   _DashTile(
  //     'All Accountants',
  //     Icons.account_balance_rounded,
  //     Color(0xFFF57C00),
  //     'Finance team',
  //     PermissionKeys.viewAccountants,
  //   ),
  //
  //   _DashTile(
  //     'Classes',
  //     Icons.layers_rounded,
  //     Color(0xFF7B1FA2),
  //     'View classes',
  //     PermissionKeys.viewClasses,
  //   ),
  //
  //   _DashTile(
  //     'Timetable',
  //     Icons.schedule_rounded,
  //     Color(0xFF2E7D32),
  //     'Weekly schedule',
  //     PermissionKeys.viewTimetable,
  //   ),
  //
  //   _DashTile(
  //     'Subject',
  //     Icons.menu_book_rounded,
  //     Color(0xFF00695C),
  //     'All subjects',
  //     PermissionKeys.viewSubjects,
  //   ),
  //
  //   _DashTile(
  //     'Fees',
  //     Icons.receipt_long_rounded,
  //     Color(0xFF27AE60),
  //     'Fee collection',
  //     PermissionKeys.viewFees,
  //   ),
  //
  //   _DashTile(
  //     'Transport Fee',
  //     Icons.directions_bus_rounded,
  //     Color(0xFF0097A7),
  //     'Bus fees',
  //     PermissionKeys.manageTransport,
  //   ),
  //
  //   _DashTile(
  //     'Exams',
  //     Icons.assignment_turned_in_rounded,
  //     Color(0xFFD4A017),
  //     'Exam schedule',
  //     PermissionKeys.viewExam,
  //   ),
  //
  //   _DashTile(
  //     'Marksheet',
  //     Icons.description_rounded,
  //     Color(0xFF1565C0),
  //     'View marks',
  //     PermissionKeys.viewMarks,
  //   ),
  //
  //   _DashTile(
  //     'Admit Card',
  //     Icons.badge_rounded,
  //     Color(0xFFC62828),
  //     'Generate cards',
  //     PermissionKeys.generateAdmitCard,
  //   ),
  //
  //   _DashTile(
  //     'Attendance',
  //     Icons.fact_check_rounded,
  //     Color(0xFF0288D1),
  //     'Daily attendance',
  //     PermissionKeys.markStudentAttendance,
  //   ),
  //
  //   _DashTile(
  //     'Homework',
  //     Icons.auto_stories_rounded,
  //     Color(0xFF00796B),
  //     'Assignments',
  //     PermissionKeys.viewHomework,
  //   ),
  //
  //   _DashTile(
  //     'Notifications',
  //     Icons.notifications_active_rounded,
  //     Color(0xFFE65100),
  //     'Alerts & updates',
  //     PermissionKeys.notificationView,
  //   ),
  //
  //   _DashTile(
  //     'Exam Marks',
  //     Icons.grading_rounded,
  //     Color(0xFF558B2F),
  //     'Enter marks',
  //     PermissionKeys.manageExamMarks,
  //   ),
  //
  //   _DashTile(
  //     'Permission',
  //     Icons.admin_panel_settings_rounded,
  //     Color(0xFF4527A0),
  //     'Access control',
  //     PermissionKeys.managePermissions,
  //   ),
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchoolAdminProfileViewModel>(
        context,
        listen: false,
      ).schoolAdminProfileApi(context);
      // ✅ Fetch students to get total count
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
      context
          .read<CmsViewModel>()
          .getCmsPages();
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

  // void _onTileTap(int index) {
  //   switch (index) {
  //     case 0:
  //       Navigator.pushNamed(context, RoutesName.allStudentList);
  //       break;
  //     case 1:
  //       Navigator.pushNamed(context, RoutesName.allTeacherListScreen);
  //       break;
  //     case 2:
  //       Navigator.pushNamed(context, RoutesName.allAccountantListScreen);
  //       break;
  //     case 3:
  //       Navigator.pushNamed(context, RoutesName.classesPage);
  //       break;
  //     case 4:
  //       Navigator.pushNamed(context, RoutesName.schoolTimetableScreen);
  //       break;
  //     // case 5:  Navigator.pushNamed(context, RoutesName.allSectionScreen); break;
  //     case 5:
  //       Navigator.pushNamed(context, RoutesName.allSubjectsScreen);
  //       break;
  //     // case 6:  Navigator.pushNamed(context, RoutesName.fineManagementScreen); break;
  //     case 6:
  //       Navigator.pushNamed(context, RoutesName.feesManagementScreen);
  //       break;
  //     case 7:
  //       Navigator.pushNamed(context, RoutesName.transportFeeManagementScreen);
  //       break;
  //     case 8:
  //       Navigator.pushNamed(context, RoutesName.examScreen);
  //       break;
  //     case 9:
  //       Navigator.pushNamed(context, RoutesName.marksheetScreen);
  //       break;
  //     case 10:
  //       Navigator.pushNamed(context, RoutesName.schoolAdmitCardScreen);
  //       break;
  //     case 11:
  //       Navigator.pushNamed(context, RoutesName.staffAttendanceScreen);
  //       break;
  //     case 12:
  //       Navigator.pushNamed(context, RoutesName.allHomeWorkScreen);
  //       break;
  //     case 13:
  //       Navigator.pushNamed(context, RoutesName.notificationScreen);
  //       break;
  //     case 14:
  //       Navigator.pushNamed(context, RoutesName.schoolExamMarksScreen);
  //       break;
  //     case 15:
  //       Navigator.pushNamed(context, RoutesName.managePermission);
  //       break;
  //   }
  // }

  // ─── BUILD ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<SchoolAdminProfileViewModel>(
      context,
    ).schoolAdminProfileModel;
    final String adminName = _capitalize(profile?.data?.name);
    final String adminEmail = profile?.data?.userEmail ?? 'admin@schoolpro.com';

    //  Dynamic student total from pagination
    final studentTotal = Provider.of<AllStudentListVieModel>(
          context,
        ).allStudentListModel?.pagination?.total?.toString() ??
        '...';
    final teacherTotal =
        Provider.of<AllTeachersListVieModel>(
          context,
        ).allTeachersListModel?.pagination?.total?.toString() ??
        '...';
    final accountantTotal =
        Provider.of<AllAccountantListVieModel>(
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

  // ─── HEADER ──────────────────────────────────────────────────────────────────

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
          // ── Top Row ──
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
                      'SCHOOL ADMIN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.55),
                        letterSpacing: 1.5,
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
              // Notification icon
              // Stack(
              //   children: [
              //     Container(
              //       width: 44,
              //       height: 44,
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.12),
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
              //             color: const Color(0xFF1565C0),
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

          // ── Stat Pills ──
          Row(
            children: [
              _statPill(
                Icons.people_rounded,
                studentTotal,
                'Students',
                const Color(0xFF6C5CE7),
              ),
              const SizedBox(width: 10),
              _statPill(
                Icons.person_rounded,
                teacherTotal,
                'Teachers',
                const Color(0xFF00B894),
              ),
              const SizedBox(width: 10),
              _statPill(
                Icons.calculate_rounded,
                accountantTotal,
                'Accountants',
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

  // ─── GRID ────────────────────────────────────────────────────────────────────

  // Widget _buildGrid() {
  //   return GridView.builder(
  //     padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       mainAxisSpacing: 14,
  //       crossAxisSpacing: 14,
  //       childAspectRatio: 1.08,
  //     ),
  //     itemCount: _tiles.length,
  //     itemBuilder: (ctx, i) {
  //       final tile = _tiles[i];
  //       return AnimatedBuilder(
  //         animation: _tileAnimations[i],
  //         builder: (_, child) => Transform.scale(
  //           scale: _tileAnimations[i].value,
  //           child: Opacity(
  //             opacity: _tileAnimations[i].value.clamp(0.0, 1.0),
  //             child: child,
  //           ),
  //         ),
  //         child: _buildTile(tile, i),
  //       );
  //     },
  //   );
  // }
  Widget _buildGrid() {
    // ✅ Sirf woh tiles jinka permission denied NAHI hai
    final permVm = Provider.of<GetUserPermissionViewModel>(
      context,
      listen: false,
    );

    final visibleTiles = DashboardModules.modules
        .where(
          (e) => PermissionExtensions.canAccess(
        e.permission,
      ),
    )
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

        return AnimatedBuilder(
          animation: _tileAnimations[i.clamp(0, _tileAnimations.length - 1)],
          builder: (_, child) => Transform.scale(
            scale:
                _tileAnimations[i.clamp(0, _tileAnimations.length - 1)].value,
            child: Opacity(
              opacity: _tileAnimations[i.clamp(0, _tileAnimations.length - 1)]
                  .value
                  .clamp(0.0, 1.0),
              child: child,
            ),
          ),
          child: _buildModuleTile(module), // ✅ original index pass
        );
      },
    );
  }

  Widget _buildModuleTile(
      DashboardModule module,
      ) {
    return GestureDetector(
      onTap: () {

        if (
        !PermissionGuard.check(
          context,
          module.permission,
          module.title,
        )
        ) {
          return;
        }

        Navigator.pushNamed(
          context,
          module.route,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              module.color,
              module.color.withOpacity(0.78),
            ],
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
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      module.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    module.title,
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

  // Widget _buildTile(_DashTile tile, int index) {
  //   return GestureDetector(
  //     onTap: () => _onTileTap(index),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [tile.color, tile.color.withOpacity(0.78)],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: tile.color.withOpacity(0.32),
  //             blurRadius: 12,
  //             offset: const Offset(0, 6),
  //           ),
  //         ],
  //       ),
  //       child: Stack(
  //         children: [
  //           Positioned(
  //             top: -14,
  //             right: -14,
  //             child: Container(
  //               width: 58,
  //               height: 58,
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.11),
  //                 shape: BoxShape.circle,
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             bottom: -8,
  //             left: 8,
  //             child: Container(
  //               width: 36,
  //               height: 36,
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.07),
  //                 shape: BoxShape.circle,
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withOpacity(0.2),
  //                     borderRadius: BorderRadius.circular(14),
  //                   ),
  //                   child: Icon(tile.icon, color: Colors.white, size: 24),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   tile.label,
  //                   textAlign: TextAlign.center,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(
  //                     fontSize: 11.5,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                     height: 1.3,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '🏫  School Administrator',
                    style: TextStyle(
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
                _drawerItem(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CmsScreen(
                          pageType: "privacy_policy",
                          title: "Privacy Policy",
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CmsScreen(
                          pageType: "terms_conditions",
                          title: "Terms & Conditions",
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CmsScreen(
                          pageType: "about_us",
                          title: "About Us",
                        ),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(
                      context,
                      RoutesName.helpSupportScreen,
                    );
                  },
                ),
                _drawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePermission())),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Divider(),
                ),
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

                print("✅ USER LOGOUT SUCCESS");

                // go to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.splash,
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
  } // void _showLogoutDialog(BuildContext context) {

  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: const Row(
  //         children: [
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
  //         //         borderRadius: BorderRadius.circular(10)),
  //         //   ),
  //         //   // onPressed: () async {
  //         //   //   await UserViewModel().removeUser();
  //         //   //   Navigator.pushNamedAndRemoveUntil(
  //         //   //     context,
  //         //   //     RoutesName.splash,
  //         //   //         (route) => false,
  //         //   //   );
  //         //   // },
  //         //   onPressed: () async {
  //         //     final userVM = UserViewModel();
  //         //
  //         //     // ✅ FCM Unsubscribe
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
  //         //     // ✅ Sab clear karo
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
  //         //   child: const Text('Logout',
  //         //       style: TextStyle(color: Colors.white)),
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
  //             Navigator.pop(context); // 👈 Dialog close
  //
  //             Future.delayed(Duration.zero, () {
  //               Navigator.pushNamedAndRemoveUntil(
  //                 context,
  //                 RoutesName.splash,
  //                     (route) => false,
  //               );
  //             });
  //             // 🔥 6️⃣ Navigate to Splash
  //             // Navigator.pushNamedAndRemoveUntil(
  //             //   context,
  //             //   RoutesName.splash,
  //             //   (route) => false,
  //             // );
  //           },
  //           child: const Text('Logout', style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// ─── DATA MODELS ─────────────────────────────────────────────────────────────

// dashboard screen ke bottom mein

class _DashTile {
  final String label;
  final IconData icon;
  final Color color;
  final String sub;
  final String permKey; // ✅ new

  const _DashTile(this.label, this.icon, this.color, this.sub, this.permKey);
}
