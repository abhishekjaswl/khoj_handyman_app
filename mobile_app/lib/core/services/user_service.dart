import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../utils/config/config.dart';
import '../providers/currentuser_provider.dart';

class UserService {
  Future<void> uploadKYC({
    required BuildContext context,
    required String id,
    required String citizenshipUrl,
    required String? paymentQrUrl,
    required String? job,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final regBody = {
      'id': id,
      'citizenshipUrl': citizenshipUrl,
      'paymentQrUrl': paymentQrUrl,
      'job': job,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };

    try {
      final response = await http.post(
        Uri.parse(uploadKYCApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
