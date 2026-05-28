## ADDED Requirements

### Requirement: Android splash screen shows logo
The Android launch screen SHALL display `assets/logo.png` centered on the app's brand background color. The splash SHALL be configured via `flutter_native_splash` and applied to both normal and night (dark) drawable variants.

#### Scenario: Splash logo visible on cold launch
- **WHEN** the app cold-starts on Android
- **THEN** the logo is centered on the brand background before the Flutter engine renders

### Requirement: Android permissions declared
`AndroidManifest.xml` SHALL declare the following permissions:
- `android.permission.BLUETOOTH_SCAN`
- `android.permission.BLUETOOTH_CONNECT`
- `android.permission.BLUETOOTH_ADVERTISE`
- `android.permission.ACCESS_FINE_LOCATION`
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.BLUETOOTH` (legacy, for API < 31)
- `android.permission.BLUETOOTH_ADMIN` (legacy, for API < 31)

#### Scenario: Permissions declared in manifest
- **WHEN** the app is installed
- **THEN** the Android system recognizes Bluetooth and location permission requirements for the app
