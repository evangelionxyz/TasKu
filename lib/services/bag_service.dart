import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskuapp/models/route_entry.dart';

class BagService extends ChangeNotifier {
  BagService() {
    _init();
  }

  final _random = Random();
  Timer? _timer;

  // --- State fields ---
  int _batteryLevel = 78;
  bool _isBluetoothConnected = true;
  bool _isSynced = true;
  final bool _isLocked = true;
  bool _motionDetected = false;
  bool _isAlarmEnabled = false;
  final List<RouteEntry> _routeHistory = _buildInitialHistory();

  // --- Getters ---
  int get batteryLevel => _batteryLevel;
  bool get isBluetoothConnected => _isBluetoothConnected;
  bool get isSynced => _isSynced;
  bool get isLocked => _isLocked;
  bool get motionDetected => _motionDetected;
  bool get isAlarmEnabled => _isAlarmEnabled;
  List<RouteEntry> get routeHistory => List.unmodifiable(_routeHistory);

  // Placeholder Jakarta-area coords
  static const LatLng placeholderLatLng = LatLng(-6.2088, 106.8456);

  void _init() {
    // Emit periodic updates every 5 seconds to simulate live bag data
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _batteryLevel = max(0, _batteryLevel - _random.nextInt(2));
      _isBluetoothConnected = _random.nextDouble() > 0.1; // 90% connected
      _isSynced = _random.nextDouble() > 0.2;
      _motionDetected = _random.nextDouble() > 0.8; // 20% chance of motion
      notifyListeners();
    });
  }

  // --- Alarm controls ---
  void setAlarm(bool enabled) {
    _isAlarmEnabled = enabled;
    notifyListeners();
  }

  void testAlarm() {
    debugPrint('[BagService] testAlarm() called — stub: no audio in mockup');
  }

  // --- Synced state for cloud sync tap ---
  void markSyncLoading() {
    _isSynced = false;
    notifyListeners();
  }

  void markSynced() {
    _isSynced = true;
    notifyListeners();
  }

  // --- Initial stub route history ---
  static List<RouteEntry> _buildInitialHistory() {
    final now = DateTime.now();
    return [
      RouteEntry(
        timestamp: now.subtract(const Duration(minutes: 12)),
        address: 'Jl. Sudirman No.1, Jakarta Pusat',
        latLng: const LatLng(-6.2088, 106.8456),
      ),
      RouteEntry(
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        address: 'Blok M Plaza, Jakarta Selatan',
        latLng: const LatLng(-6.2443, 106.7988),
      ),
      RouteEntry(
        timestamp: now.subtract(const Duration(hours: 4)),
        address: 'Stasiun Gambir, Jakarta Pusat',
        latLng: const LatLng(-6.1766, 106.8303),
      ),
      RouteEntry(
        timestamp: now.subtract(const Duration(hours: 7, minutes: 30)),
        address: 'Kota Tua, Jakarta Barat',
        latLng: const LatLng(-6.1352, 106.8133),
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
