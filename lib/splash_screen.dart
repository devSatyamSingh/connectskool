import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/accountant_management/accountant_management_dash_board_screen.dart';
import 'package:school_pro/student_management/student_dash_board_screen.dart';
import 'package:school_pro/teacher_management/teacher_management_dashboard_screen.dart';
import 'package:school_pro/utils/permission_manager.dart';

import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/auth_view_model/user_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/user_permission_view_model.dart';

import 'admin_management/school_management_dashboard_screen.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Splash animation ke baad navigation
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final userVM = UserViewModel();

    // ── STEP 1: Fresh install / reinstall detection ──────────────────────────
    // Android uninstall karne pe SharedPreferences wipe hoti hai.
    // 'app_installed_flag' missing hogi → fresh install confirm.
    final isInstalled = await userVM.isAppPreviouslyInstalled();

    if (!isInstalled) {
      // Koi bhi stale data clear karo (safety net)
      await userVM.clearUser();
      debugPrint("🆕 Fresh install detected — showing onboarding");
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
      }
      return;
    }

    // ── STEP 2: Onboarding check ─────────────────────────────────────────────
    final onboardingDone = await userVM.isOnboardingDone();
    if (!onboardingDone) {
      debugPrint("📖 Onboarding not done — showing onboarding");
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
      }
      return;
    }

    await _checkSession(userVM);
  }

  Future<void> _checkSession(UserViewModel userVM) async {
    try {
      PermissionManager.clear();

      final String? userId = await userVM.getUser();
      final String? role   = await userVM.getRole();
      final String? token  = await userVM.getToken();

      debugPrint("SPLASH CHECK → userId=$userId | role=$role | token=${token != null ? 'present' : 'null'}");

      final bool hasSession =
          userId != null && userId.isNotEmpty && userId != "0" &&
              role   != null && role.isNotEmpty &&
              token  != null && token.isNotEmpty;

      if (hasSession) {

        // ✅ ROLE PEHLE SET KARO — yahi main fix hai
        // Admin bypass tabhi kaam karega jab role set ho
        PermissionManager.setRole(role!);

        // ✅ Saved permissions restore karo
        final savedPermissions = await userVM.getPermissions();
        if (savedPermissions.isNotEmpty) {
          PermissionManager.setPermissions(savedPermissions);
          debugPrint("✅ Permissions restored: ${savedPermissions.length}");
        }

        // Backend se fresh permissions bhi lo
        try {
          if (mounted) {
            await Provider.of<GetUserPermissionViewModel>(
              context,
              listen: false,
            ).getUserPermissionApi(
              context: context,
              userId: int.tryParse(userId) ?? 0,
              role: role,
              isCurrentUser: true,
            );
          }
        } catch (e) {
          debugPrint("Permission reload (non-fatal): $e");
          // Backend fail hone pe saved permissions se kaam chalega
        }

        if (mounted) _navigateByRole(role);

      } else {
        debugPrint("No valid session → Onboarding");
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
        }
      }
    } catch (e) {
      debugPrint("CHECK SESSION ERROR => $e");
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
      }
    }
  }

  void _navigateByRole(String role) {
    switch (role) {
      case "school_admin":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SchoolManagementDashboardScreen()),
        );
        break;
      case "student":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StudentDashboardScreen()),
        );
        break;
      case "teacher":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TeacherManagementDashBoardScreen()),
        );
        break;
      case "accountant":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AccountantManagementDashBoardScreen()),
        );
        break;
      default:
        Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColor.primaryGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -80,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value * 0.5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.20),
                                      blurRadius: 40,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 2,
                                  ),
                                ),
                              ),
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.18),
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      "assets/images/school_logo.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  /// App Name
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                           Text(
                            "ConnectSkool",
                            style: GoogleFonts.poppins(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Empowering Learning & School Management",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}