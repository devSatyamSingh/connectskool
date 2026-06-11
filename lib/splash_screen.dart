import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_pro/accountant_management/accountant_management_dash_board_screen.dart';
import 'package:school_pro/student_management/student_dash_board_screen.dart';
import 'package:school_pro/teacher_management/teacher_management_dashboard_screen.dart';
import 'package:school_pro/utils/permission_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/user_view_model.dart';

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
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
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

    _shimmerAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool("isFirstTime") ?? true;

    if (isFirstTime) {
      await prefs.setBool("isFirstTime", false);

      Navigator.pushReplacementNamed(
        context,
        RoutesName.onboardingScreen,
      );
      return;
    }

    await _checkSession();
  }

  // Future<void> _checkSession() async {
  //   try {
  //     UserViewModel userViewModel = UserViewModel();
  //
  //     int? userId = await userViewModel.getUser();
  //     String? role = await userViewModel.getRole();
  //
  //     if (userId != null && userId != 0 && role != null) {
  //
  //       if (role == "school_admin") {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => SchoolManagementDashboardScreen(),
  //           ),
  //         );
  //       }
  //       else if (role == "teacher") {
  //         // Navigator.pushReplacementNamed(
  //         //   context,
  //         //   RoutesName.teacherDashboard,
  //         // );
  //       }//student
  //       else if (role == "accountant") {
  //
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (_) => StudentDashboardScreen(),
  //         //   ),
  //         // );
  //       }
  //       else if (role == "student") {
  //
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => StudentDashboardScreen(),
  //           ),
  //         );
  //       }
  //
  //       else {
  //         Navigator.pushReplacementNamed(
  //           context,
  //           RoutesName.onboardingScreen,
  //         );
  //       }
  //
  //     } else {
  //       Navigator.pushReplacementNamed(
  //         context,
  //         RoutesName.onboardingScreen,
  //       );
  //     }
  //
  //   } catch (e) {
  //     Navigator.pushReplacementNamed(
  //       context,
  //       RoutesName.onboardingScreen,
  //     );
  //   }
  // }
  Future<void> _checkSession() async {
    try {
      final userViewModel = UserViewModel();

      // ==========================
      // Restore Permissions
      // ==========================
      final permissions =
      await userViewModel.getPermissions();

      PermissionManager.setPermissions(
        permissions,
      );

      final int? userId =
      await userViewModel.getUser();

      final String? role =
      await userViewModel.getRole();

      final String? token =
      await userViewModel.getToken();

      print("USER ID => $userId");
      print("ROLE => $role");
      print("TOKEN => $token");

      // ==========================
      // Session Validation
      // ==========================
      if (userId != null &&
          userId != 0 &&
          role != null &&
          role.isNotEmpty &&
          token != null &&
          token.isNotEmpty) {

        switch (role) {

          case "school_admin":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SchoolManagementDashboardScreen(),
              ),
            );
            break;

          case "student":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const StudentDashboardScreen(),
              ),
            );
            break;

          case "teacher":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TeacherManagementDashBoardScreen(),
              ),
            );
            break;

          case "accountant":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AccountantManagementDashBoardScreen(),
              ),
            );
            break;

          default:
            Navigator.pushReplacementNamed(
              context,
              RoutesName.dashboardScreen,
            );
        }
      } else {

        print("❌ Session Not Found");

        Navigator.pushReplacementNamed(
          context,
          RoutesName.dashboardScreen,
        );
      }

    } catch (e) {

      print("CHECK SESSION ERROR => $e");

      Navigator.pushReplacementNamed(
        context,
        RoutesName.dashboardScreen,
      );
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
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 40,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          AppText.customText(
                            "ConnectSkool",
                            size: 40,
                            weight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AppText.customText(
                            "Smart School Management",
                            size: 15,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
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
}
