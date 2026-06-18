import 'package:flutter/material.dart';
import '../../model/student_model/student_fee_model.dart';
import '../../repo/student_repo/student_fee_repo.dart';

enum FeesState { idle, loading, success, error }

class StudentFeesViewModel extends ChangeNotifier {
  final StudentFeesRepo _repo;

  StudentFeesViewModel({StudentFeesRepo? repo})
      : _repo = repo ?? StudentFeesRepo();

  // ── State ──────────────────────────────────────────────
  FeesState _state = FeesState.idle;
  StudentFeesResponse? _feesResponse;
  String _errorMessage = '';

  // ── Getters ─────────────────────────────────────────────
  FeesState get state => _state;
  bool get isLoading => _state == FeesState.loading;
  bool get hasError => _state == FeesState.error;
  bool get hasData => _state == FeesState.success && _feesResponse != null;
  String get errorMessage => _errorMessage;

  StudentFeesData? get feesData => _feesResponse?.data;
  StudentInfo? get studentInfo => feesData?.studentInfo;
  FeesSummary? get summary => feesData?.summary;
  List<FeeBreakdown> get feeBreakdown => feesData?.feeBreakdown ?? [];
  List<TransportFeeBreakdown> get transportFeeBreakdown =>
      feesData?.transportFeeBreakdown ?? [];
  List<PaymentHistory> get paymentHistory => feesData?.paymentHistory ?? [];
  String get academicYear => feesData?.currentAcademicYear ?? '';

  // ── Derived helpers ──────────────────────────────────────
  double get totalAmount => summary?.currentYear.total ?? 0;
  double get paidAmount => summary?.currentYear.paid ?? 0;
  double get pendingAmount => summary?.currentYear.pending ?? 0;
  double get fineAmount => summary?.currentYear.fine ?? 0;
  double get grandTotalPending => summary?.grandTotalPending ?? 0;

  /// Pending installments across all fee heads (regular + transport).
  List<FeeInstallment> get pendingInstallments => feeBreakdown
      .expand((fb) => fb.installments)
      .where((i) => i.calculatedStatus == 'pending' || i.calculatedStatus == 'overdue')
      .toList();

  List<TransportInstallment> get pendingTransportInstallments =>
      transportFeeBreakdown
          .expand((tb) => tb.installments)
          .where((i) =>
      i.calculatedStatus == 'pending' ||
          i.calculatedStatus == 'overdue')
          .toList();

  // ── API Call ─────────────────────────────────────────────
  Future<void> fetchFees({
    required String academicYear,
  }) async {
    _state = FeesState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _repo.getStudentFees(
        academicYear: academicYear,
      );

      _feesResponse = response;
      _state = FeesState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = FeesState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = FeesState.idle;
    _feesResponse = null;
    _errorMessage = '';
    notifyListeners();
  }
}