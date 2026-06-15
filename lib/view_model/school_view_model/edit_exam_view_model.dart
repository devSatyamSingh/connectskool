import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../repo/school_repo/edit_exam_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class EditExamViewModel with ChangeNotifier {
  final _loginRepo = EditExamRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> editExamApi(
      dynamic examId,
      dynamic examTypeId,
      dynamic examName,
      dynamic academicYear,
      dynamic startDate,
      dynamic endDate,
      dynamic resultDate,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.editExam)) {

      Utils.show(
        "Permission denied",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "exam_id": examId,
      "exam_type_id": examTypeId,
      "exam_name": examName,
      "academic_year":academicYear,
      "start_date":startDate,
      "end_date":endDate,
      "result_date":resultDate
    };

    try {
      final response = await _loginRepo.editExamApi(data);

      setLoading(false);

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        Utils.show(response['message'], context);
        return true; // ✅ bas yahin khatam
      }

      Utils.show(response['message'] ?? "Something went wrong", context);
      return false;

    } catch (e) {
      setLoading(false);
      Utils.show("Network error", context);
      return false;
    }
  }

}
