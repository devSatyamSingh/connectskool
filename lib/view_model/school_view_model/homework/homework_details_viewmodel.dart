import 'package:flutter/material.dart';

import '../../../model/school_model/homework/homework_details_model.dart';
import '../../../repo/school_repo/homework/homework_details_repo.dart';

class HomeworkDetailsViewModel extends ChangeNotifier {
  final HomeworkDetailsRepository repo = HomeworkDetailsRepository();

  bool loading = false;

  HomeworkDetailsModel? homeworkDetailsModel;

  Future<void> getHomeworkById(int homeworkId) async {
    loading = true;
    notifyListeners();

    try {
      final response = await repo.getHomeworkById(homeworkId);

      homeworkDetailsModel = HomeworkDetailsModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }
}
