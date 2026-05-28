import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';

/// A card with the signature stacked / sharp-edge + offset aesthetic from the
/// auth screen: dark shadow layer behind, primary content layer in front.
class StackedCard extends StatelessWidget {
  const StackedCard({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  static const double _offset = 5;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Shadow / back layer (dark, shifted right-down)
          Positioned(
            left: _offset,
            top: _offset,
            right: 0,
            bottom: 0,
            child: Container(color: theme.colors.onCard),
          ),
          // Front layer
          Container(
            width: double.infinity,
            color: theme.colors.card,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Roxborough',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.accent,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
