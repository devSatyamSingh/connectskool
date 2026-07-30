import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class AllTeachersListRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allTeachersListApi({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url = "${ApiUrl.allTeachersList}?page=$page&limit=$limit";
      return await _apiServices.getGetApiResponse(url);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allTeachersListApi: $e');
      }
      rethrow;
    }
  }
}