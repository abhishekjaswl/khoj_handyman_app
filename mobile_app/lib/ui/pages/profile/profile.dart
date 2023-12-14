import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService();
  Future<void> _pickImage(ImageSource source, context, id) async {
    await userService.uploadProfilePic(
      source: source,
      context: context,
      id: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select image from'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _pickImage(
                              ImageSource.gallery,
                              context,
                              Provider.of<CurrentUser>(context, listen: false)
                                  .user
                                  .id);
                        },
                        child: const Text(
                          'Gallery',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _pickImage(
                              ImageSource.camera,
                              context,
                              Provider.of<CurrentUser>(context, listen: false)
                                  .user
                                  .id);
                        },
                        child: const Text(
                          'Camera',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Provider.of<CurrentUser>(context)
                    .user
                    .profilePicUrl!
                    .isNotEmpty
                ? CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                        Provider.of<CurrentUser>(context).user.profilePicUrl!),
                  )
                : Avatar(
                    shape: AvatarShape.circle(100),
                    name: Provider.of<CurrentUser>(context)
                        .user
                        .firstName
                        .toTitleCase(),
                  ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Provider.of<CurrentUser>(context).user.firstName.toTitleCase()} ${Provider.of<CurrentUser>(context).user.lastName.toTitleCase()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          Provider.of<CurrentUser>(context).user.email,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        Provider.of<CurrentUser>(context).user.status,
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      Provider.of<CurrentUser>(context).user.role.toTitleCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      Provider.of<CurrentUser>(context).user.phone.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      Provider.of<CurrentUser>(context).user.dob,
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      Provider.of<CurrentUser>(context).user.role.toTitleCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      Provider.of<CurrentUser>(context).user.phone.toString(),
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() => {}),
        label: const Text('Edit Profile'),
        icon: const Icon(Icons.edit_document),
      ),
    );
  }
}
