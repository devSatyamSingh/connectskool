import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/create_classes_repo.dart';
import 'package:school_pro/repo/school_repo/create_fine_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fine_rule_view_model.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class CreateFineViewModel with ChangeNotifier {
  final _loginRepo = CreateFineRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> createFineApi(
      dynamic ruleName,
      dynamic fineType,
      dynamic fineAmount,
      dynamic gracePeriodDays,
      dynamic maxFineCap,
      dynamic applicableTo,
      dynamic feeHeadId,
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

    // ✅ Sirf required fields pehle
    // Map<String, dynamic> data = {
    //   "rule_name"    : ruleName,
    //   "fine_type"    : fineType,
    //   "fine_amount"  : fineAmount,
    //   "applicable_to": applicableTo,
    // };
    Map<String, dynamic> data = {
      "rule_name"    : ruleName,
      "fine_type"    : fineType,
      "fine_amount"  : fineAmount,
      // ✅ "specific_fee" → "specific_fee_head" map karo
      "applicable_to": applicableTo == "specific_fee"
          ? "specific_fee_head"
          : applicableTo,
    };
    // ✅ Optional fields — sirf tab add karo jab value ho
    if (gracePeriodDays != null && gracePeriodDays.toString().isNotEmpty) {
      data["grace_period_days"] = gracePeriodDays;
    }
    if (maxFineCap != null && maxFineCap.toString().isNotEmpty) {
      data["max_fine_cap"] = maxFineCap;
    }
    if (feeHeadId != null) {
      data["fee_head_id"] = feeHeadId;
    }

    if (kDebugMode) print("CreateFine payload 👉 $data");

    try {
      final response = await _loginRepo.createFineApi(data);
      setLoading(false);

      final statusCode = response['status_code'];
      final message    = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Fine rule created successfully", context);
        Provider.of<FineRuleViewModel>(context, listen: false)
            .fineRuleApi(context);
        Navigator.pop(context);
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
      if (kDebugMode) print("CreateFine Error 👉 $e");
      Utils.show("Network error", context);
      return false;
    }
  }

  Future<bool> _handleResponse(
      dynamic response,
      BuildContext context,
      ) async {
    final statusCode = response['status_code'];
    final message = response['message'];

    if (statusCode == 200 || statusCode == 201) {
      Utils.show(message ?? "Success", context);

      Provider.of<FineRuleViewModel>(
        context,
        listen: false,
      ).fineRuleApi(context);

      return true;
    }

    if (statusCode == 400) {
      Utils.show(message ?? "Invalid data", context);
      return false;
    }

    if (statusCode == 401) {
      Utils.show(message ?? "Unauthorized", context);
      return false;
    }

    if (statusCode == 500) {
      Utils.show("Server Error", context);
      return false;
    }

    Utils.show(
      message ?? "Something went wrong",
      context,
    );

    return false;
  }

  Future<bool> updateFineApi(
      dynamic fineRuleId,
      dynamic ruleName,
      dynamic fineType,
      dynamic fineAmount,
      dynamic gracePeriodDays,
      dynamic maxFineCap,
      dynamic applicableTo,
      dynamic feeHeadId,
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

    try {
      Map<String, dynamic> data = {
        "fine_rule_id": fineRuleId,
        "rule_name": ruleName,
        "fine_type": fineType,
        "fine_amount": fineAmount,
        "applicable_to":
        applicableTo == "specific_fee"
            ? "specific_fee_head"
            : applicableTo,
      };

      if (gracePeriodDays != null &&
          gracePeriodDays.toString().isNotEmpty) {
        data["grace_period_days"] = gracePeriodDays;
      }

      if (maxFineCap != null &&
          maxFineCap.toString().isNotEmpty) {
        data["max_fine_cap"] = maxFineCap;
      }

      if (feeHeadId != null) {
        data["fee_head_id"] = feeHeadId;
      }

      final response =
      await _loginRepo.updateFineApi(data);

      final success =
      await _handleResponse(response, context);

      if (success) {
        Navigator.pop(context);
      }

      return success;
    } catch (e) {
      Utils.show(
        "Failed to update fine rule",
        context,
      );

      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteFineApi(
      dynamic fineRuleId,
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

    try {
      final response =
      await _loginRepo.deleteFineApi({
        "fine_rule_id": fineRuleId,
      });

      return await _handleResponse(
        response,
        context,
      );
    } catch (e) {
      Utils.show(
        "Failed to delete fine rule",
        context,
      );

      return false;
    } finally {
      setLoading(false);
    }
  }
}
