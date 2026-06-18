import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../view_model/auth_view_model/user_view_model.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {

  /// ================= COMMON FORM HEADERS =================
  Map<String, String> _formHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  /// ================= GET =================
  @override
  Future getGetApiResponse(String url) async {
    final token = await UserViewModel().getToken();
    if (kDebugMode) {
      print("🟢 GET API URL 👉 $url");
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 30));

      return _returnRequest(response);

    } on TimeoutException {
      return {
        "status_code": 408,
        "message": "Request Timeout",
      };
    } on SocketException {
      return {
        "status_code": 0,
        "message": "No Internet Connection",
      };
    } catch (e) {
      return {
        "status_code": 500,
        "message": e.toString(),
      };
    }
  }

  /// ================= POST (JSON) =================
  @override
  Future getPostApiResponse(String url, dynamic data) async {
    final token = await UserViewModel().getToken();
    if (kDebugMode) {
      print("🔵 POST API URL 👉 $url");
      print("🔵 POST BODY 👉 $data");
    }
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _returnRequest(response);

    } on SocketException {
      return {
        "status_code": 0,
        "message": "No Internet Connection",
      };
    }
  }

  /// ================= POST (FORM DATA) =================
  @override
  Future getPostApiFormData(
      String url,
      Map<String, String> fields,
      Map<String, dynamic> files,
      ) async {
    try {
      final token = await UserViewModel().getToken();
      if (kDebugMode) {
        print("🟣 PUT API URL 👉 $url");
      }
      var request = http.MultipartRequest('POST', Uri.parse(url));

      /// ✅ headers
      request.headers.addAll(_formHeaders(token!));

      /// ✅ fields
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      /// 🧪 DEBUG PRINTS
      if (kDebugMode) {
        print("🟡 FORM API URL 👉 $url");
        print("🟡 FORM FIELDS 👉 ${request.fields}");
      }

      /// ✅ files
      for (var entry in files.entries) {
        if (entry.value != null && entry.value is File) {

          String fileName = entry.value.path.split('/').last;

          http.MediaType mediaType;

          if (fileName.toLowerCase().endsWith('.pdf')) {
            mediaType = http.MediaType('application', 'pdf');
          } else {
            mediaType = http.MediaType('image', 'jpeg');
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
              contentType: mediaType,
            ),
          );
        }
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _returnRequest(response);

    } catch (e) {
      if (kDebugMode) print("❌ POST FormData Error: $e");
      rethrow;
    }
  }

  /// ================= PUT =================
  Future getPutApiResponse(String url, dynamic data) async {
    final token = await UserViewModel().getToken();
    if (kDebugMode) {
      print("🟣 PUT API URL 👉 $url");
      print("🟣 PUT BODY 👉 $data");
    }
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data != null ? jsonEncode(data) : null, // 👈 important
      ).timeout(const Duration(seconds: 30));

      return _returnRequest(response);

    } on SocketException {
      return {
        "status_code": 0,
        "message": "No Internet Connection",
      };
    }
  }

  // Future getPutApiResponse(String url, dynamic data) async {
  //   final token = await UserViewModel().getToken();
  //
  //   try {
  //     final response = await http.put(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(data),
  //     ).timeout(const Duration(seconds: 10));
  //
  //     return _returnRequest(response);
  //
  //   } on SocketException {
  //     return {
  //       "status_code": 0,
  //       "message": "No Internet Connection",
  //     };
  //   }
  // }

  /// ================= DELETE =================
  Future getDeleteApiResponse(String url, Map<String, dynamic> data) async {
    final token = await UserViewModel().getToken();
    if (kDebugMode) {
      print("🟣 PUT API URL 👉 $url");
    }
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _returnRequest(response);

    } on SocketException {
      return {
        "status_code": 0,
        "message": "No Internet Connection",
      };
    }
  }

  /// ================= RESPONSE HANDLER =================
  dynamic _returnRequest(http.Response response) {
    if (kDebugMode) {
      print("STATUS 👉 ${response.statusCode}");
      print("BODY 👉 ${response.body}");
    }

    dynamic body;

    if (response.body.isNotEmpty && !response.body.startsWith("<")) {
      body = jsonDecode(response.body);
    }

    return {
      "status_code": response.statusCode,
      ...?body,
    };
  }
}





