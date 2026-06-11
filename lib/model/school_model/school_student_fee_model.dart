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
  List<dynamic>? paymentHistory;
  Summary? summary;

  Data({
    this.studentInfo,
    this.currentAcademicYear,
    this.feeBreakdown,
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
      json['fee_breakdown'].forEach((v) {
        feeBreakdown!.add(FeeBreakdown.fromJson(v));
      });
    }

    paymentHistory = json['payment_history'];

    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }
}

class StudentInfo {
  int? studentId;
  String? name;
  String? admissionNo;
  String? className;
  String? sectionName;
  int? classId;
  int? sectionId;

  StudentInfo({
    this.studentId,
    this.name,
    this.admissionNo,
    this.className,
    this.sectionName,
    this.classId,
    this.sectionId,
  });

  StudentInfo.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    name = json['name'];
    admissionNo = json['admission_no'];
    className = json['class_name'];
    sectionName = json['section_name'];
    classId = json['class_id'];
    sectionId = json['section_id'];
  }
}

class FeeBreakdown {
  int? studentFeeId;
  int? feeId;
  String? feeHeadName;
  String? academicYear;
  String? className;
  int? baseAmount;
  String? feeFrequency;
  int? totalAmount;
  int? paidAmount;
  int? pendingAmount;
  int? fineAmount;
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
      json['installments'].forEach((v) {
        installments!.add(Installment.fromJson(v));
      });
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
  int? fineAmount;
  int? totalAmount;

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
    amount = json['amount'];
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

class Summary {
  CurrentYear? currentYear;
  int? previousPending;
  int? previousFine;
  int? grandTotalPending;
  int? grandTotalFine;

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
  int? total;
  int? paid;
  int? pending;
  int? fine;

  CurrentYear({this.total, this.paid, this.pending, this.fine});

  CurrentYear.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    paid = json['paid'];
    pending = json['pending'];
    fine = json['fine'];
  }
}