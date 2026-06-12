import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_student_list_model.dart';
import 'package:school_pro/model/teacher_model/teacher_profile_model.dart';
import 'package:school_pro/repo/school_repo/all_student_list_repo.dart';
import 'package:school_pro/repo/teacher_repo/teacher_profile_repo.dart';
import 'package:school_pro/utils/utils.dart';

class TeacherProfileViewModel extends ChangeNotifier {
  final _allStudentListRepo = TeacherProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _permissionDenied = false;
  bool get permissionDenied => _permissionDenied;

  void setPermissionDenied(bool value) {
    _permissionDenied = value;
    notifyListeners();
  }

  TeacherProfileModel? _teacherProfileModel;
  TeacherProfileModel? get teacherProfileModel => _teacherProfileModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(TeacherProfileModel value) {
    _teacherProfileModel = value;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> teacherProfileApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.teacherProfileApi();

      final int statusCode = response['status_code'];

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = TeacherProfileModel.fromJson(body);
          setModelData(model);
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          setPermissionDenied(true);

          Utils.show(
            "Your profile access has been disabled by administrator.",
            context,
            type: "warning",
          );
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
