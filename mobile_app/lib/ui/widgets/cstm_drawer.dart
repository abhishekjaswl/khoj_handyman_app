import 'package:flutter/material.dart';
import 'package:mobile_app/core/providers/theme_provider.dart';
import 'package:mobile_app/ui/pages/admin/pages/verification/verification_requests.dart';
import 'package:mobile_app/ui/pages/history/userHistory.dart';
import 'package:mobile_app/ui/pages/history/workerHistory.dart';
import 'package:mobile_app/ui/pages/profile/user_details.dart';
import 'package:mobile_app/ui/pages/user/my_bookings.dart';
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
            margin: const EdgeInsets.only(bottom: 0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.white,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              margin: const EdgeInsets.only(bottom: 0),
              decoration: const BoxDecoration(
                color: Colors.black38,
              ),
              accountName: Text(
                '${Provider.of<CurrentUser>(context).user.firstName} ${Provider.of<CurrentUser>(context).user.lastName}'
                    .toTitleCase(),
              ),
              accountEmail: Text(
                Provider.of<CurrentUser>(context).user.email,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              currentAccountPicture: Avatar(
                sources: [
                  if (Provider.of<CurrentUser>(context).user.profilePicUrl !=
                      null)
                    NetworkSource(
                        Provider.of<CurrentUser>(context).user.profilePicUrl!)
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                placeholderColors: const [
                  Colors.blueGrey,
                  Colors.teal,
                ],
                name: Provider.of<CurrentUser>(context)
                    .user
                    .firstName
                    .toTitleCase(),
              ),
            ),
          ),
          ListTileItem(
            leading: Icons.person_4_outlined,
            title: 'Profile',
            onTap: () => redirectFunc(UserDetails(
              user: Provider.of<CurrentUser>(context, listen: false).user,
              title: 'Profile',
            )),
          ),
          Provider.of<CurrentUser>(context).user.role == 'admin'
              ? ListTileItem(
                  leading: Icons.new_releases_outlined,
                  title: 'Verification Requests',
                  onTap: () => redirectFunc(const VerificationRequests()),
                )
              : Container(),
          Provider.of<CurrentUser>(context).user.role == 'user'
              ? ListTileItem(
                  leading: Icons.book_online,
                  title: 'My Bookings',
                  onTap: () => redirectFunc(const MyBooking()),
                )
              : Container(),
          ListTileItem(
            leading: Icons.history,
            title: 'Booking History',
            onTap: () => redirectFunc(
                Provider.of<CurrentUser>(context, listen: false).user.role ==
                        'user'
                    ? const UserHistory()
                    : const WorkerHistory()),
          ),
          const Spacer(),
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
              context.read<ThemeProvider>().toggleTheme();
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
        ],
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  final IconData leading;
  final String title;
  final Function()? onTap;

  const ListTileItem({
    required this.leading,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(leading),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
