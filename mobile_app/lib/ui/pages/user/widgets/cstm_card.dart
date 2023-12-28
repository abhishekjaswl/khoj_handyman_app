import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';

class CstmCard extends StatelessWidget {
  final UserModel user;

  const CstmCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 5),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Avatar(
              sources: [
                if (user.profilePicUrl != null)
                  NetworkSource(user.profilePicUrl!)
              ],
              shape: AvatarShape.rectangle(
                80,
                80,
                const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              placeholderColors: const [
                Colors.blueGrey,
                Colors.teal,
              ],
              name: user.firstName.toTitleCase(),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  ('${user.firstName} ${user.lastName}').toTitleCase(),
                  style: const TextStyle(fontSize: 16),
                ),
                Text((user.job!).toTitleCase()),
                user.availability != null
                    ? Text(user.availability!)
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
