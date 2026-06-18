// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'get_server_key.dart';
// // //
// // // class SendNotificationServices {
// // //
// // //   static Future<bool> sendNotification({
// // //     required String fcmToken,
// // //     required String title,
// // //     required String description,
// // //     required List<Map<String, dynamic>> targets,
// // //   }) async {
// // //
// // //     try {
// // //
// // //       String token = await GetServerKey().getServerKeyToken();
// // //       debugPrint("🚀 Sending Notification...");
// // //       debugPrint("📬 FCM Token: $fcmToken");
// // //       final response = await http.post(
// // //         Uri.parse(
// // //           "https://university.fctesting.shop/api/schooladmin/sendNotification",
// // //         ),
// // //         headers: {
// // //           "Content-Type": "application/json",
// // //           "Authorization": "Bearer $token",
// // //         },
// // //         body: jsonEncode({
// // //           "title": title,
// // //           "description": description,
// // //           "targets": targets,
// // //         }),
// // //       );
// // //
// // //       debugPrint("Status Code: ${response.statusCode}");
// // //       debugPrint("Response: ${response.body}");
// // //
// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         return true;
// // //       } else {
// // //         return false;
// // //       }
// // //
// // //     } catch (e) {
// // //       debugPrint("Error: $e");
// // //       return false;
// // //     }
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import '../view_model/user_view_model.dart';
// //
// // class SendNotificationServices {
// //
// //   static Future<bool> sendNotification({
// //     required String title,
// //     required String description,
// //     required List<Map<String, dynamic>> targets,
// //   }) async {
// //
// //     try {
// //
// //       /// 🔥 GET LOGIN TOKEN (NOT FIREBASE TOKEN)
// //       String? token = await UserViewModel().getToken();
// //
// //       debugPrint("🔑 LOGIN TOKEN: $token");
// //
// //       final response = await http.post(
// //         Uri.parse(
// //           "https://university.fctesting.shop/api/schooladmin/sendNotification",
// //         ),
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
// //       debugPrint("Status Code: ${response.statusCode}");
// //       debugPrint("Response: ${response.body}");
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         return true;
// //       } else {
// //         return false;
// //       }
// //
// //     } catch (e) {
// //       debugPrint("Error: $e");
// //       return false;
// //     }
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../view_model/user_view_model.dart';
//
// class NotificationService {
//
//   static Future<bool> createNotification({
//     required String title,
//     required String description,
//     required List<Map<String, dynamic>> targets,
//   }) async {
//
//     try {
//       // GET backend login token (not FCM)
//       String? token = await UserViewModel().getToken();
//
//       final response = await http.post(
//         Uri.parse(
//           "https://university.fctesting.shop/api/schooladmin/createNotification",
//         ),
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
//       debugPrint("Status Code: ${response.statusCode}");
//       debugPrint("Body: ${response.body}");
//
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       debugPrint("Error in create notification: $e");
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../view_model/auth_view_model/user_view_model.dart';
import 'get_server_key.dart';

class NotificationService {

  //  Backend mein save karo
  static Future<bool> createNotification({
    required String title,
    required String description,
    required List<Map<String, dynamic>> targets,
  }) async {
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

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Error in create notification: $e");
      return false;
    }
  }

  // FCM push directly bhejo
  static Future<void> sendFCMPush({
    required String deviceToken,
    required String title,
    required String body,
  }) async {
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