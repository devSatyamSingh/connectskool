import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/attendance/update_accountant_attendance_repo.dart';
import 'package:school_pro/repo/school_repo/marksheet/update_school_admin_marksheet_repo.dart';
import '../../../repo/school_repo/exam/edit_exam_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class UpdateAccountantAttendanceViewModel with ChangeNotifier {
  final _loginRepo = UpdateAccountantAttendanceRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> updateAccountantAttendanceApi(
      dynamic attendance_id,
      dynamic status,
      dynamic remarks,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.markTeacherAttendance)) {

      Utils.show(
        "You don't have permission to update accountant attendance",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "attendance_id": attendance_id,
      "status": status,
      "remarks": remarks,

    };

    try {
      final response = await _loginRepo.updateAccountantAttendanceApi(data);

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
