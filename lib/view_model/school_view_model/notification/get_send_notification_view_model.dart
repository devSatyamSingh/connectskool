import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/notification/all_notification_model.dart';
import 'package:school_pro/model/school_model/notification/get_send_notification_model.dart';
import 'package:school_pro/repo/school_repo/notifiction/all_notification_repo.dart';
import 'package:school_pro/repo/school_repo/notifiction/get_send_notification_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';

class GetSendNotificationViewModel extends ChangeNotifier {
  final _allStudentListRepo = GetSendNotificationRepository();

  bool _loading = false;
  bool get loading => _loading;

  GetSendNotificationModel? _getSendNotificationModel;
  GetSendNotificationModel? get getSendNotificationModel => _getSendNotificationModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(GetSendNotificationModel value) {
    _getSendNotificationModel = value;
    notifyListeners();
  }

  void removeNotification(int id) {

    if (_getSendNotificationModel?.data != null) {

      _getSendNotificationModel!.data!
          .removeWhere(
            (item) => item.notificationId == id,
      );

      notifyListeners();
    }
  }

  Future<void> getSendNotificationApi(BuildContext context) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.notificationView)) {

      Utils.show(
        "You don't have permission to view notifications",
        context,
      );

      return;
    }

    setLoading(true);

    try {
      final response = await _allStudentListRepo.getSendNotificationApi();
      print("SENT API RESPONSE => $response");

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          // Remove status_code as it's not part of the model
          body.remove('status_code');

          final model = GetSendNotificationModel.fromJson(body);
          setModelData(model);

          print("TOTAL SENT => ${model.data?.length}");


          // print("✅ Teachers fetched: ${model.data?.length ?? 0}");
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          Utils.show("Access denied", context);
          break;

        case 404:
          Utils.show("Notification not found", context);
          break;

        case 500:
          Utils.show("Server error", context);
          break;

        case 0:
          Utils.show("No Internet Connection", context);
          break;

        default:
          Utils.show(response['message'] ?? "Something went wrong", context);
      }
    } catch (e) {
      print("❌ Exception fetching teachers: $e");
      Utils.show("Failed to load teachers", context);
    } finally {
      setLoading(false);
    }
  }
}
