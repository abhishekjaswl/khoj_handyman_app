// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/widgets/cstm_snackbar.dart';
import '../../utils/config/config.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

import '../providers/currentuser_provider.dart';

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

  static Future<List<BookingModel>> getBookingRequests({
    required BuildContext context,
  }) async {
    try {
      String id = Provider.of<CurrentUser>(context, listen: false).user.id;
      final response = await http.get(Uri.parse('$getBookingRequestsApi/$id'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => BookingModel.fromJson(json)).toList();
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

  static Future<void> updateBookingRequests({
    required BuildContext context,
    required String id,
    required String action,
  }) async {
    try {
      final response =
          await http.patch(Uri.parse('$updateBookingRequestApi/$id/$action'));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'success',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'error',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: e.toString(),
          type: 'error',
        ),
      );
    }
  }
}
