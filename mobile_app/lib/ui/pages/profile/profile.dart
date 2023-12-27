// ignore_for_file: use_build_context_synchronously

import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/uploadimage_service.dart';
import '../../widgets/cstm_msgborder.dart';
import '../../widgets/userinfo_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UploadImageService uploadImageService = UploadImageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Avatar(
              margin: const EdgeInsets.symmetric(vertical: 10),
              sources: [
                if (Provider.of<CurrentUser>(context).user.profilePicUrl !=
                    null)
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
                Colors.teal,
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
                        Provider.of<CurrentUser>(context)
                            .user
                            .status
                            .toTitleCase(),
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
            Provider.of<CurrentUser>(context, listen: false).user.role ==
                    'worker'
                ? Card(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserInfoItem(
                          icon: Icons.work_outline,
                          label: 'Job',
                          value: (Provider.of<CurrentUser>(context).user.job ??
                                  'N/a')
                              .toTitleCase(),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.circle_outlined,
                            color: Provider.of<CurrentUser>(context)
                                        .user
                                        .availability ==
                                    'available'
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          title: const Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(Provider.of<CurrentUser>(context)
                              .user
                              .availability!
                              .toTitleCase()),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
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
                                          color: Colors.greenAccent,
                                        ),
                                        title: const Text(
                                          'Available',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        subtitle: const Text(
                                            'You will receive booking requests.'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        subtitle: const Text(
                                            'You will NOT receive booking requests.'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                  )
                : Container(),
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
                    value: Provider.of<CurrentUser>(context).user.dob ?? 'N/a',
                  ),
                  UserInfoItem(
                    icon: Icons.place_outlined,
                    label: 'Address',
                    value:
                        Provider.of<CurrentUser>(context).user.address ?? 'N/a',
                  ),
                  UserInfoItem(
                    icon: Icons.male,
                    label: 'Gender',
                    value:
                        (Provider.of<CurrentUser>(context).user.gender ?? 'N/a')
                            .toTitleCase(),
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
