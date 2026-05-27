import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color transparent = Color(0x00000000);
  static const Color dark = Color(0xFF1E2015);
  static const Color brown = Color(0xFF684d3a);
  static const Color olive = Color(0xFF827F5E);
  static const Color lightBrown = Color(0xFFE5DDD2);
  static const Color light = Color(0xFFF5F2ED);
}

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo.png',
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text(
            'TasKu',
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Roxborough",
              fontWeight: FontWeight(700),
            ),
          ),
        ],
      ),
    );
  }
}
