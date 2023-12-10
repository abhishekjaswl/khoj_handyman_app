import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app/core/models/user_model.dart';
import '../../utils/config/config.dart';
import 'auth_service.dart';

class UserService {
  static Future<List<User>> getUsers(
      String? token, AuthService authService, context) async {
    try {
      final response = await http.get(
        Uri.parse(allUsersApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> userList = jsonData["allUsers"];
        return userList.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        authService.logoutUser(context: context);
        return List<User>.empty();
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
