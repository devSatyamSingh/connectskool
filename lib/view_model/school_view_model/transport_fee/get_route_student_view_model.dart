import 'package:flutter/material.dart';
import '../../../model/school_model/transport_model/route_student_model.dart';
import '../../../repo/school_repo/transport_repo/get_route_student_repo.dart';

class GetRouteStudentsViewModel with ChangeNotifier {

  final _repo = GetRouteStudentsRepository();

  bool loading = false;

  RouteStudentsModel? routeStudentsModel;

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getRouteStudentsApi(
      String routeId,
      String academicYear,
      BuildContext context
      ) async {

    setLoading(true);

    try {

      final response = await _repo.getRouteStudentsApi(routeId, academicYear);

      routeStudentsModel = response;

      setLoading(false);

    } catch (e) {

      setLoading(false);

      debugPrint("ViewModel Error: $e");
    }
  }
}