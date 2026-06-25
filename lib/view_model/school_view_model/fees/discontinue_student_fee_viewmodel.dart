import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/transport_repo/discontinue_student_repo.dart';
import '../../../repo/school_repo/fees/discontinue_student_fee_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import '../fees/school_student_fee_view_model.dart';

class DiscontinueStudentFeeViewModel with ChangeNotifier {
  final _repo = DiscontinueStudentFeeRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _lastMessage;
  String? get lastMessage => _lastMessage;

  bool? _lastSuccess;
  bool? get lastSuccess => _lastSuccess;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  /// ✅ API now takes student_fee_id (not academic_year)
  /// Matches Postman: student_id, student_fee_id, discontinued_on, discontinue_reason
  Future<bool> discontinueStudentFeeApi({
    required dynamic studentId,
    required dynamic studentFeeId,
    required String discontinuedOn,
    required String discontinueReason,
    required BuildContext context,
  }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.manageFees)) {
      Utils.show(
          "You don't have permission to perform this action.", context);
      return false;
    }

    _setLoading(true);

    final Map<String, dynamic> data = {
      'student_id': studentId,
      'student_fee_id': studentFeeId,
      'discontinued_on': discontinuedOn,
      'discontinue_reason': discontinueReason,
    };

    try {
      final response = await _repo.discontinueStudentFeeApi(data);
      _setLoading(false);

      final statusCode = response['status_code'];
      // ✅ Always show backend message
      final message = response['message']?.toString();
      _lastMessage = message;

      if (statusCode == 200 || statusCode == 201) {
        _lastSuccess = true;
        Utils.show(message ?? 'Fee discontinued successfully', context);

        // ✅ Refresh student fees after discontinue
        final feeVm =
        Provider.of<StudentFeeViewModel>(context, listen: false);
        final info = feeVm.studentInfo;
        final year = feeVm.currentAcademicYear;
        if (info?.studentId != null && year != null) {
          await feeVm.refresh(info!.studentId!, year);
        }

        return true;
      } else {
        _lastSuccess = false;
        Utils.show(
            message ?? _defaultError(statusCode), context);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _lastSuccess = false;
      _lastMessage = 'Network error';
      if (kDebugMode) print('DiscontinueStudentViewModel Error: $e');
      Utils.show('Network error. Please try again.', context);
      return false;
    }
  }

  String _defaultError(dynamic statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid data provided';
      case 401:
        return 'Unauthorized';
      case 404:
        return 'Fee record not found';
      case 409:
        return 'Fee already discontinued';
      case 500:
        return 'Server error. Try again later';
      default:
        return 'Something went wrong';
    }
  }
}