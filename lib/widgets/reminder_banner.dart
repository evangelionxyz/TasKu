import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/services/organizer_service.dart';
import 'package:taskuapp/services/theme_service.dart';

class ReminderBanner extends StatefulWidget {
  const ReminderBanner({super.key});

  @override
  State<ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<ReminderBanner> {
  bool _dismissed = false;
  bool _lastConditionState = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final bag = context.watch<BagService>();
    final organizer = context.watch<OrganizerService>();

    final hasUnpacked = organizer.items.any((item) => !item.isPacked);
    final shouldShowCondition = bag.isLocked && hasUnpacked;

    // If the condition transitioned from false to true, reset the dismiss state
    if (shouldShowCondition && !_lastConditionState) {
      _dismissed = false;
    }
    _lastConditionState = shouldShowCondition;

    if (!shouldShowCondition || _dismissed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Stack(
        children: [
          // Shadow / back layer
          Positioned(
            left: 4,
            top: 4,
            right: 0,
            bottom: 0,
            child: Container(color: theme.colors.onCard),
          ),
          // Front layer
          Container(
            color: theme.colors.danger,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: theme.colors.onDanger,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You have unpacked items! Check your organizer.',
                    style: TextStyle(
                      fontFamily: 'Telegraf',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colors.onDanger,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.colors.onDanger, size: 20),
                  onPressed: () {
                    setState(() {
                      _dismissed = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
