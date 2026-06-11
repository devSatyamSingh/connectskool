import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class FeesManagementRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> feesManagementApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.allFees);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during feesManagementApi: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> deleteFeeApi(dynamic feeId) async {
    try {
      return await _apiServices.getDeleteApiResponse(
        ApiUrl.deleteFee,
        {
          "fee_id": feeId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
