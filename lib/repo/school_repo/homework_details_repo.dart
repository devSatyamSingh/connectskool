import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class HomeworkDetailsRepository {
  final BaseApiServices api =
  NetworkApiServices();

  Future<dynamic> getHomeworkById(
      int homeworkId,
      ) async {
    final url =
        "${ApiUrl.getHomeworkById}?homework_id=$homeworkId";

    return await api.getGetApiResponse(
      url,
    );
  }
}