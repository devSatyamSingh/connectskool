import 'package:flutter/material.dart';
import '../../../model/school_model/homework/all_home_work_model.dart';
import '../../../repo/school_repo/homework/all_home_work_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class AllHomeWorkViewModel extends ChangeNotifier {
  final AllHomeWorkRepository _repository = AllHomeWorkRepository();

  AllHomeworkModel? allHomeworkModel;
  bool loading = false;

  Future<void> allHomeworkApi(BuildContext context) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewHomework)) {

      Utils.show(
        "You don't have permission to view homework",
        context,
      );

      return;
    }
    loading = true;
    notifyListeners();

    try {
      final response = await _repository.allHomeworkApi();
      allHomeworkModel = AllHomeworkModel.fromJson(
          Map<String, dynamic>.from(response)  // fix
      );
    } catch (e) {
      debugPrint("❌ ViewModel Error: $e");
    }

    loading = false;
    notifyListeners();
  }
}