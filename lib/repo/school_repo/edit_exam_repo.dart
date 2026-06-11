import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class EditExamRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> editExamApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPutApiResponse(ApiUrl.updateExam,data);
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return (response);
    } catch (e) {
      debugPrint('❌ Error occurred during editExamApi: $e');
      rethrow;
    }
  }
}
