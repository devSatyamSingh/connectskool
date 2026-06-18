import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';


class CreateExamTimeTableRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createExamTimeTableApi(dynamic data) async {
    try {
      debugPrint(" API URL: ${ApiUrl.createExamTimetable}");

      dynamic response = await _apiServices.getPostApiResponse(
          ApiUrl.createExamTimetable, data);

      debugPrint("API Raw Response: ${jsonEncode(response)}");
      return response;
    } catch (e) {
      debugPrint(' Error occurred during createExamTimeTableApi: $e');
      rethrow;
    }
  }
}
