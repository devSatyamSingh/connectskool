import 'package:school_pro/res/api_url.dart';
import '../../../helper/network/network_api_services.dart';

class GenerateAdmitCardRepo {

  final _api = NetworkApiServices();

  Future<dynamic> generateAdmitCard(
      int examId,
      int classId,
      int sectionId,
      int studentId
      ) async {

    String url =
        "${ApiUrl.generateAdmitCard}?exam_id=$examId&class_id=$classId&section_id=$sectionId&student_id=$studentId";

    final response = await _api.getGetApiResponse(url);

    return response;
  }
}