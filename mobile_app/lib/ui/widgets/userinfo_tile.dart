import 'package:flutter/material.dart';

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
