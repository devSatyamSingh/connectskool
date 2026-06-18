import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../repo/school_repo/notifiction/mark_as_all_read_read_notification_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

// class MarkAsAllReadNotificationViewModel with ChangeNotifier {
//   final _repo = MarkAsAllReadNotificationRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> markAsAllReadNotificationApi(BuildContext context) async {
//     setLoading(true);
//
//     try {
//       final response =
//       await _repo.markAsAllReadNotificationApi(null); // 👈 no body
//
//       setLoading(false);
//
//       final message = response['message'] ?? "Done";
//
//       if (response['success'] == true) {
//         Utils.show(message, context);
//         return true;
//       } else {
//         Utils.show(message, context);
//         return false;
//       }
//     } catch (e) {
//       setLoading(false);
//
//       if (kDebugMode) {
//         print("API Error: $e");
//       }
//
//       Utils.show("Network error", context);
//       return false;
//     }
//   }
// }
class MarkAsAllReadNotificationViewModel with ChangeNotifier {

  final _loginRepo = MarkAsAllReadNotificationRepository();

  bool _loading = false;
  int _readCount = 0;

  bool get loading => _loading;
  int get readCount => _readCount;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> markAsAllReadNotificationApi(context) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.notificationView)) {

      Utils.show(
        "You don't have permission",
        context,
      );

      return false;
    }

    setLoading(true);

    try {
      final response =
      await _loginRepo.markAsAllReadNotificationApi({});

      setLoading(false);

      final message = response['message'] ?? "";

      // 🔥 Number extract from message
      final number = RegExp(r'\d+').firstMatch(message);
      _readCount = int.tryParse(number?.group(0) ?? "0") ?? 0;

      notifyListeners();

      Utils.show(message, context);

      return true;
    } catch (e) {
      setLoading(false);
      Utils.show("Network error", context);
      return false;
    }
  }
}
