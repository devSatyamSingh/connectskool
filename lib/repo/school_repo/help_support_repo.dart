import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../model/school_model/help_support_model.dart';
import '../../res/api_url.dart';

class SupportTicketRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SupportTicketModel> createSupportTicket({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        ApiUrl.createSupportTicket,
        {
          "title": title,
          "description": description,
        },
      );

      return SupportTicketModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    } catch (e) {
      rethrow;
    }
  }
}