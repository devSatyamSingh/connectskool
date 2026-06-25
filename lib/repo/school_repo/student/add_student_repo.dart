import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../model/school_model/student/student_form_model.dart';
import '../../../res/api_url.dart';
import '../../../view_model/auth_view_model/user_view_model.dart';

class AddStudentRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> addStudentApi(StudentFormModel form) async {
    try {
      final token = await UserViewModel().getToken();

      final formData = FormData.fromMap({
        "name": form.name,
        "user_email": form.email,
        "password": form.password,
        "class_id": form.classId,
        "section_id": form.sectionId,
        "admission_no": form.admissionNo,
        "gender": form.gender,
        "academic_year": form.academicYear,
        // Send each fee head as selected_fee_heads[] array entries
        for (final id in form.selectedFeeHeadIds)
          "selected_fee_heads[]": id,
        "roll_no": form.rollNo,
        "dob": form.dob,
        "mobile_number": form.mobileNumber,
        "father_name": form.fatherName,
        "mother_name": form.motherName,
        "address": form.address,
        "religion": form.religion,
        "passed_out": form.passedOut,
        "transfer": form.transfer,
        "blood_group": form.bloodGroup,
        "category": form.category,
        "aadhar_number": form.aadharNumber,
        "father_occupation": form.fatherOccupation,
        "father_mobile": form.fatherMobile,
        "mother_occupation": form.motherOccupation,
        "mother_mobile": form.motherMobile,
        "guardian_name": form.guardianName,
        "emergency_contact_number": form.emergencyContactNumber,
        "city": form.city,
        "state": form.state,
        "pincode": form.pincode,
        if (form.studentPhoto != null)
          "student_photo":
          await MultipartFile.fromFile(form.studentPhoto!.path),
        if (form.aadharCard != null)
          "aadhar_card": await MultipartFile.fromFile(form.aadharCard!.path),
        if (form.fatherPhoto != null)
          "father_photo": await MultipartFile.fromFile(form.fatherPhoto!.path),
        if (form.motherPhoto != null)
          "mother_photo": await MultipartFile.fromFile(form.motherPhoto!.path),
      });

      if (kDebugMode) {
        debugPrint("🔥 AddStudent FormData: ${formData.fields}");
      }

      final response = await _dio.post(
        ApiUrl.registerStudent,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final data = response.data is Map
          ? {...response.data as Map, "status_code": response.statusCode}
          : {"status_code": response.statusCode, "message": "Unknown error"};

      if (kDebugMode) debugPrint("✅ AddStudent Response: $data");
      return Map<String, dynamic>.from(data);
    } catch (e) {
      if (kDebugMode) debugPrint("❌ AddStudent Error: $e");
      rethrow;
    }
  }
}