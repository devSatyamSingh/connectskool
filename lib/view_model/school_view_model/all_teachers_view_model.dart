import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/all_student_list_model.dart';
import 'package:school_pro/model/school_model/all_teachers_list_model.dart';
import 'package:school_pro/repo/school_repo/all_student_list_repo.dart';
import 'package:school_pro/repo/school_repo/all_teachers_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AllTeachersListVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllTeachersListRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllTeachersListModel? _allTeachersListModel;
  AllTeachersListModel? get allTeachersListModel => _allTeachersListModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllTeachersListModel value) {
    _allTeachersListModel = value;
    notifyListeners();
  }

  Future<void> allTeachersListApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allTeachersListApi();

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          // Remove status_code as it's not part of the model
          body.remove('status_code');

          // Parse data array and pagination
          final model = AllTeachersListModel.fromJson(body);
          setModelData(model);

          if (kDebugMode) {
            print("✅ Teachers fetched: ${model.data.length ?? 0}");
          }
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;

        case 403:
          Utils.show("Access denied", context);
          break;

        case 404:
          Utils.show("Teachers not found", context);
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
