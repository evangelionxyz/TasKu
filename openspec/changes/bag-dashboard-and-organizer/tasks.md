## 1. Dependencies & Project Setup

- [x] 1.1 Add `flutter_map`, `latlong2`, and `provider` to `pubspec.yaml`
- [x] 1.2 Run `flutter pub get` to install new dependencies

## 2. Data Models & Services

- [x] 2.1 Create `lib/models/route_entry.dart` — `RouteEntry` data class with `timestamp`, `address`, `latLng`
- [x] 2.2 Create `lib/services/bag_service.dart` — `BagService` (ChangeNotifier) with stub streams for `batteryLevel`, `isBluetoothConnected`, `isSynced`, `isLocked`, `motionDetected`, `isAlarmEnabled`, `routeHistory`; periodic Timer updates every 5 seconds
- [x] 2.3 Add `setAlarm(bool)` and `testAlarm()` methods to `BagService`
- [x] 2.4 Create `lib/services/organizer_service.dart` — `OrganizerService` (ChangeNotifier) with Firestore `users/{uid}/items` listener, `addItem(name)`, `togglePacked(itemId, current)`, `deleteItem(itemId)`, and `refresh()` methods

## 3. Provider Setup

- [x] 3.1 Wrap the widget tree in `main.dart` with `MultiProvider`, registering `BagService` and `OrganizerService` (pass the authenticated `uid` to `OrganizerService`)

## 4. Dashboard — Connectivity Card Widget

- [x] 4.1 Create `lib/widgets/connectivity_card.dart` — card displaying battery icon + level, Bluetooth status label, and cloud sync status with tap-to-refresh behaviour calling `OrganizerService.refresh()`
- [x] 4.2 Wire `ConnectivityCard` to `BagService` streams via `context.watch<BagService>()`

## 5. Dashboard — Security Card Widget

- [x] 5.1 Create `lib/widgets/security_card.dart` — card displaying padlock icon (locked/unlocked) and motion alert indicator with pulsing animation when `motionDetected == true`
- [x] 5.2 Wire `SecurityCard` to `BagService` streams

## 6. Dashboard — Location Entry Card Widget

- [x] 6.1 Create `lib/widgets/location_card.dart` — card showing last-known location stub label and a chevron to navigate to `BagDetailScreen`

## 7. Dashboard Screen Rebuild

- [x] 7.1 Rebuild `lib/screens/dashboard_screen.dart` — add "Dashboard" AppBar header text alongside the existing `AppTitle` logo; compose `ConnectivityCard`, `SecurityCard`, and `LocationCard` in a scrollable column

## 8. Bag Detail Screen

- [x] 8.1 Create `lib/screens/bag_detail_screen.dart` — AppBar titled "Bag Details"; body divided into map section, route history list, and alarm section
- [x] 8.2 Add `flutter_map` `FlutterMap` widget with OSM tile layer and a marker at a placeholder Jakarta `LatLng`
- [x] 8.3 Build route history list from `BagService.routeHistory` with empty-state label
- [x] 8.4 Add alarm toggle (`Switch`) wired to `BagService.setAlarm()` and a "Test Sound" `ElevatedButton` wired to `BagService.testAlarm()` (shows a `SnackBar`)

## 9. Organizer Screen Rebuild

- [x] 9.1 Rebuild `lib/screens/organizer_screen.dart` — add "Organizer" AppBar header text; body is a `StreamBuilder`/`Consumer<OrganizerService>` list of items with checkboxes and strikethrough for packed items; `Dismissible` wrapper for swipe-to-delete
- [x] 9.2 Add a `FloatingActionButton` that opens a bottom sheet with a `TextField` + confirm button calling `OrganizerService.addItem()`
- [x] 9.3 Show empty-state widget when list is empty

## 10. Smoke Testing & Polish

- [x] 10.1 Hot-restart the app, navigate through all three tabs and verify headers ("Dashboard", "Organizer", and existing "Profile") are visible
- [x] 10.2 Verify connectivity card updates (BT, battery, sync) every ~5 seconds from the stub
- [x] 10.3 Verify motion detected state shows pulsing alert on security card
- [x] 10.4 Open Bag Detail screen; verify map renders, route history list shows stubs, alarm toggle and test button work
- [x] 10.5 On Organizer screen: add item, toggle packed, swipe-delete — verify Firestore changes in Firebase console
- [x] 10.6 Tap cloud sync on Dashboard; verify loading indicator momentarily appears
