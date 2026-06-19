import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/notification/all_notification_model.dart';
import 'package:school_pro/repo/school_repo/notifiction/all_notification_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AllNotificationViewModel extends ChangeNotifier {
  final _allStudentListRepo = AllNotificationRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllNotificationModel? _allNotificationModel;
  AllNotificationModel? get allNotificationModel => _allNotificationModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }



  void setModelData(AllNotificationModel value) {
    _allNotificationModel = value;
    notifyListeners();
  }
  void removeNotification(int id) {
    if (_allNotificationModel?.data?.notifications != null) {
      _allNotificationModel!.data!.notifications!
          .removeWhere((item) => item.notificationId == id);

      notifyListeners();
    }
  }
  Future<void> allNotificationApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allNotificationApi();

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          body.remove('status_code');

          final model = AllNotificationModel.fromJson(body);
          setModelData(model);

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
