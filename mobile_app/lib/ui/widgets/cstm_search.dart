import 'package:flutter/material.dart';

class CstmSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  const CstmSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          labelStyle: const TextStyle(fontSize: 15),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          focusColor: Theme.of(context).colorScheme.tertiary,
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(5),
        ),
      ),
    );
  }
}
