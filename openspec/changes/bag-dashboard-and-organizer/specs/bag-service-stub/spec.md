## ADDED Requirements

### Requirement: BagService exposes all bag state as streams
`BagService` SHALL be a `ChangeNotifier`-compatible class that exposes the following fields as streams or observable values:
- `batteryLevel` (int, 0–100)
- `isBluetoothConnected` (bool)
- `isSynced` (bool)
- `isLocked` (bool)
- `motionDetected` (bool)
- `isAlarmEnabled` (bool)
- `routeHistory` (List\<RouteEntry\>)

The stub SHALL update values on a periodic timer (e.g., every 5 seconds) with realistic mock data.

#### Scenario: Periodic state updates
- **WHEN** `BagService` is instantiated and running
- **THEN** all stream-emitting fields emit a new value at least every 10 seconds without manual trigger

### Requirement: BagService provides alarm control methods
`BagService` SHALL expose `setAlarm(bool enabled)` and `testAlarm()` methods. In the stub, these SHALL update the local `isAlarmEnabled` state and log a debug message respectively.

#### Scenario: setAlarm updates state
- **WHEN** `setAlarm(true)` is called
- **THEN** `isAlarmEnabled` becomes `true` and listeners are notified

#### Scenario: testAlarm logs intent
- **WHEN** `testAlarm()` is called
- **THEN** a debug print or log line is emitted (no audio in stub)

### Requirement: RouteEntry model
`RouteEntry` SHALL be a plain Dart data class with fields: `timestamp` (DateTime), `address` (String stub), `latLng` (LatLng).

#### Scenario: RouteEntry created with valid data
- **WHEN** a `RouteEntry` is constructed with timestamp, address, and latLng
- **THEN** all fields are accessible and non-null
