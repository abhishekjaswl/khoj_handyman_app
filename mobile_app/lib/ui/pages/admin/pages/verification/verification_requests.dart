import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:mobile_app/ui/widgets/listview.dart';

class VerificationRequests extends StatefulWidget {
  const VerificationRequests({super.key});

  @override
  State<VerificationRequests> createState() => _VerificationRequestsState();
}

class _VerificationRequestsState extends State<VerificationRequests> {
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
                setState(() => _getPendingList());
              });
            },
          ),
          CstmList(listFuture: _getPendingList()),
        ],
      ),
    );
  }
}
