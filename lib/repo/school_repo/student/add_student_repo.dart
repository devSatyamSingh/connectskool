// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import '../../res/api_url.dart';
// import '../../view_model/user_view_model.dart';
//
// class AddStudentRepository {
//   final Dio _dio = Dio();
//
//   Future<dynamic> addStudentApi({
//     required String name,
//     required String email,
//     required String password,
//     required String class_id,
//     required String section_id,
//     required String admission_no,
//     required String gender,
//     required String academic_year,
//     required String selected_fee_heads,
//     required String roll_no,
//     required String dob,
//     required String mobile_number,
//     required String father_name,
//     required String mother_name,
//     required String address,
//     required String religion,
//     required String passed_out,
//     required String transfer,
//     required String blood_group,
//     required String category,
//     required String aadhar_number,
//     required String father_occupation,
//     required String father_mobile,
//     required String mother_occupation,
//     required String mother_mobile,
//     required String guardian_name,
//     required String emergency_contact_number,
//     required String state,
//     required String city,
//     required String pincode,
//     File? student_photo,
//     File? aadharCard,
//     File? father_photo,
//     File? mother_photo,
//   }) async {
//     try {
//       final token = await UserViewModel().getToken(); // 🔥 IMPORTANT
//
//       FormData formData = FormData.fromMap({
//         "name": name,
//         "user_email": email,
//         "password": password,
//         "class_id": class_id,
//         "section_id": section_id,
//         "admission_no": admission_no,
//         "gender": gender,
//         "academic_year": academic_year,
//         "selected_fee_heads": selected_fee_heads,
//         "roll_no": roll_no,
//         "dob": dob,
//         "mobile_number":mobile_number,
//         "father_name":father_name,
//         "mother_name":mother_name,
//         "address":address,
//         "religion":religion,
//         "passed_out":passed_out,
//         "transfer":transfer,
//         "blood_group":blood_group,
//         "category":category,
//         "aadhar_number":aadhar_number,
//         "father_occupation":father_occupation,
//         "father_mobile":father_mobile,
//         "mother_occupation":mother_occupation,
//         "mother_mobile":mother_mobile,
//         "guardian_name":guardian_name,
//         "emergency_contact_number":emergency_contact_number,
//         "city":city,
//         "state":state,
//         "pincode":pincode,
//
//         if (student_photo != null)
//           "student_photo": await MultipartFile.fromFile(student_photo.path),
//
//         if (aadharCard != null)
//           "aadhar_card": await MultipartFile.fromFile(aadharCard.path),
//         if (father_photo != null)
//           "aadhar_card": await MultipartFile.fromFile(father_photo.path),
//         if (mother_photo != null)
//           "mother_photo": await MultipartFile.fromFile(mother_photo.path),
//
//       });
//
//       final response = await _dio.post(
//         ApiUrl.registerStudent,
//         data: formData,
//         options: Options(
//           headers: {
//             "Accept": "application/json",
//             "Authorization": "Bearer $token", // 🔥 FIX
//           },
//           validateStatus: (status) => status != null && status < 500,
//         ),
//       );
//
//       debugPrint("✅ API Response: ${response.data}");
//       return response.data;
//     } catch (e) {
//       debugPrint("❌ EditStudent API Error: $e");
//       rethrow;
//     }
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../res/api_url.dart';
import '../../../view_model/auth_view_model/user_view_model.dart';

class AddStudentRepository {
  final Dio _dio = Dio();

  Future<dynamic> addStudentApi({
    required String name,
    required String email,
    required String password,
    required String class_id,
    required String section_id,
    required String admission_no,
    required String gender,
    required String academic_year,
    required String selected_fee_heads,
    required String roll_no,
    required String dob,
    required String mobile_number,
    required String father_name,
    required String mother_name,
    required String address,
    required String religion,
    required String passed_out,
    required String transfer,
    required String blood_group,
    required String category,
    required String aadhar_number,
    required String father_occupation,
    required String father_mobile,
    required String mother_occupation,
    required String mother_mobile,
    required String guardian_name,
    required String emergency_contact_number,
    required String state,
    required String city,
    required String pincode,
    File? student_photo,
    File? aadharCard,
    File? father_photo,
    File? mother_photo,
  }) async {
    try {
      final token = await UserViewModel().getToken();

      // ✅ Debug print
      if (kDebugMode) {
        print("🔥 REPO selected_fee_heads: '$selected_fee_heads'");
      }

      FormData formData = FormData.fromMap({
        "name": name,
        "user_email": email,
        "password": password,
        "class_id": class_id,
        "section_id": section_id,
        "admission_no": admission_no,
        "gender": gender,
        "academic_year": academic_year,
        "selected_fee_heads[]": selected_fee_heads,
        // "selected_fee_heads": "1",
        "roll_no": roll_no,
        "dob": dob,
        "mobile_number": mobile_number,
        "father_name": father_name,
        "mother_name": mother_name,
        "address": address,
        "religion": religion,
        "passed_out": passed_out,
        "transfer": transfer,
        "blood_group": blood_group,
        "category": category,
        "aadhar_number": aadhar_number,
        "father_occupation": father_occupation,
        "father_mobile": father_mobile,
        "mother_occupation": mother_occupation,
        "mother_mobile": mother_mobile,
        "guardian_name": guardian_name,
        "emergency_contact_number": emergency_contact_number,
        "city": city,
        "state": state,
        "pincode": pincode,

        if (student_photo != null)
          "student_photo": await MultipartFile.fromFile(student_photo.path),
        if (aadharCard != null)
          "aadhar_card": await MultipartFile.fromFile(aadharCard.path),
        if (father_photo != null)
          "father_photo": await MultipartFile.fromFile(father_photo.path), // ✅ fix
        if (mother_photo != null)
          "mother_photo": await MultipartFile.fromFile(mother_photo.path),
      });

      // ✅ FormData fields print
      if (kDebugMode) {
        print("🔥 FormData fields: ${formData.fields}");
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

      // ✅ status_code manually add karo
      final responseData = response.data is Map
          ? {...response.data, "status_code": response.statusCode}
          : {"status_code": response.statusCode, "message": "Unknown error"};

      if (kDebugMode) {
        print("✅ API Response: $responseData");
      }

      return responseData;

    } catch (e) {
      if (kDebugMode) {
        print("❌ AddStudent API Error: $e");
      }
      rethrow;
    }
  }
}