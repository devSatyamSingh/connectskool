import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class CoScholasticGradeRepo {

  final BaseApiServices _apiServices =
  NetworkApiServices();

  Future<dynamic> getGradesApi({
    required String studentId,
    required String academicYear,
  }) async {
    try {

      final url =
          "${ApiUrl.getCoScholasticGrades}"
          "?student_id=$studentId"
          "&academic_year=$academicYear";

      return await _apiServices
          .getGetApiResponse(url);

    } catch (e) {

      if (kDebugMode) {
        print(
          "❌ getGradesApi => $e",
        );
      }

      rethrow;
    }
  }

  Future<dynamic> createGradeApi(
      Map<String, dynamic> data) async {

    try {

      return await _apiServices
          .getPostApiResponse(
        ApiUrl.createCoScholasticGrade,
        data,
      );

    } catch (e) {

      if (kDebugMode) {
        print(
          "❌ createGradeApi => $e",
        );
      }

      rethrow;
    }
  }

  Future<dynamic> updateGradeApi({
    required int gradeId,
    required String grade,
  }) async {

    try {

      return await _apiServices
          .getPutApiResponse(
        ApiUrl.updateCoScholasticGrade,
        {
          "grade_id": gradeId,
          "grade": grade,
        },
      );

    } catch (e) {

      if (kDebugMode) {
        print(
          "❌ updateGradeApi => $e",
        );
      }

      rethrow;
    }
  }

  Future<dynamic> deleteGradeApi({
    required int gradeId,
  }) async {

    try {

      return await _apiServices
          .getDeleteApiResponse(
        ApiUrl.deleteCoScholasticGrade,
        {
          "grade_id": gradeId,
        },
      );

    } catch (e) {

      if (kDebugMode) {
        print(
          "❌ deleteGradeApi => $e",
        );
      }

      rethrow;
    }
  }
}