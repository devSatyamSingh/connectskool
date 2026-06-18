import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class AllSectionsRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allSectionsApi(String classId) async {
    try {

      final url = "${ApiUrl.allSections}$classId";

      print("SECTION URL: $url");

      return await _apiServices.getGetApiResponse(url);

    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allSectionsApi: $e');
      }
      rethrow;
    }
  }
}