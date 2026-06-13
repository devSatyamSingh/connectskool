import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/add_teachers_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
import '../../repo/school_repo/add_accountant_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/all_student_list_view_model.dart';

class AddTeachersViewModel with ChangeNotifier {
  final _loginRepo = AddTeachersRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> addTeachersApi({
    required BuildContext context,
    required String name,
    required String userEmail,
    required String password,
    required String qualification,
    required String experienceYears,
    required String joiningDate,
    required String mobileNumber,
    required String address,
    required String fatherName,
    required String motherName,
    required String employeeId,
    required String gender,
    required String dob,
    required String employmentType,
    required String designation,

    File? teacher_photo,
    File? aadharCard,
  }) async {

    if(
    !PermissionExtensions.canAccess(
      PermissionKeys.addTeacher,
    )
    ){
      Utils.show(
        "Permission denied",
        context,
      );
      return false;
    }

    setLoading(true);

    try {
      /// ✅ fields map
      final Map<String, String> fields = {
        "name": name,
        "user_email": userEmail,
        "password": password,
        "qualification": qualification,
        "experience_years": experienceYears,
        "joining_date": joiningDate,
        "mobile_number": mobileNumber,
        "address": address,
        "father_name": fatherName,
        "mother_name": motherName,
        "employee_id": employeeId,
        "gender": gender,
        "dob": dob,
        "employment_type": employmentType,
        "designation": designation,
      };

      /// ✅ files map
      final Map<String, dynamic> files = {
        "teacher_photo": teacher_photo,
        "aadhar_card": aadharCard,
      };

      final response = await _loginRepo.addTeachersApi(fields, files);

      setLoading(false);


      if (response["status_code"] == 200 ||
          response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Accountant added", context);

        Provider.of<AllAccountantListVieModel>(
          context,
          listen: false,
        ).allAccountantListApi(context);

        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) {
        print("Add Accountant Error: $e");
      }
      Utils.show("Network error", context);
      return false;
    }
  }
}
