import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/accountant_repo/create_accountant_attebndance_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';

import '../../utils/utils.dart';
import '../school_view_model/all_accountant_list_view_model.dart';

class CreateAccountantAttendanceViewModel with ChangeNotifier {
  final _loginRepo = CreateAccountantAttendanceRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createAccountantAttendanceApi(
      dynamic accountantId,
      dynamic attendanceDate,
      dynamic status,
      dynamic remarks,
      context,
      ) async {
    setLoading(true);

    Map data = {
      "accountant_id": accountantId,
      "attendance_date": attendanceDate,
      "status": status,
      "remarks": remarks
    };

    try {
      final response = await _loginRepo.createAccountantAttendanceApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class created successfully", context);

        Provider.of<AllAccountantListVieModel>(
          context,
          listen: false,
        ).allAccountantListApi(context);
        // Navigator.pop(context);
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
