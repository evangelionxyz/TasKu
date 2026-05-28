## Why

TasKu needs a functional Dashboard and Organizer experience so users can monitor their smart bag's status (connectivity, security, motion, location) and manage a packing list — all backed by Firestore and a placeholder Bluetooth layer since the bag IoT hardware is not yet implemented.

## What Changes

- **Dashboard screen** is currently empty; replace it with a rich, card-based layout showing:
  - Connectivity panel: battery level, Bluetooth status, and cloud sync status (with force re-fetch on tap)
  - Bag Security panel: lock/unlock state and motion alert indicator
  - Location & Tracking panel: GPS map placeholder (Leaflet via `flutter_map`) with route history and alarm controls (accessible from a detail view)
- **Organizer screen** is currently empty; replace it with a packing-list UI reading/writing items to Firestore
- **Profile screen** already exists and is not modified by this change
- All screens adopt the existing `AppColors` palette and `Telegraf`/`Roxborough` typography
- Add `flutter_map` + `latlong2` dependencies for the map widget (placeholder coords)
- Add `flutter_bluetooth_serial` or stub service for Bluetooth placeholder state
- Introduce a `BagService` provider (mock/stub) that exposes all bag status fields as streams
- Introduce a `OrganizerService` that reads/writes Firestore `items` subcollection for the signed-in user
- Each screen shows a screen-level header text (Dashboard, Organizer, Profile) inside the `AppBar`

## Capabilities

### New Capabilities

- `bag-connectivity-status`: Displays battery level, Bluetooth connected/disconnected state, and cloud sync status with manual re-fetch trigger on the Dashboard
- `bag-security-motion`: Displays lock/unlock state and sudden-motion alert indicator on the Dashboard front page
- `bag-location-tracking`: Detail view showing GPS map (Leaflet/flutter_map placeholder), route history list, and alarm toggle + test sound button
- `organizer-items`: Full CRUD packing list synced to Firestore per user; shown on the Organizer screen
- `bag-service-stub`: Mock `BagService` that emits placeholder streams for all bag fields (battery, BT status, lock, motion, GPS, alarm) simulating a real Bluetooth-connected bag

### Modified Capabilities

- `dashboard-screen`: Existing empty scaffold is replaced with the new Dashboard card layout
- `organizer-screen`: Existing empty scaffold is replaced with the Organizer list UI

## Impact

- **New dependencies**: `flutter_map`, `latlong2` (map widget); `provider` (state management for BagService & OrganizerService)
- **Firestore**: New collection path `users/{uid}/items/{itemId}` for packing list
- **Files added**: `lib/services/bag_service.dart`, `lib/services/organizer_service.dart`, `lib/screens/bag_detail_screen.dart`, `lib/widgets/` (card widgets for each dashboard panel)
- **Files modified**: `lib/screens/dashboard_screen.dart`, `lib/screens/organizer_screen.dart`, `pubspec.yaml`, `lib/main.dart` (Provider setup)
- No breaking changes to auth flow or existing Profile screen
