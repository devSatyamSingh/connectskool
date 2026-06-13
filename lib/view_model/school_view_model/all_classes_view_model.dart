import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/all_classes_repo.dart';
import 'package:school_pro/utils/utils.dart';
import '../../model/school_model/all_classes_model.dart';

class AllClassesViewModel extends ChangeNotifier {
  final _allStudentListRepo = AllClassesRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllClassesModel? _allClassesModel;
  AllClassesModel? get allClassesModel => _allClassesModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ✅ ONLY API updates model
  Future<void> allClassesApi(BuildContext context) async {

    print("API CALL START");

    _setLoading(true);

    try {
      final response = await _allStudentListRepo.allClassesApi();

      print("API RESPONSE => $response");

      final int statusCode = response['status_code'];

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        _allClassesModel = AllClassesModel.fromJson(body);

        print(
          "TOTAL CLASSES => ${_allClassesModel?.data?.length}",
        );
      } else {
        _handleError(statusCode, response, context);
      }
    } catch (e) {
      print("ERROR => $e");
      Utils.show("Failed to load classes", context);
    }

    _setLoading(false);
  }

  void _handleError(
      int statusCode,
      Map response,
      BuildContext context,
      ) {
    switch (statusCode) {
      case 401:
        Utils.show("Unauthorized user", context);
        break;
      case 403:
        Utils.show("Access denied", context);
        break;
      case 404:
        Utils.show("Classes not found", context);
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
  }
}
