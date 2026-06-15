import 'package:flutter/material.dart';
import '../../model/school_model/user_role_model.dart';
import '../../repo/school_repo/user_role_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class GetUsersByRoleViewModel extends ChangeNotifier {

  // ─── State ─────────────────────────────────────────────────────────────────

  bool _loading = false;
  bool get loading => _loading;

  GetUsersByRoleModel? _model;
  GetUsersByRoleModel? get model => _model;

  List<UserByRole> get users => _model?.data ?? [];

  // ─── Repository ────────────────────────────────────────────────────────────

  final _repo = GetUsersByRoleRepository();

  // ─── Selected user (for dropdown) ──────────────────────────────────────────

  UserByRole? _selectedUser;
  UserByRole? get selectedUser => _selectedUser;

  void setSelectedUser(UserByRole user) {
    _selectedUser = user;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  // ─── Fetch API ─────────────────────────────────────────────────────────────

  Future<void> getUsersByRoleApi({
    required BuildContext context,
    required String role,
  }) async {

    _setLoading(true);
    _model = null;
    _selectedUser = null;
    notifyListeners();

    try {
      final response = await _repo.getUsersByRoleApi(role: role);
      _model = GetUsersByRoleModel.fromJson(response);

      // auto-select first user if list is not empty
      if (users.isNotEmpty) {
        _selectedUser = users.first;
      }

    } catch (e) {
      debugPrint('getUsersByRoleApi error: $e');
    }

    _setLoading(false);
  }

  // ─── Private ───────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}