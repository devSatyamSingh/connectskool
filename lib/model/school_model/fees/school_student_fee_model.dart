class StudentFeeModel {
  bool? success;
  Data? data;

  StudentFeeModel({this.success, this.data});

  StudentFeeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  StudentInfo? studentInfo;
  String? currentAcademicYear;
  List<FeeBreakdown>? feeBreakdown;
  List<TransportFeeBreakdown>? transportFeeBreakdown;
  List<dynamic>? paymentHistory;
  Summary? summary;

  Data({
    this.studentInfo,
    this.currentAcademicYear,
    this.feeBreakdown,
    this.transportFeeBreakdown,
    this.paymentHistory,
    this.summary,
  });

  Data.fromJson(Map<String, dynamic> json) {
    studentInfo = json['student_info'] != null
        ? StudentInfo.fromJson(json['student_info'])
        : null;

    currentAcademicYear = json['current_academic_year'];

    if (json['fee_breakdown'] != null) {
      feeBreakdown = [];
      for (var v in json['fee_breakdown']) {
        feeBreakdown!.add(FeeBreakdown.fromJson(v));
      }
    }

    if (json['transport_fee_breakdown'] != null) {
      transportFeeBreakdown = [];
      for (var v in json['transport_fee_breakdown']) {
        transportFeeBreakdown!.add(TransportFeeBreakdown.fromJson(v));
      }
    }

    paymentHistory = json['payment_history'];

    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }
}

class StudentInfo {
  int? studentId;
  String? name;
  String? fatherName;
  String? motherName;
  String? dob;
  String? address;
  String? rollNo;
  String? admissionNo;
  String? className;
  String? sectionName;
  int? classId;
  int? sectionId;

  StudentInfo({
    this.studentId,
    this.name,
    this.fatherName,
    this.motherName,
    this.dob,
    this.address,
    this.rollNo,
    this.admissionNo,
    this.className,
    this.sectionName,
    this.classId,
    this.sectionId,
  });

  StudentInfo.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    name = json['name'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    dob = json['dob'];
    address = json['address'];
    rollNo = json['roll_no'];
    admissionNo = json['admission_no'];
    className = json['class_name'];
    sectionName = json['section_name'];
    classId = json['class_id'];
    sectionId = json['section_id'];
  }
}

// ── Academic Fee Breakdown ─────────────────────────────────────────────────────

class FeeBreakdown {
  int? studentFeeId;
  int? feeId;
  String? feeHeadName;
  String? academicYear;
  String? className;
  num? baseAmount;
  String? feeFrequency;
  num? totalAmount;
  num? paidAmount;
  num? pendingAmount;
  num? fineAmount;
  String? status;
  String? assignedOn;
  List<Installment>? installments;

  FeeBreakdown({
    this.studentFeeId,
    this.feeId,
    this.feeHeadName,
    this.academicYear,
    this.className,
    this.baseAmount,
    this.feeFrequency,
    this.totalAmount,
    this.paidAmount,
    this.pendingAmount,
    this.fineAmount,
    this.status,
    this.assignedOn,
    this.installments,
  });

  FeeBreakdown.fromJson(Map<String, dynamic> json) {
    studentFeeId = json['student_fee_id'];
    feeId = json['fee_id'];
    feeHeadName = json['fee_head_name'];
    academicYear = json['academic_year'];
    className = json['class_name'];
    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];
    fineAmount = json['fine_amount'];
    status = json['status'];
    assignedOn = json['assigned_on'];

    if (json['installments'] != null) {
      installments = [];
      for (var v in json['installments']) {
        installments!.add(Installment.fromJson(v));
      }
    }
  }
}

class Installment {
  int? id;
  int? studentFeeId;
  int? installmentNo;
  String? amount;
  String? startDueDate;
  String? endDueDate;
  String? status;
  String? paidOn;
  String? createdAt;
  String? calculatedStatus;
  num? fineAmount;
  num? totalAmount;

  Installment({
    this.id,
    this.studentFeeId,
    this.installmentNo,
    this.amount,
    this.startDueDate,
    this.endDueDate,
    this.status,
    this.paidOn,
    this.createdAt,
    this.calculatedStatus,
    this.fineAmount,
    this.totalAmount,
  });

  Installment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentFeeId = json['student_fee_id'];
    installmentNo = json['installment_no'];
    amount = json['amount']?.toString();
    startDueDate = json['start_due_date'];
    endDueDate = json['end_due_date'];
    status = json['status'];
    paidOn = json['paid_on'];
    createdAt = json['created_at'];
    calculatedStatus = json['calculated_status'];
    fineAmount = json['fine_amount'];
    totalAmount = json['total_amount'];
  }
}

// ── Transport Fee Breakdown ────────────────────────────────────────────────────

class TransportFeeBreakdown {
  int? studentTransportFeeId;
  int? transportFeeId;
  String? feeHeadName;
  String? routeName;
  String? stopName;
  String? distanceKm;
  String? academicYear;
  num? baseAmount;
  String? feeFrequency;
  num? totalAmount;
  num? paidAmount;
  num? pendingAmount;
  num? fineAmount;
  String? status;
  String? assignedOn;
  String? discontinuedOn;
  List<TransportInstallment>? installments;

  TransportFeeBreakdown({
    this.studentTransportFeeId,
    this.transportFeeId,
    this.feeHeadName,
    this.routeName,
    this.stopName,
    this.distanceKm,
    this.academicYear,
    this.baseAmount,
    this.feeFrequency,
    this.totalAmount,
    this.paidAmount,
    this.pendingAmount,
    this.fineAmount,
    this.status,
    this.assignedOn,
    this.discontinuedOn,
    this.installments,
  });

  TransportFeeBreakdown.fromJson(Map<String, dynamic> json) {
    studentTransportFeeId = json['student_transport_fee_id'];
    transportFeeId = json['transport_fee_id'];
    feeHeadName = json['fee_head_name'];
    routeName = json['route_name'];
    stopName = json['stop_name'];
    distanceKm = json['distance_km']?.toString();
    academicYear = json['academic_year'];
    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];
    fineAmount = json['fine_amount'];
    status = json['status'];
    assignedOn = json['assigned_on'];
    discontinuedOn = json['discontinued_on'];

    if (json['installments'] != null) {
      installments = [];
      for (var v in json['installments']) {
        installments!.add(TransportInstallment.fromJson(v));
      }
    }
  }
}

class TransportInstallment {
  int? studentTransportInstallmentId;
  int? studentTransportFeeId;
  int? installmentNo;
  String? amount;
  String? startDueDate;
  String? endDueDate;
  String? dueDate;
  String? status;
  String? paidOn;
  String? createdAt;
  String? calculatedStatus;
  num? fineAmount;
  num? totalAmount;

  TransportInstallment({
    this.studentTransportInstallmentId,
    this.studentTransportFeeId,
    this.installmentNo,
    this.amount,
    this.startDueDate,
    this.endDueDate,
    this.dueDate,
    this.status,
    this.paidOn,
    this.createdAt,
    this.calculatedStatus,
    this.fineAmount,
    this.totalAmount,
  });

  TransportInstallment.fromJson(Map<String, dynamic> json) {
    studentTransportInstallmentId =
    json['student_transport_installment_id'];
    studentTransportFeeId = json['student_transport_fee_id'];
    installmentNo = json['installment_no'];
    amount = json['amount']?.toString();
    startDueDate = json['start_due_date'];
    endDueDate = json['end_due_date'];
    dueDate = json['due_date'];
    status = json['status'];
    paidOn = json['paid_on'];
    createdAt = json['created_at'];
    calculatedStatus = json['calculated_status'];
    fineAmount = json['fine_amount'];
    totalAmount = json['total_amount'];
  }
}

// ── Summary ────────────────────────────────────────────────────────────────────

class Summary {
  CurrentYear? currentYear;
  num? previousPending;
  num? previousFine;
  num? grandTotalPending;
  num? grandTotalFine;

  Summary({
    this.currentYear,
    this.previousPending,
    this.previousFine,
    this.grandTotalPending,
    this.grandTotalFine,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    currentYear = json['current_year'] != null
        ? CurrentYear.fromJson(json['current_year'])
        : null;
    previousPending = json['previous_pending'];
    previousFine = json['previous_fine'];
    grandTotalPending = json['grand_total_pending'];
    grandTotalFine = json['grand_total_fine'];
  }
}

class CurrentYear {
  num? total;
  num? paid;
  num? pending;
  num? fine;

  CurrentYear({this.total, this.paid, this.pending, this.fine});

  CurrentYear.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    paid = json['paid'];
    pending = json['pending'];
    fine = json['fine'];
  }
}