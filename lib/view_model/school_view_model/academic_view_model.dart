import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/academic_model.dart';
import 'package:school_pro/repo/school_repo/academic_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AcademicViewModel extends ChangeNotifier {
  final _allStudentListRepo = AcademicRepository();

  bool _loading = false;
  bool get loading => _loading;

  AcademicModel? _academicModel;
  AcademicModel? get academicModel => _academicModel;

  // ── Getters ─────────────────────────────────────────────
  List<AcademicData> get years => _academicModel?.data ?? [];

  AcademicData? get currentYear => years.where((y) => y.isCurrent == 1).isNotEmpty
      ? years.firstWhere((y) => y.isCurrent == 1)
      : null;

  void _setLoading(bool value) {
    _loading = value;
  }

  Future<void> academicApi(BuildContext context) async {
    _setLoading(true);
    notifyListeners();

    try {
      final response = await _allStudentListRepo.academicApi();
      final int statusCode = response['status_code'];

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');
        _academicModel = AcademicModel.fromJson(body);
      } else {
        _handleError(statusCode, response, context);
      }
    } catch (e) {
      Utils.show("Failed to load Academic year", context);
    }

    _setLoading(false);
    notifyListeners();
  }

  void _handleError(int statusCode, Map response, BuildContext context) {
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