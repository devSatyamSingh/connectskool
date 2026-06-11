import 'package:flutter/material.dart';

import '../../model/school_model/transport_model/student_transport_model.dart';
import '../../repo/school_repo/transport_repo/get_student_transport_fee_repo.dart';

class GetStudentTransportViewModel with ChangeNotifier {

  final _repo = GetStudentTransportRepository();

  bool _loading = false;
  bool get loading => _loading;

  AdminStudentTransportModel? _transportModel;
  AdminStudentTransportModel? get transportModel => _transportModel;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getStudentTransportApi(
      String studentId,
      String academicYear,
      BuildContext context,
      ) async {

    setLoading(true);

    try {

      final response = await _repo.getStudentTransportApi(
          studentId,
          academicYear
      );

      _transportModel = response;

      setLoading(false);

    } catch (e) {

      setLoading(false);

    }

    notifyListeners();
  }
}