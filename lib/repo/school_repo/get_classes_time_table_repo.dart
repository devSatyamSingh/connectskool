
import 'package:school_pro/res/api_url.dart';

import '../../helper/network/network_api_services.dart';

class GetClassTimeTableRepository {

  final _apiServices = NetworkApiServices();

  Future<dynamic> getClassTimeTableApi(int classId, int sectionId) async {

    String url =
        "${ApiUrl.getClassTimeTable}?class_id=$classId&section_id=$sectionId";

    final response = await _apiServices.getGetApiResponse(url);

    return response;
  }
}