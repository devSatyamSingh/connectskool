import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../model/school_model/student/student_form_model.dart';
import '../../../res/api_url.dart';
import '../../../view_model/auth_view_model/user_view_model.dart';

class EditStudentRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> editStudentApi({
    required String studentId,
    required StudentFormModel form,
  }) async {
    try {
      final token = await UserViewModel().getToken();

      final Map<String, dynamic> fields = {
        "student_id": studentId,
        "name": form.name,
        "user_email": form.email,
        "admission_no": form.admissionNo,
        "gender": form.gender,
        "class_id": form.classId,
        "section_id": form.sectionId,
        "dob": form.dob,
        "mobile_number": form.mobileNumber,
        "father_name": form.fatherName,
        "mother_name": form.motherName,
        "address": form.address,
        "religion": form.religion,
        "academic_year": form.academicYear,
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
        "roll_no": form.rollNo,
      };

      // Only include password if admin explicitly set a new one
      if (form.password.isNotEmpty) {
        fields["password"] = form.password;
      }

      if (form.studentPhoto != null) {
        fields["student_photo"] =
        await MultipartFile.fromFile(form.studentPhoto!.path);
      }
      if (form.aadharCard != null) {
        fields["aadhar_card"] =
        await MultipartFile.fromFile(form.aadharCard!.path);
      }
      if (form.fatherPhoto != null) {
        fields["father_photo"] =
        await MultipartFile.fromFile(form.fatherPhoto!.path);
      }
      if (form.motherPhoto != null) {
        fields["mother_photo"] =
        await MultipartFile.fromFile(form.motherPhoto!.path);
      }

      final formData = FormData.fromMap(fields);

      if (kDebugMode) {
        debugPrint("🔥 EditStudent FormData: ${formData.fields}");
      }

      final response = await _dio.put(
        ApiUrl.editStudent,
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

      if (kDebugMode) debugPrint("✅ EditStudent Response: $data");
      return Map<String, dynamic>.from(data);
    } catch (e) {
      if (kDebugMode) debugPrint("❌ EditStudent Error: $e");
      rethrow;
    }
  }
}