import 'package:flutter/material.dart';

import '../../model/school_model/school_student_fee_model.dart';
import '../../repo/school_repo/school_student_fee_repo.dart';

class StudentFeeViewModel extends ChangeNotifier {

  final StudentFeeRepository _repo = StudentFeeRepository();

  bool _loading = false;
  bool get loading => _loading;

  StudentFeeModel? _feeModel;
  StudentFeeModel? get feeModel => _feeModel;

  /// shortcut getters
  StudentInfo? get studentInfo => _feeModel?.data?.studentInfo;
  Summary? get summary => _feeModel?.data?.summary;
  List<FeeBreakdown> get feeBreakdown =>
      _feeModel?.data?.feeBreakdown ?? [];

  /// ================= FETCH STUDENT FEES =================

  Future<void> fetchStudentFees({
    required int studentId,
    required String academicYear,
  }) async {

    _loading = true;
    notifyListeners();

    try {

      final response = await _repo.getStudentFees(
        studentId,
        academicYear,
      );

      if (response != null && response["success"] == true) {

        /// Fix for Map<dynamic,dynamic> error
        final Map<String, dynamic> data =
        Map<String, dynamic>.from(response);

        _feeModel = StudentFeeModel.fromJson(data);

      }

    } catch (e) {
      debugPrint("Student Fee API Error: $e");
    }

    _loading = false;
    notifyListeners();
  }

  /// ================= CLEAR DATA =================

  void clearData() {
    _feeModel = null;
    notifyListeners();
  }
}