// ============================================================
//  student_attendance_view_model.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_attendance_model.dart';
import 'package:school_pro/repo/school_repo/all_attendance_repo.dart';

class AllAttendanceViewModel extends ChangeNotifier {
  final _repo = AllAttendanceRepository();

  AllAttendanceModel? _model;
  bool    _loading = false;
  String? _error;

  AllAttendanceModel? get model    => _model;
  bool                    get loading  => _loading;
  String?                 get error    => _error;

  List<StudentAttendance> get students      => _model?.data?.students ?? [];
  int                     get totalStudents => _model?.data?.totalStudents ?? 0;

  // ── Filter helpers ──
  List<StudentAttendance> get presentStudents =>
      students.where((s) => s.status?.toLowerCase() == 'present').toList();
  List<StudentAttendance> get absentStudents =>
      students.where((s) => s.status?.toLowerCase() == 'absent').toList();
  List<StudentAttendance> get lateStudents =>
      students.where((s) => s.status?.toLowerCase() == 'late').toList();

  Future<void> getAttendance({
    required int    classId,
    required int    sectionId,
    required String date,        // yyyy/MM/dd
    required BuildContext context,
  }) async {
    _loading = true;
    _error   = null;
    notifyListeners();

    try {
      _model = await _repo.getAttendance(
        classId:   classId,
        sectionId: sectionId,
        date:      date,
      );
      print("✅ Attendance loaded → ${students.length} students");
    } catch (e) {
      _error = e.toString();
      print("❌ Attendance error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clear() {
    _model  = null;
    _error  = null;
    notifyListeners();
  }
}