import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/student/add_student_repo.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class AddStudentViewModel with ChangeNotifier {
  final _loginRepo = AddStudentRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> addStudentApi({
    required BuildContext context,
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
    required String city,
    required String state,
    required String pincode,
    File? student_photo,
    File? aadharCard,
    File? father_photo,
    File? mother_photo,
  }) async {

    if (!PermissionExtensions.canAccess(
      PermissionKeys.addStudent,
    )) {
      Utils.show("You don't have permission to add student", context);
      return false;
    }

    setLoading(true);

    // 🔹 Print Request Data
    if (kDebugMode) {
      print("📤 ADD STUDENT API REQUEST");
      print("Name: $name");
      print("Email: $email");
      print("Class ID: $class_id");
      print("Section ID: $section_id");
      print("Admission No: $admission_no");
      print("Gender: $gender");
      print("Academic Year: $academic_year");
      print("Roll No: $roll_no");
      print("DOB: $dob");
      print("Mobile: $mobile_number");
      print("Father Name: $father_name");
      print("Mother Name: $mother_name");
      print("Address: $address");
      print("Religion: $religion");
      print("Category: $category");
      print("Blood Group: $blood_group");
      print("Aadhar Number: $aadhar_number");
      print("Father Mobile: $father_mobile");
      print("Mother Mobile: $mother_mobile");
      print("City: $city");
      print("State: $state");
      print("Pincode: $pincode");

      print("📸 Student Photo: ${student_photo?.path}");
      print("📸 Aadhar Card: ${aadharCard?.path}");
      print("📸 Father Photo: ${father_photo?.path}");
      print("📸 Mother Photo: ${mother_photo?.path}");
    }

    try {
      final response = await _loginRepo.addStudentApi(
        name: name,
        email: email,
        password: password,
        aadharCard: aadharCard,
        class_id: class_id,
        section_id: section_id,
        admission_no: admission_no,
        gender: gender,
        academic_year: academic_year,
        selected_fee_heads: selected_fee_heads,
        roll_no: roll_no,
        dob: dob,
        mobile_number: mobile_number,
        father_name: father_name,
        mother_name: mother_name,
        father_photo: father_photo,
        mother_photo: mother_photo,
        student_photo: student_photo,
        address: address,
        religion: religion,
        passed_out: passed_out,
        transfer: transfer,
        blood_group: blood_group,
        category: category,
        aadhar_number: aadhar_number,
        father_occupation: father_occupation,
        father_mobile: father_mobile,
        mother_occupation: mother_occupation,
        mother_mobile: mother_mobile,
        guardian_name: guardian_name,
        emergency_contact_number: emergency_contact_number,
        state: state,
        city: city,
        pincode: pincode,
      );

      setLoading(false);

      // 🔹 Print API Response
      if (kDebugMode) {
        print("📥 ADD STUDENT API RESPONSE");
        print(response);
      }

      if (response["status_code"] == 200 || response["status_code"] == 201) {

        if (kDebugMode) {
          print("✅ Student Added Successfully");
        }

        Utils.show(response["message"] ?? "Student added successfully", context);

        Provider.of<AllStudentListVieModel>(
          context,
          listen: false,
        ).allStudentListApi(context);

        return true;

      } else {

        if (kDebugMode) {
          print("❌ API Error: ${response["message"]}");
        }

        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }

    } catch (e) {

      setLoading(false);

      if (kDebugMode) {
        print("🚨 ADD STUDENT API ERROR: $e");
      }

      Utils.show("Network error", context);
      return false;
    }
  }
}