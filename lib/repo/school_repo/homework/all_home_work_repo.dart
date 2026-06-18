// import 'package:flutter/foundation.dart';
// import '../../helper/network/base_api_services.dart';
// import '../../helper/network/network_api_services.dart';
// import '../../res/api_url.dart';
//
// class AllHomeWorkRepository {
//   final BaseApiServices _apiServices = NetworkApiServices();
//
//   Future<dynamic> allHomeworkApi() async {
//     try {
//       final url = "${ApiUrl.allHomework}";
//
//       debugPrint("🌐 Homework API URL: $url");
//
//       final response = await _apiServices.getGetApiResponse(url);
//
//       debugPrint("📥 Homework API Response: $response");
//
//       return response;
//     } catch (e) {
//       debugPrint("❌ Repository Error: $e");
//       rethrow;
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class AllHomeWorkRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allHomeworkApi() async {
    try {
      final url = ApiUrl.allHomework;
      debugPrint("🌐 Homework API URL: $url");
      final response = await _apiServices.getGetApiResponse(url);
      debugPrint("📥 Homework API Response: $response");
      return response;
    } catch (e) {
      debugPrint("❌ Repository Error: $e");
      rethrow;
    }
  }
}