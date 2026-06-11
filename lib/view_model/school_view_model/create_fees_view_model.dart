import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/create_fees_repo.dart';
import '../../utils/utils.dart';
import 'fees_management_view_model.dart';

class CreateFeesViewModel with ChangeNotifier {
  final _loginRepo = CreateFeesRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createFeesApi(
    dynamic classId,
    dynamic feeHeadId,
    dynamic baseAmount,
    dynamic feeFrequency,
    dynamic academicYear,
    dynamic start_due_date,
    dynamic end_due_date,
    context,
  ) async {
    setLoading(true);

    Map data = {
      "class_id": classId,
      "fee_head_id": feeHeadId,
      "base_amount": baseAmount,
      "fee_frequency": feeFrequency,
      "academic_year": academicYear,
      "start_due_date":start_due_date,
      "end_due_date":end_due_date
    };

    try {
      final response = await _loginRepo.createFeesApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {

        Utils.show(
          message ?? "Fee structure created successfully",
          context,
        );

        await Provider.of<FeesManagementViewModel>(
          context,
          listen: false,
        ).feesManagementApi(context);

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
