import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/loading_provider.dart';

class CstmButton extends StatelessWidget {
  final Widget? leadingIcon;
  final String text;
  final Color? textColor;
  final Color? btnColor;
  final VoidCallback onPressed;

  const CstmButton({
    super.key,
    this.leadingIcon,
    required this.text,
    this.textColor,
    this.btnColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: btnColor ?? Theme.of(context).colorScheme.tertiary,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          )),
      onPressed: Provider.of<IsLoadingData>(context).isLoading == true
          ? null
          : onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Provider.of<IsLoadingData>(context).isLoading == true
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : leadingIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
