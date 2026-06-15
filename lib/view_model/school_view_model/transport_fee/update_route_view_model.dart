import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/transport_repo/update_route_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class UpdateRouteViewModel with ChangeNotifier {
  final _loginRepo = UpdateRouteRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> updateRouteApi(
      dynamic transportRouteId,
      dynamic routeName,
      dynamic vehicleNo,
      dynamic driverName,
      dynamic driverPhone,
      BuildContext context,
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
      "transport_route_id": transportRouteId,
      "route_name": routeName,
      "vehicle_no": vehicleNo,
      "driver_name": driverName,
      "driver_phone": driverPhone,
    };


    try {
      final response = await _loginRepo.updateRouteApi(data);

      setLoading(false);

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        Utils.show(response['message'], context);

        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesApi(context);
        return true; // ✅ bas yahin khatam
      }

      Utils.show(response['message'] ?? "Something went wrong", context);
      return false;

    } catch (e) {
      setLoading(false);
      Utils.show("Network error", context);
      return false;
    }
  }

}
