import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/settings/cms_model.dart';
import '../../../res/api_url.dart';

class CmsRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<CmsModel> getAllCmsPages() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        ApiUrl.getAllCmsPages,
      );

      return CmsModel.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      rethrow;
    }
  }
}
