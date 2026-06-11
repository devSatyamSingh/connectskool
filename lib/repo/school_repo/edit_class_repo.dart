import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class EditClassRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> editClassApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPutApiResponse(ApiUrl.editClasses,data);
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return (response);
    } catch (e) {
      debugPrint('❌ Error occurred during editClassApi: $e');
      rethrow;
    }
  }
}
