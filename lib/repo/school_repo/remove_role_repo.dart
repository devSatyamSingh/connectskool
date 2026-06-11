import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class RemoveRoleRepository {

  final BaseApiServices _api =
  NetworkApiServices();

  Future<dynamic> removeRoleApi(
      dynamic data,
      ) async {

    return await _api.getPostApiResponse(
      ApiUrl.removeRolePermission,
      data,
    );
  }
}