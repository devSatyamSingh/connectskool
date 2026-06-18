
import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';
class AllAccountantListRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allAccountantListApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.allAccountantList);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allAccountantListApi: $e');
      }
      rethrow;
    }
  }
}
