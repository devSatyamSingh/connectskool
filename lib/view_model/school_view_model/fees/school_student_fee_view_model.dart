import 'package:flutter/material.dart';
import '../../../model/school_model/fees/school_student_fee_model.dart';
import '../../../repo/school_repo/fees/school_student_fee_repo.dart';

class StudentFeeViewModel extends ChangeNotifier {
  final StudentFeeRepository _repo = StudentFeeRepository();

  bool _loading = false;
  bool get loading => _loading;

  StudentFeeModel? _feeModel;
  StudentFeeModel? get feeModel => _feeModel;

  // ── Shortcut getters ──────────────────────────────────────────────────────
  StudentInfo? get studentInfo => _feeModel?.data?.studentInfo;
  Summary? get summary => _feeModel?.data?.summary;
  List<FeeBreakdown> get feeBreakdown =>
      _feeModel?.data?.feeBreakdown ?? [];
  List<TransportFeeBreakdown> get transportFeeBreakdown =>
      _feeModel?.data?.transportFeeBreakdown ?? [];
  List<dynamic> get paymentHistory =>
      _feeModel?.data?.paymentHistory ?? [];
  String? get currentAcademicYear =>
      _feeModel?.data?.currentAcademicYear;

  // ── Fetch ─────────────────────────────────────────────────────────────────
  Future<void> fetchStudentFees({
    required int studentId,
    required String academicYear,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _repo.getStudentFees(studentId, academicYear);

      if (response != null && response['success'] == true) {
        _feeModel = StudentFeeModel.fromJson(
          Map<String, dynamic>.from(response),
        );
      }
    } catch (e) {
      debugPrint('StudentFeeViewModel Error: $e');
    }

    _loading = false;
    notifyListeners();
  }

  // ── Refresh after payment ─────────────────────────────────────────────────
  Future<void> refresh(int studentId, String academicYear) async {
    await fetchStudentFees(
      studentId: studentId,
      academicYear: academicYear,
    );
  }

  void clearData() {
    _feeModel = null;
    notifyListeners();
  }
}