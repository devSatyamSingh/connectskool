import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_subjects_model.dart';
import 'package:school_pro/model/school_model/fine_rule_model.dart';
import 'package:school_pro/repo/school_repo/fine_rule_repo.dart';
import 'package:school_pro/utils/utils.dart';

class FineRuleViewModel extends ChangeNotifier {
  final _allStudentListRepo = FineRuleRepository();

  bool _loading = false;
  bool get loading => _loading;

  FineRuleModel? _fineRuleModel;
  FineRuleModel? get fineRuleModel => _fineRuleModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(FineRuleModel value) {
    _fineRuleModel = value;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> fineRuleApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.fineRuleApi();

      final int statusCode = response['status_code'];

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = FineRuleModel.fromJson(body);
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
