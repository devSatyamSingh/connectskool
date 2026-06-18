import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class StudentProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> studentProfileApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.studentProfile);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during studentProfileApi: $e');
      }
      rethrow;
    }
  }
}
