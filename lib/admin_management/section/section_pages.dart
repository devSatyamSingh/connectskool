// // import 'package:flutter/material.dart';
// // import 'package:school_pro/res/app_color.dart';
// // import 'package:school_pro/res/const_text.dart';
// //
// // class SectionsPage extends StatelessWidget {
// //   const SectionsPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: GridView.builder(
// //         itemCount: 6,
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 14,
// //           mainAxisSpacing: 14,
// //           childAspectRatio: 0.9,
// //         ),
// //         itemBuilder: (context, index) {
// //           final sections = ["A", "B", "C", "D", "E", "F"];
// //
// //           return _sectionCard("Section ${sections[index]}", "25 Students");
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _sectionCard(String title, String subtitle) {
// //     return Container(
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.08),
// //             blurRadius: 20,
// //             offset: const Offset(0, 10),
// //           ),
// //           BoxShadow(
// //             color: AppColor.lightBlueColor.withOpacity(.08),
// //             blurRadius: 12,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //
// //           Container(
// //             padding: const EdgeInsets.all(18),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: AppColor.lightBlueColor.withOpacity(.12),
// //             ),
// //             child: const Icon(
// //               Icons.groups_rounded,
// //               size: 36,
// //               color: AppColor.lightBlueColor,
// //             ),
// //           ),
// //
// //           const SizedBox(height: 14),
// //
// //           AppText.customText(
// //             title,
// //             size: 16,
// //             weight: FontWeight.w600,
// //           ),
// //
// //           const SizedBox(height: 4),
// //
// //           AppText.customText(
// //             subtitle,
// //             size: 12,
// //             color: Colors.grey,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// class SectionsPage extends StatefulWidget {
//   const SectionsPage({super.key});
//
//   @override
//   State<SectionsPage> createState() => _SectionsPageState();
// }
//
// class _SectionsPageState extends State<SectionsPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   final List<Map<String, dynamic>> sections = [
//     {
//       "name": "A",
//       "students": 25,
//       "teacher": "Ms. Sarah",
//       "color": Color(0xFF6C5CE7),
//       "gradient": [Color(0xFF6C5CE7), Color(0xFF8B7EF7)],
//     },
//     {
//       "name": "B",
//       "students": 28,
//       "teacher": "Mr. John",
//       "color": Color(0xFF00B894),
//       "gradient": [Color(0xFF00B894), Color(0xFF00D2A4)],
//     },
//     {
//       "name": "C",
//       "students": 26,
//       "teacher": "Ms. Emily",
//       "color": Color(0xFFFF6B6B),
//       "gradient": [Color(0xFFFF6B6B), Color(0xFFFF8787)],
//     },
//     {
//       "name": "D",
//       "students": 27,
//       "teacher": "Mr. David",
//       "color": Color(0xFFFFA502),
//       "gradient": [Color(0xFFFFA502), Color(0xFFFFB732)],
//     },
//     {
//       "name": "E",
//       "students": 24,
//       "teacher": "Ms. Lisa",
//       "color": Color(0xFF0984E3),
//       "gradient": [Color(0xFF0984E3), Color(0xFF74B9FF)],
//     },
//     {
//       "name": "F",
//       "students": 29,
//       "teacher": "Mr. Alex",
//       "color": Color(0xFFE84393),
//       "gradient": [Color(0xFFE84393), Color(0xFFFD79A8)],
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header Section
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(
//                         "Sections",
//                         size: 26,
//                         weight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 4),
//                       AppText.customText(
//                         "${sections.length} sections available",
//                         size: 13,
//                         color: Colors.grey[600]!,
//                       ),
//                     ],
//                   ),
//                   // Add button
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColor.lightBlueColor,
//                           AppColor.lightBlueColor.withOpacity(0.8),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColor.lightBlueColor.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.add_rounded,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Stats Row
//               Row(
//                 children: [
//                   _buildStatChip(
//                     icon: Icons.people_rounded,
//                     label: "Total: ${sections.fold<int>(0, (sum, s) => sum + (s['students'] as int))}",
//                     color: Color(0xFF6C5CE7),
//                   ),
//                   const SizedBox(width: 10),
//                   _buildStatChip(
//                     icon: Icons.grid_view_rounded,
//                     label: "Avg: ${(sections.fold<int>(0, (sum, s) => sum + (s['students'] as int)) / sections.length).round()}",
//                     color: Color(0xFF00B894),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         // Grid View
//         Expanded(
//           child: GridView.builder(
//             padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//             physics: const BouncingScrollPhysics(),
//             itemCount: sections.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 0.7,
//             ),
//             itemBuilder: (context, index) {
//               return _buildAnimatedCard(index, sections[index]);
//             },
//           ),
//         ),
//          SizedBox(height: screenHeight*0.05),
//       ],
//     );
//   }
//
//   Widget _buildStatChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 18, color: color),
//           const SizedBox(width: 6),
//           AppText.customText(
//             label,
//             size: 13,
//             color: color,
//             weight: FontWeight.w600,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard(int index, Map<String, dynamic> section) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         final delay = index * 0.1;
//         final animationValue = Curves.easeOut.transform(
//           (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
//         );
//
//         return Transform.scale(
//           scale: 0.8 + (0.2 * animationValue),
//           child: Opacity(
//             opacity: animationValue,
//             child: child,
//           ),
//         );
//       },
//       child: _sectionCard(
//         name: section["name"],
//         students: section["students"],
//         teacher: section["teacher"],
//         color: section["color"],
//         gradient: section["gradient"],
//       ),
//     );
//   }
//
//   Widget _sectionCard({
//     required String name,
//     required int students,
//     required String teacher,
//     required Color color,
//     required List<Color> gradient,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth*0.014),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(22),
//       border: Border.all(color: Colors.grey.shade50),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.white.withOpacity(0.6),
//           //     offset: const Offset(-2, -2),
//           //     blurRadius: 6,
//           //   ),
//           //
//           //   // Main elevation shadow
//           //   BoxShadow(
//           //     color: color.withOpacity(0.18),
//           //     offset: const Offset(0, 12),
//           //     blurRadius: 20,
//           //     spreadRadius: 2,
//           //   ),
//           //
//           //   // Deep bottom shadow (realistic depth)
//           //   BoxShadow(
//           //     color: Colors.black.withOpacity(0.06),
//           //     offset: const Offset(0, 20),
//           //     blurRadius: 30,
//           //   ),
//           // ],
//           boxShadow: [
//             // very light top highlight
//             BoxShadow(
//               color: Colors.white.withOpacity(0.4),
//               offset: const Offset(-1, -1),
//               blurRadius: 4,
//             ),
//
//             // main soft elevation
//             BoxShadow(
//               color: color.withOpacity(0.12), // pehle se kam
//               offset: const Offset(0, 10),
//               blurRadius: 16,
//               spreadRadius: 1,
//             ),
//
//             // very subtle depth
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               offset: const Offset(0, 16),
//               blurRadius: 22,
//             ),
//           ],
//
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(22),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 // Navigate to section details
//               },
//               child: Stack(
//                 children: [
//                   // Decorative background element
//                   Positioned(
//                     top: -40,
//                     right: -40,
//                     child: Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: RadialGradient(
//                           colors: [
//                             color.withOpacity(0.15),
//                             color.withOpacity(0.05),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   Padding(
//                     padding:  EdgeInsets.all(screenWidth*0.03),
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         // Section letter with gradient background
//                         Container(
//                           width:screenWidth*0.2,
//                           height: screenHeight*0.09,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: gradient,
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: color.withOpacity(0.4),
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: AppText.customText(
//                               name,
//                               size: 25,
//                               weight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//
//                          SizedBox(height: screenHeight*0.01),
//
//                         // Section title
//                         AppText.customText(
//                           "Section $name",
//                           size: 18,
//                           weight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//
//                          SizedBox(height: screenHeight*0.01),
//
//                         // Students count
//                         Container(
//                           padding:  EdgeInsets.symmetric(
//                             horizontal: screenWidth*0.02,
//                             vertical: screenHeight*0.01,
//                           ),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.people_rounded,
//                                 size: 14,
//                                 color: color,
//                               ),
//                               const SizedBox(width: 6),
//                               AppText.customText(
//                                 "$students Students",
//                                 size: 11,
//                                 color: color,
//                                 weight: FontWeight.w600,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                          // SizedBox(height: screenHeight*0.01),
//
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.person_outline_rounded,
//                               size: 14,
//                               color: Colors.grey[600],
//                             ),
//                             const SizedBox(width: 4),
//                             Flexible(
//                               child: AppText.customText(
//                                 teacher,
//                                 size: 12,
//                                 color: Colors.grey[600]!,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: screenHeight*0.01),
//                         // const Spacer(),
//
//                         // View details button
//                         Container(
//                           padding:  EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: screenHeight*0.01,
//                           ),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: color.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AppText.customText(
//                                 "View Details",
//                                 size: 12,
//                                 color: color,
//                                 weight: FontWeight.w600,
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 Icons.arrow_forward_rounded,
//                                 size: 14,
//                                 color: color,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }