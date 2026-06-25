import 'package:school_pro/res/api_url.dart';
import '../../../helper/network/network_api_services.dart';

class DiscontinueStudentFeeRepository {
  final _api = NetworkApiServices();

  Future<dynamic> discontinueStudentFeeApi(Map data) async {
    try {
      final response = await _api.getPostApiResponse(
        ApiUrl.discontinueFee,
        data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}