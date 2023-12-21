import 'dart:io';
import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../ui/widgets/cstm_snackbar.dart';
import '../../utils/config/config.dart';
import '../providers/currentuser_provider.dart';
import 'package:mobile_app/core/services/user_service.dart';

class UploadImageService {
  final UserService userService = UserService();
  Future<void> showImageSourceDialog({
    required BuildContext? context,
    required String purpose,
  }) async {
    return showDialog(
      context: context!,
      builder: (context) => AlertDialog(
        title: const Text(
          'Select image from',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                await uploadPicture(
                  source: ImageSource.gallery,
                  context: context,
                  id: Provider.of<CurrentUser>(
                    context,
                    listen: false,
                  ).user.id,
                  purpose: purpose,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await uploadPicture(
                  source: ImageSource.camera,
                  context: context,
                  id: Provider.of<CurrentUser>(
                    context,
                    listen: false,
                  ).user.id,
                  purpose: purpose,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadPicture({
    required ImageSource source,
    required context,
    required id,
    required purpose,
  }) async {
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
              'users/$purpose/$id',
        ),
      );

      final regBody = {
        'id': id,
        'picUrl': result.secureUrl,
        'purpose': purpose,
      };

      try {
        final response = await http.post(
          Uri.parse(uploadProfilePicApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            CstmSnackBar(
              text: response.body,
              type: 'success',
            ),
          );
          switch (purpose) {
            case 'ProfilePic':
              Provider.of<CurrentUser>(context, listen: false)
                  .updateProfilePicUrl(result.secureUrl);

            case 'Citizenship':
              Provider.of<CurrentUser>(context, listen: false)
                  .updateCitizenshipUrl(result.secureUrl);
          }
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Cancelled by user!',
          type: 'error',
        ),
      );
    }
  }
}
