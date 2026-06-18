import 'package:flutter/material.dart';
import '../../../model/school_model/attendance/all_student_attendance_model.dart';
import '../../../repo/school_repo/student/get_all_student_admin_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class AllStudentAdminAttendanceViewModel with ChangeNotifier {

  final _repo = AllStudentAdminAttendanceRepository();

  bool loading = false;

  AllStudentAdminAttendanceModel? attendanceModel;

  Future<void> getAttendance({
    required int classId,
    required int sectionId,
    required String date,
    required BuildContext context,
  }) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewOneStudentAttendance)) {

      Utils.show(
        "You don't have permission to view attendance",
        context,
      );

      return;
    }

    loading = true;
    notifyListeners();

    final response = await _repo.getStudentAdminAttendance(
      classId: classId,
      sectionId: sectionId,
      date: date,
    );

    loading = false;

    if (response['success'] == true) {

      attendanceModel =
          AllStudentAdminAttendanceModel.fromJson(
            Map<String, dynamic>.from(response),
          );
    } else {

      attendanceModel = null;
    }

    notifyListeners();
  }
}