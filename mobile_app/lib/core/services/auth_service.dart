// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/models/worker_model.dart';
import 'package:mobile_app/ui/widgets/cstm_snackbar.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../ui/pages/loginregister/login.dart';
import '../../utils/config/config.dart';
import '../models/user_model.dart';
import '../providers/currentuser_provider.dart';
import '../providers/loading_provider.dart';

class AuthService {
  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http
          .post(Uri.parse(login),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(regBody))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        UserModel userInfo = UserModel.fromJson(jsonResponse["user"]);
        context.read<CurrentUser>().setUser(userInfo);

        if (jsonResponse["worker"] != null) {
          WorkerModel workerInfo = WorkerModel.fromJson(jsonResponse["worker"]);
          context.read<CurrentUser>().setWorker(workerInfo);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: 'Welcome Back ${userInfo.firstName.toTitleCase()}!',
            type: 'success',
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'error',
          ),
        );
      }
    } on TimeoutException catch (_) {
      // Handle timeout
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

  Future<void> registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String role,
    required String email,
    required String phone,
    required String password,
  }) async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'email': email,
      'phone': phone,
      'password': password,
    };

    try {
      var response = await http
          .post(Uri.parse(register),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(regBody))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: 'Registration Complete!',
            type: 'success',
          ),
        );

        UserModel userInfo = UserModel.fromJson(jsonResponse["user"]);
        context.read<CurrentUser>().setUser(userInfo);

        if (jsonResponse["worker"] != null) {
          WorkerModel workerInfo = WorkerModel.fromJson(jsonResponse["worker"]);
          context.read<CurrentUser>().setWorker(workerInfo);
        }
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CstmSnackBar(
            text: response.body,
            type: 'error',
          ),
        );
      }
    } on TimeoutException catch (_) {
      // Handle timeout
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

  Future<String> getregisOTP({
    required BuildContext context,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    var regBody = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
    try {
      var response = await http
          .post(Uri.parse(getRegisOTP),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(regBody))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          return 'ok';
        case 400:
          return response.body;
        default:
          return "Something went wrong!";
      }
    } catch (e) {
      return 'Something went wrong!';
    }
  }

  Future<String> verifyOTP({
    required BuildContext context,
    required String email,
    required String otp,
    required String purpose,
  }) async {
    try {
      var response = await http.get(
        Uri.parse('$verifyOTPApi/$email/$otp/$purpose'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          return 'ok';
        case 400:
          return response.body;
        default:
          return "Something went wrong!";
      }
    } catch (e) {
      return 'Something went wrong!';
    }
  }

  Future<void> logoutUser({
    required BuildContext context,
  }) async {
    context.read<CurrentUser>().logoutUser();
    context.read<IsLoadingData>().setIsLoading(false);
    ScaffoldMessenger.of(context).showSnackBar(
      CstmSnackBar(
        text: 'Logged Out.',
        type: 'error',
      ),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
