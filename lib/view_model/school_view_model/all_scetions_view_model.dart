import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/all_classes_repo.dart';
import 'package:school_pro/repo/school_repo/all_sections_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../model/school_model/all_classes_model.dart';
import '../../model/school_model/all_sections_model.dart';
class AllSectionsViewModel extends ChangeNotifier {

  final _repo = AllSectionsRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllSectionsModel? _allSectionsModel;
  AllSectionsModel? get allSectionsModel => _allSectionsModel;

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void setModel(AllSectionsModel m) {
    _allSectionsModel = m;
    notifyListeners();
  }
  Future<void> allSectionsApi(
      BuildContext context,
      String classId,
      ) async {

    setLoading(true);

    try {

      final response = await _repo.allSectionsApi(classId);

      print("SECTION API RESPONSE: $response");

      /// ✅ CAST FIX
      final Map<String, dynamic> data =
      Map<String, dynamic>.from(response);

      if (data['success'] == true) {

        setModel(AllSectionsModel.fromJson(data));

      } else {

        Utils.show(data['message'] ?? "Something went wrong", context);

      }

    } catch (e) {

      print("SECTION ERROR: $e");
      Utils.show("Failed to load sections", context);

    } finally {

      setLoading(false);

    }
  }
}
