import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/accountant_management/accountant_management_dash_board_screen.dart';
import 'package:school_pro/admin_management/school_management_dashboard_screen.dart';
import 'package:school_pro/splash_screen.dart';
import 'package:school_pro/student_management/student_dash_board_screen.dart';
import 'package:school_pro/teacher_management/teacher_management_dashboard_screen.dart';
import 'package:school_pro/view_model/user_view_model.dart';
import '../../repo/auth_repo/auth_repo.dart';
import '../../utils/permission_manager.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../school_view_model/user_permission_view_model.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ==============================
  // 🔹 DEVICE INFO
  // ==============================
  Future<Map<String, String>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = "unknown_device";
    String deviceName = "unknown_device";

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? "unknown_id";
        deviceName = "${androidInfo.manufacturer} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "unknown_id";
        deviceName = "${iosInfo.name} (${iosInfo.model})";
      }
    } catch (e) {
      debugPrint("Device info error: $e");
    }

    return {"device_id": deviceId, "device_name": deviceName};
  }

  // FCM TOKEN

  Future<String?> getFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      print("🔥 FCM Token: $token");
      return token;
    } catch (e) {
      print("❌ FCM Error: $e");
      return null;
    }
  }


  // LOGIN API — FIXED

  Future<void> loginApi(
      BuildContext context,
      String email,
      String password,
      ) async {
    PermissionManager.clear();
    setLoading(true);

    try {
      final results = await Future.wait([getFcmToken(), getDeviceInfo()]);

      final fcmToken = results[0] as String?;

      final data = {
        "user_email": email,
        "password": password,
        "device_token": fcmToken ?? "",
        "device_type": Platform.isIOS ? "ios" : "android",
      };

      final response = await _repo.loginApi(data);
      print("LOGIN RESPONSE => $response");

      if (response['status_code'] == 200) {
        final user = response['data']['user'];
        final role = user['role'];
        final token = response['data']['token'];
        final schoolId = user['school_id'];
        final classId = user['class_id'];
        final sectionId = user['section_id'];
        final userId = user['user_id'];
        final permissions =
        List<String>.from(
          user['permissions'] ?? [],
        );

        print("================================");
        print("LOGIN ROLE => $role");
        print("LOGIN USER ID => $userId");
        print("LOGIN PERMISSIONS => $permissions");
        print("================================");

        PermissionManager.setRole(role);

        PermissionManager.setPermissions(
          permissions,
        );
        print(
            "LOGIN PERMISSIONS (temp snapshot) => ${PermissionManager.permissions}"
        );

        await Future.wait([
          UserViewModel().saveUser(userId),
          UserViewModel().saveRole(role),
          UserViewModel().saveToken(token),
          UserViewModel().saveSchoolId(schoolId),
          UserViewModel().saveClassId(classId),
          UserViewModel().saveSectionId(sectionId),
          _subscribeToTopics(
            schoolId,
            role,
            classId: classId,
            sectionId: sectionId,
          ),
        ]);

        // if (role == "school_admin") {
        //
        //   await Provider.of<GetUserPermissionViewModel>(
        //     context,
        //     listen: false,
        //   ).getUserPermissionApi(
        //     context: context,
        //     userId: int.tryParse(userId.toString()) ?? 0,
        //     role: role,
        //     isCurrentUser: true,
        //   );
        // }

        print("================================");
        print("BEFORE USER API");
        print(PermissionManager.permissions);
        print("================================");
        print("AFTER USER API");
        print(PermissionManager.permissions);
        print("LOGIN ROLE => $role");
        print("LOGIN PERMISSIONS => $permissions");

        Utils.show(response['message'], context);

        // ✅ Navigation se pehle loader band mat karo
        _navigateFromRole(context, role);

        // ✅ Ab band karo (jab sab kaam ho gaya)
        setLoading(false);
      } else {
        setLoading(false);
        Utils.show(response['message'], context);
      }
    } catch (e, s) {
      setLoading(false);
      print("LOGIN ERROR => $e");
      print(s);
      Utils.show("Login failed", context);
    }
  }
  Future<void> logoutApi(BuildContext context) async {

    setLoading(true);

    try {
      await _repo.logoutApi({
        "device_type": "android",
      });
    } catch (e) {
      print("LOGOUT API ERROR => $e");
    }

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}

    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
        "school_role",
      );
    } catch (_) {}

    await UserViewModel().clearUser();

    PermissionManager.clear();

    setLoading(false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.loginScreen,
          (route) => false,
    );
  }

  // ==============================
  // 🔹 SUBSCRIBE — FIXED (parallel)
  // ==============================
  Future<void> _subscribeToTopics(
      dynamic schoolId,
      String role, {
        dynamic classId,
        dynamic sectionId,
      }) async {
    final messaging = FirebaseMessaging.instance;

    // ✅ Sab topics parallel subscribe
    final List<Future> tasks = [
      messaging.subscribeToTopic("school_$schoolId"),
      messaging.subscribeToTopic("school_${schoolId}_role_$role"),
    ];

    if (role == "student") {
      if (classId != null) {
        tasks.add(
          messaging.subscribeToTopic("school_${schoolId}_class_$classId"),
        );
      }
      if (classId != null && sectionId != null) {
        tasks.add(
          messaging.subscribeToTopic(
            "school_${schoolId}_class_${classId}_section_$sectionId",
          ),
        );
      }
    }

    await Future.wait(tasks, eagerError: false);
    print("✅ Topics Subscribed");
  }

  Future<void> _unsubscribeFromTopics(
      dynamic schoolId,
      String role, {
        dynamic classId,
        dynamic sectionId,
      }) async {
    final messaging = FirebaseMessaging.instance;

    //  Sab topics parallel unsubscribe
    final List<Future> tasks = [
      messaging.unsubscribeFromTopic("school_$schoolId"),
      messaging.unsubscribeFromTopic("school_${schoolId}_role_$role"),
    ];

    if (role == "student") {
      if (classId != null) {
        tasks.add(
          messaging.unsubscribeFromTopic("school_${schoolId}_class_$classId"),
        );
      }
      if (classId != null && sectionId != null) {
        tasks.add(
          messaging.unsubscribeFromTopic(
            "school_${schoolId}_class_${classId}_section_$sectionId",
          ),
        );
      }
    }

    await Future.wait(tasks, eagerError: false);
    print("✅ Topics Unsubscribed");
  }


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