import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../res/api_url.dart';
import '../../../view_model/auth_view_model/user_view_model.dart';

class EditAccountantRepository {
  final Dio _dio = Dio();

  Future<dynamic> editAccountantApi({
    required String accountantId,
    required String name,
    required String email,
    required String password,
    required String qualification,
    required String experienceYears,
    required String mobileNumber,
    required String address,
    required String fatherName,
    required String motherName,
    String? dob,            // ✅ ADD
    String? joiningDate,    // ✅ ADD
    String? employmentType, // ✅ ADD
    File? accountant_photo,
    File? aadharCard,
  }) async {
    try {
      final token = await UserViewModel().getToken();

      FormData formData = FormData.fromMap({
        "accountant_id"   : accountantId,
        "name"            : name,
        "user_email"      : email,
        "password"        : password,
        "qualification"   : qualification,
        "experience_years": experienceYears,
        "mobile_number"   : mobileNumber,
        "address"         : address,
        "father_name"     : fatherName,
        "mother_name"     : motherName,

        // ✅ Optional fields — sirf tab bhejo jab value ho
        if (dob != null && dob.isNotEmpty)
          "dob": dob,

        if (joiningDate != null && joiningDate.isNotEmpty)
          "joining_date": joiningDate,

        if (employmentType != null && employmentType.isNotEmpty)
          "employment_type": employmentType,

        if (accountant_photo != null)
          "accountant_photo": await MultipartFile.fromFile(accountant_photo.path),

        if (aadharCard != null)
          "aadhar_card": await MultipartFile.fromFile(aadharCard.path),
      });

      final response = await _dio.put(
        ApiUrl.editAccountant,
        data: formData,
        options: Options(
          headers: {
            "Accept"       : "application/json",
            "Authorization": "Bearer $token",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint("✅ Edit Accountant Response: ${response.data}");
      return response.data;

    } catch (e) {
      debugPrint("❌ EditAccountant API Error: $e");
      rethrow;
    }
  }
}