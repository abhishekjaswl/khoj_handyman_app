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
              type == 'loading'
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : type == 'error'
                      ? const Icon(Icons.report)
                      : type == 'success'
                          ? const Icon(Icons.check_circle)
                          : const Icon(Icons.warning),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: type == 'error'
              ? const Color(0xFFA33333)
              : type == 'success'
                  ? Colors.teal
                  : Colors.deepOrangeAccent,
        );
}
