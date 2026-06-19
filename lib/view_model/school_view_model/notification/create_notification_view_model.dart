import 'package:flutter/material.dart';
import '../../../repo/school_repo/notifiction/create_notification_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateNotificationViewModel with ChangeNotifier {
  final CreateNotificationRepository _repo = CreateNotificationRepository();

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createNotificationApi({
    required String title,
    required String description,
    required List<Map<String, dynamic>> targets,
    required BuildContext context,
  }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.notificationSend)) {
      Utils.show("You don't have permission to send notifications", context);

      return false;
    }

    if (title.trim().isEmpty) {
      Utils.show("Please enter title", context);
      return false;
    }

    if (description.trim().isEmpty) {
      Utils.show("Please enter description", context);
      return false;
    }

    if (targets.isEmpty) {
      Utils.show("Please select target audience", context);
      return false;
    }

    _setLoading(true);

    try {
      final cleanTargets = targets.map((e) {
        final data = Map<String, dynamic>.from(e);
        data.remove("_display");
        return data;
      }).toList();

      final payload = {
        "title": title.trim(),
        "description": description.trim(),
        "targets": cleanTargets,
      };

      debugPrint("📤 CREATE NOTIFICATION PAYLOAD => $payload");

      final response = await _repo.createNotificationApi(payload);

      debugPrint("📥 CREATE NOTIFICATION RESPONSE => $response");

      final int statusCode = response["status_code"] ?? 0;

      final String message = response["message"]?.toString() ?? "";

      switch (statusCode) {
        case 200:
        case 201:
          Utils.show(
            message.isNotEmpty ? message : "Notification sent successfully",
            context,
          );

          return true;

        case 400:
          Utils.show(message.isNotEmpty ? message : "Invalid request", context);

          return false;

        case 401:
          Utils.show("Session expired. Please login again.", context);

          return false;

        case 403:
          Utils.show("Access denied", context);

          return false;

        case 404:
          Utils.show(message.isNotEmpty ? message : "Data not found", context);

          return false;

        case 500:
          Utils.show("Server error. Please try again later.", context);

          return false;

        case 0:
          Utils.show("No internet connection", context);

          return false;

        default:
          Utils.show(
            message.isNotEmpty ? message : "Something went wrong",
            context,
          );

          return false;
      }
    } catch (e, stack) {
      debugPrint("❌ CREATE NOTIFICATION ERROR => $e");

      debugPrint("❌ STACK => $stack");

      Utils.show("Unable to send notification", context);

      return false;
    } finally {
      _setLoading(false);
    }
  }
}
