import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/fees/delete_fees_head_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class DeleteFeesHeadViewModel with ChangeNotifier {
  final _repo = DeleteFeesHeadRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<Map<String, dynamic>> deleteFeesHeadApi(
      dynamic feeHeadId,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
      PermissionKeys.manageFees,
    )) {
      return {
        "success": false,
        "message": "You don't have permission to perform this action."
      };
    }

    setLoading(true);

    try {
      final response = await _repo.deleteFeesHeadApi({
        "fee_head_id": feeHeadId,
      });

      setLoading(false);

      return {
        "success": response['status_code'] == 200,
        "message": response['message'] ?? "Unknown response",
      };
    } catch (e) {
      setLoading(false);

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
