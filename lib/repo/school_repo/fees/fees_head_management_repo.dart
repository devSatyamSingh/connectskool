import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';


class FeesHeadManagementRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> feesHeadManagementApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.feesHead);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during feesHeadManagementApi: $e');
      }
      rethrow;
    }
  }
}
