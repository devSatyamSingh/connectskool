// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:school_pro/accountant_management/accountant_management_dash_board_screen.dart';
// import 'package:school_pro/admin_management/school_management_dashboard_screen.dart';
// import 'package:school_pro/splash_screen.dart';
// import 'package:school_pro/student_management/student_dash_board_screen.dart';
// import 'package:school_pro/teacher_management/teacher_management_dashboard_screen.dart';
// import 'package:school_pro/view_model/user_view_model.dart';
// import '../../repo/auth_repo/auth_repo.dart';
// import '../../utils/utils.dart';
//
//
// class LoginViewModel with ChangeNotifier {
//   final AuthRepository _repo = AuthRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   // 🔹 Role → Title
//
//   Future<Map<String, String>> getDeviceInfo() async {
//     final deviceInfo = DeviceInfoPlugin();
//     String deviceId = "unknown_device";
//     String deviceName = "unknown_device";
//
//     try {
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         deviceId = androidInfo.id ?? "unknown_id";
//         deviceName = "${androidInfo.manufacturer} ${androidInfo.model}";
//       } else if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         deviceId = iosInfo.identifierForVendor ?? "unknown_id";
//         deviceName = "${iosInfo.name} (${iosInfo.model})";
//       }
//     } catch (e) {
//       debugPrint("Error fetching device info: $e");
//     }
//
//     return {
//       "device_id": deviceId,
//       "device_name": deviceName,
//     };
//   }
//
//   Future<String?> getFcmToken() async {
//     try {
//       final messaging = FirebaseMessaging.instance;
//       NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       print("🔔 Permission: ${settings.authorizationStatus}");
//       final token = await messaging.getToken();
//       print("🔥 Token in getFcmToken: $token");
//       return token;
//     } catch (e) {
//       print("❌ FCM Error: $e");
//       return null;
//     }
//   }
//   Future<void> logoutApi(BuildContext context) async {
//     setLoading(true);
//
//     try {
//       final userVM = UserViewModel();
//
//       final schoolId = await userVM.getSchoolId();
//       final role = await userVM.getRole();
//       final classId = await userVM.getClassId();
//       final sectionId = await userVM.getSectionId();
//
//       // 🔥 STEP 1: Unsubscribe topics FIRST
//       await _unsubscribeFromTopics(
//         schoolId,
//         role,
//         classId: classId,
//         sectionId: sectionId,
//       );
//
//       // 🔥 STEP 2: Delete FCM Token
//       await _deleteFcmToken();
//
//       final data = {
//         "device_type": "android",
//       };
//
//       if (kDebugMode) {
//         print("💡 Logout Request: $data");
//       }
//
//       final response = await _repo.logoutApi(data);
//
//       if (kDebugMode) {
//         print("💡 Logout Response: $response");
//       }
//
//       setLoading(false);
//
//       final int statusCode = response['status_code'] ?? 0;
//
//       if (statusCode == 200) {
//         print("✅ Logout Success");
//
//         // 🔥 STEP 3: Clear Local Data
//         await userVM.removeUser();
//
//         Utils.show(response['message'], context);
//
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const SplashScreen()),
//               (route) => false,
//         );
//       } else {
//         Utils.show(response['message'] ?? "Logout failed", context);
//       }
//     } catch (e) {
//       setLoading(false);
//       print("❌ Logout Error: $e");
//       Utils.show("Something went wrong", context);
//     }
//   }
//   Future<void> _deleteFcmToken() async {
//     try {
//       await FirebaseMessaging.instance.deleteToken();
//       print("🔥 FCM Token Deleted");
//     } catch (e) {
//       print("❌ Token delete error: $e");
//     }
//   }
//   Future<void> _unsubscribeFromTopics(
//       dynamic schoolId,
//       String role, {
//         dynamic classId,
//         dynamic sectionId,
//       }) async {
//     try {
//       final messaging = FirebaseMessaging.instance;
//
//       // 1️⃣ School
//       await messaging.unsubscribeFromTopic("school_$schoolId");
//
//       // 2️⃣ Role
//       await messaging.unsubscribeFromTopic(
//           "school_${schoolId}_role_$role");
//
//       // 3️⃣ Student specific
//       if (role == "student") {
//         if (classId != null) {
//           await messaging.unsubscribeFromTopic(
//               "school_${schoolId}_class_$classId");
//         }
//
//         if (classId != null && sectionId != null) {
//           await messaging.unsubscribeFromTopic(
//               "school_${schoolId}_class_${classId}_section_$sectionId");
//         }
//       }
//
//       print("✅ All topics unsubscribed");
//     } catch (e) {
//       print("❌ Unsubscribe error: $e");
//     }
//   }
// }
