import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/accountant_model/accountant_profile_model.dart';
import 'package:school_pro/repo/accountant_repo/accountant_profile_repo.dart';
import 'package:school_pro/repo/student_repo/student_profile_repo.dart';
import '../../model/student_model/student_profile_model.dart';

class AccountantProfileViewModel with ChangeNotifier {
  final AccountantProfileRepository _loginRepo = AccountantProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

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

  Future<void> accountantProfileApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _loginRepo.accountantProfileApi();

      debugPrint("📥 Raw API Response: $response");

      if (response == null) {
        debugPrint("❌ API returned null response");
        return;
      }

      final Map<String, dynamic> json =
      Map<String, dynamic>.from(response);

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