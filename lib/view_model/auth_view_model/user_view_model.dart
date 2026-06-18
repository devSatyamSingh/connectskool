// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserViewModel with ChangeNotifier {
//
//   /// Save user id
//   Future<bool> saveUser(int userId) async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.setInt('user_id', userId);
//     notifyListeners();
//     return true;
//   }
//
//   Future<int?> getUser() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.getInt('user_id');
//   }
//
//   Future<bool> removeUser() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.remove('user_id');
//   }
//
//   /// Save token
//   Future<bool> saveToken(String token) async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.setString('access_token', token);
//     notifyListeners();
//     return true;
//   }
//
//   Future<String?> getToken() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.getString('access_token');
//   }
//
//   Future<bool> removeToken() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.remove('access_token');
//   }
//   /// Save student id
//   Future<bool> saveStudentId(int studentId) async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.setInt('student_id', studentId);
//     notifyListeners();
//     return true;
//   }
//
//   Future<int?> getStudentId() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.getInt('student_id');
//   }
//
//   Future<bool> removeStudentId() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.remove('student_id');
//   }
//
// // user_view_model.dart mein add karo
//
//   Future<void> saveSchoolId(dynamic schoolId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('school_id', schoolId.toString());
//   }
//
//   Future<String?> getSchoolId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('school_id');
//   }
//   Future<bool> removeSchoolId() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.remove('school_id');
//   }
//   /// Save role (STRING because API sends string)
//   Future<bool> saveRole(String role) async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.setString('role', role);
//     notifyListeners();
//     return true;
//   }
//
//   Future<String?> getRole() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.getString('role');
//   }
//
//   Future<bool> removeRole() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.remove('role');
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {

  Future<bool> saveUser(int userId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('user_id', userId);
    notifyListeners();
    return true;
  }

  Future<int?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt('user_id');
  }

  Future<bool> removeUser() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('user_id');
  }

  // ==============================
  // 🔹 TOKEN
  // ==============================
  Future<bool> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('access_token', token);
    notifyListeners();
    return true;
  }

  Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('access_token');
  }

  Future<bool> removeToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('access_token');
  }

  // ==============================
  // 🔹 STUDENT ID
  // ==============================
  Future<bool> saveStudentId(int studentId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('student_id', studentId);
    notifyListeners();
    return true;
  }

  Future<int?> getStudentId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt('student_id');
  }

  Future<bool> removeStudentId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('student_id');
  }

  // ==============================
  // 🔹 SCHOOL ID
  // ==============================
  Future<void> saveSchoolId(dynamic schoolId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('school_id', schoolId.toString());
  }

  Future<String?> getSchoolId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('school_id');
  }

  Future<bool> removeSchoolId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('school_id');
  }

  // ==============================
  // 🔹 ROLE
  // ==============================
  Future<bool> saveRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('role', role);
    notifyListeners();
    return true;
  }

  Future<String?> getRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('role');
  }

  Future<bool> removeRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('role');
  }

  // ==============================
  // 🔹 CLASS ID
  // ==============================
  Future<void> saveClassId(dynamic classId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('class_id', classId?.toString() ?? "");
  }

  Future<String?> getClassId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('class_id');
  }

  Future<bool> removeClassId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('class_id');
  }

  // ==============================
  // 🔹 SECTION ID
  // ==============================
  Future<void> saveSectionId(dynamic sectionId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('section_id', sectionId?.toString() ?? "");
  }

  Future<String?> getSectionId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('section_id');
  }

  Future<bool> removeSectionId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove('section_id');
  }

  Future<void> savePermissions(List<dynamic> permissions) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      "permissions",
      permissions.map((e) => e.toString()).toList(),
    );
  }

  Future<List<String>> getPermissions() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList("permissions") ?? [];
  }

  Future<void> clearUser() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    notifyListeners();
  }
}
