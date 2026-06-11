import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_accountant_list_model.dart';
import 'package:school_pro/model/school_model/all_student_list_model.dart';
import 'package:school_pro/model/school_model/all_teachers_list_model.dart';
import 'package:school_pro/repo/school_repo/all_accountant_list_repo.dart';
import 'package:school_pro/repo/school_repo/all_student_list_repo.dart';
import 'package:school_pro/repo/school_repo/all_teachers_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AllAccountantListVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllAccountantListRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllAccountantListModel? _allAccountantListModel;
  AllAccountantListModel? get allAccountantListModel => _allAccountantListModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllAccountantListModel value) {
    _allAccountantListModel = value;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> allAccountantListApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allAccountantListApi();

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          // Remove status_code as it's not part of the model
          body.remove('status_code');

          // Parse data array and pagination
          final model = AllAccountantListModel.fromJson(body);
          setModelData(model);

          print("✅ Accountant fetched: ${model.data?.length ?? 0}");
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          Utils.show("Access denied", context);
          break;

        case 404:
          Utils.show("Accountant not found", context);
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
      print("❌ Exception fetching teachers: $e");
      Utils.show("Failed to load teachers", context);
    } finally {
      setLoading(false);
    }
  }
}
