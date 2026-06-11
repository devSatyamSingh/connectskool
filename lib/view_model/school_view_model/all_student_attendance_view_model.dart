import 'package:flutter/material.dart';
import '../../model/school_model/all_student_attendance_model.dart';
import '../../repo/school_repo/get_all_student_admin_repo.dart';

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