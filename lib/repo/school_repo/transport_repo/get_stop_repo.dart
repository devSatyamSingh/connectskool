import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/transport_model/stop_model.dart';
import '../../../res/api_url.dart';

class GetStopRepository {

  final BaseApiServices _apiServices = NetworkApiServices();

  Future<StopModel> getStopApi(String routeId) async {

    try {

      String url = "${ApiUrl.getStops}?transport_route_id=$routeId";

      final response = await _apiServices.getGetApiResponse(url);

      return StopModel.fromJson(
          Map<String, dynamic>.from(response)
      );

    } catch (e) {

      if (kDebugMode) {
        print('Error occurred during getStopApi: $e');
      }

      rethrow;
    }
  }
}