import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/classes/edit_class_repo.dart';
import 'package:school_pro/repo/school_repo/fees/edit_fees_head_repo.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class EditFeesHeadViewModel with ChangeNotifier {
  final _loginRepo = EditFeesHeadRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> editFeesHeadApi(
      dynamic feeHeadId,
      dynamic headName,
      dynamic description,
      BuildContext context,
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
      "fee_head_id": feeHeadId,
      "head_name": headName,
      "description": description,
    };

    try {
      final response = await _loginRepo.editFeesHeadApi(data);

      setLoading(false);

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        Utils.show(response['message'], context);
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
