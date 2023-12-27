import 'dart:convert';
import 'dart:io';

import 'package:mobile_app/core/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/utils/config/config.dart';

class AdminService {
  static Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(allUsers));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load users. Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception(
            'Failed to connect to the server. Please check your internet connection.');
      } else {
        throw Exception('Failed to load users: $e');
      }
    }
  }

  static Future<List<UserModel>> getUserList() async {
    try {
      final response = await http.get(Uri.parse(userList));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load users. Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception(
            'Failed to connect to the server. Please check your internet connection.');
      } else {
        throw Exception('Failed to load users: $e');
      }
    }
  }

  static Future<List<UserModel>> getWorkerList() async {
    try {
      final response = await http.get(Uri.parse(workerList));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load users. Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception(
            'Failed to connect to the server. Please check your internet connection.');
      } else {
        throw Exception('Failed to load users: $e');
      }
    }
  }

  static Future<List<UserModel>> getPendingList() async {
    try {
      final response = await http.get(Uri.parse(pendingList));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load users. Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception(
            'Failed to connect to the server. Please check your internet connection.');
      } else {
        throw Exception('Failed to load users: $e');
      }
    }
  }
}
