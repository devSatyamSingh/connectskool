import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/all_classes_repo.dart';
import 'package:school_pro/repo/school_repo/school_admin_profile_repo.dart';
import 'package:school_pro/utils/utils.dart';
import '../../model/school_model/school_admin_profile_model.dart';

class SchoolAdminProfileViewModel extends ChangeNotifier {
  final _allStudentListRepo = SchoolAdminProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  SchoolAdminProfileModel? _schoolAdminProfileModel;
  SchoolAdminProfileModel? get schoolAdminProfileModel => _schoolAdminProfileModel;

  void _setLoading(bool value) {
    _loading = value;
  }

  Future<void> schoolAdminProfileApi(BuildContext context) async {
    _setLoading(true);
    notifyListeners();

    try {
      final response = await _allStudentListRepo.schoolAdminProfileApi();
      final int statusCode = response['status_code'];

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        _schoolAdminProfileModel = SchoolAdminProfileModel.fromJson(body);
      } else {
        _handleError(statusCode, response, context);
      }
    } catch (e) {
      Utils.show("Failed to load classes", context);
    }

    _setLoading(false);
    notifyListeners(); // 🔔 ONE FINAL rebuild
  }

  void _handleError(
      int statusCode,
      Map response,
      BuildContext context,
      ) {
    switch (statusCode) {
      case 401:
        Utils.show("Unauthorized user", context);
        break;
      case 403:
        Utils.show("Access denied", context);
        break;
      case 404:
        Utils.show("Classes not found", context);
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
  }
}
