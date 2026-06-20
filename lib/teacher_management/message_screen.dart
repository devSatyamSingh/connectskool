// import 'package:flutter/material.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// class MessagesPage extends StatelessWidget {
//   const MessagesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ListView(
//         children: [
//
//           _messageCard("Parent - Rahul", "Regarding fee submission", "2 min ago", true),
//           _messageCard("Student - Aman", "Homework clarification", "10 min ago", false),
//           _messageCard("Admin Office", "Meeting at 3 PM today", "1 hour ago", true),
//           _messageCard("Parent - Neha", "Leave application", "Yesterday", false),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _messageCard(
//       String name,
//       String message,
//       String time,
//       bool unread,
//       ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//
//           BoxShadow(
//             color: AppColor.lightBlueColor.withOpacity(.08),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//
//           BoxShadow(
//             color: Colors.black.withOpacity(.10),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//
//           CircleAvatar(
//             radius: 24,
//             backgroundColor: unread
//                 ? AppColor.lightBlueColor
//                 : AppColor.lightBlueColor.withOpacity(.2),
//             child: const Icon(Icons.message, color: Colors.white),
//           ),
//
//           const SizedBox(width: 14),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText.customText(
//                   name,
//                   size: 16,
//                   weight: unread ? FontWeight.w700 : FontWeight.w600,
//                 ),
//                 const SizedBox(height: 4),
//                 AppText.customText(
//                   message,
//                   size: 13,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//           ),
//
//           Column(
//             children: [
//               AppText.customText(
//                 time,
//                 size: 11,
//                 color: Colors.grey,
//               ),
//
//               const SizedBox(height: 6),
//
//               if (unread)
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(
//                     color: AppColor.lightBlueColor,
//                     shape: BoxShape.circle,
//                   ),
//                 )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> messages = [
    {
      "name": "Parent - Rahul Kumar",
      "message": "Regarding fee submission for this month",
      "time": "2 min ago",
      "unread": true,
      "type": "parent",
      "avatar": "R",
      "color": Color(0xFF6C5CE7),
      "count": 3,
    },
    {
      "name": "Student - Aman Gupta",
      "message": "Need clarification on homework assignment",
      "time": "10 min ago",
      "unread": false,
      "type": "student",
      "avatar": "A",
      "color": Color(0xFF00B894),
      "count": 0,
    },
    {
      "name": "Admin Office",
      "message": "Important meeting scheduled at 3 PM today",
      "time": "1 hour ago",
      "unread": true,
      "type": "admin",
      "avatar": "A",
      "color": Color(0xFFFF6B6B),
      "count": 1,
    },
    {
      "name": "Parent - Neha Sharma",
      "message": "Submitted leave application for tomorrow",
      "time": "Yesterday",
      "unread": false,
      "type": "parent",
      "avatar": "N",
      "color": Color(0xFFFFA502),
      "count": 0,
    },
    {
      "name": "Teacher - Priya Singh",
      "message": "Assignment submission deadline extended",
      "time": "2 days ago",
      "unread": false,
      "type": "teacher",
      "avatar": "P",
      "color": Color(0xFF0984E3),
      "count": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get unreadCount => messages.where((m) => m["unread"] == true).length;

  IconData _getTypeIcon(String type) {
    switch (type) {
      case "parent":
        return Icons.family_restroom_rounded;
      case "student":
        return Icons.school_rounded;
      case "admin":
        return Icons.admin_panel_settings_rounded;
      case "teacher":
        return Icons.person_rounded;
      default:
        return Icons.message_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Header Section
          Container(
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightBlueColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.customText(
                          "Messages",
                          size: 26,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        AppText.customText(
                          "$unreadCount unread messages",
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: AppText.customText(
                                  "$unreadCount",
                                  size: 8,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText.customText(
                          "Search messages...",
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Messages List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.customText(
                  "All Messages",
                  size: 18,
                  weight: FontWeight.bold,
                  color: Colors.black87,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      AppText.customText(
                        "Filter",
                        size: 12,
                        color: Colors.grey[700]!,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              physics: const BouncingScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildAnimatedCard(index, messages[index]);
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(int index, Map<String, dynamic> message) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: child,
          ),
        );
      },
      child: _messageCard(
        name: message["name"],
        message: message["message"],
        time: message["time"],
        unread: message["unread"],
        type: message["type"],
        avatar: message["avatar"],
        color: message["color"],
        count: message["count"],
      ),
    );
  }

  Widget _messageCard({
    required String name,
    required String message,
    required String time,
    required bool unread,
    required String type,
    required String avatar,
    required Color color,
    required int count,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread
              ? AppColor.lightBlueColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: unread ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: unread
                ? AppColor.lightBlueColor.withOpacity(0.15)
                : Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to message details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with gradient and type icon
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AppText.customText(
                          avatar,
                          size: 24,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _getTypeIcon(type),
                          size: 12,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText.customText(
                              name,
                              size: 16,
                              weight: unread ? FontWeight.bold : FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          AppText.customText(
                            time,
                            size: 11,
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: AppText.customText(
                              message,
                              size: 13,
                              color: Colors.grey[600]!,
                              weight: unread ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                          if (count > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.lightBlueColor,
                                    AppColor.lightBlueColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.lightBlueColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: AppText.customText(
                                "$count",
                                size: 10,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Unread indicator
                if (unread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.lightBlueColor,
                          AppColor.lightBlueColor.withOpacity(0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.lightBlueColor.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}