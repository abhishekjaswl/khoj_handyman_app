import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avatars/avatars.dart';

import '../../core/providers/currentuser_provider.dart';
import '../../core/services/auth_service.dart';
import '../pages/loginregister/login.dart';
import 'cstm_button.dart';

class CstmDrawer extends StatefulWidget {
  const CstmDrawer({super.key});

  @override
  State<CstmDrawer> createState() => _CstmDrawerState();
}

class _CstmDrawerState extends State<CstmDrawer> {
  bool tokenExists = false;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenExists = prefs.getString('token') != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: tokenExists
                ? UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.black38),
                    accountName: Text(
                      'Welcome Back, ${Provider.of<CurrentUser>(context).user.firstName}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    accountEmail:
                        Text(Provider.of<CurrentUser>(context).user.email),
                    currentAccountPictureSize: const Size.square(60),
                    currentAccountPicture: Avatar(
                        shape: AvatarShape.circle(30),
                        name: Provider.of<CurrentUser>(context).user.firstName,
                        placeholderColors: const [
                          Colors.grey,
                        ]),
                  )
                : CstmButton(
                    leadingIcon: const Icon(
                      Icons.login_outlined,
                    ),
                    text: 'Login',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
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
            child: tokenExists
                ? Padding(
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
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
