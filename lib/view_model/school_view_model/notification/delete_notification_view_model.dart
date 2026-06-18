
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/notifiction/delete_notification_repo.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class DeleteNotificationViewModel with ChangeNotifier {
  final DeleteNotificationRepository _repo = DeleteNotificationRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> deleteNotificationApi(
      int id,
      BuildContext context,
      ) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.notificationSend)) {

      Utils.show(
        "You don't have permission to delete notifications",
        context,
      );

      return false;
    }

    setLoading(true);

    try {
      Map<String, dynamic> data = {
        "notification_ids": [id],
        "is_all": 0,
      };

      final response = await _repo.deleteNotificationApi(data);

      setLoading(false);

      if (response != null &&
          (response['status_code'] == 200 || response['status_code'] == 201)) {
        print("Delete Success: $response");
        return true;
      } else {
        print("Delete Failed: $response");
        return false;
      }
    } catch (e) {
      setLoading(false);
      print("Delete Error: $e");
      return false;
    }
  }
}
