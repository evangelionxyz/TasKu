import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/widgets/stacked_card.dart';

class SecurityCard extends StatefulWidget {
  const SecurityCard({super.key});

  @override
  State<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<SecurityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final bag = context.watch<BagService>();

    return StackedCard(
      label: 'Security & Motion',
      child: Column(
        children: [
          // Lock state row
          Row(
            children: [
              Icon(
                bag.isLocked ? Icons.lock : Icons.lock_open,
                color: bag.isLocked ? theme.colors.accent : theme.colors.danger,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                bag.isLocked ? 'Locked' : 'Unlocked',
                style: TextStyle(
                  fontFamily: 'Telegraf',
                  fontSize: 14,
                  color: theme.colors.onCard,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                color: bag.isLocked ? theme.colors.accent : theme.colors.danger,
                child: Text(
                  bag.isLocked ? 'SECURE' : 'OPEN',
                  style: TextStyle(
                    fontFamily: 'Telegraf',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.colors.onDanger,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: theme.colors.accent.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          // Motion sensor row
          Row(
            children: [
              bag.motionDetected
                  ? AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, _) => Opacity(
                        opacity: _pulseAnim.value,
                        child: Icon(
                          Icons.sensors,
                          color: theme.colors.danger,
                          size: 22,
                        ),
                      ),
                    )
                  : Icon(Icons.sensors, color: theme.colors.accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bag.motionDetected ? 'Motion detected!' : 'No motion',
                  style: TextStyle(
                    fontFamily: 'Telegraf',
                    fontSize: 14,
                    fontWeight: bag.motionDetected
                        ? FontWeight.w700
                        : FontWeight.normal,
                    color: bag.motionDetected
                        ? theme.colors.danger
                        : theme.colors.onCard,
                  ),
                ),
              ),
              if (bag.motionDetected)
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, _) => Opacity(
                    opacity: _pulseAnim.value,
                    child: Container(
                      width: 10,
                      height: 10,
                      color: theme.colors.danger,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
