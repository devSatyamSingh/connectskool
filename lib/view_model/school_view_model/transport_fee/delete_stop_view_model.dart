import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/timetable/delete_classes_time_table_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/delete_route_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/delete_stop_repo.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class DeleteStopViewModel with ChangeNotifier {
  final _repo = DeleteStopRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> deleteRouteApi(
      dynamic transportRouteStopId,
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

    Map<String, dynamic> data = {
      "transport_route_stop_id": transportRouteStopId,
    };

    try {
      // ✅ Pass the data to repo
      final response = await _repo.deleteStopApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "stop deleted successfully", context);

        // Refresh subjects list
        Provider.of<AllClassesViewModel>(context, listen: false)
            .allClassesApi(context);

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
