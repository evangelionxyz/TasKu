import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/services/organizer_service.dart';
import 'package:taskuapp/widgets/stacked_card.dart';

class ConnectivityCard extends StatelessWidget {
  const ConnectivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final bag = context.watch<BagService>();
    final organizer = context.watch<OrganizerService>();

    return StackedCard(
      label: 'Connectivity',
      child: Column(
        children: [
          _ConnectRow(
            icon: _batteryIcon(bag.batteryLevel),
            iconColor: _batteryColor(theme, bag.batteryLevel),
            label: 'Battery',
            value: '${bag.batteryLevel}%',
          ),
          const SizedBox(height: 12),
          _ConnectRow(
            icon: bag.isBluetoothConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            iconColor: bag.isBluetoothConnected
                ? theme.colors.accent
                : theme.colors.danger,
            label: 'Bluetooth',
            value: bag.isBluetoothConnected ? 'Connected' : 'Disconnected',
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              bag.markSyncLoading();
              await organizer.refresh();
              bag.markSynced();
            },
            child: _ConnectRow(
              icon: bag.isSynced
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_sync_outlined,
              iconColor: bag.isSynced ? theme.colors.accent : theme.colors.danger,
              label: 'Cloud Sync',
              value: organizer.isLoading
                  ? 'Syncing…'
                  : bag.isSynced
                  ? 'Synced'
                  : 'Out of sync',
              trailing: Icon(
                Icons.refresh,
                size: 16,
                color: theme.colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _batteryIcon(int level) {
    if (level < 20) return Icons.battery_alert;
    if (level < 50) return Icons.battery_2_bar;
    if (level < 80) return Icons.battery_5_bar;
    return Icons.battery_full;
  }

  static Color _batteryColor(ThemeService theme, int level) {
    if (level < 20) return theme.colors.danger;
    if (level < 50) return theme.colors.accentDim;
    return theme.colors.accent;
  }
}

class _ConnectRow extends StatelessWidget {
  const _ConnectRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Telegraf',
            fontSize: 14,
            color: theme.colors.onCard,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Telegraf',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colors.onCard,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 6), trailing!],
      ],
    );
  }
}
