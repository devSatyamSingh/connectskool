import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/delete_fees_head_view_model.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class DeleteFeesHeadViewModel with ChangeNotifier {
  final _repo = DeleteFeesHeadRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> deleteFeesHeadApi(dynamic feeHeadId, BuildContext context,) async {
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

    try {
      final response = await _repo.deleteFeesHeadApi({
        "fee_head_id": feeHeadId,
      });

      setLoading(false);

      return response['status_code'] == 200;

    } catch (e) {
      setLoading(false);
      if (kDebugMode) print(e);
      return false;
    }
  }

  // Future<bool> deleteFeesHeadApi(
  //     dynamic feeHeadId,
  //     BuildContext context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map<String, dynamic> data = {
  //     "fee_head_id": feeHeadId,
  //   };
  //
  //   try {
  //     // ✅ Pass the data to repo
  //     final response = await _repo.deleteFeesHeadApi(data);
  //
  //     setLoading(false);
  //
  //     final statusCode = response['status_code'];
  //     final message = response['message'];
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       Utils.show(message ?? "deleted successfully", context);
  //
  //       // Refresh subjects list
  //       // Provider.of<FeesHeadManagementViewModel>(context, listen: false)
  //       //     .feesHeadManagementApi(context);
  //
  //       return true;
  //     } else if (statusCode == 400) {
  //       Utils.show(message ?? "Invalid data", context);
  //       return false;
  //     } else if (statusCode == 401) {
  //       Utils.show("Unauthorized user", context);
  //       return false;
  //     } else if (statusCode == 500) {
  //       Utils.show("Server error. Try again later", context);
  //       return false;
  //     } else {
  //       Utils.show("Something went wrong", context);
  //       return false;
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     if (kDebugMode) print("API Error: $e");
  //     Utils.show("Network error", context);
  //     return false;
  //   }
  // }
}
