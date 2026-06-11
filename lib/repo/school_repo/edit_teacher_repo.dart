import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../res/api_url.dart';
import '../../view_model/user_view_model.dart';

class EditTeacherRepository {
  final Dio _dio = Dio();

  Future<dynamic> editTeacherApi({
    required String teacherId,
    required String name,
    required String email,
    required String password,
    required String qualification,
    required String experinceYears,
    required String joining_date,
    required String employeeId,
    required String gender,
    required String dob,
    required String employmentType,
    required String designation,
    required String mobileNumber,   // ✅ ADD
    required String address,        // ✅ ADD
    required String fatherName,     // ✅ ADD
    required String motherName,
    File? teacher_photo,
    File? aadharCard,
  }) async {
    try {
      final token = await UserViewModel().getToken(); // 🔥 IMPORTANT

      FormData formData = FormData.fromMap({
        "teacher_id": teacherId,
        "name": name,
        "user_email": email,
        "password": password,
        "qualification": qualification,
        "experience_years": experinceYears,
        "joining_date": joining_date,
        "employee_id": employeeId,
        "gender": gender,
        "dob": dob,
        "employment_type": employmentType,
        "designation": designation,
        "mobile_number": mobileNumber,   // ✅ ADD
        "address": address,              // ✅ ADD
        "father_name": fatherName,       // ✅ ADD
        "mother_name": motherName,

        if (teacher_photo != null)
          "teacher_photo": await MultipartFile.fromFile(teacher_photo.path),

        if (aadharCard != null)
          "aadhar_card": await MultipartFile.fromFile(aadharCard.path),

      });

      final response = await _dio.put(
        ApiUrl.editTeacher,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token", // 🔥 FIX
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint("✅ API Response: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("❌ EditStudent API Error: $e");
      rethrow;
    }
  }
}
