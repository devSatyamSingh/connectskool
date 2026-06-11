import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../res/api_url.dart';
import '../../view_model/user_view_model.dart';

class EditStudentRepository {
  final Dio _dio = Dio();

  Future<dynamic> editStudentApi({
    required String studentId,
    required String name,
    required String email,
    required String password,
    required String admission_no,
    required String class_id,
    required String section_id,
    required String gender,
    required String dob,
    required String mobileNumber,
    required String fatherName,
    required String motherName,
    required String address,
    required String religion,
    required String academicYear,
    required String passedOut,
    required String transfer,
    required String bloodGroup,
    required String category,
    required String aadharNumber,
    required String fatherOccupation,
    required String fatherMobile,
    required String motherOccupation,
    required String motherMobile,
    required String guardianName,
    required String emergencyContactNumber,
    required String city,
    required String state,
    required String pincode,
    required String roll_no,
    File? studentPhoto,
    File? aadharCard,
    File? fatherPhoto,
    File? motherPhoto,
  }) async {
    try {
      final token = await UserViewModel().getToken(); // 🔥 IMPORTANT

      FormData formData = FormData.fromMap({
        "student_id": studentId,
        "name": name,
        "user_email": email,
        "password": password,
        "admission_no": admission_no,
        "gender": gender,
        "class_id": class_id,
        "section_id": section_id,
        "dob":dob,
        "mobile_number":mobileNumber,
        "father_name":fatherName,
        "mother_name":motherName,
        "address":address,
        "religion":religion,
        "academic_year":academicYear,
        "passed_out":passedOut,
        "transfer":transfer,
        "blood_group":bloodGroup,
        "category":category,
        "aadhar_number":aadharNumber,
        "father_occupation":fatherOccupation,
        "father_mobile":fatherMobile,
        "mother_occupation":motherOccupation,
        "mother_mobile":motherMobile,
        "guardian_name":guardianName,
        "emergency_contact_number":emergencyContactNumber,
        "city":city,
        "state":state,
        "pincode":pincode,
          "roll_no": roll_no,

        if (studentPhoto != null)
          "student_photo":
          await MultipartFile.fromFile(studentPhoto.path),

        if (aadharCard != null)
          "aadhar_card":
          await MultipartFile.fromFile(aadharCard.path),

        if (fatherPhoto != null)
          "father_photo":
          await MultipartFile.fromFile(fatherPhoto.path),

        if (motherPhoto != null)
          "mother_photo":
          await MultipartFile.fromFile(motherPhoto.path),
      });

      final response = await _dio.put(
        ApiUrl.editStudent,
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
