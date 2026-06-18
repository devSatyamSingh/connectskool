import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/notifiction/edit_notification_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class EditNotificationViewModel with ChangeNotifier {
  final _loginRepo = EditNotificationRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> editNotificationApi(
      dynamic notificationTypeId,
      dynamic typeName,
      dynamic typeCode,
      dynamic description,
      dynamic icon,
      dynamic color,
      dynamic status,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.notificationSend)) {

      Utils.show(
        "You don't have permission to edit notifications",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "notification_type_id": notificationTypeId,
      "type_name": typeName,
      "type_code": typeCode,
      "description": description,
      "icon": icon,
      "color": color,
      "status": status,
    };

    try {
      final response = await _loginRepo.editNotificationApi(data);

      setLoading(false);

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        Utils.show(response['message'], context);
        return true; // ✅ bas yahin khatam
      }

      Utils.show(response['message'] ?? "Something went wrong", context);
      return false;

    } catch (e) {
      setLoading(false);
      Utils.show("Network error", context);
      return false;
    }
  }

}
