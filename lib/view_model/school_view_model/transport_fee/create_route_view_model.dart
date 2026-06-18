import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/classes/create_classes_repo.dart';
import 'package:school_pro/repo/school_repo/fees/create_fine_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/create_route_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fine_rule_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateRouteViewModel with ChangeNotifier {
  final _loginRepo = CreateRouteRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createFineApi(
      dynamic routeName,
      dynamic vehicleNo,
      dynamic driverName,
      dynamic driverPhone,

      context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageTransport)) {

      Utils.show(
        "You don't have permission to perform this action.",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "route_name": routeName,
      "vehicle_no": vehicleNo,
      "driver_name": driverName,
      "driver_phone":driverPhone
    };

    try {
      final response = await _loginRepo.createRouteApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Route created successfully", context);

        Provider.of<FineRuleViewModel>(
          context,
          listen: false,
        ).fineRuleApi(context);
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
        Utils.show(message ?? "Unauthorized user", context);
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
