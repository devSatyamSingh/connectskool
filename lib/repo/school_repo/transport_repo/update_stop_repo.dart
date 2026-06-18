import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class UpdateStopRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updateStopApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPutApiResponse(ApiUrl.updateStops,data);
      debugPrint(" API Raw Response: ${jsonEncode(response)}");
      return (response);
    } catch (e) {
      debugPrint(' Error occurred during updateStopApi: $e');
      rethrow;
    }
  }
}
