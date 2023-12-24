import 'dart:convert';
import 'dart:io';

import '../../utils/config/config.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<List<UserModel>> getVerWorkers() async {
    try {
      final response = await http.get(Uri.parse(verWorkerList));

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
