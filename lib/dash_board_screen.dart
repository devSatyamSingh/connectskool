import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/routes/routes_name.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> modules = const [
    {
      "icon": Icons.school_rounded,
      "title": "Admin",
      "subtitle": "Classes, sections & fees",
      "color": Color(0xFF6C5CE7),
      "gradient": [Color(0xFF6C5CE7), Color(0xFF8B7EF7)],
    },
    {
      "icon": Icons.person_rounded,
      "title": "Teacher",
      "subtitle": "Attendance & performance",
      "color": Color(0xFF00B894),
      "gradient": [Color(0xFF00B894), Color(0xFF00D2A4)],
    },
    {
      "icon": Icons.groups_rounded,
      "title": "Accountant",
      "subtitle": "Records & progress",
      "color": Color(0xFFFF6B6B),
      "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8787)],
    },
    {
      "icon": Icons.menu_book_rounded,
      "title": "Student",
      "subtitle": "Student Management",
      "color": Color(0xFFFFA502),
      "gradient": [Color(0xFFFFA502), Color(0xFFFFB732)],
    },
  ];
  Future<bool> _showExitPopup() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Exit App", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'poppins'),),
        content: const Text("Are you sure you want to exit?", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'poppins'),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.black, fontFamily: 'poppins'),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
            ),
            onPressed: () {
              SystemNavigator.pop(); // app close
            },
            child: const Text("OK", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitPopup();
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColor.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.01,
                  ),
                  child: Column(
                    children: [
                      // Profile & Notification Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Profile Section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColor.lightBlueColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.customText(
                                    "Welcome Back",
                                    size: 13,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                  AppText.customText(
                                    "Admin User",
                                    size: 18,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Notification Icon
                          // Container(
                          //   padding: const EdgeInsets.all(12),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.2),
                          //     borderRadius: BorderRadius.circular(14),
                          //     border: Border.all(
                          //       color: Colors.white.withOpacity(0.3),
                          //       width: 1,
                          //     ),
                          //   ),
                          //   child: Stack(
                          //     children: [
                          //       const Icon(
                          //         Icons.notifications_rounded,
                          //         color: Colors.white,
                          //         size: 26,
                          //       ),
                          //       Positioned(
                          //         right: 0,
                          //         top: 0,
                          //         child: Container(
                          //           width: 10,
                          //           height: 10,
                          //           decoration: BoxDecoration(
                          //             color: Colors.red,
                          //             shape: BoxShape.circle,
                          //             border: Border.all(
                          //               color: Colors.white,
                          //               width: 2,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: screenWidth*0.04,
                          vertical: screenHeight*0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.dashboard_customize_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            AppText.customText(
                              "ConnectSkool Dashboard",
                              size: 18,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.02),

                      // Row(
                      //   children: [
                      //     _buildStatCard(
                      //       icon: Icons.people_rounded,
                      //       count: "1,234",
                      //       label: "Students",
                      //       color: Color(0xFF6C5CE7),
                      //     ),
                      //     SizedBox(width: screenWidth * 0.03),
                      //     _buildStatCard(
                      //       icon: Icons.person_rounded,
                      //       count: "45",
                      //       label: "Teachers",
                      //       color: Color(0xFF00B894),
                      //     ),
                      //     SizedBox(width: screenWidth * 0.03),
                      //     _buildStatCard(
                      //       icon: Icons.class_rounded,
                      //       count: "28",
                      //       label: "Classes",
                      //       color: Color(0xFFFF6B6B),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Modules Grid Section
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      top: screenHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 16),
                          child: AppText.customText(
                            "Management Modules",
                            size: 20,
                            weight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        // Expanded(
                        //   child: GridView.builder(
                        //     physics: const BouncingScrollPhysics(),
                        //     itemCount: modules.length,
                        //     padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                        //     gridDelegate:
                        //     const SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 2,
                        //       mainAxisSpacing: 18,
                        //       crossAxisSpacing: 18,
                        //       childAspectRatio: 0.7,
                        //     ),
                        //     itemBuilder: (context, index) {
                        //       final module = modules[index];
                        //       return _buildAnimatedCard(
                        //         index: index,
                        //         module: module,
                        //         context: context,
                        //       );
                        //     },
                        //   ),
                        // ),
                        Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: modules.length,
                            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              childAspectRatio:
                              MediaQuery.of(context).size.height < 700 ? 0.72 : 0.78,
                            ),
                            itemBuilder: (context, index) {
                              final module = modules[index];
                              return _buildAnimatedCard(
                                index: index,
                                module: module,
                                context: context,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 6),
            AppText.customText(
              count,
              size: 18,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            AppText.customText(
              label,
              size: 11,
              color: Colors.white.withOpacity(0.85),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required int index,
    required Map<String, dynamic> module,
    required BuildContext context,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.1;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: child,
          ),
        );
      },
      child: _dashboardCard(
        icon: module["icon"],
        title: module["title"],
        subtitle: module["subtitle"],
        color: module["color"],
        gradient: module["gradient"],
        onTap: () {
          Navigator.pushNamed(context, RoutesName.loginScreen);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => ModuleScreen(
          //       title: module["title"],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2), // subtle border
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
       child:  Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Spacer(),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 38,
                ),
              ),

              const SizedBox(height: 14),

              AppText.customText(
                title,
                size: 16,
                weight: FontWeight.bold,
                align: TextAlign.center,
                color: Colors.black87,
              ),

              const SizedBox(height: 6),

              AppText.customText(
                subtitle,
                size: 12,
                color: Colors.grey[600]!,
                align: TextAlign.center,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),

      // child: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(22),
      //     gradient: LinearGradient(
      //       colors: [Colors.white, Colors.white!],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: color.withValues(alpha:0.07),
      //         blurRadius: 12,
      //         // offset: const Offset(0, 2),
      //         spreadRadius: 2,
      //       ),
      //       // BoxShadow(
      //       //   color: Colors.black.withValues(alpha: .09),
      //       //   blurRadius: 12,
      //       //   // offset: const Offset(0, 2),
      //       // ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(22),
      //     child: Stack(
      //       children: [
      //         // Decorative background circle
      //         Positioned(
      //           top: -30,
      //           right: -30,
      //           child: Container(
      //             width: 100,
      //             height: 100,
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               gradient: LinearGradient(
      //                 colors: [
      //                   color.withValues(alpha: 0.06),
      //                   color.withValues(alpha: 0.05),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //
      //         Padding(
      //           padding: const EdgeInsets.all(8),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               // Icon with gradient background
      //               Container(
      //                 padding: const EdgeInsets.all(18),
      //                 decoration: BoxDecoration(
      //                   gradient: LinearGradient(
      //                     colors: gradient,
      //                     begin: Alignment.topLeft,
      //                     end: Alignment.bottomRight,
      //                   ),
      //                   borderRadius: BorderRadius.circular(18),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: color.withOpacity(0.4),
      //                       blurRadius: 15,
      //                       offset: const Offset(0, 8),
      //                     ),
      //                   ],
      //                 ),
      //                 child: Icon(
      //                   icon,
      //                   color: Colors.white,
      //                   size: 40,
      //                 ),
      //               ),
      //
      //               SizedBox(height: screenHeight * 0.02),
      //
      //               AppText.customText(
      //                 title,
      //                 size: 16,
      //                 weight: FontWeight.bold,
      //                 align: TextAlign.center,
      //                 color: Colors.black87,
      //                 // height: 1.2,
      //               ),
      //
      //               SizedBox(height: 6),
      //
      //               AppText.customText(
      //                 subtitle,
      //                 size: 12,
      //                 color: Colors.grey[600]!,
      //                 align: TextAlign.center,
      //                 // height: 1.3,
      //               ),
      //
      //               // const Spacer(),
      //               //
      //               // // Arrow indicator
      //               // Container(
      //               //   padding: const EdgeInsets.all(6),
      //               //   decoration: BoxDecoration(
      //               //     color: color.withOpacity(0.1),
      //               //     borderRadius: BorderRadius.circular(8),
      //               //   ),
      //               //   child: Icon(
      //               //     Icons.arrow_forward_rounded,
      //               //     color: color,
      //               //     size: 18,
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );

  }
}