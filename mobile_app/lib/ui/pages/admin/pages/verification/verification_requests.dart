import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:mobile_app/ui/pages/admin/pages/verification/userdetails.dart';
import 'package:mobile_app/ui/pages/home/widgets/cstm_card.dart';

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
          SliverToBoxAdapter(
            child: FutureBuilder<List<UserModel>>(
              future: _pendingListFuture,
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
                                builder: (context) => UserDetails(user: user))),
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