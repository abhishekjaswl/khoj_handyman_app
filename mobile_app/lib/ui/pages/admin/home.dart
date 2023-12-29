import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/providers/currentuser_provider.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:mobile_app/ui/widgets/cstm_appbar.dart';
import 'package:mobile_app/ui/widgets/cstm_drawer.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../profile/user_details.dart';
import '../user/widgets/cstm_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<UserModel>> _userListFuture;
  @override
  void initState() {
    super.initState();
    _userListFuture = _getUsers();
  }

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
      drawer: const CstmDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CstmAppBar(
            stretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() {});
              });
            },
          ),
          SliverToBoxAdapter(
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
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<UserModel>>(
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
                          'Oh no! There are no users!.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
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
                        UserModel user = userList[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                        user: user,
                                        title: 'User Details',
                                      ))),
                          child: CstmCard(
                            user: user,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
