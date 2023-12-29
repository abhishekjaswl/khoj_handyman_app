// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/providers/loading_provider.dart';
import 'package:mobile_app/ui/widgets/cstm_snackbar.dart';
import 'package:mobile_app/utils/config/config.dart';
import 'package:provider/provider.dart';

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

  static Future<void> updateUserStatus({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    context.read<IsLoadingData>().setIsLoading(true);
    try {
      var response = await http.patch(
        Uri.parse('$updateStatus/$id/$status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'success',
          ),
        );
        Navigator.of(context)
          ..pop()
          ..pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'error',
          ),
        );
      }
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Took too long to respond.',
          type: 'error',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: e.toString(),
          type: 'error',
        ),
      );
    } finally {
      context.read<IsLoadingData>().setIsLoading(false);
    }
  }
}
