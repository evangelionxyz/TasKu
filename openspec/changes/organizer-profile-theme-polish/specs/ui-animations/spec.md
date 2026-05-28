## ADDED Requirements

### Requirement: Dashboard card stagger animation on enter
The Dashboard screen SHALL animate its three cards (Connectivity, Security, Location) with a staggered fade-in + slight upward slide on first build, 80ms apart.

#### Scenario: Cards animate in on Dashboard load
- **WHEN** the Dashboard screen is first rendered
- **THEN** the Connectivity card fades in first, followed by Security (80ms later), then Location (160ms later)

### Requirement: Organizer list stagger animation
The Organizer Checklist tab SHALL animate list items with a staggered fade-in on first build, 40ms apart per item (up to 10 items; items beyond 10 appear instantly).

#### Scenario: List items animate in
- **WHEN** the Organizer Checklist tab is opened and items load
- **THEN** each item fades in with a slight delay relative to its index

### Requirement: Bottom sheet slide-up animation
All app bottom sheets (Add Item, Profile edit, Help Center) SHALL use a smooth slide-up curve (`Curves.easeOutCubic`) with a 300ms duration.

#### Scenario: Bottom sheet slides up smoothly
- **WHEN** any bottom sheet is triggered
- **THEN** it slides up from the bottom with `easeOutCubic` in ~300ms

### Requirement: Interactions appear above the navigation bar
All `SnackBar`s, bottom sheets, and dialogs SHALL render above the floating bottom navigation bar. The `Scaffold` wrapping the app SHALL use `extendBody: true` and snackbars SHALL use bottom padding equal to the nav bar height.

#### Scenario: SnackBar appears above nav bar
- **WHEN** a SnackBar is shown (e.g., alarm test, reminder, error)
- **THEN** it is fully visible above the floating bottom navigation bar
