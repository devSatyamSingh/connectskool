import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class SchoolTimetableRepo {

  final BaseApiServices api = NetworkApiServices();

  Future<dynamic> getTimetable(
      String classId,
      String sectionId,
      ) async {

    final url = "${ApiUrl.getTimetable}"
        "?class_id=$classId"
        "&section_id=$sectionId";

    return await api.getGetApiResponse(url);
  }
}