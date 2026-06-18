import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/subject/add_subject_repo.dart';
import 'package:school_pro/repo/school_repo/classes/create_classes_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/all_subjects_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class AddSubjectViewModel with ChangeNotifier {
  final _loginRepo = AddSubjectsRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> addSubjectsApi(
      dynamic subjectName,
      dynamic assessmentModel,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.addSubject)) {

      Utils.show(
        "You don't have permission to add subject",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "subject_name": subjectName,
      "assessment_model": assessmentModel
    };

    try {
      final response = await _loginRepo.addSubjectsApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Subject added successfully", context);
        return true; // ✅ Only return success
      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;
      } else if (statusCode == 401) {
        Utils.show("Unauthorized user", context);
        return false;
      } else if (statusCode == 500) {
        Utils.show("Server error. Try again later", context);
        return false;
      } else {
        Utils.show("Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("API Error: $e");

      Utils.show("Network error", context);
      return false;
    }
  }
  // Future<bool> addSubjectsApi(
  //     dynamic subjectName,
  //     dynamic assessmentModel,
  //     context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map data = {
  //     "subject_name": subjectName,
  //     "assessment_model":assessmentModel
  //
  //   };
  //
  //   try {
  //     final response = await _loginRepo.addSubjectsApi(data);
  //
  //     setLoading(false);
  //
  //     final statusCode = response['status_code'];
  //     final message = response['message'];
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       Utils.show(message ?? "Class created successfully", context);
  //
  //       Provider.of<AllSubjectsVieModel>(
  //         context,
  //         listen: false,
  //       ).allSubjectsApi(context);
  //
  //
  //       return true;
  //     } else if (statusCode == 400) {
  //       Utils.show(message ?? "Invalid data", context);
  //       return false;
  //     } else if (statusCode == 401) {
  //       Utils.show("Unauthorized user", context);
  //       return false;
  //     } else if (statusCode == 500) {
  //       Utils.show("Server error. Try again later", context);
  //       return false;
  //     } else {
  //       Utils.show("Something went wrong", context);
  //       return false;
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     if (kDebugMode) print("API Error: $e");
  //
  //     Utils.show("Network error", context);
  //     return false;
  //   }
  // }
}
