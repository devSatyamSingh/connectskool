// import 'package:flutter/material.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// class FeesPage extends StatefulWidget {
//   const FeesPage({super.key});
//
//   @override
//   State<FeesPage> createState() => _FeesPageState();
// }
//
// class _FeesPageState extends State<FeesPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   final List<Map<String, dynamic>> fees = [
//     {
//       "class": "Class 1",
//       "amount": 15000,
//       "status": "Paid",
//       "dueDate": "15 Jan 2024",
//       "color": Color(0xFF6C5CE7),
//     },
//     {
//       "class": "Class 2",
//       "amount": 14500,
//       "status": "Pending",
//       "dueDate": "20 Jan 2024",
//       "color": Color(0xFF00B894),
//     },
//     {
//       "class": "Class 3",
//       "amount": 16000,
//       "status": "Paid",
//       "dueDate": "10 Jan 2024",
//       "color": Color(0xFFFF6B6B),
//     },
//     {
//       "class": "Class 4",
//       "amount": 15200,
//       "status": "Overdue",
//       "dueDate": "05 Jan 2024",
//       "color": Color(0xFFFFA502),
//     },
//     {
//       "class": "Class 5",
//       "amount": 17000,
//       "status": "Pending",
//       "dueDate": "25 Jan 2024",
//       "color": Color(0xFF0984E3),
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
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
//   int get totalAmount => fees.fold<int>(0, (sum, fee) => sum + (fee['amount'] as int));
//   int get paidAmount => fees
//       .where((fee) => fee['status'] == 'Paid')
//       .fold<int>(0, (sum, fee) => sum + (fee['amount'] as int));
//   int get pendingAmount => fees
//       .where((fee) => fee['status'] != 'Paid')
//       .fold<int>(0, (sum, fee) => sum + (fee['amount'] as int));
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Paid":
//         return Colors.green;
//       case "Pending":
//         return Colors.orange;
//       case "Overdue":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case "Paid":
//         return Icons.check_circle_rounded;
//       case "Pending":
//         return Icons.schedule_rounded;
//       case "Overdue":
//         return Icons.error_rounded;
//       default:
//         return Icons.info_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               // Header Section
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText.customText(
//                               "Fee Management",
//                               size: 26,
//                               weight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                             const SizedBox(height: 4),
//                             AppText.customText(
//                               "Academic Year 2023-24",
//                               size: 13,
//                               color: Colors.grey[600]!,
//                             ),
//                           ],
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColor.lightBlueColor,
//                                 AppColor.lightBlueColor.withOpacity(0.8),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColor.lightBlueColor.withOpacity(0.3),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: const Icon(
//                             Icons.filter_list_rounded,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Summary Cards
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     // Total Amount Card
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             AppColor.lightBlueColor,
//                             AppColor.lightBlueColor.withOpacity(0.8),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColor.lightBlueColor.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               AppText.customText(
//                                 "Total Collection",
//                                 size: 14,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                               Icon(
//                                 Icons.account_balance_wallet_rounded,
//                                 color: Colors.white.withOpacity(0.9),
//                                 size: 24,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           AppText.customText(
//                             "₹${totalAmount.toStringAsFixed(0)}",
//                             size: 32,
//                             weight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(height: 4),
//                           AppText.customText(
//                             "All classes combined",
//                             size: 12,
//                             color: Colors.white.withOpacity(0.85),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 14),
//
//                     // Paid and Pending Row
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildSummaryCard(
//                             title: "Paid",
//                             amount: paidAmount,
//                             icon: Icons.check_circle_rounded,
//                             color: Colors.green,
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: _buildSummaryCard(
//                             title: "Pending",
//                             amount: pendingAmount,
//                             icon: Icons.pending_rounded,
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Class Fees Section Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppText.customText(
//                       "Class-wise Fees",
//                       size: 18,
//                       weight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: AppText.customText(
//                         "${fees.length} Classes",
//                         size: 12,
//                         color: Colors.grey[700]!,
//                         weight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Fee Cards List
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: List.generate(
//                     fees.length,
//                         (index) => _buildAnimatedCard(index, fees[index]),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSummaryCard({
//     required String title,
//     required int amount,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AppText.customText(
//                 title,
//                 size: 13,
//                 color: Colors.grey[700]!,
//                 weight: FontWeight.w600,
//               ),
//               Icon(icon, color: color, size: 22),
//             ],
//           ),
//           const SizedBox(height: 8),
//           AppText.customText(
//             "₹${amount.toStringAsFixed(0)}",
//             size: 20,
//             weight: FontWeight.bold,
//             color: color,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard(int index, Map<String, dynamic> fee) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         final delay = index * 0.08;
//         final animationValue = Curves.easeOut.transform(
//           (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
//         );
//
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - animationValue)),
//           child: Opacity(
//             opacity: animationValue,
//             child: child,
//           ),
//         );
//       },
//       child: _feeCard(
//         className: fee["class"],
//         amount: fee["amount"],
//         status: fee["status"],
//         dueDate: fee["dueDate"],
//         color: fee["color"],
//       ),
//     );
//   }
//
//   Widget _feeCard({
//     required String className,
//     required int amount,
//     required String status,
//     required String dueDate,
//     required Color color,
//   }) {
//     final statusColor = _getStatusColor(status);
//     final statusIcon = _getStatusIcon(status);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(
//           color: statusColor.withOpacity(0.2),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: statusColor.withOpacity(0.15),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//             spreadRadius: 1,
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(22),
//           onTap: () {
//             // Navigate to fee details
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Gradient icon bubble
//                 Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         color,
//                         color.withOpacity(0.7),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.35),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.payments_rounded,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(
//                         className,
//                         size: 17,
//                         weight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.currency_rupee_rounded,
//                             size: 16,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(width: 4),
//                           AppText.customText(
//                             amount.toStringAsFixed(0),
//                             size: 16,
//                             weight: FontWeight.bold,
//                             color: color,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today_rounded,
//                             size: 12,
//                             color: Colors.grey[500],
//                           ),
//                           const SizedBox(width: 2),
//                           AppText.customText(
//                             "Due: $dueDate",
//                             size: 11,
//                             color: Colors.grey[600]!,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Modern status pill with icon
//                 Container(
//                   padding:  EdgeInsets.symmetric(
//                     horizontal: screenWidth*0.03,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         statusColor,
//                         statusColor.withOpacity(0.8),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: statusColor.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         statusIcon,
//                         size: 16,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(width: 6),
//                       AppText.customText(
//                         status,
//                         size: 12,
//                         weight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }