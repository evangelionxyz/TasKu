## MODIFIED Requirements

### Requirement: Organizer screen hosts three tabs
The Organizer screen (`OrganizerPage`) SHALL use `DefaultTabController(length: 3)` with a `TabBar` and `TabBarView`. The three tabs SHALL be: "Checklist" (existing list), "Compartment" (placeholder map), "Stats" (placeholder statistics). The `TabBar` SHALL use flat underline styling consistent with the stacked design language and SHALL be theme-aware.

#### Scenario: Checklist tab is default
- **WHEN** the user navigates to the Organizer tab
- **THEN** the Checklist tab is active by default and the existing CRUD list is visible

#### Scenario: Switching tabs
- **WHEN** the user taps "Compartment" or "Stats"
- **THEN** the corresponding tab content is displayed with a smooth animated tab transition

## MODIFIED Requirements

### Requirement: Organizer items list is theme-aware
The checklist item tiles, FAB, and bottom sheet on the Organizer Checklist tab SHALL use `ThemeService.colors.*` instead of hardcoded `AppColors.*` values, so they render correctly in both dark and light modes.

#### Scenario: Checklist in dark mode
- **WHEN** `ThemeService.isDark == true`
- **THEN** item tiles use dark `card`, `onCard`, and `accent` colors; FAB uses `accent` color
