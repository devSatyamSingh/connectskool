import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/student/all_student_list_model.dart';
import 'package:school_pro/repo/school_repo/student/all_student_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';

class AllStudentListVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllStudentListRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllStudentListModel? _allStudentListModel;
  AllStudentListModel? get allStudentListModel => _allStudentListModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllStudentListModel value) {
    _allStudentListModel = value;
    notifyListeners();
  }

  void clearStudents() {
    _allStudentListModel = null;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  //
  // [showMessage] = false (default) -> dashboard jaise auto-load screens se
  // call hone par "Access denied" toast NAHI dikhega.
  //
  // [showMessage] = true -> explicit user action (e.g. "All Students" screen
  // open karne par) par hi toast dikhana hai.
  Future<void> allStudentListApi(
      BuildContext context, {
        String? classId,
        String? sectionId,
        bool showMessage = false,
      }) async {
    // ✅ Pattern C - ViewModel level permission guard
    if (!PermissionExtensions.canAccess(PermissionKeys.viewAllStudent)) {
      if (showMessage) {
        Utils.show("You don't have permission to view all student", context);
      }
      return;
    }

    setLoading(true);

    try {
      final response = await _allStudentListRepo.allStudentListApi(
        classId: classId,
        sectionId: sectionId,
      );

      final int statusCode = response['status_code'] ?? 200;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = AllStudentListModel.fromJson(body);
          setModelData(model);
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          if (showMessage) {
            Utils.show("Access denied", context);
          }
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
      debugPrint("Student List Error => $e");
      if (showMessage) {
        Utils.show("Failed to load students", context);
      }
    } finally {
      setLoading(false);
    }
  }
}