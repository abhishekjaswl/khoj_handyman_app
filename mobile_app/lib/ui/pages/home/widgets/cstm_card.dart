import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';

class CstmCard extends StatelessWidget {
  final User user;

  const CstmCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(user.id),
            Text(user.firstName),
            Text(user.lastName),
          ],
        ),
      ),
    );
  }
}
