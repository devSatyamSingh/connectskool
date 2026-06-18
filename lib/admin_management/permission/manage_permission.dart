import 'package:flutter/material.dart';
import 'package:school_pro/utils/routes/routes_name.dart';

import '../../res/app_color.dart';
import '../../res/const_text.dart';

class ManagePermission extends StatefulWidget {
  const ManagePermission({super.key});

  @override
  State<ManagePermission> createState() => _ManagePermissionState();
}

class _ManagePermissionState extends State<ManagePermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText(
                    "Manage Permissions",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 20),

          // Grid Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _permissionCard(
                    title: "Role Permission",
                    icon: Icons.admin_panel_settings_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.rolePermissionScreen);
                      // Navigate to Role Permission Screen
                    },
                  ),
                  _permissionCard(
                    title: "User Permission",
                    icon: Icons.person_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.userPermissionScreen);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _permissionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 👈 Light background
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // 👈 Soft shadow
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColor.primary, // 👈 Theme color icon
              ),
            ),
            const SizedBox(height: 14),
            AppText.customText(
              title,
              size: 15,
              weight: FontWeight.w600,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}