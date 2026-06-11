import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/transport_model/route_student_model.dart';
import '../../../res/api_url.dart';

class GetRouteStudentsRepository {

  final BaseApiServices _apiServices = NetworkApiServices();

  Future<RouteStudentsModel> getRouteStudentsApi(
      String routeId,
      String academicYear
      ) async {

    try {

      String url =
          "${ApiUrl.getRouteStudents}?transport_route_id=$routeId&academic_year=$academicYear";

      final response = await _apiServices.getGetApiResponse(url);

      return RouteStudentsModel.fromJson(
          Map<String, dynamic>.from(response)
      );

    } catch (e) {

      if (kDebugMode) {
        print("Route Students API Error: $e");
      }

      rethrow;
    }
  }
}