import 'package:flutter/material.dart';

import '../../../model/school_model/marksheet/generate_marksheet_model.dart';
import '../../../repo/school_repo/marksheet/generate_marksheet_repo.dart';
import '../../../utils/utils.dart';

class GenerateMarksheetViewModel extends ChangeNotifier {
  final GenerateMarksheetRepo _repo = GenerateMarksheetRepo();

  bool _loading = false;

  bool get loading => _loading;

  GenerateMarksheetModel? _marksheetModel;

  GenerateMarksheetModel? get marksheetModel => _marksheetModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModel(GenerateMarksheetModel model) {
    _marksheetModel = model;
    notifyListeners();
  }

  Future<void> generateMarksheetApi({
    required String studentId,
    required String academicYear,
    required BuildContext context,
  }) async {
    setLoading(true);

    try {
      final response = await _repo.generateMarksheetApi(
        studentId: studentId,
        academicYear: academicYear,
      );

      final statusCode = response['status_code'];

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          body.remove('status_code');

          final model = GenerateMarksheetModel.fromJson(body);

          setModel(model);

          break;

        case 404:
          Utils.show("Marksheet not found", context);

          break;

        case 401:
          Utils.show("Unauthorized", context);

          break;

        case 500:
          Utils.show("Server Error", context);

          break;

        case 0:
          Utils.show("No Internet Connection", context);

          break;

        default:
          Utils.show(
            response['message']?.toString() ?? "Something went wrong",
            context,
          );
      }
    } catch (e) {
      Utils.show("Failed to load marksheet", context);
    } finally {
      setLoading(false);
    }
  }

  void clear() {
    _marksheetModel = null;

    notifyListeners();
  }

}
