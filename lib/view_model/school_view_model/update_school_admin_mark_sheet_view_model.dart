import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/update_school_admin_marksheet_repo.dart';
import '../../repo/school_repo/edit_exam_repo.dart';
import '../../utils/utils.dart';

class UpdateSchoolAdminMarkSheetViewModel with ChangeNotifier {
  final _loginRepo = UpdateSchoolAdminMarkSheetRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> updateSchoolAdminMarkSheetApi(
      dynamic gradeId,
      dynamic grade,
      BuildContext context,
      ) async {
    setLoading(true);

    Map data = {
      "grade_id": gradeId,
      "grade": grade

    };

    try {
      final response = await _loginRepo.updateSchoolAdminMarkSheetApi(data);

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
