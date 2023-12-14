import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['user'] != null) {
        Fluttertoast.showToast(
          msg: "Logging in",
          backgroundColor: Colors.green,
          fontSize: 16,
        );
        User userInfo = User.fromJson(jsonResponse["user"]);
        // ignore: use_build_context_synchronously
        context.read<CurrentUser>().setUser(userInfo);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['error'],
          backgroundColor: Colors.red,
          fontSize: 16,
        );
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      Fluttertoast.showToast(
        msg: "Took too long to respond.",
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    } finally {
      context.read<IsLoadingData>().setIsLoading(false);
    }
  }

  Future<void> registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String dob,
    required String role,
    required String email,
    required String phone,
    required String password,
  }) async {
    context.read<IsLoadingData>().setIsLoading(true);
    var regBody = {
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
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

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse);

      if (jsonResponse['user'] != null) {
        Fluttertoast.showToast(
          msg: "Registration Complete!",
          backgroundColor: Colors.green,
          fontSize: 16,
        );
        User userInfo = User.fromJson(jsonResponse["user"]);
        print(userInfo);
        // ignore: use_build_context_synchronously
        context.read<CurrentUser>().setUser(userInfo);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['error'],
          backgroundColor: Colors.red,
          fontSize: 16,
        );
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      Fluttertoast.showToast(
        msg: "Took too long to respond.",
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    } finally {
      context.read<IsLoadingData>().setIsLoading(false);
    }
  }

  Future<String> checkEmail({
    required BuildContext context,
    required String email,
  }) async {
    var regBody = {'email': email};
    try {
      var response = await http
          .post(Uri.parse(checkEmailApi),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(regBody))
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          return 'ok';
        case 400:
          return 'This email is already in use.';
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
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
