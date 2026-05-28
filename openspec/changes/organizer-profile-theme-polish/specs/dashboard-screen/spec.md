## MODIFIED Requirements

### Requirement: Dashboard cards are theme-aware
All three Dashboard cards (Connectivity, Security, Location) and `StackedCard` SHALL read colors from `ThemeService.colors.*` instead of hardcoded `AppColors.*`. The `StackedCard` back-layer color SHALL be `colors.surface` and the front-layer SHALL use `colors.card`.

#### Scenario: Dashboard in dark mode
- **WHEN** `ThemeService.isDark == true`
- **THEN** cards use the dark palette (`card`, `onCard`, `accent`) for backgrounds, text, and icons

#### Scenario: Dashboard in light mode
- **WHEN** `ThemeService.isDark == false`
- **THEN** cards use the light palette matching the existing design

### Requirement: Reminder banner on Dashboard
The Dashboard SHALL show a visible dismissible reminder strip at the top of the scrollable content area when the bag is locked and there are unchecked items.

#### Scenario: Reminder visible
- **WHEN** `BagService.isLocked == true` and any `OrganizerService.items` has `isPacked == false`
- **THEN** a banner strip is rendered at the top of the Dashboard body with the reminder message

#### Scenario: Reminder hidden
- **WHEN** all items are packed OR bag is unlocked
- **THEN** the reminder strip is not rendered
