import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/create_classes_repo.dart';
import 'package:school_pro/repo/school_repo/create_section_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';

import '../../utils/utils.dart';

class CreateSectionViewModel with ChangeNotifier {
  final _loginRepo = CreateSectionRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createClassApi(
      dynamic class_id,
      dynamic sectionName,
      dynamic capacity,
      context,
      ) async {
    setLoading(true);

    Map data = {
      "class_id": class_id,
      "section_name": sectionName,
      "capacity": capacity,
    };

    try {
      final response = await _loginRepo.createSectionApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class created successfully", context);

        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesApi(context);
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(
        //   context,
        //   RoutesName.classesPage,
        // );

        return true;
      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;
      } else if (statusCode == 401) {
        Utils.show("Unauthorized user", context);
        return false;
      } else if (statusCode == 500) {
        Utils.show("Server error. Try again later", context);
        return false;
      } else {
        Utils.show("Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("API Error: $e");

      Utils.show("Network error", context);
      return false;
    }
  }
}
