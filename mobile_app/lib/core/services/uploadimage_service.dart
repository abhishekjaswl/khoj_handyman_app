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
    return showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context!,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Upload Image From:',
                style: TextStyle(fontSize: 20),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 2.7),
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  await uploadPicture(
                    source: ImageSource.gallery,
                    context: context,
                    id: Provider.of<CurrentUser>(
                      context,
                      listen: false,
                    ).user.id,
                    purpose: purpose,
                  );
                },
              ),
              const Divider(
                height: 0,
                indent: 50,
                endIndent: 50,
                color: Colors.grey,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 2.75),
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  await uploadPicture(
                    source: ImageSource.camera,
                    context: context,
                    id: Provider.of<CurrentUser>(
                      context,
                      listen: false,
                    ).user.id,
                    purpose: purpose,
                  );
                },
              ),
            ],
          ),
        );
      },
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
          folder: 'users/$purpose/$id',
        ),
      );
      Navigator.of(context).pop();

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
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Cancelled by user!',
          type: 'error',
        ),
      );
    }
  }
}
