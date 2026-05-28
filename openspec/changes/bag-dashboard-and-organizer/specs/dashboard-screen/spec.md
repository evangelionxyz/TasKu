## MODIFIED Requirements

### Requirement: Dashboard screen shows header and content cards
The Dashboard screen (`HomePage`) SHALL display a screen-level header text "Dashboard" in the `AppBar` alongside the existing `AppTitle` logo widget. The screen body SHALL render a scrollable column of card widgets:
1. **Connectivity Card** — battery, Bluetooth, cloud sync
2. **Security Card** — lock state, motion alert
3. **Location Card** — entry point to the bag detail screen (shows last known location label and a chevron)

#### Scenario: Dashboard header visible
- **WHEN** the user navigates to the Dashboard tab
- **THEN** the AppBar displays the "Dashboard" header text and the TasKu logo

#### Scenario: Dashboard cards rendered
- **WHEN** `BagService` has emitted its initial values
- **THEN** all three card sections (Connectivity, Security, Location) are visible on the Dashboard without scrolling on a standard phone screen
