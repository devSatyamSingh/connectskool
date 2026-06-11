import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/fees_management_model.dart';
import 'package:school_pro/model/school_model/fine_rule_model.dart';
import 'package:school_pro/repo/school_repo/fees_management_repo.dart';
import 'package:school_pro/utils/utils.dart';

class FeesManagementViewModel extends ChangeNotifier {
  final _allStudentListRepo = FeesManagementRepository();

  bool _loading = false;
  bool get loading => _loading;

  FeesManagementModel? _feesManagementModel;
  FeesManagementModel? get feesManagementModel => _feesManagementModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _deleteLoading = false;

  bool get deleteLoading => _deleteLoading;

  void setDeleteLoading(bool value) {
    _deleteLoading = value;
    notifyListeners();
  }

  void setModelData(FeesManagementModel value) {
    _feesManagementModel = value;
    notifyListeners();
  }



  Future<Map<String, dynamic>> deleteFee(
      dynamic feeId,
      BuildContext context,
      ) async {
    try {
      setDeleteLoading(true);

      final response =
      await _allStudentListRepo.deleteFeeApi(feeId);

      setDeleteLoading(false);

      return {
        "success": response["success"] ?? false,
        "message": response["message"] ?? "Something went wrong",
      };
    } catch (e) {
      setDeleteLoading(false);

      return {
        "success": false,
        "message": "Network Error",
      };
    }
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> feesManagementApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.feesManagementApi();

      final int statusCode = response['status_code'];

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = FeesManagementModel.fromJson(body);
          setModelData(model);
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          Utils.show("Access denied", context);
          break;

        case 404:
          Utils.show("Students not found", context);
          break;

        case 500:
          Utils.show("Server error", context);
          break;

        case 0:
          Utils.show("No Internet Connection", context);
          break;

        default:
          Utils.show(response['message'] ?? "Something went wrong", context);
      }
    } catch (e) {
      Utils.show("Failed to load students", context);
    } finally {
      setLoading(false);
    }
  }
}
