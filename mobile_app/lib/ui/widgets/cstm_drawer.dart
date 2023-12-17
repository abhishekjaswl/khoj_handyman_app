import 'package:flutter/material.dart';
import 'package:mobile_app/ui/pages/profile/profile.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:avatars/avatars.dart';

import '../../core/providers/currentuser_provider.dart';
import '../../core/services/auth_service.dart';
import 'cstm_button.dart';

class CstmDrawer extends StatefulWidget {
  const CstmDrawer({super.key});

  @override
  State<CstmDrawer> createState() => _CstmDrawerState();
}

class _CstmDrawerState extends State<CstmDrawer> {
  final AuthService authService = AuthService();

  void redirectFunc(x) async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => x));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black38),
              accountName: Text(
                'Welcome Back, ${Provider.of<CurrentUser>(context).user.firstName}',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                Provider.of<CurrentUser>(context).user.email,
                overflow: TextOverflow.ellipsis,
              ),
              currentAccountPictureSize: const Size.square(70),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  ),
                ),
                child: Provider.of<CurrentUser>(context)
                        .user
                        .profilePicUrl!
                        .isNotEmpty
                    ? CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(
                          Provider.of<CurrentUser>(context).user.profilePicUrl!,
                        ),
                      )
                    : Avatar(
                        shape: AvatarShape.circle(30),
                        name: Provider.of<CurrentUser>(context)
                            .user
                            .firstName
                            .toTitleCase(),
                        placeholderColors: const [
                            Colors.grey,
                          ]),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.person_4_outlined),
                  title: const Text('Profile'),
                  onTap: () {
                    redirectFunc(ProfilePage());
                  },
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CstmButton(
                  leadingIcon: const Icon(Icons.logout_outlined),
                  text: 'Logout',
                  textColor: Colors.white,
                  btnColor: Colors.red,
                  onPressed: () => {
                    Navigator.pop(context),
                    authService.logoutUser(
                      context: context,
                    )
                  },
                ),
              )),
        ],
      ),
    );
  }
}
