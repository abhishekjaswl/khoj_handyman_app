import 'dart:io';

import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/uploadimage_service.dart';
import '../../widgets/cstm_msgborder.dart';
import '../../widgets/cstm_snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UploadImageService uploadImageService = UploadImageService();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Avatar(
              margin: const EdgeInsets.symmetric(vertical: 10),
              onTap: () async {
                File? selectedImage =
                    await uploadImageService.showImageSourceDialog(
                  context: context,
                );
                if (selectedImage != null) {
                  // Do something with the selected image file
                  setState(() {
                    this.selectedImage = selectedImage;
                  });
                } else {
                  // No image selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    CstmSnackBar(
                      text: 'Cancelled by user!',
                      type: 'error',
                    ),
                  );
                }
              },
              sources: [
                if (selectedImage != null)
                  GenericSource(FileImage(selectedImage!)),
                NetworkSource(
                    Provider.of<CurrentUser>(context).user.profilePicUrl!)
              ],
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              shape: AvatarShape.circle(100),
              placeholderColors: const [
                Colors.blueGrey,
                Colors.lime,
                Colors.cyan,
                Colors.deepOrange,
                Colors.green,
                Colors.orangeAccent,
                Colors.red,
                Colors.teal,
                Colors.yellow,
              ],
              name: Provider.of<CurrentUser>(context)
                  .user
                  .firstName
                  .toTitleCase(),
            ),
            Card(
              margin: const EdgeInsets.all(8),
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
                        Text(
                          Provider.of<CurrentUser>(context).user.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color:
                              Provider.of<CurrentUser>(context).user.status ==
                                      'verified'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.secondary,
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
            Provider.of<CurrentUser>(context).user.status == 'unverified'
                ? Transform.translate(
                    offset: const Offset(0, -15),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: MessageBorder(),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.9,
                            child: const Text(
                              'You are not verified. Please fill up the KYC to be verified.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          FilledButton(
                            child: const Text('KYC Form'),
                            onPressed: () =>
                                {Navigator.pushNamed(context, '/kyc')},
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            Card(
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserInfoItem(
                    icon: Icons.work_outline,
                    label: 'Job',
                    value: 'Coming Soon...',
                  ),
                  ListTile(
                    leading: const Icon(Icons.circle_outlined),
                    title: const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Coming Soon...'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(
                                    Icons.circle_outlined,
                                    color: Colors.green,
                                  ),
                                  title: const Text(
                                    'Available',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: const Text(
                                      'You will receive booking requests.'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  onTap: () => {},
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.circle_outlined,
                                    color: Colors.redAccent,
                                  ),
                                  title: const Text(
                                    'Unavailable',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: const Text(
                                      'You will NOT receive booking requests.'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  onTap: () => {},
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoItem(
                    icon: Icons.person_4_outlined,
                    label: 'Role',
                    value: Provider.of<CurrentUser>(context)
                        .user
                        .role
                        .toTitleCase(),
                  ),
                  UserInfoItem(
                    icon: Icons.phone_iphone,
                    label: 'Phone Number',
                    value:
                        Provider.of<CurrentUser>(context).user.phone.toString(),
                  ),
                  UserInfoItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Date of Birth',
                    value: Provider.of<CurrentUser>(context).user.dob ?? 'N/A',
                  ),
                  UserInfoItem(
                    icon: Icons.place_outlined,
                    label: 'Address',
                    value:
                        Provider.of<CurrentUser>(context).user.address ?? 'N/A',
                  ),
                  UserInfoItem(
                    icon: Icons.male,
                    label: 'Gender',
                    value:
                        Provider.of<CurrentUser>(context).user.gender ?? 'N/A',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Function()? onTap;

  const UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(value),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
