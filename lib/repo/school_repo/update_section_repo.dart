import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_pro/res/api_url.dart';
import 'package:school_pro/view_model/user_view_model.dart';

class SectionRepository {

  Future<bool> updateSection(UpdateSectionRequest request) async {

    final token = await UserViewModel().getToken();   // ✅ Token fetch

    final url = Uri.parse(ApiUrl.updateSection);

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",   // ✅ Token added
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
class UpdateSectionRequest {
  final int classId;
  final int sectionId;
  final String sectionName;
  final int capacity;

  UpdateSectionRequest({
    required this.classId,
    required this.sectionId,
    required this.sectionName,
    required this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      "class_id": classId,
      "section_id": sectionId,
      "section_name": sectionName,
      "capacity": capacity,
    };
  }
}