import 'package:flutter/material.dart';
import '../../../model/school_model/transport_model/transport_all_student_model.dart';
import '../../../repo/school_repo/transport_repo/get_all_transport_student_repo.dart';
import '../../../utils/utils.dart';

class GetAllTransportStudentsViewModel extends ChangeNotifier {
  final GetAllTransportStudentsRepo _repo = GetAllTransportStudentsRepo();

  bool _loading = false;

  bool get loading => _loading;

  TransportStudentsModel? _transportStudentsModel;

  TransportStudentsModel? get transportStudentsModel => _transportStudentsModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getStudentsApi(String academicYear, BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _repo.getStudents(academicYear);

      final int statusCode = response["status_code"] ?? 500;

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);

        body.remove("status_code");

        _transportStudentsModel = TransportStudentsModel.fromJson(body);
      } else {
        _handleError(statusCode, response, context);
      }
    } catch (e) {
      Utils.show("Failed to load transport students", context, type: "error");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshStudents(
    String academicYear,
    BuildContext context,
  ) async {
    await getStudentsApi(academicYear, context);
  }

  void clearData() {
    _transportStudentsModel = null;

    notifyListeners();
  }

  void _handleError(int statusCode, Map response, BuildContext context) {
    switch (statusCode) {
      case 401:
        Utils.show("Unauthorized user", context, type: "error");
        break;

      case 403:
        Utils.show("Access denied", context, type: "error");
        break;

      case 404:
        Utils.show("Transport students not found", context, type: "error");
        break;

      case 500:
        Utils.show("Server error", context, type: "error");
        break;

      case 0:
        Utils.show("No Internet Connection", context, type: "error");
        break;

      default:
        Utils.show(
          response["message"] ?? "Something went wrong",
          context,
          type: "error",
        );
    }
  }
}
