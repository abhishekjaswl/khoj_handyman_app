import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/providers/currentuser_provider.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:mobile_app/ui/widgets/cstm_appbar.dart';
import 'package:mobile_app/ui/widgets/cstm_drawer.dart';
import 'package:mobile_app/ui/widgets/listview.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Future<List<UserModel>> _getUsers() async {
    try {
      return await AdminService.getAllUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CstmAppBar(),
      ),
      drawer: const CstmDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, ${'${Provider.of<CurrentUser>(context).user.firstName} ${Provider.of<CurrentUser>(context).user.lastName}'.toTitleCase()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Ready to get work done?',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CstmList(
              listFuture: _getUsers(),
              title: 'User Details',
            ),
          ],
        ),
      ),
    );
  }
}
