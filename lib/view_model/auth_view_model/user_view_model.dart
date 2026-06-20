import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const userId              = 'user_id';
  static const userIdInt           = 'user_id_int';
  static const accessToken         = 'access_token';
  static const studentId           = 'student_id';
  static const schoolId            = 'school_id';
  static const role                = 'role';
  static const classId             = 'class_id';
  static const sectionId           = 'section_id';
  static const permissions         = 'permissions';
  static const appInstalled        = 'app_installed_flag';
  static const onboardingDone      = 'onboarding_done';
  static const subscribedSchoolId  = 'subscribed_school_id';
  static const subscribedRole      = 'subscribed_role';
  static const subscribedUserId    = 'subscribed_user_id';
  static const subscribedClassId   = 'subscribed_class_id';
  static const subscribedSectionId = 'subscribed_section_id';
}

class UserViewModel with ChangeNotifier {

  // ─── Install / Onboarding ─────────────────────────────────────────────────

  Future<bool> isAppPreviouslyInstalled() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_Keys.appInstalled) ?? false;
  }

  Future<void> markAppInstalled() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_Keys.appInstalled, true);
  }

  Future<bool> isOnboardingDone() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_Keys.onboardingDone) ?? false;
  }

  Future<void> markOnboardingDone() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_Keys.onboardingDone, true);
  }

  // ─── User ID ──────────────────────────────────────────────────────────────

  Future<bool> saveUser(dynamic userId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.userId, userId.toString()); // string
    notifyListeners();
    return true;
  }

  Future<String?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.userId);
  }

  /// ALAG key pe int save — 'user_id' string key se koi conflict nahi
  Future<void> saveUserIdAsInt(dynamic userId) async {
    final sp = await SharedPreferences.getInstance();
    final parsed = int.tryParse(userId.toString());
    if (parsed != null) {
      await sp.setInt(_Keys.userIdInt, parsed); // 'user_id_int' alag key
    }
  }

  Future<int?> getUserIdAsInt() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_Keys.userIdInt);
  }

  // ─── Token ────────────────────────────────────────────────────────────────

  Future<bool> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.accessToken, token);
    notifyListeners();
    return true;
  }

  Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.accessToken);
  }

  // ─── JWT Token Decode → user_id ───────────────────────────────────────────
  // Koi extra save nahi — token se real-time nikalta hai

  Future<String?> getUserIdFromToken() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(_Keys.accessToken);
    if (token == null || token.isEmpty) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      switch (payload.length % 4) {
        case 2: payload += '=='; break;
        case 3: payload += '=';  break;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final map = json.decode(decoded) as Map<String, dynamic>;
      return map['user_id']?.toString();
    } catch (e) {
      debugPrint("❌ Token decode error: $e");
      return null;
    }
  }

  // ─── Student ID ───────────────────────────────────────────────────────────

  Future<bool> saveStudentId(int studentId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_Keys.studentId, studentId);
    notifyListeners();
    return true;
  }

  Future<int?> getStudentId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_Keys.studentId);
  }

  // ─── School ID ────────────────────────────────────────────────────────────

  Future<void> saveSchoolId(dynamic schoolId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.schoolId, schoolId.toString());
  }

  Future<String?> getSchoolId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.schoolId);
  }

  // ─── Role ─────────────────────────────────────────────────────────────────

  Future<bool> saveRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.role, role);
    notifyListeners();
    return true;
  }

  Future<String?> getRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.role);
  }

  // ─── Class ID ─────────────────────────────────────────────────────────────

  Future<void> saveClassId(dynamic classId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.classId, classId?.toString() ?? "");
  }

  Future<String?> getClassId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.classId);
  }

  // ─── Section ID ───────────────────────────────────────────────────────────

  Future<void> saveSectionId(dynamic sectionId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.sectionId, sectionId?.toString() ?? "");
  }

  Future<String?> getSectionId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.sectionId);
  }

  // ─── Permissions ──────────────────────────────────────────────────────────

  Future<void> savePermissions(List<dynamic> permissions) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(
      _Keys.permissions,
      permissions.map((e) => e.toString()).toList(),
    );
  }

  Future<List<String>> getPermissions() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_Keys.permissions) ?? [];
  }

  // ─── Subscribed FCM Session ───────────────────────────────────────────────

  Future<void> saveSubscribedSession({
    required dynamic schoolId,
    required String role,
    dynamic userId,
    dynamic classId,
    dynamic sectionId,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.setString(_Keys.subscribedSchoolId,  schoolId.toString()),
      sp.setString(_Keys.subscribedRole,       role),
      sp.setString(_Keys.subscribedUserId,     userId?.toString() ?? ""),
      sp.setString(_Keys.subscribedClassId,    classId?.toString() ?? ""),
      sp.setString(_Keys.subscribedSectionId,  sectionId?.toString() ?? ""),
    ]);
  }

  Future<Map<String, String?>> getSubscribedSession() async {
    final sp = await SharedPreferences.getInstance();
    return {
      'schoolId':  sp.getString(_Keys.subscribedSchoolId),
      'role':      sp.getString(_Keys.subscribedRole),
      'userId':    sp.getString(_Keys.subscribedUserId),
      'classId':   sp.getString(_Keys.subscribedClassId),
      'sectionId': sp.getString(_Keys.subscribedSectionId),
    };
  }

  Future<void> clearSubscribedSession() async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.remove(_Keys.subscribedSchoolId),
      sp.remove(_Keys.subscribedRole),
      sp.remove(_Keys.subscribedUserId),
      sp.remove(_Keys.subscribedClassId),
      sp.remove(_Keys.subscribedSectionId),
    ]);
  }



  Future<void> clearUser() async {
    final sp = await SharedPreferences.getInstance();
    final installFlag = sp.getBool(_Keys.appInstalled);
    await sp.clear();
    if (installFlag != null) {
      await sp.setBool(_Keys.appInstalled, installFlag);
    }
    notifyListeners();
  }
}