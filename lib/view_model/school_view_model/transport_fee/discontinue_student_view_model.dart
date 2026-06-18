import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/subject/edit_subject_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/discontinue_student_repo.dart';
import 'package:school_pro/view_model/school_view_model/subject/all_subjects_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class DiscontinueStudentViewModel with ChangeNotifier {
  final _loginRepo = DiscontinueStudentRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> discontinueStudentApi(
    dynamic studentId,
    dynamic academicYear,
    dynamic discontinuedOn,
    dynamic discontinueReason,
    context,
  ) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.manageTransport)) {
      Utils.show("You don't have permission to perform this action.", context);

      return false;
    }
    setLoading(true);

    Map data = {
      "student_id": studentId,
      "academic_year": academicYear,
      "discontinued_on": discontinuedOn,
      "discontinue_reason": discontinueReason,
    };

    try {
      final response = await _loginRepo.discontinueStudentApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class updated successfully", context);

        Provider.of<AllSubjectsVieModel>(
          context,
          listen: false,
        ).allSubjectsApi(context);

        return true;
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
}
