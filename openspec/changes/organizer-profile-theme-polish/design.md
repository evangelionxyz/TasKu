## Context

TasKu is a Flutter app using Firebase Auth + Firestore, custom fonts (Telegraf/Roxborough), and a stacked sharp-edge design language. The current codebase has `AppColors` as a static `abstract final class` with hardcoded light-mode hex values. All widgets consume these constants directly. The Organizer screen has a single checklist list; Profile is an empty scaffold. There are no Android Bluetooth/location permissions and no splash branding.

## Goals / Non-Goals

**Goals:**
- Introduce a `ThemeService` that makes dark mode the default and stores the preference in `SharedPreferences`; all color references switch to read from a theme-aware accessor
- Add a three-tab Organizer (`TabBarView`): Checklist (existing), Compartment Map (placeholder), Statistics (placeholder)
- Unchecked-items + bag-locked reminder displayed as a persistent `SnackBar` or banner on the Dashboard
- Replace the Profile scaffold with a full settings-style page: avatar, display name edit, theme toggle, help center, delete account, sign-out row
- Remove the sign-out `IconButton` from the Profile AppBar
- Update Android splash and permissions
- Add coordinated micro-animations: staggered card fade-in on Dashboard, staggered list on Organizer, slide-up modals, FAB scale

**Non-Goals:**
- Real-time compartment sensor data (placeholder only)
- Real weight measurement (statistics mocked)
- iOS permission declarations (deferred)
- Dark mode for the auth page (keep light for now — brand consistency)

## Decisions

### D1 — ThemeService as ChangeNotifier, not ThemeMode from MaterialApp
Use a `ThemeService extends ChangeNotifier` holding `isDark` (bool) and two `AppPalette` color structs (light/dark). Widgets access colors via `context.watch<ThemeService>().colors`. This is simpler than overriding MaterialApp's `themeMode` and allows widgets to read individual semantic colors without rebuilding on unrelated state changes.

> Alternative: Use `MaterialApp(themeMode:)` with full `ThemeData` — rejected because TasKu uses hand-rolled card widgets and non-standard color roles that don't map cleanly to Material 3 color scheme roles.

### D2 — AppPalette value object
Define `class AppPalette { final Color bg, surface, card, onCard, accent, accentDim, danger, onDanger; }`. `ThemeService` exposes `.colors` returning one of two pre-built `AppPalette` instances. Existing `AppColors` constants remain for legacy reference during migration but widgets should use `ThemeService.colors.*`.

**Dark palette:**
- `bg` = `#121210` (near-black warm)
- `surface` = `#1E2015` (dark olive — existing `AppColors.dark`)
- `card` = `#2A2C21`
- `onCard` = `#E5DDD2` (existing `lightBrown`)
- `accent` = `#827F5E` (existing olive)
- `accentDim` = `#5A5840`
- `danger` = `#8B3A2A`
- `onDanger` = `#F5F2ED`

**Light palette (existing):**
- `bg` = `#F5F2ED`, `surface` = `#E5DDD2`, `card` = `#E5DDD2`, `onCard` = `#1E2015`, `accent` = `#827F5E`, `accentDim` = `#B0AD8E`, `danger` = `#684d3a`, `onDanger` = `#F5F2ED`

### D3 — Organizer tabs with DefaultTabController
Wrap the Organizer screen body in `DefaultTabController(length: 3)` with a custom tab bar styled to match the stacked design (flat underline, no rounded corners). Tabs: Checklist, Compartment, Stats.

### D4 — Reminder via overlay SnackBar from Dashboard
`ConnectivityCard` (or a new `ReminderBanner` widget on the Dashboard) watches `BagService.isLocked` and `OrganizerService.items` — if locked and any item `isPacked == false`, it shows a persistent top `SnackBar` using `ScaffoldMessenger`. Dismissed when the user acknowledges it.

### D5 — Profile as a settings list
Profile screen uses a scrollable `Column` of setting rows with the stacked-card aesthetic. Display name editing opens an inline bottom sheet with a `TextField`. Delete account requires a confirmation dialog before calling `FirebaseAuth.instance.currentUser?.delete()`.

### D6 — Android splash: PNG to drawable, use mipmap reference
Copy `assets/logo.png` to `android/app/src/main/res/drawable/launch_logo.png` at build time, or use `flutter_native_splash` package. Decision: use the `flutter_native_splash` package (dev dependency) for simplicity — it handles both drawable variants and dark-mode splash automatically.

> Alternative: Manually edit `launch_background.xml` to reference `@drawable/launch_logo` — feasible but requires copying the asset manually and doesn't handle density variants. Use `flutter_native_splash` for correctness.

### D7 — Animations via AnimationController + staggered intervals
Use a single `AnimationController` per screen with `Interval`-based `CurvedAnimation`s to stagger widget entry. Dashboard cards stagger 80ms apart; Organizer list items stagger 40ms apart. Bottom sheets use `showModalBottomSheet` with a custom slide curve.

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| Touching every widget for theme migration is error-prone | Migrate systematically file-by-file; use `ThemeService.colors` consistently |
| `flutter_native_splash` might conflict with existing launch theme | Run `dart run flutter_native_splash:create` after config; test on emulator |
| Delete account fails if user hasn't recently authenticated (Firebase re-auth requirement) | Catch `requires-recent-login` error and show re-auth dialog before retry |
| Theme `SharedPreferences` not initialized before `runApp` | `await SharedPreferences.getInstance()` in `main()` before runApp |

## Migration Plan

1. Add `shared_preferences`, `flutter_native_splash` to `pubspec.yaml`
2. Create `ThemeService` with both palettes
3. Add `ThemeService` to `MultiProvider` in `main.dart`; update `MaterialApp` background color
4. Migrate all widgets to use `ThemeService.colors.*` (dashboard cards, organizer, bag detail, bottom nav, profile)
5. Rebuild Profile screen with settings list + sign-out row; remove AppBar sign-out button
6. Add three-tab Organizer layout; implement Compartment and Stats placeholder tabs
7. Add reminder logic on Dashboard
8. Configure and run `flutter_native_splash`; update `AndroidManifest.xml`
9. Add stagger animations to Dashboard and Organizer screens
10. Smoke-test dark/light toggle; verify Firestore, auth, and splash on emulator
