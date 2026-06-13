import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';

import '../../repo/school_repo/add_accountant_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class AddAccountantViewModel with ChangeNotifier {
  final _loginRepo = AddAccountantRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
    print("Loading state: $_loading"); // ✅ Debug loading state
  }

  Future<bool> addAccountantApi({
    required BuildContext context,
    required String name,
    required String user_email,
    required String password,
    required String qualification,
    required String experience_years,
    required String mobile_number,
    required String address,
    required String father_name,
    required String mother_name,
    required String dob,
    required String joining_date,
    required String employment_type,

    File? accountant_photo,
    File? aadharCard,
  }) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.addAccountant)) {

      Utils.show(
        "You don't have permission to add accountant",
        context,
      );

      return false;
    }
    setLoading(true);

    try {
      final Map<String, String> fields = {
        "name": name,
        "user_email": user_email,
        "password": password,
        "qualification": qualification,
        "experience_years": experience_years,
        "mobile_number": mobile_number,
        "address": address,
        "father_name": father_name,
        "mother_name": mother_name,
        // ✅ NEW FIELDS
        "dob": dob,
        "joining_date": joining_date,
        "employment_type": employment_type,
      };

      print("Fields being sent: $fields");

      final Map<String, dynamic> files = {
        "accountant_photo": accountant_photo,
        "aadhar_card": aadharCard,
      };

      print("Files being sent: $files");

      final response = await _loginRepo.addAccountantApi(fields, files);

      print("API Response: $response");

      setLoading(false);

      if (response["status_code"] == 200 || response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Accountant added", context);

        Provider.of<AllAccountantListVieModel>(
          context,
          listen: false,
        ).allAccountantListApi(context);

        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      print("Add Accountant Error: $e"); // ✅ Debug error
      Utils.show("Network error", context);
      return false;
    }
  }
}