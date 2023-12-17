import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';

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
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3.0,
                ),
              ),
              child: user.profilePicUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                        user.profilePicUrl!,
                      ),
                    )
                  : Avatar(
                      shape: AvatarShape.circle(30),
                      name: user.firstName.toTitleCase(),
                    ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(user.id),
                Text(user.firstName),
                Text(user.lastName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
