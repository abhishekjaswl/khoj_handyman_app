import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  const BookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    UserModel user = booking.user;
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
                90,
                90,
                const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              placeholderColors: const [
                Colors.blueGrey,
                Colors.amber,
                Colors.lime,
                Colors.cyan,
                Colors.deepOrange,
                Colors.green,
                Colors.orangeAccent,
                Colors.red,
                Colors.teal,
                Colors.yellow,
              ],
              name: user.firstName.toTitleCase(),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(user.address!),
                Text(
                  DateFormat('yyyy-MM-dd | hh:mm a').format(booking.dateTime),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
