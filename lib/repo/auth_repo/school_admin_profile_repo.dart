import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class SchoolAdminProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> schoolAdminProfileApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.schoolAdminProfile);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during schoolAdminProfileApi: $e');
      }
      rethrow;
    }
  }
}
