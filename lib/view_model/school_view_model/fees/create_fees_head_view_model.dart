import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import '../../../repo/school_repo/fees/create_fees_head_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import 'fees_management_view_model.dart';

class CreateFeesHeadViewModel with ChangeNotifier {
  final _loginRepo = CreateFeesHeadRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createFeesHeadApi(
      dynamic headName,
      dynamic description,

      context,
      ) async {
    if (!PermissionExtensions.canAccess(
      PermissionKeys.manageFees,
    )) {
      Utils.show(
        "You don't have permission to perform this action.",
        context,
      );
      return false;
    }
    setLoading(true);

    Map data = {
      "head_name": headName,
      "description": description

    };

    try {
      final response = await _loginRepo.createFeesHeadApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class created successfully", context);

        Navigator.pop(context);
        Provider.of<FeesHeadManagementViewModel>(
          context,
          listen: false,
        ).feesHeadManagementApi(context);
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
