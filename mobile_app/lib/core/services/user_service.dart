import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/config/config.dart';
import '../providers/currentuser_provider.dart';

class UserService {
  Future<void> uploadProfilePic(
      {required ImageSource source, required context, required id}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final cloudinary = CloudinaryPublic('bookabahun', 'ch37wxpt');

      final result = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder:
              // ignore: use_build_context_synchronously
              'users/ProfilePic/$id',
        ),
      );
      final regBody = {
        'id': id,
        'profilePicUrl': result.secureUrl,
      };

      try {
        final response = await http.post(
          Uri.parse(uploadProfilePicApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          Provider.of<CurrentUser>(context, listen: false)
              .updateProfilePicUrl(result.secureUrl);
          Fluttertoast.showToast(
            msg: response.body,
            backgroundColor: Colors.green,
            fontSize: 16,
          );
        } else {
          Fluttertoast.showToast(
            msg: response.body,
            backgroundColor: Colors.red,
            fontSize: 16,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          fontSize: 16,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Error uploading image to Cloudinary',
        backgroundColor: Colors.red,
        fontSize: 16,
      );
    }
  }
}
