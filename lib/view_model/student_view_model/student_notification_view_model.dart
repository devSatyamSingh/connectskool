import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/school_model/all_notification_model.dart';
import '../../model/student_model/student_notification_model.dart';
import '../../res/api_url.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../user_view_model.dart';

class StudentNotificationViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  StudentNotificationModel? _studentNotificationModel;
  StudentNotificationModel? get studentNotificationModel => _studentNotificationModel;

  // ── Fetch ──────────────────────────────────────────────
  // Future<void> studentNotificationApi(BuildContext context) async {
  //   _loading = true;
  //   notifyListeners();
  //
  //   try {
  //     final token = await UserViewModel().getToken(); // ✅ Yahi use karo// replace with your method
  //
  //     final response = await http.get(
  //       Uri.parse('${ApiUrl.studentNotification}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     final body = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && body['success'] == true) {
  //       _studentNotificationModel = StudentNotificationModel.fromJson(body);
  //     } else {
  //       debugPrint('Notification API error: ${body['message']}');
  //     }
  //   } catch (e) {
  //     debugPrint('allNotificationApi exception: $e');
  //   }
  //
  //   _loading = false;
  //   notifyListeners();
  // }
  Future<void> studentNotificationApi(BuildContext context) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.notificationView)) {

      Utils.show(
        "You don't have permission to view notifications",
        context,
      );

      return;
    }

    _loading = true;
    notifyListeners();

    try {
      final token = await UserViewModel().getToken();

      // ✅ Token check
      debugPrint('🔑 Token: $token');
      debugPrint('🌐 URL: ${ApiUrl.studentNotification}');

      final response = await http.get(
        Uri.parse(ApiUrl.studentNotification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // ✅ Exact status + body
      debugPrint('📬 Status: ${response.statusCode}');
      debugPrint('📬 Body: ${response.body}');
      debugPrint('🔑 Token used: $token');
      debugPrint('📬 Status: ${response.statusCode}');
      debugPrint('📬 Body: ${response.body}');
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        _studentNotificationModel = StudentNotificationModel.fromJson(body);
        debugPrint('✅ Notifications: ${_studentNotificationModel?.data?.notifications?.length}');
      } else {
        debugPrint('❌ Failed: ${response.statusCode} → ${body['message']}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }

    _loading = false;
    notifyListeners();
  }
  // ── Local remove (after delete) ────────────────────────
  void removeNotification(int id) {
    _studentNotificationModel?.data?.notifications
        ?.removeWhere((n) => n.notificationId == id);
    notifyListeners();
  }

  // ── Unread count helper ────────────────────────────────
  int get unreadCount =>
      _studentNotificationModel?.data?.unreadCount ?? 0;
}