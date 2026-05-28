## ADDED Requirements

### Requirement: Display GPS location on a map
The bag detail screen SHALL display an embedded `flutter_map` widget showing a placeholder `LatLng` coordinate. A marker SHALL indicate the bag's "current" position.

#### Scenario: Map loads with placeholder location
- **WHEN** the user opens the Bag Detail screen
- **THEN** a map is rendered centred on the placeholder coordinate with a visible bag marker
- **THEN** the map is interactive (pan/zoom)

#### Scenario: Map tile load failure
- **WHEN** the network is unavailable and tiles cannot load
- **THEN** a grey tile background is shown without crashing; cached tiles are displayed if available

### Requirement: Display route history list
The bag detail screen SHALL display a scrollable list of historical route entries sourced from `BagService.routeHistory` (a `List<RouteEntry>` with timestamp and address stub). The list SHALL be ordered newest-first.

#### Scenario: Route history has entries
- **WHEN** `BagService.routeHistory` contains one or more entries
- **THEN** the detail screen lists each entry showing a formatted timestamp and a stub address string

#### Scenario: Route history is empty
- **WHEN** `BagService.routeHistory` is empty
- **THEN** the detail screen displays an empty-state label "No route history yet"

### Requirement: Alarm toggle and test
The bag detail screen SHALL provide an alarm toggle (`BagService.isAlarmEnabled`, bool) and a "Test Sound" button. The toggle SHALL call `BagService.setAlarm(bool)`. The test button SHALL call `BagService.testAlarm()`.

#### Scenario: Enable alarm
- **WHEN** the alarm toggle is OFF and the user taps it
- **THEN** `BagService.setAlarm(true)` is called and the toggle switches to ON state

#### Scenario: Disable alarm
- **WHEN** the alarm toggle is ON and the user taps it
- **THEN** `BagService.setAlarm(false)` is called and the toggle switches to OFF state

#### Scenario: Test alarm sound
- **WHEN** the user taps the "Test Sound" button
- **THEN** `BagService.testAlarm()` is called and a brief confirmation snackbar is shown ("Testing alarm…")
