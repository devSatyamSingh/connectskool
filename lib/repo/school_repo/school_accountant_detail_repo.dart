import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class SchoolAccountantDetailRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> schoolAccountantDetailApi(int accountantId) async {
    try {
      final url = "${ApiUrl.schoolAccountantDetail}?accountant_id=$accountantId";

      debugPrint("🌐 accountant Detail API URL: $url");

      final response = await _apiServices.getGetApiResponse(url);

      debugPrint("📥 accountant Detail API Response: $response");

      return response;
    } catch (e) {
      debugPrint("❌ Repository Error: $e");
      rethrow;
    }
  }
}
