import 'package:flutter/material.dart';
import 'package:mobile_app/core/providers/theme_provider.dart';
import 'package:mobile_app/ui/pages/profile/profile.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:avatars/avatars.dart';

import '../../core/providers/currentuser_provider.dart';
import '../../core/services/auth_service.dart';
import '../themes/light_theme.dart';

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
              currentAccountPicture: Avatar(
                sources: [
                  NetworkSource(
                      Provider.of<CurrentUser>(context).user.profilePicUrl!)
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                shape: AvatarShape.circle(50),
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
            ),
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
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
                  leading: const Icon(Icons.abc),
                  title: const Text('Unknown'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.abc),
                  title: const Text('Unknown'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  leading: const Icon(Icons.abc),
                  title: const Text('Unknown'),
                  onTap: () {},
                ),
                const Divider(
                  height: 0,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            trailing: Icon(
                Provider.of<ThemeProvider>(context).themeData == lightTheme
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined),
            title: Text(
                Provider.of<ThemeProvider>(context).themeData == lightTheme
                    ? 'Dark Mode'
                    : 'Light Mode'),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            textColor: Colors.red,
            iconColor: Colors.red,
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            trailing: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.pop(context),
              authService.logoutUser(
                context: context,
              )
            },
          ),
          const Divider(
            height: 0,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
