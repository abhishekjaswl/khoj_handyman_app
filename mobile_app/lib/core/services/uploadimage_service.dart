// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageService {
  Future<File?> showImageSourceDialog({
    required BuildContext context,
  }) async {
    return showModalBottomSheet<File?>(
      useRootNavigator: true,
      context: context,
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
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final imageFile = File(pickedFile.path);
                    Navigator.of(context).pop(imageFile);
                  }
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
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final imageFile = File(pickedFile.path);
                    Navigator.of(context).pop(imageFile);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
