// import 'package:flutter/material.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
// import 'package:school_pro/utils/routes/routes_name.dart';
// import '../res/app_button.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//
//   final PageController _controller = PageController();
//   int currentIndex = 0;
//
//   final List<Map<String, dynamic>> pages = [
//     {
//       "icon": Icons.school_rounded,
//       "title": "Manage Students Easily",
//       "desc": "Add, update and track all student records in one place"
//     },
//     {
//       "icon": Icons.fact_check_rounded,
//       "title": "Attendance & Fees",
//       "desc": "Mark attendance and manage school fees digitally"
//     },
//     {
//       "icon": Icons.analytics_rounded,
//       "title": "Reports & Communication",
//       "desc": "Generate reports and connect with parents instantly"
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColor.primaryGradient,
//         ),
//         child: Column(
//           children: [
//
//             Expanded(
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: pages.length,
//                 onPageChanged: (i) => setState(() => currentIndex = i),
//                 itemBuilder: (context, index) {
//                   final page = pages[index];
//
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//                         Container(
//                           padding: const EdgeInsets.all(34),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(.12),
//                                 blurRadius: 18,
//                                 offset: const Offset(0, 8),
//                               )
//                             ],
//                           ),
//                           child: Icon(
//                             page["icon"],
//                             size: 120,
//                             color: AppColor.lightBlueColor,
//                           ),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.05),
//
//                         AppText.customText(
//                           page["title"],
//                           size: 28,
//                           weight: FontWeight.bold,
//                           align: TextAlign.center,
//                           color: Colors.white,
//                         ),
//
//                         SizedBox(height: screenHeight * 0.015),
//
//                         AppText.customText(
//                           page["desc"],
//                           size: 15,
//                           color: Colors.white70,
//                           align: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 pages.length,
//                     (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.all(5),
//                   height: 8,
//                   width: currentIndex == index ? 26 : 8,
//                   decoration: BoxDecoration(
//                     color: currentIndex == index
//                         ? Colors.white
//                         : Colors.white38,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: screenHeight * 0.03),
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//               child: AppButton(
//                 bgColor: Colors.white,
//                 title: currentIndex == pages.length - 1
//                     ? "Get Started"
//                     : "Next",
//                 textColor: Colors.black,
//                 onTap: () {
//                   if (currentIndex == pages.length - 1) {
//                     Navigator.pushNamed(context, RoutesName.dashboardScreen);
//                     // Navigator.pushReplacement(...)
//                   } else {
//                     _controller.nextPage(
//                       duration: const Duration(milliseconds: 350),
//                       curve: Curves.easeOut,
//                     );
//                   }
//                 },
//               ),
//             ),
//
//             SizedBox(height: screenHeight * 0.08),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import '../res/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int currentIndex = 0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> pages = [
    {
      "icon": Icons.school_rounded,
      "title": "Manage Students\nEasily",
      "desc": "Add, update and track all student records in one centralized platform",
      "color": Color(0xFF6C5CE7),
    },
    {
      "icon": Icons.fact_check_rounded,
      "title": "Attendance &\nFee Management",
      "desc": "Mark attendance and manage school fees digitally with automated tracking",
      "color": Color(0xFF00B894),
    },
    {
      "icon": Icons.analytics_rounded,
      "title": "Reports &\nCommunication",
      "desc": "Generate detailed reports and connect with parents instantly",
      "color": Color(0xFFFF6B6B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  void _onPageChanged(int index) {
    setState(() => currentIndex = index);
    _fadeController.reset();
    _scaleController.reset();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  right: screenWidth * 0.05,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.dashboardScreen);
                    },
                    child: AppText.customText(
                      "Skip",
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final page = pages[index];

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated icon container with gradient
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer glow circle
                                  Container(
                                    width: 240,
                                    height: screenHeight*0.1,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          page["color"].withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Middle circle
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  // Icon container
                                  Container(
                                    padding: const EdgeInsets.all(45),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: page["color"].withOpacity(0.4),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      page["icon"],
                                      size: 90,
                                      color: page["color"],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.07),

                              // Title with gradient
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.95),
                                  ],
                                ).createShader(bounds),
                                child: AppText.customText(
                                  page["title"],
                                  size: 32,
                                  weight: FontWeight.w900,
                                  align: TextAlign.center,
                                  color: Colors.white,
                                  // height: 1.3,
                                  // letterSpacing: 0.5,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // Description with container
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: AppText.customText(
                                  page["desc"],
                                  size: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  align: TextAlign.center,
                                  // height: 1.6,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page indicators with animation
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: currentIndex == index ? 12 : 8,
                      width: currentIndex == index ? 36 : 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: currentIndex == index
                            ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom action buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    // Back button
                    if (currentIndex > 0)
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 56,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOut,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),

                    // Next/Get Started button
                    Expanded(
                      flex: currentIndex > 0 ? 3 : 4,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (currentIndex == pages.length - 1) {
                                Navigator.pushNamed(
                                  context,
                                  RoutesName.dashboardScreen,
                                );
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.customText(
                                    currentIndex == pages.length - 1
                                        ? "Get Started"
                                        : "Next",
                                    size: 18,
                                    weight: FontWeight.w700,
                                    color: AppColor.lightBlueColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    currentIndex == pages.length - 1
                                        ? Icons.check_circle_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: AppColor.lightBlueColor,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
