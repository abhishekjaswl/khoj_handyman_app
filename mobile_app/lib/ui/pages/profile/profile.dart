import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/user_service.dart';
import '../../widgets/cstm_msgborder.dart';

class ProfilePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProfilePage({super.key});

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
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Avatar(
              onTap: () {
                showDialog(
                  context: context,
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _pickImage(
                                ImageSource.gallery,
                                widget._scaffoldKey.currentContext,
                                Provider.of<CurrentUser>(context, listen: false)
                                    .user
                                    .id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _pickImage(
                                ImageSource.camera,
                                widget._scaffoldKey.currentContext,
                                Provider.of<CurrentUser>(context, listen: false)
                                    .user
                                    .id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
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
              },
              sources: [
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
                Colors.indigo,
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
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
            Provider.of<CurrentUser>(context).user.status == 'unverified'
                ? Transform.translate(
                    offset: const Offset(0, -15),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: MessageBorder(),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: const Text(
                              'You are not verified. Please fill up the KYC to be verified.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          ElevatedButton(
                            child: const Text('KYC Form'),
                            onPressed: () => {},
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                child: Padding(
                  padding: const EdgeInsets.all(15),
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
                      const SizedBox(
                        height: 10,
                      ),
                      UserInfoItem(
                        icon: Icons.phone_iphone,
                        label: 'Phone Number',
                        value: Provider.of<CurrentUser>(context)
                            .user
                            .phone
                            .toString(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      UserInfoItem(
                        icon: Icons.calendar_month_outlined,
                        label: 'Date of Birth',
                        value: Provider.of<CurrentUser>(context).user.dob,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Card(
                margin: EdgeInsets.only(right: 10, left: 10, bottom: 5),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserInfoItem(
                        icon: Icons.place_outlined,
                        label: 'Address',
                        value: 'Coming Soon...',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      UserInfoItem(
                        icon: Icons.abc,
                        label: 'Unknown',
                        value: 'Coming Soon...',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() => {}),
        label: const Text('Edit Profile'),
        icon: const Icon(Icons.edit_document),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
