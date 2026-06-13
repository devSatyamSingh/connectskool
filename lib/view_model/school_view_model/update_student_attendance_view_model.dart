import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/update_accountant_attendance_repo.dart';
import 'package:school_pro/repo/school_repo/update_school_admin_marksheet_repo.dart';
import 'package:school_pro/repo/school_repo/update_student_attendance_repo.dart';
import '../../repo/school_repo/edit_exam_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class UpdateStudentAttendanceViewModel with ChangeNotifier {
  final _loginRepo = UpdateStudentAttendanceRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> updateStudentAttendanceApi(
      int attendanceId,
      int studentId,           // ✅ add karo
      String status,
      String remarks,
      String attendanceDate,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.markStudentAttendance)) {
      Utils.show(
        "You don't have permission to update attendance",
        context,
      );
      return false;
    }
    setLoading(true);

    final Map<String, dynamic> data = {
      "attendance_date": attendanceDate,
      "students": [
        {
          "attendance_id": attendanceId,
          "student_id"   : studentId,    // ✅ add karo
          "status"       : status,
          "remarks"      : remarks,
        }
      ],
    };

    if (kDebugMode) print("Update Attendance payload 👉 $data");

    try {
      final response = await _loginRepo.updateStudentAttendanceApi(data);
      setLoading(false);

      final statusCode = response['status_code'];
      final message    = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Attendance updated", context);
        return true;
      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;
      } else if (statusCode == 401) {
        Utils.show(message ?? "Unauthorized", context);
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
      if (kDebugMode) print("UpdateAttendance Error 👉 $e");
      Utils.show("Network error", context);
      return false;
    }
  }
  // Future<bool> updateStudentAttendanceApi(
  //     dynamic attendance_id,
  //     dynamic status,
  //     dynamic remarks,
  //     BuildContext context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map data = {
  //     "attendance_id": attendance_id,
  //     "status": status,
  //     "remarks": remarks,
  //
  //   };
  //
  //   try {
  //     final response = await _loginRepo.updateStudentAttendanceApi(data);
  //
  //     setLoading(false);
  //
  //     if (response['status_code'] == 200 ||
  //         response['status_code'] == 201) {
  //
  //       Utils.show(response['message'], context);
  //       return true; // ✅ bas yahin khatam
  //     }
  //
  //     Utils.show(response['message'] ?? "Something went wrong", context);
  //     return false;
  //
  //   } catch (e) {
  //     setLoading(false);
  //     Utils.show("Network error", context);
  //     return false;
  //   }
  // }

}
