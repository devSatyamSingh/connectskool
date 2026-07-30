import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/student/all_student_list_model.dart';
import '../../../res/api_url.dart';


class AllStudentListRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allStudentListApi({
    String? classId,
    String? sectionId,
    int page = 1,
    int limit = 20,
  }) async {
    String url = "${ApiUrl.allStudentList}?page=$page&limit=$limit";

    if (classId != null && classId.isNotEmpty) {
      url += "&class_id=$classId";
    }
    if (sectionId != null && sectionId.isNotEmpty) {
      url += "&section_id=$sectionId";
    }

    return await _apiServices.getGetApiResponse(url);
  }
}