import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/models/route_entry.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/services/theme_service.dart';

class BagDetailScreen extends StatelessWidget {
  const BagDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final bag = context.watch<BagService>();

    return Scaffold(
      backgroundColor: theme.colors.bg,
      appBar: AppBar(
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.onCard,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: theme.colors.onCard),
        ),
        title: Text(
          'Bag Details',
          style: TextStyle(
            fontFamily: 'Roxborough',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colors.onCard,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          // ── Map Section ──────────────────────────────────────────────────
          const _SectionLabel(label: 'GPS Location'),
          const SizedBox(height: 12),
          const _MapWidget(center: BagService.placeholderLatLng),
          const SizedBox(height: 28),

          // ── Route History ────────────────────────────────────────────────
          const _SectionLabel(label: 'Route History'),
          const SizedBox(height: 12),
          _RouteHistorySection(entries: bag.routeHistory),
          const SizedBox(height: 28),

          // ── Alarm Section ────────────────────────────────────────────────
          const _SectionLabel(label: 'Alarm'),
          const SizedBox(height: 12),
          _AlarmSection(bag: bag),
        ],
      ),
    );
  }
}

// ─────────────────────────── Section Label ───────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return Row(
      children: [
        Container(width: 4, height: 18, color: theme.colors.accent),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Roxborough',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: theme.colors.accent,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Map Widget ──────────────────────────────────────

class _MapWidget extends StatelessWidget {
  const _MapWidget({required this.center});
  final LatLng center;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          // Dark offset shadow layer (stacked design)
          Positioned(
            left: 6,
            top: 6,
            right: 0,
            bottom: 0,
            child: Container(color: theme.colors.onCard),
          ),
          ClipRect(
            child: FlutterMap(
              options: MapOptions(initialCenter: center, initialZoom: 14),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.taskuapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.colors.accent.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: theme.colors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────── Route History ───────────────────────────────────

class _RouteHistorySection extends StatelessWidget {
  const _RouteHistorySection({required this.entries});
  final List<RouteEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No route history yet',
          style: TextStyle(
            fontFamily: 'Telegraf',
            fontSize: 14,
            color: theme.colors.accent,
          ),
        ),
      );
    }

    return Column(
      children: entries.map((e) => _RouteEntryTile(entry: e)).toList(),
    );
  }
}

class _RouteEntryTile extends StatelessWidget {
  const _RouteEntryTile({required this.entry});
  final RouteEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final diff = DateTime.now().difference(entry.timestamp);
    final timeLabel = diff.inMinutes < 60
        ? '${diff.inMinutes}m ago'
        : diff.inHours < 24
        ? '${diff.inHours}h ago'
        : '${diff.inDays}d ago';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          Column(
            children: [
              Container(width: 10, height: 10, color: theme.colors.accent),
              Container(
                width: 1,
                height: 36,
                color: theme.colors.accent.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.address,
                  style: TextStyle(
                    fontFamily: 'Telegraf',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colors.onCard,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontFamily: 'Telegraf',
                    fontSize: 12,
                    color: theme.colors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Alarm Section ───────────────────────────────────

class _AlarmSection extends StatelessWidget {
  const _AlarmSection({required this.bag});
  final BagService bag;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Offset shadow
          Positioned(
            left: 5,
            top: 5,
            right: 0,
            bottom: 0,
            child: Container(color: theme.colors.onCard),
          ),
          Container(
            color: theme.colors.card,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle row
                Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: theme.colors.accent,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Alarm',
                      style: TextStyle(
                        fontFamily: 'Telegraf',
                        fontSize: 15,
                        color: theme.colors.onCard,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: bag.isAlarmEnabled,
                      onChanged: bag.setAlarm,
                      activeThumbColor: theme.colors.accent,
                      inactiveThumbColor: theme.colors.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Test button — stacked design
                GestureDetector(
                  onTap: () {
                    bag.testAlarm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Testing alarm…'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Stack(
                      children: [
                        // Shadow layer
                        Positioned(
                          left: 5,
                          top: 5,
                          right: 0,
                          bottom: 0,
                          child: Container(color: theme.colors.onCard),
                        ),
                        // Button face
                        Container(
                          color: theme.colors.accent,
                          width: double.infinity,
                          height: 46,
                          alignment: Alignment.center,
                          child: Text(
                            'Test Sound',
                            style: TextStyle(
                              fontFamily: 'Roxborough',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: theme.colors.onDanger,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
