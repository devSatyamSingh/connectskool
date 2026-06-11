import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class ExamManagementRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> examManagementApi() async {
    try {
      if (kDebugMode) {
        print('API URL: ${ApiUrl.examManagement}');
      }

      final response =
      await _apiServices.getGetApiResponse(ApiUrl.examManagement);

      if (kDebugMode) {
        print('Response: $response');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during examManagementApi: $e');
      }
      rethrow;
    }
  }
}