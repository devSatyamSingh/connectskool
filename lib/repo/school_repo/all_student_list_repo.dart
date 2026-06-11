import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../model/school_model/all_student_list_model.dart';
import '../../res/api_url.dart';


class AllStudentListRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allStudentListApi({
    String? classId,
    String? sectionId,
  }) async {

    String url = ApiUrl.allStudentList;

    if (classId != null && sectionId != null) {
      url =
      "${ApiUrl.allStudentList}?class_id=$classId&section_id=$sectionId";
    }

    return await _apiServices.getGetApiResponse(url);
  }}
