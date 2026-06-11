// ============================================================
// lib/features/fees/model/student_fees_model.dart
// ============================================================

class StudentFeesResponse {
  final bool success;
  final StudentFeesData data;

  StudentFeesResponse({required this.success, required this.data});

  factory StudentFeesResponse.fromJson(Map<String, dynamic> json) {
    return StudentFeesResponse(
      success: json['success'] ?? false,
      data: StudentFeesData.fromJson(json['data']),
    );
  }
}

// ─────────────────────────────────────────
class StudentFeesData {
  final StudentInfo studentInfo;
  final String currentAcademicYear;
  final List<FeeBreakdown> feeBreakdown;
  final List<TransportFeeBreakdown> transportFeeBreakdown;
  final List<PaymentHistory> paymentHistory;
  final FeesSummary summary;

  StudentFeesData({
    required this.studentInfo,
    required this.currentAcademicYear,
    required this.feeBreakdown,
    required this.transportFeeBreakdown,
    required this.paymentHistory,
    required this.summary,
  });

  factory StudentFeesData.fromJson(Map<String, dynamic> json) {
    return StudentFeesData(
      studentInfo: StudentInfo.fromJson(json['student_info']),
      currentAcademicYear: json['current_academic_year'] ?? '',
      feeBreakdown: (json['fee_breakdown'] as List<dynamic>? ?? [])
          .map((e) => FeeBreakdown.fromJson(e))
          .toList(),
      transportFeeBreakdown:
      (json['transport_fee_breakdown'] as List<dynamic>? ?? [])
          .map((e) => TransportFeeBreakdown.fromJson(e))
          .toList(),
      paymentHistory: (json['payment_history'] as List<dynamic>? ?? [])
          .map((e) => PaymentHistory.fromJson(e))
          .toList(),
      summary: FeesSummary.fromJson(json['summary']),
    );
  }
}

// ─────────────────────────────────────────
class StudentInfo {
  final int studentId;
  final String name;
  final String fatherName;
  final String motherName;
  final String? dob;
  final String? address;
  final String rollNo;
  final String admissionNo;
  final String className;
  final String sectionName;
  final int classId;
  final int sectionId;

  StudentInfo({
    required this.studentId,
    required this.name,
    required this.fatherName,
    required this.motherName,
    this.dob,
    this.address,
    required this.rollNo,
    required this.admissionNo,
    required this.className,
    required this.sectionName,
    required this.classId,
    required this.sectionId,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      studentId: json['student_id'] ?? 0,
      name: json['name'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      dob: json['dob'],
      address: json['address'],
      rollNo: json['roll_no']?.toString() ?? '',
      admissionNo: json['admission_no']?.toString() ?? '',
      className: json['class_name'] ?? '',
      sectionName: json['section_name'] ?? '',
      classId: json['class_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
    );
  }
}

// ─────────────────────────────────────────
class FeeBreakdown {
  final int studentFeeId;
  final int feeId;
  final String feeHeadName;
  final String academicYear;
  final String className;
  final double baseAmount;
  final String feeFrequency;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final double fineAmount;
  final String status;
  final String? assignedOn;
  final List<FeeInstallment> installments;

  FeeBreakdown({
    required this.studentFeeId,
    required this.feeId,
    required this.feeHeadName,
    required this.academicYear,
    required this.className,
    required this.baseAmount,
    required this.feeFrequency,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.fineAmount,
    required this.status,
    this.assignedOn,
    required this.installments,
  });

  factory FeeBreakdown.fromJson(Map<String, dynamic> json) {
    return FeeBreakdown(
      studentFeeId: json['student_fee_id'] ?? 0,
      feeId: json['fee_id'] ?? 0,
      feeHeadName: json['fee_head_name'] ?? '',
      academicYear: json['academic_year'] ?? '',
      className: json['class_name'] ?? '',
      baseAmount: (json['base_amount'] ?? 0).toDouble(),
      feeFrequency: json['fee_frequency'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] ?? 0).toDouble(),
      fineAmount: (json['fine_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      assignedOn: json['assigned_on'],
      installments: (json['installments'] as List<dynamic>? ?? [])
          .map((e) => FeeInstallment.fromJson(e))
          .toList(),
    );
  }
}

class FeeInstallment {
  final int id;
  final int studentFeeId;
  final int installmentNo;
  final double amount;
  final String? startDueDate;
  final String? endDueDate;
  final String status;
  final String? paidOn;
  final String calculatedStatus;
  final double fineAmount;
  final double totalAmount;

  FeeInstallment({
    required this.id,
    required this.studentFeeId,
    required this.installmentNo,
    required this.amount,
    this.startDueDate,
    this.endDueDate,
    required this.status,
    this.paidOn,
    required this.calculatedStatus,
    required this.fineAmount,
    required this.totalAmount,
  });

  factory FeeInstallment.fromJson(Map<String, dynamic> json) {
    return FeeInstallment(
      id: json['id'] ?? 0,
      studentFeeId: json['student_fee_id'] ?? 0,
      installmentNo: json['installment_no'] ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      startDueDate: json['start_due_date'],
      endDueDate: json['end_due_date'],
      status: json['status'] ?? '',
      paidOn: json['paid_on'],
      calculatedStatus: json['calculated_status'] ?? '',
      fineAmount: (json['fine_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}

// ─────────────────────────────────────────
class TransportFeeBreakdown {
  final int studentTransportFeeId;
  final int transportFeeId;
  final String feeHeadName;
  final String routeName;
  final String stopName;
  final String distanceKm;
  final String academicYear;
  final double baseAmount;
  final String feeFrequency;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final double fineAmount;
  final String status;
  final String? assignedOn;
  final String? discontinuedOn;
  final List<TransportInstallment> installments;

  TransportFeeBreakdown({
    required this.studentTransportFeeId,
    required this.transportFeeId,
    required this.feeHeadName,
    required this.routeName,
    required this.stopName,
    required this.distanceKm,
    required this.academicYear,
    required this.baseAmount,
    required this.feeFrequency,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.fineAmount,
    required this.status,
    this.assignedOn,
    this.discontinuedOn,
    required this.installments,
  });

  factory TransportFeeBreakdown.fromJson(Map<String, dynamic> json) {
    return TransportFeeBreakdown(
      studentTransportFeeId: json['student_transport_fee_id'] ?? 0,
      transportFeeId: json['transport_fee_id'] ?? 0,
      feeHeadName: json['fee_head_name'] ?? '',
      routeName: json['route_name'] ?? '',
      stopName: json['stop_name'] ?? '',
      distanceKm: json['distance_km']?.toString() ?? '0',
      academicYear: json['academic_year'] ?? '',
      baseAmount: (json['base_amount'] ?? 0).toDouble(),
      feeFrequency: json['fee_frequency'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] ?? 0).toDouble(),
      fineAmount: (json['fine_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      assignedOn: json['assigned_on'],
      discontinuedOn: json['discontinued_on'],
      installments: (json['installments'] as List<dynamic>? ?? [])
          .map((e) => TransportInstallment.fromJson(e))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────
class TransportInstallment {
  final int studentTransportInstallmentId;
  final int studentTransportFeeId;
  final int installmentNo;
  final double amount;
  final String? startDueDate;
  final String? endDueDate;
  final String? dueDate;
  final String status;
  final String? paidOn;
  final String calculatedStatus;
  final double fineAmount;
  final double totalAmount;

  TransportInstallment({
    required this.studentTransportInstallmentId,
    required this.studentTransportFeeId,
    required this.installmentNo,
    required this.amount,
    this.startDueDate,
    this.endDueDate,
    this.dueDate,
    required this.status,
    this.paidOn,
    required this.calculatedStatus,
    required this.fineAmount,
    required this.totalAmount,
  });

  factory TransportInstallment.fromJson(Map<String, dynamic> json) {
    return TransportInstallment(
      studentTransportInstallmentId:
      json['student_transport_installment_id'] ?? 0,
      studentTransportFeeId: json['student_transport_fee_id'] ?? 0,
      installmentNo: json['installment_no'] ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      startDueDate: json['start_due_date'],
      endDueDate: json['end_due_date'],
      dueDate: json['due_date'],
      status: json['status'] ?? '',
      paidOn: json['paid_on'],
      calculatedStatus: json['calculated_status'] ?? '',
      fineAmount: (json['fine_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}

// ─────────────────────────────────────────
class PaymentHistory {
  final int paymentId;
  final int feeId;
  final int studentFeeInstallmentId;
  final String feeHeadName;
  final double amount;
  final double fineAmount;
  final String paymentMode;
  final String status;
  final String? transactionRef;
  final String paidOn;
  final String academicYear;

  PaymentHistory({
    required this.paymentId,
    required this.feeId,
    required this.studentFeeInstallmentId,
    required this.feeHeadName,
    required this.amount,
    required this.fineAmount,
    required this.paymentMode,
    required this.status,
    this.transactionRef,
    required this.paidOn,
    required this.academicYear,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      paymentId: json['payment_id'] ?? 0,
      feeId: json['fee_id'] ?? 0,
      studentFeeInstallmentId: json['student_fee_installment_id'] ?? 0,
      feeHeadName: json['fee_head_name'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      fineAmount:
      double.tryParse(json['fine_amount']?.toString() ?? '0') ?? 0,
      paymentMode: json['payment_mode'] ?? '',
      status: json['status'] ?? '',
      transactionRef: json['transaction_ref'],
      paidOn: json['paid_on'] ?? '',
      academicYear: json['academic_year'] ?? '',
    );
  }
}

// ─────────────────────────────────────────
class FeesSummary {
  final CurrentYearSummary currentYear;
  final double previousPending;
  final double previousFine;
  final double grandTotalPending;
  final double grandTotalFine;

  FeesSummary({
    required this.currentYear,
    required this.previousPending,
    required this.previousFine,
    required this.grandTotalPending,
    required this.grandTotalFine,
  });

  factory FeesSummary.fromJson(Map<String, dynamic> json) {
    return FeesSummary(
      currentYear: CurrentYearSummary.fromJson(json['current_year'] ?? {}),
      previousPending: (json['previous_pending'] ?? 0).toDouble(),
      previousFine: (json['previous_fine'] ?? 0).toDouble(),
      grandTotalPending: (json['grand_total_pending'] ?? 0).toDouble(),
      grandTotalFine: (json['grand_total_fine'] ?? 0).toDouble(),
    );
  }
}

// ─────────────────────────────────────────
class CurrentYearSummary {
  final double total;
  final double paid;
  final double pending;
  final double fine;

  CurrentYearSummary({
    required this.total,
    required this.paid,
    required this.pending,
    required this.fine,
  });

  factory CurrentYearSummary.fromJson(Map<String, dynamic> json) {
    return CurrentYearSummary(
      total: (json['total'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
      fine: (json['fine'] ?? 0).toDouble(),
    );
  }
}