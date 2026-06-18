import 'package:flutter/material.dart';

import '../../../model/school_model/settings/help_support_model.dart';
import '../../../repo/school_repo/settings/help_support_repo.dart';

class SupportTicketViewModel extends ChangeNotifier {
  final SupportTicketRepository _repository = SupportTicketRepository();

  bool _loading = false;

  bool get loading => _loading;

  SupportTicketModel? _ticketModel;

  SupportTicketModel? get ticketModel => _ticketModel;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createSupportTicket({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    try {
      setLoading(true);

      _ticketModel = await _repository.createSupportTicket(
        title: title,
        description: description,
      );

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Support Ticket Error => $e");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
