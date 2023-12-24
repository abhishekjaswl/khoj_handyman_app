import 'package:flutter/material.dart';

class CstmSnackBar extends SnackBar {
  CstmSnackBar({
    super.key,
    required String text,
    required String type,
  }) : super(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              type == 'error'
                  ? const Icon(Icons.report)
                  : type == 'success'
                      ? const Icon(Icons.check_circle)
                      : const Icon(Icons.warning),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 250,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.all(20),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          backgroundColor: type == 'error'
              ? const Color(0xFFA33333)
              : type == 'success'
                  ? Colors.teal
                  : Colors.deepOrangeAccent,
        );
}
