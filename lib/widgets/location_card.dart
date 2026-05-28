import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/screens/bag_detail_screen.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/widgets/stacked_card.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final bag = context.watch<BagService>();
    final lastEntry = bag.routeHistory.isNotEmpty ? bag.routeHistory.first : null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BagDetailScreen()),
      ),
      child: StackedCard(
        label: 'Location & Tracking',
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: theme.colors.accent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lastEntry?.address ?? 'No location data',
                    style: TextStyle(
                      fontFamily: 'Telegraf',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colors.onCard,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lastEntry != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(lastEntry.timestamp),
                      style: TextStyle(
                        fontFamily: 'Telegraf',
                        fontSize: 12,
                        color: theme.colors.accent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: theme.colors.accent, size: 22),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
