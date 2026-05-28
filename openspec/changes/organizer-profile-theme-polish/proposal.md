## Why

TasKu's Organizer and Profile screens are skeletal placeholders, the app only has a single light theme hardcoded into `AppColors`, and there are no Android permissions, splash screen branding, or polish animations. These gaps make the app feel unfinished and prevent the user from actually using it day-to-day.

## What Changes

- **Organizer** screen gains a tabbed layout: Quick Checklist (Firestore CRUD already started), Compartment Map (placeholder image + filled/empty indicators), and Statistics (placeholder AVG Weight & AVG Bag Opens)
- **Reminder** banner/snackbar shown when the bag is "closed" (locked) and there are unchecked items in the checklist
- **Profile** screen fully replaced: avatar, editable display name, theme toggle, help center sheet, delete account flow, and a full-width sign-out row — the AppBar sign-out button is removed
- **Theme** system introduced: Dark mode becomes default; `AppColors` is replaced by a `ThemeService` (ChangeNotifier) that exposes both dark and light palettes; all existing widgets are updated to read theme-aware colors
- **Android splash screen** updated to show `assets/logo.png` centered on the brand background
- **Android Manifest** gains Bluetooth (BLUETOOTH_SCAN, BLUETOOTH_CONNECT, BLUETOOTH_ADVERTISE) and Location (ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION) permission declarations
- **Animations**: page transitions on `BottomNavShell`, hero-in fade for cards on Dashboard, staggered list items on Organizer, and slide-up for bottom sheets/modals

## Capabilities

### New Capabilities

- `organizer-compartment-map`: Placeholder compartment map UI with a bag image and per-compartment filled/empty indicator chips
- `organizer-statistics`: Placeholder statistics panel showing AVG Weight and AVG Bag Opens with mocked values
- `organizer-unchecked-reminder`: Reminder shown (SnackBar/banner) when bag lock state is `true` and there are unchecked items
- `profile-edit`: Allow user to update display name (Firebase Auth `updateDisplayName`) and view profile photo
- `theme-system`: `ThemeService` ChangeNotifier holding `isDark` bool; dark-mode color palette defined alongside existing light palette; theme toggle stored in `SharedPreferences`
- `splash-screen-logo`: Android launch background updated to show `logo.png` centered
- `android-permissions`: Bluetooth and location permissions declared in AndroidManifest.xml
- `ui-animations`: Coordinated enter animations (fade-in stagger on cards, slide-up on bottom sheets, scale on FAB)

### Modified Capabilities

- `organizer-items`: Organizer screen gains tab bar (Checklist / Compartment / Stats); existing checklist list moves into the Checklist tab
- `organizer-screen`: Header remains, body becomes `TabBarView` with three tabs
- `dashboard-screen`: Cards use theme-aware colors via `ThemeService`; existing stacked-card widgets updated
- `dashboard-screen` (reminder): Connectivity card area shows reminder badge if unchecked items exist and bag is locked

## Impact

- **New dependency**: `shared_preferences` (theme persistence)
- **Modified**: `lib/globals/globals.dart` — `AppColors` becomes a theme-aware accessor; new `ThemeService` added
- **Modified**: `lib/main.dart` — add `ThemeService` provider; `MaterialApp` uses dynamic `ThemeData`
- **Modified**: `lib/navbar/bottom_nav.dart` — all hardcoded `AppColors.*` calls read from `ThemeService`; nav bar color theme-aware
- **Modified**: All screen and widget files that reference `AppColors` colors directly (dashboard cards, bag detail, organizer, profile)
- **Modified**: `android/app/src/main/res/drawable/launch_background.xml` — splash with logo
- **Modified**: `android/app/src/main/AndroidManifest.xml` — permissions
- **New**: `lib/services/theme_service.dart`, `lib/screens/profile_screen.dart` (full rebuild), `lib/widgets/organizer_tabs/` (compartment map + stats widgets)
- No breaking changes to Firebase Auth or Firestore schema
