// import 'package:flutter/material.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// class StudentFeesScreen extends StatefulWidget {
//   const StudentFeesScreen({super.key});
//
//   @override
//   State<StudentFeesScreen> createState() => _StudentFeesScreenState();
// }
//
// class _StudentFeesScreenState extends State<StudentFeesScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late TabController _tabController;
//
//   // Fee Structure Data
//   final List<Map<String, dynamic>> feeStructure = [
//     {
//       "category": "Tuition Fee",
//       "amount": 50000,
//       "dueDate": "15 Jan 2024",
//       "status": "Paid",
//       "paymentDate": "10 Jan 2024",
//       "color": Color(0xFF6C5CE7),
//       "icon": Icons.school_rounded,
//     },
//     {
//       "category": "Laboratory Fee",
//       "amount": 15000,
//       "dueDate": "15 Jan 2024",
//       "status": "Paid",
//       "paymentDate": "10 Jan 2024",
//       "color": Color(0xFF00B894),
//       "icon": Icons.science_rounded,
//     },
//     {
//       "category": "Library Fee",
//       "amount": 10000,
//       "dueDate": "15 Jan 2024",
//       "status": "Paid",
//       "paymentDate": "10 Jan 2024",
//       "color": Color(0xFFFF6B6B),
//       "icon": Icons.menu_book_rounded,
//     },
//     {
//       "category": "Sports Fee",
//       "amount": 10000,
//       "dueDate": "15 Jan 2024",
//       "status": "Paid",
//       "paymentDate": "10 Jan 2024",
//       "color": Color(0xFFFFA502),
//       "icon": Icons.sports_cricket_rounded,
//     },
//     {
//       "category": "Transport Fee",
//       "amount": 12000,
//       "dueDate": "20 Feb 2024",
//       "status": "Pending",
//       "paymentDate": "-",
//       "color": Color(0xFF0984E3),
//       "icon": Icons.directions_bus_rounded,
//     },
//   ];
//
//   // Payment History
//   final List<Map<String, dynamic>> paymentHistory = [
//     {
//       "transactionId": "TXN123456789",
//       "date": "10 Jan 2024",
//       "amount": 85000,
//       "method": "Online Banking",
//       "status": "Success",
//       "category": "Term 1 Fees",
//       "color": Color(0xFF00B894),
//     },
//     {
//       "transactionId": "TXN123456788",
//       "date": "15 Aug 2023",
//       "amount": 85000,
//       "method": "Credit Card",
//       "status": "Success",
//       "category": "Annual Fees 2023",
//       "color": Color(0xFF6C5CE7),
//     },
//     {
//       "transactionId": "TXN123456787",
//       "date": "20 Jul 2023",
//       "amount": 12000,
//       "method": "UPI",
//       "status": "Success",
//       "category": "Transport Fee",
//       "color": Color(0xFF0984E3),
//     },
//   ];
//
//   // Upcoming Dues
//   final List<Map<String, dynamic>> upcomingDues = [
//     {
//       "category": "Transport Fee",
//       "amount": 12000,
//       "dueDate": "20 Feb 2024",
//       "daysLeft": 16,
//       "color": Color(0xFF0984E3),
//       "icon": Icons.directions_bus_rounded,
//     },
//     {
//       "category": "Exam Fee",
//       "amount": 5000,
//       "dueDate": "01 Mar 2024",
//       "daysLeft": 25,
//       "color": Color(0xFFFF6B6B),
//       "icon": Icons.assignment_rounded,
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
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   int get totalFees =>
//       feeStructure.fold<int>(0, (sum, fee) => sum + (fee['amount'] as int));
//
//   int get paidAmount => feeStructure
//       .where((fee) => fee['status'] == 'Paid')
//       .fold<int>(0, (sum, fee) => sum + (fee['amount'] as int));
//
//   int get pendingAmount => feeStructure
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
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//             decoration: BoxDecoration(
//               gradient: AppColor.primaryGradient,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
//               boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: AppText.customText("Fee Management", size: 19, weight: FontWeight.bold, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 // Header Section
//                 // Padding(
//                 //   padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//                 //   child: Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       Row(
//                 //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //         children: [
//                 //           Column(
//                 //             crossAxisAlignment: CrossAxisAlignment.start,
//                 //             children: [
//                 //               AppText.customText(
//                 //                 "Fee Management",
//                 //                 size: 26,
//                 //                 weight: FontWeight.bold,
//                 //                 color: Colors.black87,
//                 //               ),
//                 //               const SizedBox(height: 4),
//                 //               AppText.customText(
//                 //                 "Academic Year 2023-24",
//                 //                 size: 13,
//                 //                 color: Colors.grey[600]!,
//                 //               ),
//                 //             ],
//                 //           ),
//                 //           Container(
//                 //             padding: const EdgeInsets.all(12),
//                 //             decoration: BoxDecoration(
//                 //               gradient: LinearGradient(
//                 //                 colors: [
//                 //                   AppColor.lightBlueColor,
//                 //                   AppColor.lightBlueColor.withOpacity(0.8),
//                 //                 ],
//                 //               ),
//                 //               borderRadius: BorderRadius.circular(14),
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: AppColor.lightBlueColor.withOpacity(0.3),
//                 //                   blurRadius: 12,
//                 //                   offset: const Offset(0, 6),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //             child: const Icon(
//                 //               Icons.download_rounded,
//                 //               color: Colors.white,
//                 //               size: 24,
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//
//
//                 // Total Fee Summary Card
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColor.lightBlueColor,
//                           AppColor.lightBlueColor.withOpacity(0.8),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColor.lightBlueColor.withOpacity(0.3),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             AppText.customText(
//                               "Total Fee Amount",
//                               size: 14,
//                               color: Colors.white.withOpacity(0.9),
//                               weight: FontWeight.w600,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.verified_rounded,
//                                     color: Colors.white,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   AppText.customText(
//                                     "Verified",
//                                     size: 11,
//                                     color: Colors.white,
//                                     weight: FontWeight.bold,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         AppText.customText(
//                           "₹${totalFees.toStringAsFixed(0)}",
//                           size: 36,
//                           weight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 4),
//                         AppText.customText(
//                           "All categories included",
//                           size: 12,
//                           color: Colors.white.withOpacity(0.85),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 // Paid and Pending Row
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildSummaryCard(
//                           title: "Paid",
//                           amount: paidAmount,
//                           icon: Icons.check_circle_rounded,
//                           color: const Color(0xFF00B894),
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: _buildSummaryCard(
//                           title: "Pending",
//                           amount: pendingAmount,
//                           icon: Icons.pending_rounded,
//                           color: const Color(0xFFFFA502),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Tab Bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 15,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelColor: AppColor.lightBlueColor,
//                       unselectedLabelColor: Colors.grey[600],
//                       indicatorColor: AppColor.lightBlueColor,
//                       indicatorWeight: 3,
//                       labelStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                       tabs: const [
//                         Tab(text: 'Structure'),
//                         Tab(text: 'History'),
//                         Tab(text: 'Upcoming'),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Tab Content
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       _buildFeeStructureTab(),
//                       _buildPaymentHistoryTab(),
//                       _buildUpcomingDuesTab(),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
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
//   // Fee Structure Tab
//   Widget _buildFeeStructureTab() {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppText.customText(
//               "Fee Breakdown",
//               size: 18,
//               weight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: AppText.customText(
//                 "${feeStructure.length} Categories",
//                 size: 12,
//                 color: Colors.grey[700]!,
//                 weight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...List.generate(
//           feeStructure.length,
//               (index) => _buildAnimatedCard(
//             index,
//             _buildFeeCard(feeStructure[index]),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeeCard(Map<String, dynamic> fee) {
//     Color color = fee['color'];
//     String status = fee['status'];
//     Color statusColor = _getStatusColor(status);
//     IconData statusIcon = _getStatusIcon(status);
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
//             if (status == "Pending") {
//               _showPaymentDialog(fee);
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 // Icon Container
//                 Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [color, color.withOpacity(0.7)],
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
//                   child: Icon(
//                     fee['icon'],
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Fee Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(
//                         fee['category'],
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
//                           // const SizedBox(width: 4),
//                           AppText.customText(
//                             fee['amount'].toString(),
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
//                           // const SizedBox(width: 4),
//                           AppText.customText(
//                             "Due: ${fee['dueDate']}",
//                             size: 11,
//                             color: Colors.grey[600]!,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Status Badge
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: screenWidth * 0.03,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [statusColor, statusColor.withOpacity(0.8)],
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
//                       Icon(statusIcon, size: 16, color: Colors.white),
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
//
//   // Payment History Tab
//   Widget _buildPaymentHistoryTab() {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppText.customText(
//               "Payment History",
//               size: 18,
//               weight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: AppText.customText(
//                 "${paymentHistory.length} Transactions",
//                 size: 12,
//                 color: Colors.grey[700]!,
//                 weight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...List.generate(
//           paymentHistory.length,
//               (index) => _buildAnimatedCard(
//             index,
//             _buildPaymentHistoryCard(paymentHistory[index]),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPaymentHistoryCard(Map<String, dynamic> payment) {
//     Color color = payment['color'];
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.15),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [color, color.withOpacity(0.7)],
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
//                     Icons.account_balance_wallet_rounded,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText.customText(
//                         payment['category'],
//                         size: 16,
//                         weight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 4),
//                       AppText.customText(
//                         payment['date'],
//                         size: 12,
//                         color: Colors.grey[600]!,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
//                     ),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF00B894).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.check_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Column(
//                 children: [
//                   _buildPaymentInfoRow(
//                     "Amount Paid",
//                     "₹${payment['amount']}",
//                     color,
//                   ),
//                   const SizedBox(height: 8),
//                   _buildPaymentInfoRow(
//                     "Transaction ID",
//                     payment['transactionId'],
//                     Colors.grey[700]!,
//                   ),
//                   const SizedBox(height: 8),
//                   _buildPaymentInfoRow(
//                     "Payment Method",
//                     payment['method'],
//                     Colors.grey[700]!,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentInfoRow(String label, String value, Color valueColor) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppText.customText(
//           label,
//           size: 13,
//           color: Colors.grey[600]!,
//           weight: FontWeight.w600,
//         ),
//         AppText.customText(
//           value,
//           size: 13,
//           color: valueColor,
//           weight: FontWeight.bold,
//         ),
//       ],
//     );
//   }
//
//   // Upcoming Dues Tab
//   Widget _buildUpcomingDuesTab() {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppText.customText(
//               "Upcoming Payments",
//               size: 18,
//               weight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: AppText.customText(
//                 "${upcomingDues.length} Pending",
//                 size: 12,
//                 color: Colors.grey[700]!,
//                 weight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (upcomingDues.isEmpty)
//           Center(
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 Icon(
//                   Icons.check_circle_outline_rounded,
//                   size: 80,
//                   color: Colors.green[300],
//                 ),
//                 const SizedBox(height: 16),
//                 AppText.customText(
//                   "All Fees Paid!",
//                   size: 18,
//                   weight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//                 const SizedBox(height: 8),
//                 AppText.customText(
//                   "You have no pending payments",
//                   size: 14,
//                   color: Colors.grey[600]!,
//                 ),
//               ],
//             ),
//           )
//         else
//           ...List.generate(
//             upcomingDues.length,
//                 (index) => _buildAnimatedCard(
//               index,
//               _buildUpcomingDueCard(upcomingDues[index]),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildUpcomingDueCard(Map<String, dynamic> due) {
//     Color color = due['color'];
//     int daysLeft = due['daysLeft'];
//     Color urgencyColor = daysLeft <= 7
//         ? Colors.red
//         : daysLeft <= 14
//         ? Colors.orange
//         : Colors.green;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(
//           color: urgencyColor.withOpacity(0.2),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: urgencyColor.withOpacity(0.15),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(22),
//           onTap: () {
//             _showPaymentDialog(due);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(18),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [color, color.withOpacity(0.7)],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: color.withOpacity(0.35),
//                             blurRadius: 12,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         due['icon'],
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText.customText(
//                             due['category'],
//                             size: 17,
//                             weight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           const SizedBox(height: 6),
//                           AppText.customText(
//                             "Due: ${due['dueDate']}",
//                             size: 12,
//                             color: Colors.grey[600]!,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.03,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [urgencyColor, urgencyColor.withOpacity(0.8)],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: urgencyColor.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.access_time_rounded,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(width: 4),
//                           AppText.customText(
//                             "$daysLeft days",
//                             size: 12,
//                             weight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText.customText(
//                             "Amount Due",
//                             size: 12,
//                             color: Colors.grey[700]!,
//                           ),
//                           const SizedBox(height: 4),
//                           AppText.customText(
//                             "₹${due['amount']}",
//                             size: 24,
//                             weight: FontWeight.bold,
//                             color: color,
//                           ),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _showPaymentDialog(due);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: color,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Row(
//                           children: [
//                             AppText.customText(
//                               "Pay Now",
//                               size: 14,
//                               weight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(width: 6),
//                             const Icon(
//                               Icons.arrow_forward_rounded,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                           ],
//                         ),
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
//
//   Widget _buildAnimatedCard(int index, Widget child) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, _) {
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
//     );
//   }
//
//   void _showPaymentDialog(Map<String, dynamic> fee) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [fee['color'], fee['color'].withOpacity(0.7)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 Icons.payment_rounded,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: AppText.customText(
//                 "Payment Options",
//                 size: 18,
//                 weight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AppText.customText(
//               fee['category'],
//               size: 16,
//               weight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             const SizedBox(height: 8),
//             AppText.customText(
//               "Amount: ₹${fee['amount']}",
//               size: 20,
//               weight: FontWeight.bold,
//               color: fee['color'],
//             ),
//             const SizedBox(height: 20),
//             _buildPaymentOptionButton(
//               "UPI Payment",
//               Icons.account_balance_rounded,
//               const Color(0xFF6C5CE7),
//             ),
//             const SizedBox(height: 12),
//             _buildPaymentOptionButton(
//               "Credit/Debit Card",
//               Icons.credit_card_rounded,
//               const Color(0xFF00B894),
//             ),
//             const SizedBox(height: 12),
//             _buildPaymentOptionButton(
//               "Net Banking",
//               Icons.account_balance_wallet_rounded,
//               const Color(0xFF0984E3),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: AppText.customText(
//               "Cancel",
//               size: 14,
//               color: Colors.grey[600]!,
//               weight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentOptionButton(String title, IconData icon, Color color) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(14),
//           onTap: () {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Processing payment via $title...'),
//                 backgroundColor: color,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 12),
//                 AppText.customText(
//                   title,
//                   size: 15,
//                   weight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// ============================================================
// lib/features/fees/view/student_fees_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';

import '../model/student_model/student_fee_model.dart';
import '../view_model/student_view_model/student_fee_view_model.dart';
import '../view_model/auth_view_model/user_view_model.dart';


class StudentFeesScreen extends StatefulWidget {
  final String yearName;

  const StudentFeesScreen({
    super.key,
    required this.yearName,
  });

  @override
  State<StudentFeesScreen> createState() => _StudentFeesScreenState();
}

class _StudentFeesScreenState extends State<StudentFeesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;


  @override

  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await context.read<StudentFeesViewModel>().fetchFees(
        academicYear: widget.yearName,
      );
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'partial':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle_rounded;
      case 'partial':
        return Icons.timelapse_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'overdue':
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.glassWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText('Fee Management',
                      size: 19, weight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Consumer<StudentFeesViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.hasError) {
                  return _buildErrorState(vm);
                }

                if (!vm.hasData) {
                  return const SizedBox.shrink();
                }

                // Start entry animation once data arrives
                _animationController.forward(from: 0);

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildTotalFeeCard(vm),
                    const SizedBox(height: 14),
                    _buildPaidPendingRow(vm),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // _buildFeeStructureTab(vm),
                          _buildPaymentHistoryTab(vm),
                          _buildUpcomingDuesTab(vm),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Error State ────────────────────────────────────────────────────────

  Widget _buildErrorState(StudentFeesViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            AppText.customText('Something went wrong',
                size: 18, weight: FontWeight.bold, color: Colors.black87),
            const SizedBox(height: 8),
            AppText.customText(vm.errorMessage,
                size: 13, color: Colors.grey[600]!),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => vm.fetchFees(
                  academicYear: widget.yearName,),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlueColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Summary Cards ──────────────────────────────────────────────────────

  Widget _buildTotalFeeCard(StudentFeesViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.lightBlueColor,
              AppColor.lightBlueColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.lightBlueColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.customText('Total Fee Amount',
                    size: 14,
                    color: Colors.white.withOpacity(0.9),
                    weight: FontWeight.w600),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      AppText.customText('Verified',
                          size: 11,
                          color: Colors.white,
                          weight: FontWeight.bold),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppText.customText(
              '₹${vm.totalAmount.toStringAsFixed(0)}',
              size: 36,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            AppText.customText(
              'Academic Year: ${vm.academicYear}',
              size: 12,
              color: Colors.white.withOpacity(0.85),
            ),
            if (vm.fineAmount > 0) ...[
              const SizedBox(height: 4),
              AppText.customText(
                'Fine: ₹${vm.fineAmount.toStringAsFixed(0)}',
                size: 12,
                color: Colors.orange[200]!,
                weight: FontWeight.w600,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaidPendingRow(StudentFeesViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Paid',
              amount: vm.paidAmount,
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF00B894),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSummaryCard(
              title: 'Pending',
              amount: vm.grandTotalPending,
              icon: Icons.pending_rounded,
              color: const Color(0xFFFFA502),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.customText(title,
                  size: 13,
                  color: Colors.grey[700]!,
                  weight: FontWeight.w600),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 8),
          AppText.customText('₹${amount.toStringAsFixed(0)}',
              size: 20, weight: FontWeight.bold, color: color),
        ],
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: AppColor.lightBlueColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppColor.lightBlueColor,
          indicatorWeight: 3,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            // Tab(text: 'Structure'),
            Tab(text: 'History'),
            Tab(text: 'Upcoming'),
          ],
        ),
      ),
    );
  }

  // ── Fee Structure Tab ──────────────────────────────────────────────────

  // Widget _buildFeeStructureTab(StudentFeesViewModel vm) {
  //   final allFees = [
  //     ...vm.feeBreakdown.map((f) => _feeBreakdownToMap(f)),
  //     ...vm.transportFeeBreakdown.map((t) => _transportToMap(t)),
  //   ];
  //
  //   return ListView(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           AppText.customText('Fee Breakdown',
  //               size: 18, weight: FontWeight.bold, color: Colors.black87),
  //           _countBadge('${allFees.length} Categories'),
  //         ],
  //       ),
  //       const SizedBox(height: 12),
  //       ...List.generate(
  //         allFees.length,
  //             (i) => _buildAnimatedCard(i, _buildFeeCard(allFees[i])),
  //       ),
  //     ],
  //   );
  // }

  Map<String, dynamic> _feeBreakdownToMap(FeeBreakdown f) => {
    'category': f.feeHeadName,
    'amount': f.totalAmount,
    'paidAmount': f.paidAmount,
    'pendingAmount': f.pendingAmount,
    'frequency': f.feeFrequency,
    'status': f.status,
    'fineAmount': f.fineAmount,
    'color': const Color(0xFF6C5CE7),
    'icon': Icons.school_rounded,
  };

  Map<String, dynamic> _transportToMap(TransportFeeBreakdown t) => {
    'category': 'Transport – ${t.routeName} (${t.stopName})',
    'amount': t.totalAmount,
    'paidAmount': t.paidAmount,
    'pendingAmount': t.pendingAmount,
    'frequency': t.feeFrequency,
    'status': t.status,
    'fineAmount': t.fineAmount,
    'color': const Color(0xFF0984E3),
    'icon': Icons.directions_bus_rounded,
  };

  Widget _buildFeeCard(Map<String, dynamic> fee) {
    final Color color = fee['color'];
    final String status = fee['status'];
    final Color statusColor = _getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
              color: statusColor.withOpacity(0.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Icon(fee['icon'], color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(fee['category'],
                      size: 16, weight: FontWeight.bold, color: Colors.black87),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee_rounded,
                          size: 14, color: Colors.grey),
                      AppText.customText(
                          '${fee['amount'].toStringAsFixed(0)} total',
                          size: 14,
                          weight: FontWeight.bold,
                          color: color),
                    ],
                  ),
                  const SizedBox(height: 2),
                  AppText.customText(
                    'Paid: ₹${fee['paidAmount'].toStringAsFixed(0)}  |  Pending: ₹${fee['pendingAmount'].toStringAsFixed(0)}',
                    size: 11,
                    color: Colors.grey[600]!,
                  ),
                  if ((fee['fineAmount'] as double) > 0)
                    AppText.customText(
                      'Fine: ₹${fee['fineAmount'].toStringAsFixed(0)}',
                      size: 11,
                      color: Colors.red[400]!,
                      weight: FontWeight.w600,
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [statusColor, statusColor.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  AppText.customText(status,
                      size: 12, weight: FontWeight.bold, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Payment History Tab ────────────────────────────────────────────────

  Widget _buildPaymentHistoryTab(StudentFeesViewModel vm) {
    final history = vm.paymentHistory;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.customText('Payment History',
                size: 18, weight: FontWeight.bold, color: Colors.black87),
            _countBadge('${history.length} Transactions'),
          ],
        ),
        const SizedBox(height: 12),
        if (history.isEmpty)
          _buildEmptyState(
              'No payment records found', Icons.receipt_long_rounded)
        else
          ...List.generate(
            history.length,
                (i) => _buildAnimatedCard(i, _buildPaymentHistoryCard(history[i])),
          ),
      ],
    );
  }

  Widget _buildPaymentHistoryCard(PaymentHistory payment) {
    final Color color = const Color(0xFF00B894);
    final DateTime paidDate =
        DateTime.tryParse(payment.paidOn) ?? DateTime.now();
    final String formattedDate =
        '${paidDate.day} ${_monthName(paidDate.month)} ${paidDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(payment.feeHeadName,
                          size: 16,
                          weight: FontWeight.bold,
                          color: Colors.black87),
                      const SizedBox(height: 4),
                      AppText.customText(formattedDate,
                          size: 12, color: Colors.grey[600]!),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF00B894), Color(0xFF55EFC4)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Amount Paid',
                      '₹${payment.amount.toStringAsFixed(0)}', color),
                  if (payment.fineAmount > 0) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('Fine Paid',
                        '₹${payment.fineAmount.toStringAsFixed(0)}',
                        Colors.red[400]!),
                  ],
                  const SizedBox(height: 8),
                  _buildInfoRow('Payment Mode',
                      payment.paymentMode.toUpperCase(), Colors.grey[700]!),
                  if (payment.transactionRef != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        'Txn Ref', payment.transactionRef!, Colors.grey[700]!),
                  ],
                  const SizedBox(height: 8),
                  _buildInfoRow('Academic Year', payment.academicYear,
                      Colors.grey[700]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.customText(label,
            size: 13, color: Colors.grey[600]!, weight: FontWeight.w600),
        AppText.customText(value,
            size: 13, color: valueColor, weight: FontWeight.bold),
      ],
    );
  }

  // ── Upcoming Dues Tab ──────────────────────────────────────────────────

  Widget _buildUpcomingDuesTab(StudentFeesViewModel vm) {
    final pendingInstallments = vm.pendingInstallments;
    final pendingTransport = vm.pendingTransportInstallments;
    final bool nothingPending =
        pendingInstallments.isEmpty && pendingTransport.isEmpty;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.customText('Upcoming Payments',
                size: 18, weight: FontWeight.bold, color: Colors.black87),
            _countBadge(
                '${pendingInstallments.length + pendingTransport.length} Pending'),
          ],
        ),
        const SizedBox(height: 12),
        if (nothingPending)
          _buildEmptyState('All Fees Paid!', Icons.check_circle_outline_rounded,
              color: Colors.green)
        else ...[
          // Regular fee pending installments
          ...List.generate(
            pendingInstallments.length,
                (i) => _buildAnimatedCard(
                i, _buildInstallmentCard(pendingInstallments[i], vm)),
          ),
          // Transport pending installments
          ...List.generate(
            pendingTransport.length,
                (i) => _buildAnimatedCard(
                pendingInstallments.length + i,
                _buildTransportInstallmentCard(pendingTransport[i], vm)),
          ),
        ],
      ],
    );
  }

  Widget _buildInstallmentCard(
      FeeInstallment installment, StudentFeesViewModel vm) {
    final Color color = installment.calculatedStatus == 'overdue'
        ? Colors.red
        : Colors.orange;

    final DateTime? dueDate = installment.endDueDate != null
        ? DateTime.tryParse(installment.endDueDate!)
        : null;

    final String dueDateStr = dueDate != null
        ? '${dueDate.day} ${_monthName(dueDate.month)} ${dueDate.year}'
        : 'N/A';

    return _buildDueCard(
      title: 'Tuition Fee – Installment #${installment.installmentNo}',
      amount: installment.totalAmount,
      dueDate: dueDateStr,
      status: installment.calculatedStatus,
      color: color,
      icon: Icons.school_rounded,
      fineAmount: installment.fineAmount,
    );
  }

  Widget _buildTransportInstallmentCard(
      TransportInstallment installment, StudentFeesViewModel vm) {
    final Color color = installment.calculatedStatus == 'overdue'
        ? Colors.red
        : Colors.orange;

    final DateTime? dueDate = installment.dueDate != null
        ? DateTime.tryParse(installment.dueDate!)
        : null;

    final String dueDateStr = dueDate != null
        ? '${dueDate.day} ${_monthName(dueDate.month)} ${dueDate.year}'
        : 'N/A';

    return _buildDueCard(
      title: 'Transport Fee – Installment #${installment.installmentNo}',
      amount: installment.totalAmount,
      dueDate: dueDateStr,
      status: installment.calculatedStatus,
      color: color,
      icon: Icons.directions_bus_rounded,
      fineAmount: installment.fineAmount,
    );
  }

  Widget _buildDueCard({
    required String title,
    required double amount,
    required String dueDate,
    required String status,
    required Color color,
    required IconData icon,
    required double fineAmount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(title,
                          size: 15,
                          weight: FontWeight.bold,
                          color: Colors.black87),
                      const SizedBox(height: 6),
                      AppText.customText('Due: $dueDate',
                          size: 12, color: Colors.grey[600]!),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.8)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: AppText.customText(
                    status == 'overdue' ? 'Overdue' : 'Pending',
                    size: 12,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color.withOpacity(0.1), color.withOpacity(0.05)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText('Amount Due',
                          size: 12, color: Colors.grey[700]!),
                      const SizedBox(height: 4),
                      AppText.customText('₹${amount.toStringAsFixed(0)}',
                          size: 24, weight: FontWeight.bold, color: color),
                      if (fineAmount > 0)
                        AppText.customText(
                          'Incl. ₹${fineAmount.toStringAsFixed(0)} fine',
                          size: 11,
                          color: Colors.red[400]!,
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showPaymentDialog(
                        title: title, amount: amount, color: color),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        AppText.customText('Pay Now',
                            size: 14,
                            weight: FontWeight.bold,
                            color: Colors.white),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 18, color: Colors.white),
                      ],
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

  // ── Animated Card wrapper ──────────────────────────────────────────────

  Widget _buildAnimatedCard(int index, Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final delay = index * 0.08;
        final value = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) /
              (1.0 - delay),
        );
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  // ── Payment Dialog ─────────────────────────────────────────────────────

  void _showPaymentDialog({
    required String title,
    required double amount,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.payment_rounded,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: AppText.customText('Payment Options',
                    size: 18, weight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.customText(title,
                size: 15, weight: FontWeight.bold, color: Colors.black87),
            const SizedBox(height: 8),
            AppText.customText('Amount: ₹${amount.toStringAsFixed(0)}',
                size: 20, weight: FontWeight.bold, color: color),
            const SizedBox(height: 20),
            _buildPaymentOptionButton(
                'UPI Payment', Icons.account_balance_rounded,
                const Color(0xFF6C5CE7)),
            const SizedBox(height: 12),
            _buildPaymentOptionButton(
                'Credit/Debit Card', Icons.credit_card_rounded,
                const Color(0xFF00B894)),
            const SizedBox(height: 12),
            _buildPaymentOptionButton(
                'Net Banking', Icons.account_balance_wallet_rounded,
                const Color(0xFF0984E3)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.customText('Cancel',
                size: 14, color: Colors.grey[600]!, weight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionButton(
      String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Processing payment via $title...'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                AppText.customText(title,
                    size: 15,
                    weight: FontWeight.w600,
                    color: Colors.black87),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Shared small widgets ───────────────────────────────────────────────

  Widget _countBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)),
    child: AppText.customText(text,
        size: 12, color: Colors.grey[700]!, weight: FontWeight.w600),
  );

  Widget _buildEmptyState(String message, IconData icon,
      {Color color = Colors.grey}) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(icon, size: 80, color: color.withOpacity(0.6)),
          const SizedBox(height: 16),
          AppText.customText(message,
              size: 18, weight: FontWeight.bold, color: color),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}