import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_subjects_model.dart';
import 'package:school_pro/repo/school_repo/all_subjects_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';

class AllSubjectsVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllSubjectsRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllSubjectsModel? _allSubjectsModel;
  AllSubjectsModel? get allSubjectsModel => _allSubjectsModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllSubjectsModel value) {
    _allSubjectsModel = value;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> allSubjectsApi(BuildContext context) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewSubjects)) {

      Utils.show(
        "You don't have permission to view subjects",
        context,
      );

      return;
    }
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allSubjectsApi();

      final int statusCode = response['status_code'];

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = AllSubjectsModel.fromJson(body);
          setModelData(model);
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          Utils.show("Access denied", context);
          break;

        case 404:
          Utils.show("Students not found", context);
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
      Utils.show("Failed to load students", context);
    } finally {
      setLoading(false);
    }
  }
}
