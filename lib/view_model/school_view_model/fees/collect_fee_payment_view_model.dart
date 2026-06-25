import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/fees/collect_fee_payment_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import 'school_student_fee_view_model.dart';

class CollectFeePaymentViewModel with ChangeNotifier {
  final _repo = CollectFeePaymentRepository();

  bool _loading = false;
  bool get loading => _loading;

  Map<String, dynamic>? _lastReceiptData;
  Map<String, dynamic>? get lastReceiptData => _lastReceiptData;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  Future<bool> collectFeePaymentApi({
    required dynamic studentId,
    required List<dynamic> installmentIds,
    List<dynamic>? transportInstallmentIds,
    required String paymentMode,
    String? transactionRef,
    String? remarks,
    required BuildContext context,
  }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.collectPayment)) {
      Utils.show("You don't have permission to collect fees.", context);
      return false;
    }

    _setLoading(true);

    final Map<String, dynamic> data = {
      'student_id': studentId,
      'installment_ids': installmentIds,
      if (transportInstallmentIds != null && transportInstallmentIds.isNotEmpty)
        'transport_installment_ids': transportInstallmentIds,
      'payment_mode': paymentMode.toLowerCase(),
      'payment_gateway': paymentMode.toLowerCase() == 'cash' ? 'offline' : 'online',
      if (transactionRef != null && transactionRef.isNotEmpty)
        'transaction_ref': transactionRef,
      if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
    };

    try {
      final response = await _repo.collectFeePaymentApi(data);

      final int statusCode =
          int.tryParse(response['status_code'].toString()) ?? 0;

      final String message =
          response['message']?.toString() ??
              response['error']?.toString() ??
              response['msg']?.toString() ??
              'Something went wrong';

      _setLoading(false);

      if (statusCode == 200 || statusCode == 201) {
        if (response['data'] != null) {
          _lastReceiptData = Map<String, dynamic>.from(response['data']);
        }

        final feeVm =
        Provider.of<StudentFeeViewModel>(context, listen: false);

        final info = feeVm.studentInfo;
        final year = feeVm.currentAcademicYear;

        if (info?.studentId != null && year != null) {
          await feeVm.refresh(info!.studentId!, year);
        }

        Utils.show(message, context);
        return true;
      }

      Utils.show(message, context);
      return false;
    } catch (e) {
      _setLoading(false);
      if (kDebugMode) print('CollectFeePayment Error: $e');
      Utils.show('Network error', context);
      return false;
    }
  }
}