import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/edit_student_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import 'dart:io';

class EditStudentViewModel with ChangeNotifier {
  final _repo = EditStudentRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> editStudentApi({
    required String studentId,
    required String name,
    required String email,
    required String password,
    required String admission_no,
    required String gender,
    required String class_id,
    required String section_id,
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
    required BuildContext context,
  }) async {

    if (!PermissionExtensions.canAccess(
      PermissionKeys.editStudent,
    )) {
      Utils.show(
        "You don't have permission to edit student",
        context,
      );
      return false;
    }
    setLoading(true);

    try {
      final response = await _repo.editStudentApi(
        studentId: studentId,
        name: name,
        email: email,
        studentPhoto: studentPhoto,
        aadharCard: aadharCard,
        fatherPhoto: fatherPhoto,
        motherPhoto: motherPhoto,
        password: password,
        admission_no: admission_no,
        gender: gender,
        class_id: class_id,
        section_id: section_id,
        dob: dob,
        mobileNumber: mobileNumber,
        fatherName: fatherName,
        motherName: motherName,
        address: address,
        religion: religion,
        academicYear: academicYear,
        passedOut: passedOut,
        transfer: transfer,
        bloodGroup:   bloodGroup,
        category: category,
        aadharNumber: aadharNumber,
        fatherOccupation: fatherOccupation,
        fatherMobile: fatherMobile,
        motherOccupation: motherOccupation,
        motherMobile: motherMobile,
        guardianName: guardianName,
        emergencyContactNumber: emergencyContactNumber,
        city: city,
        state: state,
        pincode: pincode,
       roll_no: roll_no
      );

      setLoading(false);

      if (response["status_code"] == 200 || response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Student updated", context);
        Provider.of<AllStudentListVieModel>(
          context,
          listen: false,
        ).allStudentListApi(context);
        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Edit Student Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}
