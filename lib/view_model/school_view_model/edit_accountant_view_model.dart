// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/repo/school_repo/edit_accountant_repo.dart';
// import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
// import '../../utils/utils.dart';
//
// class EditAccountantViewModel with ChangeNotifier {
//   final _repo = EditAccountantRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> editAccountantApi({
//     required String accountantId,
//     required String name,
//     required String email,
//     required String password,
//     required String qualification,
//     required String experienceYears,  // ✅ ADD
//     required String mobileNumber,     // ✅ ADD
//     required String address,          // ✅ ADD
//     required String fatherName,       // ✅ ADD
//     required String motherName,
//     File? accountantPhoto,
//     File? aadharCard,
//     required BuildContext context,
//   }) async {
//     setLoading(true);
//
//     try {
//       final response = await _repo.editAccountantApi(
//         accountantId: accountantId,
//         name: name,
//         email: email,
//         password: password,
//         qualification: qualification,
//         experienceYears: experienceYears,  // ✅ ADD
//         mobileNumber: mobileNumber,        // ✅ ADD
//         address: address,                  // ✅ ADD
//         fatherName: fatherName,            // ✅ ADD
//         motherName: motherName,            // ✅ ADD
//         accountant_photo: accountantPhoto, // ✅ FIXED
//         aadharCard: aadharCard,
//       );
//
//       setLoading(false);
//
//       if (response["status_code"] == 200 ||
//           response["status_code"] == 201) {
//         Utils.show(
//           response["message"] ?? "Accountant updated",
//           context,
//         );
//
//         // ✅ refresh list
//         Provider.of<AllAccountantListVieModel>(
//           context,
//           listen: false,
//         ).allAccountantListApi(context);
//
//         return true;
//       } else {
//         Utils.show(
//           response["message"] ?? "Something went wrong",
//           context,
//         );
//         return false;
//       }
//     } catch (e) {
//       setLoading(false);
//       if (kDebugMode) {
//         print("Edit Accountant Error: $e");
//       }
//       Utils.show("Network error", context);
//       return false;
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/edit_accountant_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
import '../../utils/utils.dart';

class EditAccountantViewModel with ChangeNotifier {
  final _repo = EditAccountantRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> editAccountantApi({
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
    String? dob,             // ✅ ADD
    String? joiningDate,     // ✅ ADD
    String? employmentType,  // ✅ ADD
    File? accountantPhoto,
    File? aadharCard,
    required BuildContext context,
  }) async {
    setLoading(true);

    try {
      final response = await _repo.editAccountantApi(
        accountantId:    accountantId,
        name:            name,
        email:           email,
        password:        password,
        qualification:   qualification,
        experienceYears: experienceYears,
        mobileNumber:    mobileNumber,
        address:         address,
        fatherName:      fatherName,
        motherName:      motherName,
        dob:             dob,            // ✅ ADD
        joiningDate:     joiningDate,    // ✅ ADD
        employmentType:  employmentType, // ✅ ADD
        accountant_photo: accountantPhoto,
        aadharCard:      aadharCard,
      );

      setLoading(false);

      if (response["status_code"] == 200 || response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Accountant updated", context);
        Provider.of<AllAccountantListVieModel>(context, listen: false)
            .allAccountantListApi(context);
        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Edit Accountant Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}