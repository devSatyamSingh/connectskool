import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_student_list_model.dart';
import 'package:school_pro/repo/school_repo/all_student_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

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

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> allStudentListApi(
    BuildContext context, {
    String? classId,
    String? sectionId,
  }) async {
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
      debugPrint("Student List Error => $e");
      Utils.show("Failed to load students", context);
    } finally {
      setLoading(false);
    }
  }
}
