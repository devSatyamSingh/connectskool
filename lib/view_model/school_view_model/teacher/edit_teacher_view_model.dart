import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/student/edit_student_repo.dart';
import 'package:school_pro/repo/school_repo/teacher/edit_teacher_repo.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import 'dart:io';

class EditTeacherViewModel with ChangeNotifier {
  final _repo = EditTeacherRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> editTeacherApi({
    required BuildContext context, // pass context here
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

    if (!PermissionExtensions.canAccess(
        PermissionKeys.editTeacher)) {
      Utils.show(
        "You don't have permission to edit teacher",
        context,
      );
      return false;
    }

    setLoading(true);

    try {
      final response = await _repo.editTeacherApi(
        teacherId: teacherId,
        name: name,
        email: email,
        password: password,
        aadharCard: aadharCard,
        qualification: qualification,
        experinceYears: experinceYears,
        joining_date: joining_date,
        employeeId: employeeId,
        gender: gender,
        dob: dob,
        employmentType: employmentType,
        designation: designation,
        mobileNumber: mobileNumber,   // ✅ ADD
        address: address,             // ✅ ADD
        fatherName: fatherName,       // ✅ ADD
        motherName: motherName,       // ✅ ADD
        teacher_photo: teacher_photo, // ✅ ADD


      );

      setLoading(false);

      if (response["status_code"] == 200 || response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Teacher updated", context);

        // Update student/teacher list
        Provider.of<AllTeachersListVieModel>(
          context,
          listen: false,
        ).allTeachersListApi(context);

        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Edit Teacher Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}
