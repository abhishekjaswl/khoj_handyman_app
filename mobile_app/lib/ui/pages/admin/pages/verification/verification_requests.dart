import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:mobile_app/ui/pages/user/widgets/cstm_card.dart';
import 'package:mobile_app/ui/pages/profile/user_details.dart';

class VerificationRequests extends StatefulWidget {
  const VerificationRequests({super.key});

  @override
  State<VerificationRequests> createState() => _VerificationRequestsState();
}

class _VerificationRequestsState extends State<VerificationRequests> {
  late Future<List<UserModel>> _pendingListFuture;
  @override
  void initState() {
    super.initState();
    _pendingListFuture = _getPendingList();
  }

  // returns the list of verified workers
  Future<List<UserModel>> _getPendingList() async {
    try {
      return await AdminService.getPendingList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('Verification Requests'),
            onStretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() => _pendingListFuture = _getPendingList());
              });
            },
          ),
          SliverFillRemaining(
            child: FutureBuilder<List<UserModel>>(
              future: _pendingListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error}',
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'There are no pending verification requests!.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
