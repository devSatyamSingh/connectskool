import 'package:flutter/material.dart';
import '../../model/school_model/all_home_work_model.dart';
import '../../repo/school_repo/all_home_work_repo.dart';

class AllHomeWorkViewModel extends ChangeNotifier {
  final AllHomeWorkRepository _repository = AllHomeWorkRepository();

  AllHomeworkModel? allHomeworkModel;
  bool loading = false;

  Future<void> allHomeworkApi(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _repository.allHomeworkApi();
      allHomeworkModel = AllHomeworkModel.fromJson(
          Map<String, dynamic>.from(response)  // ✅ fix
      );
      // final response = await _repository.allHomeworkApi();
      // allHomeworkModel = AllHomeworkModel.fromJson(response);
    } catch (e) {
      debugPrint("❌ ViewModel Error: $e");
    }

    loading = false;
    notifyListeners();
  }
}