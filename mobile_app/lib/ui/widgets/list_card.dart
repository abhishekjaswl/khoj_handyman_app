import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';

class CstmCard extends StatelessWidget {
  final Function() onTap;
  final UserModel user;

  const CstmCard({
    super.key,
    required this.onTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(
          bottom: 6,
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            Avatar(
              sources: [
                if (user.profilePicUrl != null)
                  NetworkSource(user.profilePicUrl!)
              ],
              shape: AvatarShape.rectangle(
                90,
                90,
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
            const VerticalDivider(
              color: Colors.amber,
              thickness: 10,
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('${user.firstName} ${user.lastName}').toTitleCase(),
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(
                  height: 5,
                  thickness: 5,
                  color: Colors.white,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: user.role == 'admin'
                            ? Colors.red
                            : user.role == 'user'
                                ? Colors.blueGrey
                                : Colors.amber,
                      ),
                      child: Text(
                        user.role.toTitleCase(),
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    user.job == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                            ),
                            child: Text(
                              user.job!.toTitleCase(),
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    user.availability != null
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: user.availability == 'available'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                            child: Text(
                              user.availability!.toTitleCase(),
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
