import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/transport_repo/get_route_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../../model/school_model/transport_model/route_model.dart';
class GetRouteViewModel extends ChangeNotifier {
  final _allStudentListRepo = GetRouteRepository();

  bool _loading = false;
  bool get loading => _loading;

  RouteModel? _routeModel;
  RouteModel? get routeModel => _routeModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(RouteModel value) {
    _routeModel = value;
    notifyListeners();
  }

  // 🔥 API CALL (POSTMAN STATUS CODE HANDLING)
  Future<void> getRouteApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _allStudentListRepo.getRouteApi();

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          // Remove status_code as it's not part of the model
          body.remove('status_code');

          // Parse data array and pagination
          final model = RouteModel.fromJson(body);
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
