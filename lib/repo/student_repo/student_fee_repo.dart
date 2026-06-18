
import '../../helper/network/network_api_services.dart';
import '../../model/student_model/student_fee_model.dart';
import '../../res/api_url.dart';

class StudentFeesRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<StudentFeesResponse> getStudentFees({
    required String academicYear,
  }) async {
    final response = await _apiServices.getGetApiResponse(
      "${ApiUrl.studentFees}?academic_year=$academicYear",
    );

    final body = Map<String, dynamic>.from(response);
    body.remove("status_code");

    return StudentFeesResponse.fromJson(body);
  }
}