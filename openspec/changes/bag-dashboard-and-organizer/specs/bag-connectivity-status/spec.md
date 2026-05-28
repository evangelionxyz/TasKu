## ADDED Requirements

### Requirement: Display battery level
The Dashboard SHALL display a battery level indicator sourced from `BagService.batteryLevel` (an integer 0–100). The indicator SHALL use a visual icon that reflects approximate charge tiers (critical < 20%, low < 50%, full ≥ 50%).

#### Scenario: Battery level shown at full charge
- **WHEN** `BagService.batteryLevel` emits a value ≥ 50
- **THEN** the Dashboard displays a full battery icon and the percentage value

#### Scenario: Battery level shown in critical state
- **WHEN** `BagService.batteryLevel` emits a value < 20
- **THEN** the Dashboard displays a critical (near-empty) battery icon in a warning colour

### Requirement: Display Bluetooth connection status
The Dashboard SHALL display a Bluetooth status indicator sourced from `BagService.isBluetoothConnected` (bool). The label SHALL read "Connected" or "Disconnected" accordingly.

#### Scenario: Bluetooth connected
- **WHEN** `BagService.isBluetoothConnected` emits `true`
- **THEN** the connectivity card shows a filled Bluetooth icon with the label "Connected"

#### Scenario: Bluetooth disconnected
- **WHEN** `BagService.isBluetoothConnected` emits `false`
- **THEN** the connectivity card shows a dimmed Bluetooth icon with the label "Disconnected"

### Requirement: Display and trigger cloud sync status
The Dashboard SHALL display a cloud sync status indicator sourced from `BagService.isSynced` (bool). Tapping the indicator SHALL call `OrganizerService.refresh()` to force a re-fetch of the organizer list from Firestore.

#### Scenario: Synced state shown
- **WHEN** `BagService.isSynced` emits `true`
- **THEN** the connectivity card shows a cloud-check icon with label "Synced"

#### Scenario: Force re-fetch on tap
- **WHEN** the user taps the cloud sync indicator
- **THEN** `OrganizerService.refresh()` is called and a brief loading indicator is shown while the Firestore fetch is in progress
