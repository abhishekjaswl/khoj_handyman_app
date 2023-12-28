import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/admin_service.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../widgets/cstm_button.dart';

class ViewDocuments extends StatelessWidget {
  final UserModel user;
  final String title;
  const ViewDocuments({
    super.key,
    required this.user,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    user.citizenshipUrl != null
                        ? Container(
                            height: 280,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(user.citizenshipUrl!),
                                    fit: BoxFit.cover),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                          )
                        : Container(),
                    user.paymentQrUrl != null
                        ? Container(
                            height: 280,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(user.paymentQrUrl!),
                                    fit: BoxFit.cover),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Provider.of<CurrentUser>(context).user.role == 'admin' &&
                    title == 'User Details'
                ? Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: 'Feedback',
                                labelStyle: const TextStyle(fontSize: 15),
                                filled: true,
                                focusColor:
                                    Theme.of(context).colorScheme.tertiary,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                contentPadding: const EdgeInsets.all(13),
                                prefixIcon: const Icon(Icons.abc)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  child: CstmButton(
                                    btnColor: Colors.green,
                                    leadingIcon: const Icon(Icons.check),
                                    text: 'Approve',
                                    onPressed: () {
                                      AdminService.updateUserStatus(
                                        context: context,
                                        id: user.id,
                                        status: 'verified',
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  child: CstmButton(
                                    btnColor: Colors.red,
                                    leadingIcon: const Icon(Icons.close),
                                    text: 'Decline',
                                    onPressed: () {
                                      AdminService.updateUserStatus(
                                        context: context,
                                        id: user.id,
                                        status: 'unverified',
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
