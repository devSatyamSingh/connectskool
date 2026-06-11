// // // // import 'package:flutter/foundation.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:school_pro/repo/school_repo/create_notification_repo.dart';
// // // // import 'package:school_pro/view_model/school_view_model/fine_rule_view_model.dart';
// // // //
// // // // import '../../utils/utils.dart';
// // // //
// // // // class CreateNotificationViewModel with ChangeNotifier {
// // // //   final _loginRepo = CreateNotificationRepository();
// // // //   bool _loading = false;
// // // //   bool get loading => _loading;
// // // //   setLoading(bool value) {
// // // //     _loading = value;
// // // //     notifyListeners();
// // // //   }
// // // //   Future<bool> createNotificationApi(
// // // //       String title,
// // // //       String description,
// // // //       List<Map<String, dynamic>> targets,
// // // //       BuildContext context,
// // // //       ) async {
// // // //     setLoading(true);
// // // //
// // // //     Map<String, dynamic> data = {
// // // //       "title": title,
// // // //       "description": description,
// // // //       "targets": targets,
// // // //     };
// // // //
// // // //     try {
// // // //       final response = await _loginRepo.createNotificationApi(data);
// // // //
// // // //       setLoading(false);
// // // //
// // // //       final statusCode = response['status_code'];
// // // //       final message = response['message'];
// // // //
// // // //       if (statusCode == 200 || statusCode == 201) {
// // // //         Utils.show(message ?? "Notification created successfully", context);
// // // //
// // // //         Provider.of<FineRuleViewModel>(
// // // //           context,
// // // //           listen: false,
// // // //         ).fineRuleApi(context);
// // // //
// // // //         Navigator.pop(context);
// // // //         return true;
// // // //
// // // //       } else if (statusCode == 400) {
// // // //         Utils.show(message ?? "Invalid data", context);
// // // //         return false;
// // // //
// // // //       } else if (statusCode == 401) {
// // // //         Utils.show(message ?? "Unauthorized user", context);
// // // //         return false;
// // // //
// // // //       } else if (statusCode == 500) {
// // // //         Utils.show("Server error. Try again later", context);
// // // //         return false;
// // // //
// // // //       } else {
// // // //         Utils.show("Something went wrong", context);
// // // //         return false;
// // // //       }
// // // //     } catch (e) {
// // // //       setLoading(false);
// // // //       if (kDebugMode) print("API Error: $e");
// // // //
// // // //       Utils.show("Network error", context);
// // // //       return false;
// // // //     }
// // // //   }
// // // //
// // // // }
// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:school_pro/repo/school_repo/create_notification_repo.dart';
// // // import '../../utils/utils.dart';
// // //
// // // class CreateNotificationViewModel with ChangeNotifier {
// // //   final _loginRepo = CreateNotificationRepository();
// // //   bool _loading = false;
// // //   bool get loading => _loading;
// // //
// // //   setLoading(bool value) {
// // //     _loading = value;
// // //     notifyListeners();
// // //   }
// // //
// // //   Future<bool> createNotificationApi(
// // //       String title,
// // //       String description,
// // //       List<Map<String, dynamic>> targets,
// // //       BuildContext context,
// // //       ) async {
// // //     setLoading(true);
// // //
// // //     Map<String, dynamic> data = {
// // //       "title": title,
// // //       "description": description,
// // //       "targets": targets,
// // //     };
// // //
// // //     if (kDebugMode) print("📤 Notification Request: $data");
// // //
// // //     try {
// // //       final response = await _loginRepo.createNotificationApi(data);
// // //       if (kDebugMode) print("📥 Notification Response: $response");
// // //
// // //       setLoading(false);
// // //
// // //       final statusCode = response['status_code'];
// // //       final message = response['message'];
// // //
// // //       if (statusCode == 200 || statusCode == 201) {
// // //         Utils.show(message ?? "Notification sent successfully", context);
// // //         return true; // ✅ Sirf true return karo — pop ViewModel mein mat karo
// // //
// // //       } else if (statusCode == 400) {
// // //         Utils.show(message ?? "Invalid data", context);
// // //         return false;
// // //
// // //       } else if (statusCode == 401) {
// // //         Utils.show(message ?? "Unauthorized", context);
// // //         return false;
// // //
// // //       } else if (statusCode == 500) {
// // //         Utils.show("Server error. Try again later", context);
// // //         return false;
// // //
// // //       } else {
// // //         Utils.show(message ?? "Something went wrong", context);
// // //         return false;
// // //       }
// // //     } catch (e) {
// // //       setLoading(false);
// // //       if (kDebugMode) print("❌ API Error: $e");
// // //       Utils.show("Network error", context);
// // //       return false;
// // //     }
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import '../../services/get_server_key.dart';
// //
// // class CreateNotificationViewModel with ChangeNotifier {
// //
// //   bool loading = false;
// //
// //   Future<bool> createNotificationApi(
// //       String title,
// //       String description,
// //       List<Map<String, dynamic>> targets,
// //       BuildContext context,
// //       ) async {
// //
// //     loading = true;
// //     notifyListeners();
// //
// //     try {
// //
// //       String token = await GetServerKey().getServerKeyToken();
// //
// //       final response = await http.post(
// //         Uri.parse("https://university.fctesting.shop/api/schooladmin/createNotification"),
// //         headers: {
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $token",
// //         },
// //         body: jsonEncode({
// //           "title": title,
// //           "description": description,
// //           "targets": targets,
// //         }),
// //       );
// //
// //       debugPrint("Create Notification Status: ${response.statusCode}");
// //       debugPrint("Create Notification Body: ${response.body}");
// //
// //       loading = false;
// //       notifyListeners();
// //
// //       if (response.statusCode == 200) {
// //         return true;
// //       } else {
// //         return false;
// //       }
// //
// //     } catch (e) {
// //       loading = false;
// //       notifyListeners();
// //       debugPrint("Create Notification Error: $e");
// //       return false;
// //     }
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../services/get_server_key.dart';
// import '../user_view_model.dart';
//
// class CreateNotificationViewModel with ChangeNotifier {
//
//   bool loading = false;
//   Future<bool> createNotificationApi(
//       String title,
//       String description,
//       List<Map<String, dynamic>> targets,
//       BuildContext context,
//       ) async {
//
//     loading = true;
//     notifyListeners();
//
//     try {
//
//       /// 🔥 USE LOGIN TOKEN (NOT FIREBASE TOKEN)
//       String? token = await UserViewModel().getToken();
//
//       final response = await http.post(
//         Uri.parse("https://university.fctesting.shop/api/schooladmin/createNotification"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "title": title,
//           "description": description,
//           "targets": targets,
//         }),
//       );
//
//       debugPrint("Status: ${response.statusCode}");
//       debugPrint("Body: ${response.body}");
//
//
//
//
//       loading = false;
//       notifyListeners();
//
//       return response.statusCode == 200 || response.statusCode == 201;
//
//     } catch (e) {
//       loading = false;
//       notifyListeners();
//       debugPrint("Error: $e");
//       return false;
//     }
//   }
//   // Future<bool> createNotificationApi(
//   //     String title,
//   //     String description,
//   //     List<Map<String, dynamic>> targets,
//   //     BuildContext context,
//   //     ) async
//   // {
//   //
//   //   loading = true;
//   //   notifyListeners();
//   //
//   //   try {
//   //
//   //     String token = await GetServerKey().getServerKeyToken();
//   //
//   //     final response = await http.post(
//   //       Uri.parse("https://university.fctesting.shop/api/schooladmin/createNotification"),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: jsonEncode({
//   //         "title": title,
//   //         "description": description,
//   //         "targets": targets,
//   //       }),
//   //     );
//   //
//   //     debugPrint("Status: ${response.statusCode}");
//   //     debugPrint("Body: ${response.body}");
//   //
//   //     loading = false;
//   //     notifyListeners();
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       return true;
//   //     } else {
//   //       return false;
//   //     }
//   //
//   //   } catch (e) {
//   //     loading = false;
//   //     notifyListeners();
//   //     debugPrint("Error: $e");
//   //     return false;
//   //   }
//   // }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/get_server_key.dart';
import '../user_view_model.dart';

class CreateNotificationViewModel with ChangeNotifier {

  bool loading = false;

  Future<bool> createNotificationApi(
      String title,
      String description,
      List<Map<String, dynamic>> targets,
      BuildContext context,
      ) async {

    loading = true;
    notifyListeners();

    try {
      String? token = await UserViewModel().getToken();

      final response = await http.post(
        Uri.parse("https://university.fctesting.shop/api/schooladmin/createNotification"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "targets": targets,
        }),
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      loading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ FCM push bhejo
        await _sendFCMByTargets(targets, title, description, token!);
        return true;
      }
      return false;

    } catch (e) {
      loading = false;
      notifyListeners();
      debugPrint("Error: $e");
      return false;
    }
  }

  // ✅ Targets ke hisaab se FCM bhejo
  Future<void> _sendFCMByTargets(
      List<Map<String, dynamic>> targets,
      String title,
      String description,
      String loginToken,
      ) async {
    for (var target in targets) {
      String targetType = target['target_type'] ?? '';

      if (targetType == 'role_based') {
        String role = target['role'] ?? '';
        List<String> tokens = await _getTokensByRole(role, loginToken);
        await _sendFCMToAll(tokens, title, description);

      } else if (targetType == 'school_wide') {
        List<String> teacherTokens = await _getTokensByRole('teacher', loginToken);
        List<String> studentTokens = await _getTokensByRole('student', loginToken);
        await _sendFCMToAll([...teacherTokens, ...studentTokens], title, description);

      } else if (targetType == 'individual') {
        int? userId = target['target_user_id'];
        if (userId != null) {
          String? token = await _getTokenByUserId(userId, loginToken);
          if (token != null) {
            await _sendSingleFCM(token, title, description);
          }
        }
      }
    }
  }

  // ✅ Role ke saare users ke tokens fetch karo
  Future<List<String>> _getTokensByRole(String role, String loginToken) async {
    try {
      String endpoint = '';
      String dataKey = '';

      if (role == 'teacher') {
        endpoint = 'https://university.fctesting.shop/api/schooladmin/getAllTeachers';
        dataKey = 'teachers';
      } else if (role == 'student') {
        endpoint = 'https://university.fctesting.shop/api/schooladmin/getTotalStudentsListBySchoolId';
        dataKey = 'students';
      } else if (role == 'accountant') {
        endpoint = 'https://university.fctesting.shop/api/schooladmin/getAllAccountants';
        dataKey = 'accountants';
      }

      if (endpoint.isEmpty) return [];

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $loginToken",
        },
      );

      debugPrint("$role tokens response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Apne response structure check karo
        List users = data['data'] ?? data[dataKey] ?? [];

        List<String> tokens = users
            .where((u) => u['device_token'] != null &&
            u['device_token'].toString().isNotEmpty)
            .map<String>((u) => u['device_token'].toString())
            .toList();

        debugPrint("📱 $role tokens found: ${tokens.length}");
        return tokens;
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching $role tokens: $e");
      return [];
    }
  }

  // ✅ Individual user ka token
  Future<String?> _getTokenByUserId(int userId, String loginToken) async {
    // Apne API se user detail fetch karo
    return null;
  }

  // ✅ Saare tokens pe FCM bhejo
  Future<void> _sendFCMToAll(List<String> tokens, String title, String body) async {
    for (String token in tokens) {
      if (token.isNotEmpty) {
        await _sendSingleFCM(token, title, body);
      }
    }
  }

  // ✅ Single FCM push
  Future<void> _sendSingleFCM(String deviceToken, String title, String body) async {
    try {
      String serverKey = await GetServerKey().getServerKeyToken();

      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/v1/projects/schoolerp-5df03/messages:send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $serverKey",
        },
        body: jsonEncode({
          "message": {
            "token": deviceToken,
            "notification": {
              "title": title,
              "body": body,
            },
            "android": {
              "priority": "high",
              "notification": {
                "channel_id": "high_importance_channel",
                "sound": "default",
              }
            }
          }
        }),
      );

      debugPrint("FCM Status: ${response.statusCode}");
      debugPrint("FCM Response: ${response.body}");
    } catch (e) {
      debugPrint("FCM Error: $e");
    }
  }
}