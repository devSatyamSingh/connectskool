import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/collect_fee_payment_repo.dart';
import 'package:school_pro/repo/school_repo/create_classes_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';

import '../../utils/utils.dart';

class CollectFeePaymentViewModel with ChangeNotifier {
  final _loginRepo = CollectFeePaymentRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> collectFeePaymentApi(
      dynamic student_id,
      dynamic installment_ids,
      dynamic payment_mode,
      dynamic transaction_ref,
      dynamic payment_gateway,
      dynamic remarks,
      context,
      ) async {
    setLoading(true);

    Map data = {
      "student_id": student_id,
      "installment_ids": installment_ids,
      "payment_mode": payment_mode,
      "transaction_ref": transaction_ref,
      "payment_gateway": payment_gateway,
      "remarks": remarks,
    };

    try {
      final response = await _loginRepo.collectFeePaymentApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class created successfully", context);

        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesApi(context);
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(
        //   context,
        //   RoutesName.classesPage,
        // );

        return true;
      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;
      } else if (statusCode == 401) {
        Utils.show("Unauthorized user", context);
        return false;
      } else if (statusCode == 500) {
        Utils.show("Server error. Try again later", context);
        return false;
      } else {
        Utils.show("Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("API Error: $e");

      Utils.show("Network error", context);
      return false;
    }
  }
}
