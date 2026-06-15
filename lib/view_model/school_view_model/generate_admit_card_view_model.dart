// import 'package:flutter/foundation.dart';
// import '../../model/school_model/generate_admit_card_model.dart';
// import '../../repo/school_repo/generate_admit_card_repo.dart';
//
// class GenerateAdmitCardViewModel with ChangeNotifier {
//
//   final _repo = GenerateAdmitCardRepo();
//
//   bool loading = false;
//
//   GenerateAdmitCardModel admitCardModel = GenerateAdmitCardModel();
//
//   Future<void> getAdmitCard(
//       int examId,
//       int classId,
//       int sectionId,
//       int studentId
//       ) async {
//
//     loading = true;
//     notifyListeners();
//
//     final response = await _repo.generateAdmitCard(
//         examId, classId, sectionId, studentId);
//
//     if (response["success"] == true) {
//       admitCardModel = GenerateAdmitCardModel.fromJson(response);
//     }
//
//     loading = false;
//     notifyListeners();
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/school_model/generate_admit_card_model.dart';
import '../../repo/school_repo/generate_admit_card_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class GenerateAdmitCardViewModel with ChangeNotifier {

  final _repo = GenerateAdmitCardRepo();

  bool loading = false;

  GenerateAdmitCardModel admitCardModel = GenerateAdmitCardModel();

  Future<void> getAdmitCard(
      int examId,
      int classId,
      int sectionId,
      int studentId,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.generateAdmitCard)) {

      Utils.show(
        "You don't have permission to perform this action",
        context,
      );

      return;
    }

    loading = true;
    notifyListeners();

    final response = await _repo.generateAdmitCard(
        examId, classId, sectionId, studentId);

    if (response["success"] == true) {

      admitCardModel = GenerateAdmitCardModel.fromJson(
          Map<String, dynamic>.from(response));

    }

    loading = false;
    notifyListeners();
  }
}