import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/accountant_management/accountant_management_dash_board_screen.dart';
import 'package:school_pro/admin_management/school_management_dashboard_screen.dart';
import 'package:school_pro/student_management/student_dash_board_screen.dart';
import 'package:school_pro/teacher_management/teacher_management_dashboard_screen.dart';
import 'package:school_pro/view_model/auth_view_model/user_view_model.dart';
import '../../repo/auth_repo/auth_repo.dart';
import '../../utils/permission_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../school_view_model/permission/user_permission_view_model.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ─── Device Info ──────────────────────────────────────────────────────────

  Future<Map<String, String>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = "unknown_device";
    String deviceName = "unknown_device";
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceId = info.id ?? "unknown_id";
        deviceName = "${info.manufacturer} ${info.model}";
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceId = info.identifierForVendor ?? "unknown_id";
        deviceName = "${info.name} (${info.model})";
      }
    } catch (e) {
      debugPrint("Device info error: $e");
    }
    return {"device_id": deviceId, "device_name": deviceName};
  }

  // ─── FCM Token ────────────────────────────────────────────────────────────

  Future<String?> getFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      debugPrint("✅ FCM Token: $token");
      return token;
    } catch (e) {
      debugPrint("❌ FCM Token Error: $e");
      return null;
    }
  }

  // ─── Build Topics List ────────────────────────────────────────────────────
  // SINGLE source of truth — subscribe & unsubscribe always use same list.

  List<String> _buildTopics({
    required dynamic schoolId,
    required String role,
    dynamic userId,
    dynamic classId,
    dynamic sectionId,
  }) {
    final topics = <String>[
      "school_$schoolId",
      "school_${schoolId}_role_$role",
    ];

    if (userId != null && userId.toString().isNotEmpty) {
      topics.add("user_$userId");
    }

    if (role == "student") {
      if (classId != null && classId.toString().isNotEmpty) {
        topics.add("school_${schoolId}_class_$classId");
      }
      if (classId != null &&
          classId.toString().isNotEmpty &&
          sectionId != null &&
          sectionId.toString().isNotEmpty) {
        topics.add("school_${schoolId}_class_${classId}_section_$sectionId");
      }
    }

    return topics;
  }

  // ─── Subscribe ────────────────────────────────────────────────────────────

  Future<void> _subscribeToTopics({
    required dynamic schoolId,
    required String role,
    dynamic userId,
    dynamic classId,
    dynamic sectionId,
  }) async {
    final topics = _buildTopics(
      schoolId: schoolId,
      role: role,
      userId: userId,
      classId: classId,
      sectionId: sectionId,
    );
    final messaging = FirebaseMessaging.instance;
    await Future.wait(
      topics.map((t) => messaging.subscribeToTopic(t)),
      eagerError: false,
    );
    debugPrint("✅ Subscribed: $topics");
  }

  // ─── Unsubscribe ──────────────────────────────────────────────────────────

  Future<void> _unsubscribeFromTopics({
    required dynamic schoolId,
    required String role,
    dynamic userId,
    dynamic classId,
    dynamic sectionId,
  }) async {
    final topics = _buildTopics(
      schoolId: schoolId,
      role: role,
      userId: userId,
      classId: classId,
      sectionId: sectionId,
    );
    final messaging = FirebaseMessaging.instance;
    await Future.wait(
      topics.map((t) => messaging.unsubscribeFromTopic(t)),
      eagerError: false,
    );
    debugPrint("✅ Unsubscribed: $topics");
  }

  // ─── Login API ────────────────────────────────────────────────────────────

  Future<void> loginApi(
    BuildContext context,
    String email,
    String password,
  ) async {
    PermissionManager.clear();
    setLoading(true);

    try {
      final userVM = UserViewModel();
      final fcmToken = await getFcmToken();

      // STEP 1: Unsubscribe stale session from previous login (cross-school fix)
      final oldSession = await userVM.getSubscribedSession();
      final oldSchoolId = oldSession['schoolId'];
      final oldRole = oldSession['role'];

      if (oldSchoolId != null &&
          oldSchoolId.isNotEmpty &&
          oldRole != null &&
          oldRole.isNotEmpty) {
        debugPrint(
          "🧹 Cleaning stale session: school=$oldSchoolId role=$oldRole",
        );
        await _unsubscribeFromTopics(
          schoolId: oldSchoolId,
          role: oldRole,
          userId: oldSession['userId'],
          classId: oldSession['classId'],
          sectionId: oldSession['sectionId'],
        );
        await userVM.clearSubscribedSession();
      }

      // STEP 2: Call login API
      final data = {
        "user_email": email,
        "password": password,
        "device_token": fcmToken ?? "",
        "device_type": Platform.isIOS ? "ios" : "android",
      };

      final response = await _repo.loginApi(data);
      debugPrint("LOGIN RESPONSE => $response");

      if (response['status_code'] == 200) {
        final user = response['data']['user'];
        final role = user['role'] as String;
        final token = response['data']['token'];
        final schoolId = user['school_id'];
        final classId = user['class_id'];
        final sectionId = user['section_id'];
        final userId = user['user_id'];
        final permissions = List<String>.from(user['permissions'] ?? []);

        debugPrint("LOGIN ROLE    => $role");
        debugPrint("LOGIN USER ID => $userId");

        PermissionManager.setRole(role);
        PermissionManager.setPermissions(permissions);

        await Future.wait([
          userVM.saveUser(userId),
          userVM.saveRole(role),
          userVM.saveToken(token),
          userVM.saveSchoolId(schoolId),
          userVM.saveClassId(classId),
          userVM.saveSectionId(sectionId),
          userVM.savePermissions(permissions),
          userVM.markAppInstalled(),
          userVM.saveUserIdAsInt(userId),
        ]);

        await _subscribeToTopics(
          schoolId: schoolId,
          role: role,
          userId: userId,
          classId: classId,
          sectionId: sectionId,
        );

        await userVM.saveSubscribedSession(
          schoolId: schoolId,
          role: role,
          userId: userId,
          classId: classId,
          sectionId: sectionId,
        );

        if (!context.mounted) return;

        await Provider.of<GetUserPermissionViewModel>(
          context,
          listen: false,
        ).getUserPermissionApi(
          context: context,
          userId: int.tryParse(userId.toString()) ?? 0,
          role: role,
          isCurrentUser: true,
        );

        if (!context.mounted) return;

        _navigateFromRole(context, role);
        Utils.show(response['message'], context);
      } else {
        Utils.show(response['message'], context);
      }
    } catch (e, s) {
      debugPrint("LOGIN ERROR => $e\n$s");
      if (context.mounted)
        Utils.show("Login failed. Please try again.", context);
    } finally {
      setLoading(false);
    }
  }

  // ─── Logout API ───────────────────────────────────────────────────────────

  // ─── Logout API ───────────────────────────────────────────────────────────

  Future<void> logoutApi(BuildContext context) async {
    setLoading(true);
    final userVM = UserViewModel();

    // STEP 1: Subscribed session PEHLE padho — clearUser se pehle
    // (clearUser ke baad ye data available nahi rahega)
    final session = await userVM.getSubscribedSession();
    final schoolId = session['schoolId'];
    final role = session['role'];
    final userId = session['userId'];
    final classId = session['classId'];
    final sectionId = session['sectionId'];

    debugPrint(
      "🔍 Logout session => school=$schoolId | role=$role | userId=$userId",
    );

    // STEP 2: FCM Topics se PEHLE unsubscribe karo — kuch bhi delete karne se pehle
    if (schoolId != null &&
        schoolId.isNotEmpty &&
        role != null &&
        role.isNotEmpty) {
      try {
        await _unsubscribeFromTopics(
          schoolId: schoolId,
          role: role,
          userId: userId,
          classId: classId,
          sectionId: sectionId,
        );
        debugPrint("✅ FCM Topics unsubscribed successfully");
      } catch (e) {
        debugPrint("⚠️ Unsubscribe error (non-fatal): $e");
      }
    } else {
      debugPrint("⚠️ No session found — skipping unsubscribe");
    }

    // STEP 3: FCM Token delete karo
    try {
      await FirebaseMessaging.instance.deleteToken();
      debugPrint("✅ FCM Token deleted");
    } catch (e) {
      debugPrint("⚠️ FCM Token delete error (non-fatal): $e");
    }

    // STEP 4: Backend logout API call (best-effort — fail hone pe bhi aage bado)
    try {
      await _repo.logoutApi({
        "device_type": Platform.isIOS ? "ios" : "android",
      });
      debugPrint("✅ Backend logout done");
    } catch (e) {
      debugPrint("⚠️ Logout API error (non-fatal): $e");
    }

    // STEP 5: Subscribed session explicitly clear karo
    try {
      await userVM.clearSubscribedSession();
      debugPrint("✅ Subscribed session cleared");
    } catch (e) {
      debugPrint("⚠️ Clear subscribed session error: $e");
    }

    // STEP 6: Baki sab local data clear karo (install/onboarding flags preserved)
    await userVM.clearUser();
    PermissionManager.clear();

    setLoading(false);

    // STEP 7: Splash screen pe bhejo — pushNamedAndRemoveUntil se
    // Splash screen se session check hoga aur login pe jayega
    // UI bhi properly rebuild ho jayega
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.splash, // ← SPLASH pe bhejo, dashboard nahi
        (route) => false, // ← pura stack clear
      );
    }
  }
  // ─── Role Navigation ──────────────────────────────────────────────────────

  void _navigateFromRole(BuildContext context, String role) {
    switch (role) {
      case "school_admin":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SchoolManagementDashboardScreen()),
        );
        break;
      case "student":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StudentDashboardScreen()),
        );
        break;
      case "teacher":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TeacherManagementDashBoardScreen()),
        );
        break;
      case "accountant":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountantManagementDashBoardScreen(),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Coming Soon")));
    }
  }
}
