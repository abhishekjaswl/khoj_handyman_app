import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CstmBg extends StatelessWidget {
  const CstmBg({super.key});

  @override
  Widget build(BuildContext context) {
    // Background image
    return Lottie.network(
      'https://lottie.host/e59aa853-94fe-4896-924c-d461cdb1fcc9/c4xuZAPMmJ.json',
      width: double.infinity,
      height: 500,
      fit: BoxFit.contain,
      repeat: false,
    );
  }
}
