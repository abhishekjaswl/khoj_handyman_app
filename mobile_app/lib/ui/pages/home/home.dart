import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/user_service.dart';
import '../../widgets/cstm_appbar.dart';
import '../../widgets/cstm_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> _userListFuture;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _userListFuture = _getUsers();
  }

  Future<List<User>> _getUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      return await UserService.getUsers(token, authService, context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CstmDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CstmAppBar(
            stretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _userListFuture =
                      _getUsers(); // Update the future to trigger a rebuild
                });
              });
            },
          ),
          const SliverToBoxAdapter(
            child: Text('Welcome back User!'),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<User>>(
              future: _userListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        '${snapshot.error}',
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: Text(
                        'No Handymen Available!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                } else {
                  final userList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = userList[index];
                      return Text(
                        user.firstName,
                        style: TextStyle(height: 50),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
