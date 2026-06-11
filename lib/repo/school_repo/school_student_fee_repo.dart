import 'package:school_pro/res/api_url.dart';
import '../../helper/network/network_api_services.dart';

class StudentFeeRepository {

  final _api = NetworkApiServices();

  Future<dynamic> getStudentFees(
      int studentId,
      String academicYear,
      ) async {

    final url =
        "${ApiUrl.baseUrl}/schooladmin/getStudentFees"
        "?academic_year=$academicYear&student_id=$studentId";

    dynamic response = await _api.getGetApiResponse(url);

    return response;
  }
}