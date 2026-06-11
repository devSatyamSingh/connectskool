// ============================================================
// lib/features/fees/repo/student_fees_repo.dart
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/student_model/student_fee_model.dart';

class StudentFeesRepo {
  static const String _baseUrl =
      'https://university.fctesting.shop/api/student';

  /// Fetch student fees for a given academic year.
  /// Pass the token (Bearer) that your app stores after login.
  Future<StudentFeesResponse> getStudentFees({
    required String academicYear,
    required String token,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/getStudentFeesStudentSide?academic_year=$academicYear',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return StudentFeesResponse.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to fetch fees — HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}