import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/transport_model/student_transport_model.dart';
import '../../../res/api_url.dart';

class GetStudentTransportRepository {

  final BaseApiServices _apiServices = NetworkApiServices();

  Future<AdminStudentTransportModel> getStudentTransportApi(
      String studentId,
      String academicYear,
      ) async {

    try {

      String url =
          "${ApiUrl.getStudentTransport}?student_id=$studentId&academic_year=$academicYear";

      final response = await _apiServices.getGetApiResponse(url);

      return AdminStudentTransportModel.fromJson(
        Map<String, dynamic>.from(response),
      );

    } catch (e) {

      if (kDebugMode) {
        print('Error occurred during getStudentTransportApi: $e');
      }

      rethrow;
    }
  }
}