import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class GenerateMarksheetRepo {

  final BaseApiServices _api = NetworkApiServices();

  Future<dynamic> generateMarksheetApi({
    required String studentId,
    required String academicYear,
  }) async {

    final url =
        "${ApiUrl.generateMarksheet}"
        "?student_id=$studentId"
        "&academic_year=$academicYear";

    return await _api.getGetApiResponse(url);
  }
}