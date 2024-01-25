import 'package:flutter/material.dart';

class CstmLoginSwitcher extends StatelessWidget {
  final String preText;
  final String suffText;
  final VoidCallback onpressed;

  const CstmLoginSwitcher({
    super.key,
    required this.preText,
    required this.suffText,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          preText,
          style: const TextStyle(),
        ),
        TextButton(
          onPressed: onpressed,
          child: Text(
            suffText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
