import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/edit_subject_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_subjects_view_model.dart';

import '../../utils/utils.dart';

class EditSubjectsViewModel with ChangeNotifier {
  final _loginRepo = EditSubjectRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> editSubjectsApi(
      dynamic subjectId,
      dynamic subjectName,
      dynamic assessmentModel,
      BuildContext context,
      ) async {
    setLoading(true);

    Map data = {
      "subject_id": subjectId,
      "subject_name": subjectName,
      "assessment_model": assessmentModel,
    };

    try {
      final response = await _loginRepo.editSubjectsApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Subject updated successfully", context);
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
  // Future<bool> editSubjectsApi(
  //     dynamic subjectId,
  //     dynamic subjectName,
  //     dynamic assessmentModel,
  //     context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map data = {
  //     "subject_id":subjectId,
  //     "subject_name": subjectName,
  //     "assessment_model": assessmentModel,
  //
  //   };
  //
  //   try {
  //     final response = await _loginRepo.editSubjectsApi(data);
  //
  //     setLoading(false);
  //
  //     final statusCode = response['status_code'];
  //     final message = response['message'];
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       Utils.show(message ?? "Class updated successfully", context);
  //
  //       Provider.of<AllSubjectsVieModel>(
  //         context,
  //         listen: false,
  //       ).allSubjectsApi(context);
  //
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
