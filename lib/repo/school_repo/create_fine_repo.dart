import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class CreateFineRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createFineApi(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        ApiUrl.createFineRule,
        data,
      );

      debugPrint(
        "✅ CREATE FINE RESPONSE => ${jsonEncode(response)}",
      );

      return response;
    } catch (e) {
      debugPrint("❌ CREATE FINE ERROR => $e");
      rethrow;
    }
  }

  Future<dynamic> updateFineApi(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.getPutApiResponse(
        ApiUrl.updateFineRule,
        data,
      );

      debugPrint(
        "✅ UPDATE FINE RESPONSE => ${jsonEncode(response)}",
      );

      return response;
    } catch (e) {
      debugPrint("❌ UPDATE FINE ERROR => $e");
      rethrow;
    }
  }

  Future<dynamic> deleteFineApi(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.getDeleteApiResponse(
        ApiUrl.deleteFineRule,
        data,
      );

      debugPrint(
        "✅ DELETE FINE RESPONSE => ${jsonEncode(response)}",
      );

      return response;
    } catch (e) {
      debugPrint("❌ DELETE FINE ERROR => $e");
      rethrow;
    }
  }
}