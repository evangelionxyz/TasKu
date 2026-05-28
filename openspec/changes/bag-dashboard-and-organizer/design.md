## Context

TasKu is a Flutter app (Dart, Firebase Auth + Firestore, custom Telegraf/Roxborough fonts, AppColors palette) targeting iOS/Android. The Dashboard and Organizer screens are currently empty scaffolds. The bag's IoT hardware (Bluetooth, GPS, motion sensor, alarm) does not yet exist — all bag-state data will be simulated by a stub service. The app already has Google Auth wired up and a `BottomNavShell` with smooth page-transition.

## Goals / Non-Goals

**Goals:**
- Use Stacked UI design with Sharp edges and Offset like in the Auth Page sign in button. it has primary background and one at the back with offset   
- Replace the empty Dashboard scaffold with a card-based UI showing connectivity, security/motion, and a location/tracking entry point
- Replace the empty Organizer scaffold with a Firestore-backed packing list (CRUD)
- Introduce a `BagService` stub that emits mock streams for all bag fields, so the UI is wired as if a real BLE device were connected
- Introduce an `OrganizerService` that reads/writes the `users/{uid}/items` Firestore subcollection
- Use `flutter_map` + `latlong2` for an embedded map with a placeholder location
- Each main screen shows a text header (Dashboard, Organizer, Profile) in its AppBar
- Use `provider` for dependency injection of both services

**Non-Goals:**
- Real Bluetooth (BLE) integration — deferred to a future change
- Real GPS or motion sensor data — placeholder only
- Push notifications or background sync
- Alarm audio playback (button exists, calls stub)
- Modifying the Profile screen or auth flow

## Decisions

### D1 — Mock service via stub streams, not a package
Use a plain Dart class `BagService` with `StreamController`s and a `Timer` to emit periodic fake values. This is simpler than integrating `flutter_bluetooth_serial` (which requires native setup) and keeps the UI/service contract identical to what a real implementation will expose later.

> Alternative considered: `flutter_bluetooth_serial` package with fake device — rejected because it requires Android/iOS native permissions, complicates the build, and adds no UI value in a mockup stage.

### D2 — `provider` for state management
Use the `provider` package (`ChangeNotifierProvider` / `StreamProvider`) to inject `BagService` and `OrganizerService` into the widget tree from `main.dart`. This is the lightest-weight solution that fits the current app scale and avoids introducing Riverpod or Bloc overhead.

### D3 — `flutter_map` for the GPS widget
`flutter_map` renders OpenStreetMap tiles without a Google Maps API key, is MIT licensed, and has a pub.dev-stable release compatible with Flutter 3.x. A fixed placeholder `LatLng` (e.g., Jakarta, Indonesia) is used until real GPS is wired.

> Alternative: `google_maps_flutter` — rejected because it requires billing-enabled API keys and is heavier to set up for a mockup.

### D4 — Firestore schema for Organizer
Collection path: `users/{uid}/items/{itemId}`
Fields: `name` (String), `isPacked` (bool), `createdAt` (Timestamp), `category` (String, optional).
Simple, flat structure — no sub-collections needed at this stage.

### D5 — Dashboard layout: scrollable Column of Cards
Each concern (Connectivity, Security, Location) maps to a custom card widget in `lib/widgets/`. Cards use `AppColors` palette and have subtle `BoxShadow` + rounded corners consistent with the existing nav bar aesthetic. No custom design tokens are added; the existing `AppColors` class is extended only if truly necessary.

### D6 — Detail screen for Location & Tracking
A separate `BagDetailScreen` (pushed via `Navigator.push`) hosts the map, route history list, and alarm controls. This avoids over-crowding the Dashboard and allows the map to take more vertical space.

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| `flutter_map` tile network calls fail in offline/emulator environments | Show a loading spinner; tiles cached after first load |
| Stub `BagService` streams cause memory leaks if not disposed | Dispose all `StreamController`s in service `dispose()` and wire `Provider` disposal |
| Firestore rules not allowing user subcollection writes | Remind developer to update Firestore security rules to `allow read, write: if request.auth.uid == userId` |
| `provider` version conflict with existing Firebase packages | Pin `provider: ^6.1.2` which is known-compatible with `firebase_auth ^6.x` |

## Migration Plan

1. Add `flutter_map`, `latlong2`, `provider` to `pubspec.yaml`
2. Run `flutter pub get`
3. Wrap `MaterialApp` in `MultiProvider` in `main.dart`
4. Implement `BagService` and `OrganizerService`
5. Build Dashboard card widgets and wire to `BagService` streams
6. Build Organizer list widget and wire to `OrganizerService`
7. Build `BagDetailScreen` with map + alarm controls
8. Update Firestore security rules (manual step, out of code scope)
9. Smoke-test on Android emulator with `flutter run`

No database migrations needed (new Firestore subcollection, no existing data affected). Rollback: revert `pubspec.yaml` and the four modified/added Dart files.
