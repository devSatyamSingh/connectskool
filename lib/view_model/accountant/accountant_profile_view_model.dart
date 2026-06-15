import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/accountant_model/accountant_profile_model.dart';
import 'package:school_pro/repo/accountant_repo/accountant_profile_repo.dart';
import 'package:school_pro/repo/student_repo/student_profile_repo.dart';
import '../../model/student_model/student_profile_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class AccountantProfileViewModel with ChangeNotifier {
  final AccountantProfileRepository _loginRepo = AccountantProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _permissionDenied = false;
  bool get permissionDenied => _permissionDenied;

  void setPermissionDenied(bool value) {
    _permissionDenied = value;
    notifyListeners();
  }

  AccountantProfileModel? _accountantProfileModel;
  AccountantProfileModel? get accountantProfileModel => _accountantProfileModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AccountantProfileModel value) {
    _accountantProfileModel = value;
    notifyListeners();
  }

  // [showMessage] = false (default) -> dashboard jaise auto-load screens se
  // call hone par koi toast NAHI dikhega, sirf permissionDenied flag set hoga.
  //
  // [showMessage] = true -> explicit user action (e.g. "View Profile" button)
  // par hi toast dikhana hai.
  Future<void> accountantProfileApi(
      BuildContext context, {
        bool showMessage = false,
      }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.viewAccountants)) {
      setPermissionDenied(true);

      if (showMessage) {
        Utils.show(
          "You don't have permission to view accountant profile",
          context,
        );
      }

      return;
    }

    setLoading(true);

    try {
      final response = await _loginRepo.accountantProfileApi();

      debugPrint("📥 Raw API Response: $response");

      if (response == null) {
        debugPrint("❌ API returned null response");
        return;
      }

      final Map<String, dynamic> json = Map<String, dynamic>.from(response);

      debugPrint("✅ Parsed JSON: $json");

      if (json['success'] == true) {
        final model = AccountantProfileModel.fromJson(json);
        setModelData(model);
      } else {
        debugPrint("⚠️ API failed: ${json['message']}");
      }
    } catch (e, stack) {
      debugPrint("❌ API Error: $e");
      debugPrint("🧵 StackTrace: $stack");
    } finally {
      setLoading(false);
    }
  }
}